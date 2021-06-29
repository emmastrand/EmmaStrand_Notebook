---
layout: post
title: 16s Analysis Pipeline
date: '2021-06-21'
categories: Bioinformatics
tags: bioinformatics, 16s, coral, dna
projects: HoloInt
---

# 16s Analysis Pipeline

Lab protocol for 16s: [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-02-01-16s-Sequencing-HoloInt.md).  

251 samples with the 515F and 806RB primers (Apprill et al 2015) from *M. capitata* and *P. acuta* samples in the Holobiont Integration project.  

Sequenced at URI's GSC. Information found [here](https://web.uri.edu/gsc/).

Platemap, sample IDs, and manifest sheet found [here](https://docs.google.com/spreadsheets/d/1ePRCiBFAKLnapxBVCbzIo4Qzjxv-7t0zPcrdJDk2Oo8/edit?ts=6064f16c#gid=0). Order name = Putnam_NGS_20210520_16sITS2_Wong_Strand. My samples start HPW060 - HPW322.  

## Related resources

Fastq vs fasta format  
16s
Shell and linux/unix coding

## Bluewaves and Andromeda for URI

Logging into bluewaves and andromeda. Information for creating an account on [Andromeda](https://web.uri.edu/hpc-research-computing/using-andromeda/).

```
# Bluewaves
$ ssh -l username@bluewaves.uri.edu
$ pw: (your own password)

# Andromeda
$ ssh -l emma_strand.hac.uri.edu
```

## Initial Upload

Hollie uploaded all files into the 16s HoloInt folder. Each sample will have a R1 and R2 fastq.gz file.

HPW### = Sample ID Number    
S### =    
L001 = Lane number  
R1/R2 = Forward (R1) and reverse (R2) b/c they are paired end reads  
001 = Read number  
.fastq = fastq file format   
.gz = gunzipped file format  

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s
$ ls

## first three lines

filenames_md5.txt                 HPW147_S174_L001_R1_001.fastq.gz  HPW235_S221_L001_R2_001.fastq.gz
HPW060_S44_L001_R1_001.fastq.gz   HPW147_S174_L001_R2_001.fastq.gz  HPW236_S233_L001_R1_001.fastq.gz
HPW060_S44_L001_R2_001.fastq.gz   HPW148_S186_L001_R1_001.fastq.gz  HPW236_S233_L001_R2_001.fastq.gz
```

**There was no checksum file from URI GSC but I created one once Hollie transfered them to my folder on andromeda to reference back to if needed.**

#### Create a new checksum file (md5sum)

```
# Create file (takes ~6-7 min to complete)
$ md5sum *.fastq.gz > 16s-checksum2.md5  

# Read the created file above
$ nano 16s-checksum2.md5

Output (first six lines):
210b589620ef946cd5c51023b0f90d8d  HPW060_S44_L001_R1_001.fastq.gz
227032c7b7f7fa8c407cb0509a1fcd6a  HPW060_S44_L001_R2_001.fastq.gz
2f8d8892b7be06cf047a1085dd8bbbf1  HPW061_S56_L001_R1_001.fastq.gz
b603f7ff519130555527bec4c8f8e2c6  HPW061_S56_L001_R2_001.fastq.gz
32c549eb8422ac2ba7affe3dedfb4d3b  HPW062_S68_L001_R1_001.fastq.gz
4caef9d9f684e8345060fdc5896159c8  HPW062_S68_L001_R2_001.fastq.gz

# Check that the individual files went into the new md5 file OK
$ md5sum -c 16s-checksum2.md5

Output: all files = OK
```

## OTU vs. ASV and program choices

Nicola did:  
1.) Retain only PE reads that match amplicon primer.  
2.) Remove reads containing Illumina sequencing adapters.  
3.) Cut out first 4 'de-generate' basepairs.  
4.) Cut out reads that don't start with the 16s primer  
5.) Removes primer  
6.) DADA2 pipeline  

Seems like there a couple programs to use choose from..

DADA2: [here](https://benjjneb.github.io/dada2/tutorial.html).  
Qiime2: [here](https://docs.qiime2.org/2021.4/about/).  

Apparently DADA2 is a newer version for bacteria (good to use if that's what you're working on) and Qiime2 is established/tried & true methods. Qiime2 might be safer option?

DADA2 produces an amplicon sequence variant (ASV) table which is a higher resolution analogue of the traditional OTU table and records the number of times each exact amplicon sequence variant was observed in each sample.

Qiime2 produces OTUs ("tried and true")

OTU vs. ASV information [here](https://www.zymoresearch.com/blogs/blog/microbiome-informatics-otu-vs-asv).

## CONDA Environment

Download [miniconda](https://docs.conda.io/en/latest/miniconda.html).

#### Create a conda environment and download all programs that you will need

```
$ conda create -n HoloInt_16s
$ conda activate HoloInt_16s

$ conda install fastqc
$ conda install multiqc
$ conda install cutadapt
$ conda install qiime2
```

## FASTQC: Quality control of raw read files.

Fastqc resources:  
- https://github.com/s-andrews/FastQC  
- https://raw.githubusercontent.com/s-andrews/FastQC/master/README.txt  
- How to interpret fastqc results [link](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)

#### Create a new directory for fastqc results

```
$ mkdir fastqc_results
$ cd fastqc_results
```

#### Write script to run fastqc

#### Run fastqc

#### Multiqc report


## CUTADAPT

## QIIME2

Program webpage [here](https://docs.qiime2.org/2021.4/getting-started/), beginners guide [here](https://docs.qiime2.org/2021.4/tutorials/overview/).
