# genomics-pipeline-intro

Introduction to basic genomics filetypes and processing techniques. The methods presented are necessary for moving from raw genomic reads to variants, but additional steps not introduced here should be implemented. In other words, the purpose of this introduction is to help individuals new to genomics understand the basics of file transformation; it is not to present every step in genomic data processing.
 
---

## Contents

-   [Objectives](#objectives)
-   [Genomic Filetypes](#genomic-filetypes)
-   [Basic Processing Steps](#basic-processing-steps)
-   [Exercise](#exercise)

---

# <a name="objectives"></a>
## Objectives 

1.  Understand major genomic filetype structure (.fastq, .sam, .vcf)
2.  Understand basic flow of genomic bioinformatics pipeline
---

# <a name="study-design"></a>
## Genomic Filetypes

### .fastq 
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
The fourth line contains a quality score for each position of the sequence. Each character represents a number based on ASCII coding(see this [link](https://support.illumina.com/help/BaseSpace_OLH_009008/Content/Source/Informatics/BS/QualityScoreEncoding_swBS.htm) for the relationship between symbols and quality score value). On this scale, 0 (!) is the lowest value, and 40 (I) is the highest value. Because each score corresponds to a site within the sequence itself, the number of score symbols must equal the number of positions in the sequence.

#### Looking at a .fastq file
Let's look at an example .fastq file. Sometimes these files can be very large, but example.fastq is an abbreviated file that can be opened in your text editor. If on the command line, you can examine this file using ```less example.fastq```. You'll notice that the sequence identifier line is more complex than the example above. Sequencing companies use this line to provide unique characteristics of each sequence. For example, Illumina (the platform used to obtain this sequencing data) uses the following format for the sequence ID and description:

```
@<instrument>:<run number>:<flowcell ID>:<lane>:<tile>:<x-pos>:<y-pos> <read>:<is filtered>:<control number>:<sample number>
```
For the purposes of this introduction, you don't need to worry about all of these elements– just that this line is the unique identifier for the sequence with additional sequencing details.

### .sam
Filler text
### .vcf
Filler text

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


