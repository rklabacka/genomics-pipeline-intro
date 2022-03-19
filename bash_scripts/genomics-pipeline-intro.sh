#!/bin/bash

{
usage="$(basename "$0") [-h] [-l <SRA_list>] [-g <reference_genome.fasta>] [-a <Frequency>] [-t <threads>]
This program will call variants using freebayes in given SRA NGS sequences files to obtain major viral variants.
    -h  show this help text
    -l  File or path to SRA accession list in tabular format
    -g  PATH where the SARS-CoV-2 reference genome (in fasta format) is located. If the genome is located in the working folder, just specify the name.
    -a  A number between (0-1) indicating Viral Frequency for Freebayes variant calling (i.e.: 0.5 = 50% viral frequency).
    -t  Number of CPU processors"
options=':hl:g:a:t:'
while getopts $options option; do
  case "$option" in
    h) echo "$usage"; exit;;
    l) l=$OPTARG;;
    g) g=$OPTARG;;
    a) a=$OPTARG;;
    t) t=$OPTARG;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2; echo "$usage" >&2; exit 1;;
  esac
done

# mandatory arguments
if [ ! "$l" ] || [ ! "$g" ] || [ ! "$a" ] || [ ! "$t" ]; then
  echo "arguments -l, -g, -a and -t must be provided"
  echo "$usage" >&2; exit 1
fi

begin=`date +%s`

echo "Downloading SRA files from the given list of accessions"
prefetch --max-size 800G -O ./ --option-file ${l}
echo "SRA files were downloaded in current directory"
echo ""
echo "Done"
echo ""
echo "Converting SRA files to fastq.gz"
ls -p | grep SRR > sra_dirs
while read i; do mv "$i"*.sra .; done<sra_dirs
SRA= ls -1 *.sra
for SRA in *.sra; do fastq-dump --gzip ${SRA}
done

##################################################################################
# Trimming downloaded Illumina datasets with fastp, using 16 threads (-w option) #
##################################################################################

echo "Trimming downloaded Illumina datasets with fastp."
echo ""

z= ls -1 *.fastq.gz
for z in *.fastq.gz; do fastp -w ${t} -i ${z} -o ${z}.fastp
gzip ${z}.fastp
done

######################
# Indexing Reference #
######################

echo "Indexing Reference"
echo ""
samtools faidx ${g}

###########################################################################################
# Aligning illumina datasets againts reference with minimap, using 20 threads (-t option) #
###########################################################################################

echo "Aligning illumina datasets againts reference with minimap, using n threads."
echo ""
b= ls -1 *.fastq.gz.fastp.gz
for b in *.fastq.gz.fastp.gz; do minimap2 -ax sr ${g} ${b} > ${b}.sam -t ${t}
samtools sort ${b}.sam > ${b}.sam.sorted.bam -@ ${t}
rm ${b}.sam
rm ${b}
done


######################
# Renaming BAM files #
######################

echo "Renaming files in bash"
echo ""
for filename in *.bam; do mv "./$filename" "./$(echo "$filename" | sed -e 's/.fastq.gz.fastp.gz.sam.sorted//g')";  done

######################
# Indexing BAM files #
######################

echo "Indexing BAM files."
echo ""

f= ls -1 *.bam
for f in *.bam; do samtools index ${f}; done

#################################################
### Performing Variant Calling with freebayes ###
#################################################

echo "Performing Variant Calling with freebayes:"
echo ""

x= ls -1 *.bam
for x in *.bam; do freebayes-parallel <(fasta_generate_regions.py ${g}.fai 2000) ${t} -f ${g} -F ${a} -b ${x} > ${x}.freebayes.vcf
done

#######################################
### Merging variants using jacquard ###
#######################################
echo "Merging variants using jacquard"
echo ""
echo "for information, please see: https://jacquard.readthedocs.io/en/v0.42/overview.html#why-would-i-use-jacquard"
echo ""
# Removing 0-byte files in folder
find . -size 0 -delete
echo "Merge VCFs using jacquard"
echo ""
jacquard merge --include_all ./ merged.vcf


end=`date +%s`
elapsed=`expr $end - $begin`
echo Time taken: $elapsed

mdate=`date +'%d/%m/%Y %H:%M:%S'`
mcpu=$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]%
mmem=`free | grep Mem | awk '{print $3/$2 * 100.0}'`
echo "$mdate | $mcpu | $mmem" >> ./stats-cpu
###############################################################
#
} | tee logfile
#
