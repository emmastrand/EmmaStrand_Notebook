---
layout: post
title: KBay Bleaching Pairs WGBS Analysis Pipeline
date: '2021-10-21'
categories: Processing
tags: DNA, methylation, WGBS
projects: KBay Bleaching Pairs
---

# KBAY WGBS Methylation Analysis Pipeline

Raw data folder path: /data/putnamlab/KITT/hputnam/20211008_BleachingPairs_WGBS    
Processed data folder path: /data/putnamlab/estrand/BleachingPairs_WGBS  

References:  
- Wong and Strand WGBS pipeline info: https://github.com/Putnam-Lab/Lab_Management/blob/master/Bioinformatics_%26_Coding/Workflows/Methylation_QC.md  
- Wong Past pipeline: https://github.com/kevinhwong1/Thermal_Transplant_Molecular/blob/main/scripts/Past_WGBS_Workflow.md   
- Wong methylseq trimming tests pipeline: https://kevinhwong1.github.io/KevinHWong_Notebook/Methylseq-trimming-test-to-remove-m-bias/

#### Download genome file from Rutgers

http://cyanophora.rutgers.edu/montipora/ and upload to andromeda.

Contents:  
- [**Setting Up Andromeda**](#Setting_up)  
- [**Initial fastqc on files**](#fastqc)    
- [**Initial Multiqc Report**](#multiqc)    
- [**Methylseq: Trimming parameters test**](#Test)  

## <a name="Setting_up"></a> **Setting Up Andromeda**

#### Make a new directory for output files

```
$ mkdir BleachingPairs_WGBS
$ mkdir fastqc_results
$ mkdir scripts
```

#### Download genome file from Rutgers

http://cyanophora.rutgers.edu/montipora/

## <a name="fastqc"></a> **Initial fastqc on files**

`fastqc.sh`. This took 14 hours for 40 files. Maybe I would do this only on a subset next time.

```
#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_WGBS                
#SBATCH --error="script_error_fastqc" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_fastqc" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

cd /data/putnamlab/estrand/BleachingPairs_WGBS

module load FastQC/0.11.9-Java-11
module load MultiQC/1.9-intel-2020a-Python-3.8.2

for file in /data/putnamlab/KITT/hputnam/20211008_BleachingPairs_WGBS/*fastq.gz
do
fastqc $file --outdir /data/putnamlab/estrand/BleachingPairs_WGBS/fastqc_results         
done

multiqc --interactive fastqc_results
```

The first time I ran this I didn't have the right output path for multiqc because I did 'cd' to the wrong folder. This has been fixed in the script above and I ran the multiqc function

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/BleachingPairs_WGBS/multiqc_report.html /Users/emmastrand/MyProjects/HI_Bleaching_Timeseries/Dec-July-2019-analysis/output/WGBS/initial_multiqc_report.html
```

## <a name="fastqc"></a> **Initial MultiQC Report**

**All samples have sequences of a single length (151bp).**




## <a name="Test"></a> **Methylseq: Trimming parameters test**

**Goal**: Reduce M-bias but keep as much of the sequence as possible.

Nextflow version 21.03.0 requires an -input command.  
The --name output needs to be different every time you run this script.  

### Creating a test run folder

Tests for methylseq were done on a small subset (n=5) to reduce the time that these scripts had to run. I.e. 5 samples instead of 60.

```
$ mkdir test_set
$ cp /data/putnamlab/KITT/hputnam/20211008_HoloInt_WGBS/16_S138_L003_R{1,2}_001.fastq.gz /data/putnamlab/estrand/HoloInt_WGBS/test_set
$ cp /data/putnamlab/KITT/hputnam/20211008_HoloInt_WGBS/17_S134_L003_R{1,2}_001.fastq.gz /data/putnamlab/estrand/HoloInt_WGBS/test_set
$ cp /data/putnamlab/KITT/hputnam/20211008_HoloInt_WGBS/18_S154_L003_R{1,2}_001.fastq.gz /data/putnamlab/estrand/HoloInt_WGBS/test_set
$ cp /data/putnamlab/KITT/hputnam/20211008_HoloInt_WGBS/21_S119_L003_R{1,2}_001.fastq.gz /data/putnamlab/estrand/HoloInt_WGBS/test_set
$ cp /data/putnamlab/KITT/hputnam/20211008_HoloInt_WGBS/22_S120_L003_R{1,2}_001.fastq.gz /data/putnamlab/estrand/HoloInt_WGBS/test_set
```

### BleachingPairs_methylseq (1)

```
nano BleachingPairs_methylseq.sh
```

```
#!/bin/bash
#SBATCH --job-name="methylseq"
#SBATCH -t 120:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=100GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_WGBS
#SBATCH -p putnamlab
#SBATCH --cpus-per-task=3

# load modules needed
source /usr/share/Modules/init/sh # load the module function
module load Nextflow/21.03.0

# run nextflow methylseq

nextflow run nf-core/methylseq -profile singularity \
--aligner bismark \
--igenomes_ignore \
--fasta /data/putnamlab/estrand/Montipora_capitata_HIv2.assembly.fasta \
--save_reference \
--input '/data/putnamlab/KITT/hputnam/20211008_BleachingPairs_WGBS/*_R{1,2}_001.fastq.gz' \
--clip_r1 10 \
--clip_r2 10 \
--three_prime_clip_r1 10 --three_prime_clip_r2 10 \
--non_directional \
--cytosine_report \
--relax_mismatches \
--unmapped \
--outdir /data/putnamlab/estrand/BleachingPairs_WGBS \
-name WGBS_methylseq_BleachingPairs3
```

Run first and then moved all output to BleachingPairs_methylseq directory folder.

### BleachingPairs_methylseq2
