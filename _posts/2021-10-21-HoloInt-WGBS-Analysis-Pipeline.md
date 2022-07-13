---
layout: post
title: HoloInt WGBS Analysis Pipeline
date: '2021-10-21'
categories: Processing
tags: DNA, methylation, WGBS
projects: Holobiont Integration
---

# HoloInt WGBS Methylation Analysis Pipeline

Raw data folder path: /data/putnamlab/KITT/hputnam/20211008_HoloInt_WGBS     
Processed data folder path: /data/putnamlab/estrand/HoloInt_WGBS  

References:  
- Wong and Strand WGBS pipeline info: https://github.com/Putnam-Lab/Lab_Management/blob/master/Bioinformatics_%26_Coding/Workflows/Methylation_QC.md  
- Wong Past pipeline: https://github.com/kevinhwong1/Thermal_Transplant_Molecular/blob/main/scripts/Past_WGBS_Workflow.md   
- Wong methylseq trimming tests pipeline: https://kevinhwong1.github.io/KevinHWong_Notebook/Methylseq-trimming-test-to-remove-m-bias/

Contents:  
- [**Setting Up Andromeda**](#Setting_up)  
- [**Initial fastqc run**](#fastqc)   
- [**Initial Multiqc Report**](#multiqc)     
- [**Methylseq: Trimming parameters test**](#Test)  

## <a name="Setting_up"></a> **Setting Up Andromeda**

#### Make a new directory for output files

```
$ mkdir HoloInt_WGBS
$ mkdir scripts
$ mkdir fastqc_results
```

Test runs were done on a small subset (n=5) to reduce the time that these scripts had to run. I.e. 5 samples instead of 60.

### Creating a test run folder

```
$ mkdir test_set
$ cp /data/putnamlab/KITT/hputnam/20211008_HoloInt_WGBS/1047_S0_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/HoloInt_WGBS/test_set
$ cp /data/putnamlab/KITT/hputnam/20211008_HoloInt_WGBS/1051_S0_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/HoloInt_WGBS/test_set
$ cp /data/putnamlab/KITT/hputnam/20211008_HoloInt_WGBS/1059_S0_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/HoloInt_WGBS/test_set
$ cp /data/putnamlab/KITT/hputnam/20211008_HoloInt_WGBS/1090_S0_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/HoloInt_WGBS/test_set
$ cp /data/putnamlab/KITT/hputnam/20211008_HoloInt_WGBS/1103_S0_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/HoloInt_WGBS/test_set
```

## <a name="fastqc"></a> **Initial fastqc run**

`fastqc.sh`. This took over 24 hours and timed out the first time around so I increased the -t to 60 hours. 

```
#!/bin/bash
#SBATCH -t 60:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS                
#SBATCH --error="script_error_fastqc" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_fastqc" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

cd /data/putnamlab/estrand/HoloInt_WGBS

module load FastQC/0.11.9-Java-11
module load MultiQC/1.9-intel-2020a-Python-3.8.2

for file in /data/putnamlab/KITT/hputnam/20211008_HoloInt_WGBS/*fastq.gz
do
fastqc $file --outdir /data/putnamlab/estrand/HoloInt_WGBS/fastqc_results/         
done

multiqc --interactive fastqc_results
```



```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/HoloInt_WGBS/fastqc_results/multiqc_report.html /Users/emmastrand/MyProjects/Acclim_Dynamics/Molecular_paper/WGBS/output/multiqc_report.html
```

## <a name="multiqc"></a> **Initial MultiQC Report**


![]()
![]()
![]()
![]()
![]()
![]()
![]()
![]()
![]()
![]()



## <a name="Test"></a> **Methylseq: Trimming parameters test**

This was done on a small subset (n=5) to reduce the time that these scripts had to run. I.e. 5 samples instead of 60.

### Options tested

**Goal**: Reduce M-bias but keep as much of the sequence as possible.

**Reasoning behind values**: I chose to not include the Zymo preset because this one worked the least well for Kevin's set. I proceeded with my own preset cut-offs to test. I included the final version that Kevin went with for his and what appeared to be the second best option as well.

Options tested:  
1. HoloInt_methylseq.sh: clip_r1 = 10, clip_r2 = 10, three_prime_clip_r1 = 10, three_prime_clip_r2 = 10    
2. HoloInt_methylseq2.sh: clip_r1 = 15, clip_r2 = 30, three_prime_clip_r1 = 30, three_prime_clip_r2 = 15 (options that worked best for Kevin Past workflow)   
3. HoloInt_methylseq3.sh: clip_r1 = 15, clip_r2 = 30, three_prime_clip_r1 = 15, three_prime_clip_r2 = 15    
4. HoloInt_methylseq4.sh: clip_r1 = 15, clip_r2 = 15, three_prime_clip_r1 = 15, three_prime_clip_r2 = 15  

1: 10, 30, 10, 10   
2: 10, 30, 30, 10  
3: 15, 30, 30, 15  
4: 15, 30, 15, 15  


Nextflow version 21.03.0 requires an -input command.

### HoloInt_methylseq (1)

```
nano HoloInt_methylseq.sh
```

```
#!/bin/bash
#SBATCH --job-name="methylseq"
#SBATCH -t 120:00:00 #use higher # next time
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=500GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS
#SBATCH -p putnamlab
#SBATCH --cpus-per-task=3

# load modules needed
source /usr/share/Modules/init/sh # load the module function

module load Nextflow/21.03.0

# run nextflow methylseq

nextflow run nf-core/methylseq -resume \
-profile singularity \
--aligner bismark \
--igenomes_ignore \
--fasta /data/putnamlab/estrand/Pocillopora_acuta_HIv1.assembly.fasta \
--save_reference \
--input '/data/putnamlab/KITT/hputnam/20211008_HoloInt_WGBS/*_R{1,2}_001.fastq.gz' \
--clip_r1 10 \
--clip_r2 10 \
--three_prime_clip_r1 10 --three_prime_clip_r2 10 \
--non_directional \
--cytosine_report \
--relax_mismatches \
--unmapped \
--outdir /data/putnamlab/estrand/HoloInt_WGBS \
-name WGBS_methylseq_HoloInt
```

I ran this first and then moved all of the output to a new HoloInt_methylseq directory folder.

### HoloInt_methylseq2

```
nano HoloInt_methylseq2.sh
```

```
#!/bin/bash
#SBATCH --job-name="methylseq"
#SBATCH -t 500:00:00  
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=500GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq2
#SBATCH -p putnamlab
#SBATCH --cpus-per-task=3
#SBATCH --error="script_error_HoloInt_methylseq2" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_HoloInt_methylseq2" #once your job is completed, any final job report comments will be put in this file

# load modules needed
source /usr/share/Modules/init/sh # load the module function

module load Nextflow/21.03.0

# run nextflow methylseq

nextflow run nf-core/methylseq -resume \
-profile singularity \
--aligner bismark \
--igenomes_ignore \
--fasta /data/putnamlab/estrand/Pocillopora_acuta_HIv1.assembly.fasta \
--save_reference \
--input '/data/putnamlab/estrand/HoloInt_WGBS/test_set/*_R{1,2}_001.fastq.gz' \
--clip_r1 15 \
--clip_r2 30 \
--three_prime_clip_r1 30 --three_prime_clip_r2 15 \
--non_directional \
--cytosine_report \
--relax_mismatches \
--unmapped \
--outdir /data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq2 \
-name WGBS_methylseq_HoloInt2
```

### HoloInt_methylseq3

```
nano HoloInt_methylseq3.sh
```

```
#!/bin/bash
#SBATCH --job-name="methylseq"
#SBATCH -t 500:00:00  
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=500GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq3
#SBATCH -p putnamlab
#SBATCH --cpus-per-task=3
#SBATCH --error="script_error_HoloInt_methylseq3" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_HoloInt_methylseq3" #once your job is completed, any final job report comments will be put in this file

# load modules needed
source /usr/share/Modules/init/sh # load the module function

module load Nextflow/21.03.0

# run nextflow methylseq

nextflow run nf-core/methylseq -resume \
-profile singularity \
--aligner bismark \
--igenomes_ignore \
--fasta /data/putnamlab/estrand/Pocillopora_acuta_HIv1.assembly.fasta \
--save_reference \
--input '/data/putnamlab/estrand/HoloInt_WGBS/test_set/*_R{1,2}_001.fastq.gz' \
--clip_r1 15 \
--clip_r2 30 \
--three_prime_clip_r1 15 --three_prime_clip_r2 15 \
--non_directional \
--cytosine_report \
--relax_mismatches \
--unmapped \
--outdir /data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq3 \
-name WGBS_methylseq_HoloInt3
```
