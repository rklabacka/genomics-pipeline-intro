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
Filler text
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



