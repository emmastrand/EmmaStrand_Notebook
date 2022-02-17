---
layout: post
title: Holobiont Integration 16S Mothur Pipeline
date: '2022-02-17'
categories: Analysis
tags: 16S, bioinformatics, Mothur, Holobiont Integration
projects: Holobiont Integration
---

# Holobiont Integration 16S Mothur Pipeline

We tried QIIME2 for this project originally (notebook post [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-06-21-16s-Analysis-Pipeline.md)) but after using both the Mothur and QIIME2 pipeline for the KBay Bleaching Pairs project we found Mothur might be better suited for our data ([KBay QIIME2](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-01-07-KBay-Pairs-16S-Analysis-Pipeline.md); [KBay Mothur](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-01-24-KBay-Bleached-Pairs-16S-Analysis-Mothur.md)).

See [Holobiont Integration 16S page](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-06-21-16s-Analysis-Pipeline.md) for more information on sequencing, primers, URI GSC, and laboratory related information.

Raw data path (edit-able): ../../data/putnamlab/estrand/HoloInt_16s/raw-data
Output data path: ../../data/putnamlab/estrand/BleachingPairs_16S/Mothur

Contents:  
- [**Setting Up Andromeda**](#Setting_up)  
- [**Make contigs**](#Contigs)  
- [**QC with screen.seqs**](#QC_screen)  
- [**Determining and counting unique sequences**](#Unigue)
- [**Aligning to a reference database**](#Reference)   
- [**Pre-clustering**](#Pre-clustering)   
- [**Identifying Chimeras**](#Chimeras)    
- [**Classifying sequences**](#Classify_seq)  
- [**OTU Clustering**](#OTU)   
- [**Subsampling for sequencing depth**](#Subsample)   
- [**Calculate Ecological Statistics**](#Ecostats)    
- [**Population Level Analyses**](#Popstats)  
- [**Exporting for R Analyses**](#RExport)                
- [**Troubleshooting**](#Troubleshooting)    


**For a more detailed description of Mothur commands, see A.Huffmyer's notebook post: [link here](https://github.com/AHuffmyer/ASH_Putnam_Lab_Notebook/blob/master/_posts/2022-01-12-16S-Analysis-in-Mothr-Part-1.md).**

## <a name="Setting_up"></a> **Setting Up Andromeda**

Make a directory for Mothur within HoloInt_16s directory.

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s
$ mkdir Mothur
$ cd Mothur
$ mkdir processed_data
$ mkdir scripts
```

Make a file with the primer sequence information (515F and 806RB; see notebook post at the top of this document that describes the laboratory work for this protocol).

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s/Mothur
$ nano oligos.oligos

## copy and paste the following text into that file

primer GTGCCAGCMGCCGCGGTAA GGACTACNVGGGTWTCTAAT
```

Copy all raw files into the mothur folder.

```
$ cp /data/putnamlab/estrand/HoloInt_16s/raw-data/*.gz /data/putnamlab/estrand/HoloInt_16s/Mothur
```

## <a name="Contigs"></a> **Make Contigs**

Script to make contigs.

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s/Mothur/scripts
$ nano contigs.sh
$ cd .. ### need to be in mothur directory when running script

## copy and paste the below text into the nano file

#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab                  
#SBATCH --error="script_error_contigs" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_contigs" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur "#make.file(inputdir=., type=gz, prefix=HoloInt)"

mothur "#make.contigs(inputdir=., outputdir=., file=HoloInt.files, oligos=oligos.oligos)"

mothur "#summary.seqs(fasta=HoloInt.trim.contigs.fasta)"
```

From `output_script_contigs`:

```
#### Insert output here
```

#### Check that the primers are gone.

`$ head HoloInt.trim.contigs.fasta`

We are looking to see that these primers `F GTGCCAGCMGCCGCGGTAA R GGACTACNVGGGTWTCTAAT` have been taken out.

Output:

```
#### Insert output here
```

## <a name="QC_screen"></a> **QC with screen.seqs**

Make script for screen.seqs function.

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s/Mothur/scripts
$ nano screen.sh
$ cd ..

## copy and paste the below text into the script file

#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab                  
#SBATCH --error="script_error_screen" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_screen" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#screen.seqs(inputdir=., outputdir=., fasta=HoloInt.trim.contigs.fasta, group=HoloInt.contigs.groups, maxambig=0, maxlength=350, minlength=250)"

mothur "#summary.seqs(fasta=HoloInt.trim.contigs.good.fasta)"
```

From `output_script_screen`:

```
#### Insert output here
```
