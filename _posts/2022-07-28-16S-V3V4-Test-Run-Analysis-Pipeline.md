---
layout: post
title: 16S-V3V4 Test Run Analysis Pipeline
date: '2022-07-28'
categories: Analysis
tags: 16S
projects: Holobiont Integration, KBay Bleaching Pairs
---

# Analysis Pipeline for 16S V3V4 Test Sequencing Run 1

Lab work that produced these sequences: https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-03-21-16S-V3V4-Sample-Processing.md

Questions to answer:
- Do we get microbiome or host sequences from 338F and 341F V3V4 region PCR products?  
- Which V3V34 primer (338F and or 341F) yields higher microbiome sequences?  
- Does 63C annealing temperature for the V4 (515F) region yield better microbiome vs host ratios? Is this still all host?  
- What kind of noise do we get from negative controls?  

Contents:  
- [**Setting Up Andromeda**](#Setting_up)  
- [**Initial fastqc on files**](#fastqc)  
- [**Initial Multiqc Report**](#multiqc)    

## <a name="Setting_up"></a> **Setting Up Andromeda**

Make a new directory for the test output, fastqc results, and scripts.

```
$ mkdir /data/putnamlab/estrand/Test_V3V4_16S
$ cd Test_V3V4_16S
$ mkdir scripts
$ mkdir fastqc_results
```

Raw data path: `/data/putnamlab/KITT/hputnam/2022728_16sTest_Coral`. Contains md5 checksum files, download from basespace script (.sh), and ELS01-30 R1 and R2 files (60 total).

## <a name="fastqc"></a> **Initial fastqc on files**

`fastqc.sh` created in the scripts folder. This takes under 10 minutes.

```
#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab                  
#SBATCH --error="script_error_fastqc" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_fastqc" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function
module load FastQC/0.11.9-Java-11
module load MultiQC/1.9-intel-2020a-Python-3.8.2

cd /data/putnamlab/estrand/Test_V3V4_16S

for file in /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/*fastq.gz
do
fastqc $file --outdir /data/putnamlab/estrand/Test_V3V4_16S/fastqc_results         
done

multiqc --interactive /data/putnamlab/estrand/Test_V3V4_16S/fastqc_results  ### this file will output in whatever directory we cd'd to first

mv multiqc_report.html V3V4Test_initial_multiqc_report.html # renames file
```

## <a name="multiqc"></a> **Initial MultiQC Report**

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/Test_V3V4_16S/V3V4Test_initial_multiqc_report.html /Users/emmastrand/MyProjects/EmmaStrand_Notebook/Lab-work/V3V4Test_initial_multiqc_report.html
```
