# Genomics Pipeline Intro

Introduction to basic genomics filetypes and processing techniques. The methods presented are necessary for moving from raw genomic reads to variants, but additional steps not introduced here should be implemented. In other words, the purpose of this introduction is to help individuals new to genomics understand the basics of file transformation; it is not to present every step in genomic data processing.
 
---

# Contents

-   [Objectives](#objectives)
-   [Genomic Filetypes](#genomic-filetypes)
-   [Basic Processing Steps](#basic-processing-steps)
-   [Exercise](#exercise)

---

# <a name="objectives"></a>
# Objectives 

1.  Understand major genomic filetype structure (.fastq, .sam, .vcf)
2.  Understand basic flow of genomic bioinformatics pipeline
---

# <a name="study-design"></a>
# Genomic Filetypes

## .FASTQ 
Similar to .fasta files, .fastq files contain a <b>[sequence identifier](#fastq-seq-id)</b> and biological <b>[sequence data](#fastq-seq-data)</b>. Additionally, .fastq files contain a sequencing <b>[quality score](#fastq-qual-score)</b> for each base pair position. Here is an example of one sequence and its associated information:

```
@SeqID
AAGCCAGCAAACCTTGTTTTACCTCACTGATATAGATTAGATATTTCAAGACAAATTTGTTGCCAATGTTAGATTATTAACATTATTTATTATAAAAATA
+
CCCFFFFFHHHHHJJJJJJJJJJJJJJJJIJJJJJJJJJJJJIJIJJJJJJJJJJJJJJJJJJJJJJIJJJJJJIJJJJHHHHHHHFFFFFFFEEEEEEC
```

# <a name="fastq-seq-id"></a>
#### 1) .fastq Sequence Identifier
The first line is the sequence identifier. The first character for the identifier line is '@'. Similar to the '>' character in .fasta files, the '@' character in .fastq files denotes the sequence identity for the following sequence. Additionally, this line might contain a description of the sequence. 
 
# <a name="fastq-seq-data"></a>
#### 2) .fastq Sequence Data
The second line contains the sequence itself (string of nucleotides). The sequence is followed by a '+' on the third line to indicate the end of the sequence string.

# <a name="fastq-qual-score"></a>
#### 3) .fastq Quality Score
The fourth line contains a quality score for each position of the sequence. Each character represents a number based on ASCII coding (see this [link](https://support.illumina.com/help/BaseSpace_OLH_009008/Content/Source/Informatics/BS/QualityScoreEncoding_swBS.htm) for the relationship between symbols and quality score value). On this scale, 0 ('!') is the lowest value, and 40 ('I') is the highest value. Because each score corresponds to a site within the sequence itself, the number of score symbols must equal the number of positions in the sequence.

#### Looking at a .fastq file
Let's look at an example .fastq file. Sometimes these files can be very large, but example.fastq is an abbreviated file that can be opened in your text editor. If on the command line, you can examine this file using ```vim example.fastq```. 

> note: If you are new to using vim, you can exit without saving by typing ':q!' followed by enter. 

You'll notice that the sequence identifier line is more complex than the example above. Sequencing companies use this line to provide unique characteristics of each sequence. For example, Illumina paired-end sequencing (the platform and method used to obtain this sequencing data) uses a [specific format](https://help.basespace.illumina.com/articles/descriptive/fastq-files/) for the sequence ID and description.

With this info, you can parse out the information from the first sequence id in example.fastq as follows:

| Order |  description     | value      |
|:-----:|:----------------:|:----------:|
|  1    |  instrument      | D3NH4HQ1   |
|  2    |  run number      | 149        |
|  3    |  flowcell ID     | C1H5KACXX  |
|  4    |  lane            | 3          |
|  5    |  tile            | 1101       |
|  6    |  x-pos           | 2106       |
|  7    |  y-pos           | 2242       |
|  -    |  space           | -          |
|  8    |  read            | 2          |
|  9    |  is filtered     | N          |
|  10   |  control number  | 0          |
|  11   |  index number    | GCTCGGTA   |

For the purposes of this introduction, you don't need to worry about all of these elements– just that this line is the unique identifier for the sequence with additional sequencing details.

## .SAM
Sequence alignment map (SAM) files are text-based genomic files with biological sequence data aligned to a reference sequence. SAM files contain a <b>[header section](sam-header-section)</b> and an <b>[alignment section](sam-alignment-section)</b>. They contain the same information as the .fastq file, with additional information on mapping details. As you probably gathered, that makes these files larger than the .fastq files. Here is an example of header and alignment lines within a .sam file:

```
@SQ SN:NC_045541.1  LN:186725308
@PG ID:bwa PN:bwa CL:bwa mem -t 4 -M RefGenome.fasta Read1.fastq Read2.fastq
SeqID 99  ref_name 72165682    60  100M    =   72165982    399 TACTTATGTTCTTCTTCATTCAGGATCATATGTGAAACTTCAGAAAAGCTAATATGTGAAACTTCAGAAGACAAATATGGTGAGAACAACAGTGAAAGAG    CCCFFFFFHHHHHJIJJJJJJJIJIJJJJJIJJJJJJJJJJIIJGIJJJJJJJIJJBGIJJJIJIIJJIJJJIIICFIHEA@EGHHHHHFFFEFEEEEDE
```

# <a name="sam-header-section"></a>
#### 1) .sam Header Section
The header section precedes the alignment section, and each heading begins with the '@' symbol. Each heading contains tab-delimited sections. The first column indicates the record type. The following columns contain tags and values (in the format TAG:VALUE). While there are different tag types, two you will see often are @SQ (reference sequences) and @PG (programs used for creating .sam). The values of these tags contain information about the sequence. @SQ requires the reference sequence name (SN) and length (LN) tags, and the @PG tag requires the program identity but may also include the program name (PN), version (VN), and command line implementation (CL).


# <a name="sam-alignment-section"></a>
#### 2) .sam Alignment Section
The alignment section requires 11 tab-separated fields, and additional fields are optional. Each line within this section represents the alignment of a segment to the reference. The 11 required sections include information on the query template (read that mapped), the reference sequence name (SN), the position on reference where the query template mapped, the mapping quality, the sequence itself, and the quality score for each position in the base pair. Simplified descriptions of each required field are within the table in the [looking at a .SAM file](sam-example) section.


# <a name="sam-example"></a>
#### Looking at a .sam file
Let's look at an example .sam file. These files can be very large, but example.sam is an abbreviated file that can be opened in your text editor. If on the command line, you can examine this file using ```vim example.sam```. 
> note: If you are new to using vim, you can remove text wrap by typing ':set nowrap' followed by enter. You can see line numbers by typing ':set number' followed by enter. You can exit vim without saving by typing ':q!' followed by enter. 

You'll see that there are many @SQ header lines (one for each of the reference sequences). Each of these has a name and length. At line 366 you'll see the @PG header line for the program details. The remaining lines of the file contain alignment information. From what we learned above, we can parse the first alignment line (line 367) as follows:


| Col |  Field     | Type   |  Description                                                                  |  Value             |
|:---:|:----------:|:------:|:-----------------------------------------------------------------------------:|:------------------:|
|  1  |  QNAME     | string |  query template name                                                          |  D3NH...:4262:2214 |
|  2  |  FLAG      | int    |  bitwise flag                                                                 |  99                |
|  3  |  RNAME     | string |  ref sequence name                                                            |  NC_045541.1       |
|  4  |  POS       | int    |  1-based leftmost mapping position                                            |  72165682          |
|  5  |  MAPQ      | ing    |  mapping quality                                                              |  60                |
|  6  |  CIGAR     | string |  [CIGAR string](https://jef.works/blog/2017/03/28/CIGAR-strings-for-dummies/) |  100M              |
|  7  |  RNEXT     | string |  ref name of the mate/next read                                               |  =                 |
|  8  |  PNEXT     | int    |  position of the mate/next read                                               |  72165982          |
|  9  |  TLEN      | int    |  template length                                                              |  399               |
|  10 |  SEQ       | string |  segment sequence                                                             |  TACTTATGTTCT...   |
|  11 |  QUAL      | string |  [ASCII score](https://support.illumina.com/help/BaseSpace_OLH_009008/Content/Source/Informatics/BS/QualityScoreEncoding_swBS.html) of base quality                                                  |  @DCC?CCEC>CE...   |

### .VCF
Variant call format (VCF) files are text-based genomic files with information on sequence variation. More specifically, it includes sites where multiple characters are present in the samples examined. A .vcf file contains a <b>[header section](vcf-header-section)</b> and a <b>[variant data section](vcf-data-section)</b>. Basic .vcf files do not contain information on every position from the .fastq or reference file, rather they include information on the genomic positions with sequence variation. As you probably gathered, that makes these files smaller than the .fastq and .sam files (and the less variation, the smaller the file). Here is an abbreviated example of header and alignment lines within a .vcf file:

# <a name="example .vcf"></a>
| example vcf |
|:------------|

```
##fileformat=VCFv4.2
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##FORMAT=<ID=AD,Number=R,Type=Integer,Description="Allelic depths for the ref and alt alleles in the order listed">
##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Approximate read depth (reads with MQ=255 or with bad mates are filtered)">
##FORMAT=<ID=GQ,Number=1,Type=Integer,Description="Genotype Quality">
##INFO=<ID=AC,Number=A,Type=Integer,Description="Allele count in genotypes, for each ALT allele, in the same order as listed">
##INFO=<ID=AF,Number=A,Type=Float,Description="Allele Frequency, for each ALT allele, in the same order as listed">
##INFO=<ID=DP,Number=1,Type=Integer,Description="Approximate read depth; some reads may have been filtered">
##INFO=<ID=FS,Number=1,Type=Float,Description="Phred-scaled p-value using Fisher's exact test to detect strand bias">
##contig=<ID=NC_045541.1,length=186725308,assembly=reference.fasta>
##reference=file://reference.fasta
#CHROM  POS ID  REF ALT QUAL    FILTER  INFO    FORMAT  Sample01   Sample02   Sample03
NC_045541.1 1206    .   A   G   138.21  .   AC=2;AF=0.4;DP=6;FS=0.000 GT:AD:DP:GQ  0/0:6,0:6:42   ./.:0,0:0:0   1/0:6,6:12:71
```

# <a name="vcf-header-section"></a>
#### 1) .vcf Header Section
The header section precedes the variant data section, and each heading begins with '##' symbols (notice there are *two* hash marks).  Information about the variant dataset, the reference sequence, and the program used to generate the .vcf are contained within the header. ```FORMAT``` and ```INFO``` sections of the header include information on the site and genotype annotation in the data section (i.e., the abbreviations in this section correspond with those in the data section). The ```contig``` and ```reference``` sections contain information about the reference used for variant calling.

# <a name="vcf-data-section"></a>
#### 1) .vcf Variant Data Section
The variant section consists of a row for every variant. The columns provide information about (1) the variant site as a whole and (2) the genotype of each individual in the dataset. The first section of columns correspond to the variant site as a whole, with the first 8 columns being required. These include information about the location, the reference allele, the alternate allele(s), and the quality of the SNP. The second section contains information about the genotypes of each sample. In the  

---

# <a name="basic-processing-steps"></a>
## Basic Processing Steps
Filler text

![Raw Read FastQC Quality](./Examining-Sequence-Variation/images/RawReadsFastQC.png)


[BWA](https://hpc.nih.gov/apps/bwa.html)



| Step |                     filtering settings                          |    n   |
|:----:|:---------------------------------------------------------------:|:------:|
|  0   | Pre-filter                                                      | 70,177 |
|  I   | GATK Best Practices: SOR, QD, MQ, MQRankSum, FS, ReadPosRankSum | 64,648 |
|  II  | Remove individual genotypes with low GQ or low DP               | 64,648 |
|  III | Remove multi-allelic SNPs                                       | 63,000 |
|  IV  | Remove singletons                                               | 21,898 |
|  V   | Remove sites with high amounts of missing data                  | 12,512 |

# <a name="exercise"></a>
## Exercise
The basic workflow and data for this exercise come from [Farkas et al., 2021](https://doi.org/10.3389/fmicb.2021.665041) and the associated [github repository](https://github.com/cfarkas/SARS-CoV-2-freebayes).

### Exercise Objective
Download and analyze a small sample of genomic data using published scripts to see an applied process of genomic data processing.

For this exercise, create a text file called \<last-name\>_exercise3.txt. Within this text file, you should answer each of the questions in this exercise marked with an asterisk (*).

### Getting set up
1.  Make sure [mini/anaconda](https://docs.conda.io/en/latest/miniconda.html) and python versions = 2.7 and >=3.0 are installed.
2.  Clone repository and activate conda environment
```
git clone git@github.com:rklabacka/genomics-pipeline-intro.git # clone repository using password-protected ssh key
cd genomics-pipeline-intro
conda config --add channels conda-forge                        # add conda-forge channel (if you haven't already done so)
conda config --add channels bioconda                           # add bioconda channel (if you haven't already done so)
conda env update --file environment.yml                        # install required programs
conda activate genomics-pipeline-intro                         # activate genomics-pipeline-intro enviroment
bash makefile.sh                                               # make & install
sudo cp ./bin/* /usr/local/bin/                                # Copy binaries into /usr/local/bin/ (require sudo privileges)
```

3.  Install a vcftools version that includes the --haploid flag as follows:
```
git clone https://github.com/cfarkas/vcftools.git       # Forked Julien Y. Dutheil version: https://github.com/jydu/vcftools
cd vcftools
./autogen.sh
./configure
make                                                    # make
sudo make install                                       # requires sudo privileges
```

4. Install the latest version of sra toolkit. See instructions here:
```
https://github.com/ncbi/sra-tools/wiki/02.-Installing-SRA-Toolkit
```

### Raw reads to vcf

Examine the genomics-pipeline-intro.sh (in the bash_scripts directory). Where are the areas where file transformation occurs? What input files are necessary?

You can see the parameters required for the script by looking at the help menu:
```
genomics-pipeline-intro -h
```

Now that you have examined the script, run it.

```
genomics-pipeline-intro -l July_28_2020_NorAm.txt -g covid19-refseq.fasta -a 0.4999 -t 4
``` 


