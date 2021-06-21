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
$
```

## Initial Upload and Checksum

Hollie uploaded all files into the 16s HoloInt folder. Each sample will have a R1 and R2 fastq.gz file.

HPW### = Sample ID Number    
S### =    
L001 =    
R1/R2 = Forward (R1) and reverse (R2) b/c they are paired end reads  
001 =    
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

### Checksum

*Insert description of a checksum and why we do this*.

There are 502 .fastq.gz files in this folder and one checksum file from the sequencing center (GSC).

**Check contents of that GSC file below.**

```
$ nano filenames_md5.txt

## first five lines

HPW060_L001_ds.63c5692775594b4e811abb0cecf838cf
HPW061_L001_ds.f5e292bfbf0549e082be0f361b25b6f7
HPW062_L001_ds.76f08d3b48e64ac6af6241c80641d4bb
HPW063_L001_ds.ea979401bc754993aa1f113ea40d50de
HPW064_L001_ds.40e48ebf01e44689badc0ca895ee6b67
```

HPW### = sample ID number  
L0001 =  
ds =  
letter code =

Each sample above only has 1 checksum letter code for each sample.

**Create a new checksum file (md5sum)**  

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

The above new md5 file that I made has 2 lines for each sample compared to the 1 line in the md5 file from GSC.

**Compare the two checksum files**  
```
$ cksum filenames_md5.txt 16s-checksum2.md5

Output:
679781788 12048 filenames_md5.txt
1907163389 33418 16s-checksum2.md5

$ cksum filenames_md5.txt 16s-checksum2.md5.txt

Output:  
79781788 12048 filenames_md5.txt
1907163389 33418 16s-checksum2.md5.txt
```

**Problem: above output values are way off.. these files are in different formats. Txt vs md5 and # of lines per sample.**

This is a different format than the .txt file above. Each sample has 2 checksum values. I'm making another checksum file but this time in txt format.

```
$ md5sum *.fastq.gz > 16s-checksum2.md5.txt
$ nano 16s-checksum2.md5.txt

Output (first four lines):  
210b589620ef946cd5c51023b0f90d8d  HPW060_S44_L001_R1_001.fastq.gz
227032c7b7f7fa8c407cb0509a1fcd6a  HPW060_S44_L001_R2_001.fastq.gz
2f8d8892b7be06cf047a1085dd8bbbf1  HPW061_S56_L001_R1_001.fastq.gz
b603f7ff519130555527bec4c8f8e2c6  HPW061_S56_L001_R2_001.fastq.gz
```
This didn't change the format..
