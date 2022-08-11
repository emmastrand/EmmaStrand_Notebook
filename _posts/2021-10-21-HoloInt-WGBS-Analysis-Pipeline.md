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
- [**Methylseq: Final Script Run**](#methylseq_final)  
- [**Methylseq: Final Multiqc Report Output**](#final_multiqc)  
- [**Troubleshooting**](#troubleshooting)  

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

This failed at the multiqc line above because the path was incorrect. So I did that function in the terminal.

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/HoloInt_WGBS/multiqc_report.html /Users/emmastrand/MyProjects/Acclim_Dynamics/Molecular_paper/WGBS/output/initial_multiqc_report.html
```

## <a name="multiqc"></a> **Initial MultiQC Report**

Full report here: https://github.com/hputnam/Acclim_Dynamics/blob/master/Molecular_paper/WGBS/output/initial_multiqc_report.html

**All samples have sequences of a single length (150bp , 151bp).**

| Sample Name         | % Dups | % GC | M Seqs |
|---------------------|--------|------|--------|
| 1047_S0_L001_R1_001 |  28.6% |  27% |  67.0  |
| 1047_S0_L001_R2_001 |  26.8% |  27% |  67.0  |
| 1051_S0_L001_R1_001 |  36.6% |  23% |  104.2 |
| 1051_S0_L001_R2_001 |  36.0% |  24% |  104.2 |
| 1059_S0_L001_R1_001 |  30.3% |  26% |  98.9  |
| 1059_S0_L001_R2_001 |  30.6% |  26% |  98.9  |
| 1090_S0_L001_R1_001 |  25.8% |  27% |  97.3  |
| 1090_S0_L001_R2_001 |  26.2% |  27% |  97.3  |
| 1103_S0_L001_R1_001 |  19.1% |  28% |  64.8  |
| 1103_S0_L001_R2_001 |  19.3% |  28% |  64.8  |
| 1147_S0_L001_R1_001 |  19.8% |  28% |  27.1  |
| 1147_S0_L001_R2_001 |  20.1% |  28% |  27.1  |
| 1159_S0_L001_R1_001 |  19.9% |  29% |  57.8  |
| 1159_S0_L001_R2_001 |  20.7% |  29% |  57.8  |
| 1168_S0_L001_R1_001 |  25.8% |  32% |  94.9  |
| 1168_S0_L001_R2_001 |  26.4% |  31% |  94.9  |
| 1184_S0_L001_R1_001 |  20.8% |  26% |  80.5  |
| 1184_S0_L001_R2_001 |  21.7% |  26% |  80.5  |
| 1205_S0_L001_R1_001 |  28.3% |  27% |  117.1 |
| 1205_S0_L001_R2_001 |  28.9% |  27% |  117.1 |
| 1225_S0_L001_R1_001 |  43.4% |  25% |  63.5  |
| 1225_S0_L001_R2_001 |  43.0% |  25% |  63.5  |
| 1238_S0_L001_R1_001 |  22.9% |  30% |  70.3  |
| 1238_S0_L001_R2_001 |  23.5% |  30% |  70.3  |
| 1281_S0_L001_R1_001 |  29.3% |  26% |  122.8 |
| 1281_S0_L001_R2_001 |  30.0% |  26% |  122.8 |
| 1296_S0_L001_R1_001 |  42.0% |  24% |  86.1  |
| 1296_S0_L001_R2_001 |  42.0% |  24% |  86.1  |
| 1303_S0_L001_R1_001 |  22.5% |  27% |  83.6  |
| 1303_S0_L001_R2_001 |  22.7% |  27% |  83.6  |
| 1312_S0_L001_R1_001 |  27.7% |  28% |  94.8  |
| 1312_S0_L001_R2_001 |  28.5% |  28% |  94.8  |
| 1329_S0_L001_R1_001 |  43.9% |  25% |  117.1 |
| 1329_S0_L001_R2_001 |  44.3% |  26% |  117.1 |
| 1415_S0_L001_R1_001 |  25.6% |  27% |  80.2  |
| 1415_S0_L001_R2_001 |  26.1% |  27% |  80.2  |
| 1416_S0_L001_R1_001 |  26.4% |  27% |  98.4  |
| 1416_S0_L001_R2_001 |  27.2% |  27% |  98.4  |
| 1427_S0_L001_R1_001 |  24.4% |  29% |  74.5  |
| 1427_S0_L001_R2_001 |  23.9% |  29% |  74.5  |
| 1445_S0_L001_R1_001 |  51.9% |  23% |  81.9  |
| 1445_S0_L001_R2_001 |  51.2% |  23% |  81.9  |
| 1459_S0_L001_R1_001 |  21.1% |  28% |  91.6  |
| 1459_S0_L001_R2_001 |  21.8% |  29% |  91.6  |
| 1487_S0_L001_R1_001 |  21.3% |  27% |  90.4  |
| 1487_S0_L001_R2_001 |  22.1% |  28% |  90.4  |
| 1536_S0_L001_R1_001 |  21.4% |  27% |  81.4  |
| 1536_S0_L001_R2_001 |  22.2% |  27% |  81.4  |
| 1559_S0_L001_R1_001 |  28.4% |  29% |  86.4  |
| 1559_S0_L001_R2_001 |  28.5% |  29% |  86.4  |
| 1563_S0_L001_R1_001 |  32.2% |  25% |  110.5 |
| 1563_S0_L001_R2_001 |  32.7% |  26% |  110.5 |
| 1571_S0_L001_R1_001 |  31.9% |  28% |  116.3 |
| 1571_S0_L001_R2_001 |  32.2% |  28% |  116.3 |
| 1582_S0_L001_R1_001 |  20.1% |  28% |  79.1  |
| 1582_S0_L001_R2_001 |  20.2% |  28% |  79.1  |
| 1596_S0_L001_R1_001 |  22.7% |  25% |  76.8  |
| 1596_S0_L001_R2_001 |  23.7% |  25% |  76.8  |
| 1641_S0_L001_R1_001 |  29.4% |  26% |  122.5 |
| 1641_S0_L001_R2_001 |  30.0% |  26% |  122.5 |
| 1647_S0_L001_R1_001 |  19.4% |  28% |  84.4  |
| 1647_S0_L001_R2_001 |  19.7% |  28% |  84.4  |
| 1707_S0_L001_R1_001 |  83.1% |  24% |  99.2  |
| 1707_S0_L001_R2_001 |  82.0% |  24% |  99.2  |
| 1709_S0_L001_R1_001 |  55.8% |  27% |  680.6 |
| 1709_S0_L001_R2_001 |  60.5% |  27% |  680.6 |
| 1728_S0_L001_R1_001 |  29.9% |  24% |  106.4 |
| 1728_S0_L001_R2_001 |  28.1% |  25% |  106.4 |
| 1732_S0_L001_R1_001 |  26.2% |  29% |  97.4  |
| 1732_S0_L001_R2_001 |  26.5% |  28% |  97.4  |
| 1755_S0_L001_R1_001 |  23.6% |  26% |  81.1  |
| 1755_S0_L001_R2_001 |  24.6% |  26% |  81.1  |
| 1757_S0_L001_R1_001 |  28.4% |  28% |  92.4  |
| 1757_S0_L001_R2_001 |  29.6% |  28% |  92.4  |
| 1765_S0_L001_R1_001 |  17.2% |  28% |  65.5  |
| 1765_S0_L001_R2_001 |  18.0% |  27% |  65.5  |
| 1777_S0_L001_R1_001 |  19.6% |  29% |  36.6  |
| 1777_S0_L001_R2_001 |  19.1% |  29% |  36.6  |
| 1820_S0_L001_R1_001 |  28.5% |  31% |  133.3 |
| 1820_S0_L001_R2_001 |  28.6% |  31% |  133.3 |
| 2012_S0_L001_R1_001 |  40.1% |  24% |  110.5 |
| 2012_S0_L001_R2_001 |  40.3% |  26% |  110.5 |
| 2064_S0_L001_R1_001 |  18.7% |  26% |  83.6  |
| 2064_S0_L001_R2_001 |  19.2% |  27% |  83.6  |
| 2072_S0_L001_R1_001 |  17.2% |  28% |  61.7  |
| 2072_S0_L001_R2_001 |  17.7% |  28% |  61.7  |
| 2087_S0_L001_R1_001 |  31.0% |  25% |  106.0 |
| 2087_S0_L001_R2_001 |  31.8% |  26% |  106.0 |
| 2185_S0_L001_R1_001 |  44.0% |  30% |  83.1  |
| 2185_S0_L001_R2_001 |  44.1% |  30% |  83.1  |
| 2197_S0_L001_R1_001 |  45.2% |  23% |  94.4  |
| 2197_S0_L001_R2_001 |  45.1% |  24% |  94.4  |
| 2212_S0_L001_R1_001 |  77.0% |  22% |  86.8  |
| 2212_S0_L001_R2_001 |  75.0% |  23% |  86.8  |
| 2300_S0_L001_R1_001 |  27.9% |  27% |  113.1 |
| 2300_S0_L001_R2_001 |  28.6% |  26% |  113.1 |
| 2304_S0_L001_R1_001 |  30.4% |  29% |  91.5  |
| 2304_S0_L001_R2_001 |  30.7% |  29% |  91.5  |
| 2306_S0_L001_R1_001 |  20.7% |  28% |  81.5  |
| 2306_S0_L001_R2_001 |  21.1% |  27% |  81.5  |
| 2409_S0_L001_R1_001 |  31.3% |  27% |  101.5 |
| 2409_S0_L001_R2_001 |  31.9% |  27% |  101.5 |
| 2413_S0_L001_R1_001 |  43.9% |  23% |  108.4 |
| 2413_S0_L001_R2_001 |  44.1% |  24% |  108.4 |
| 2513_S0_L001_R1_001 |  21.6% |  32% |  96.5  |
| 2513_S0_L001_R2_001 |  22.3% |  32% |  96.5  |
| 2550_S0_L001_R1_001 |  34.4% |  25% |  152.1 |
| 2550_S0_L001_R2_001 |  34.9% |  26% |  152.1 |
| 2564_S0_L001_R1_001 |  22.5% |  27% |  73.5  |
| 2564_S0_L001_R2_001 |  22.5% |  27% |  73.5  |
| 2668_S0_L001_R1_001 |  18.1% |  28% |  67.6  |
| 2668_S0_L001_R2_001 |  18.6% |  28% |  67.6  |
| 2861_S0_L001_R1_001 |  26.6% |  26% |  76.9  |
| 2861_S0_L001_R2_001 |  27.7% |  26% |  76.9  |
| 2877_S0_L001_R1_001 |  24.2% |  26% |  65.3  |
| 2877_S0_L001_R2_001 |  24.6% |  27% |  65.3  |
| 2878_S0_L001_R1_001 |  29.8% |  24% |  159.4 |
| 2878_S0_L001_R2_001 |  17.4% |  25% |  159.4 |
| 2879_S0_L001_R1_001 |  23.2% |  29% |  85.7  |
| 2879_S0_L001_R2_001 |  23.0% |  28% |  85.7  |

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/initial%20fastqc/seq%20counts.png?raw=true)

Sample 1709 had a very large # of reads. The rest are within the range of my other projects (not low reads, graph is relative).

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/initial%20fastqc/seq%20quality.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/initial%20fastqc/per%20seq%20quality.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/initial%20fastqc/per%20seq%20GC%20content.png?raw=true)

This peak has a normal distribution (good, what we're looking for) but is shifted to a peak ~20-25... This is usually higher? Red flag?
Is this shifted because methylation changes unmethylated Cytosine to Thymine and therefore a smaller amount of GC content? Especially in an invertebrate that only has 20% methylation.. This is actually a green flag then?

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/initial%20fastqc/per%20base%20N%20content.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/initial%20fastqc/seq%20duplication%20levels.png?raw=true)

~6 samples have a red peak >10. I'm not sure why.. come back to this.

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/initial%20fastqc/overrepresented%20seqs.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/initial%20fastqc/adapter%20content.png?raw=true)

## <a name="Test"></a> **Methylseq: Trimming parameters test**

### Options tested

This was done on a small subset (n=5) to reduce the time that these scripts had to run. I.e. 5 samples instead of 60. Each script took a little over 24 hours to run.

**Goal**: Reduce M-bias but keep as much of the sequence as possible.

**Reasoning behind values**: I chose to not include the Zymo preset because this one worked the least well for Kevin's set. I proceeded with my own preset cut-offs to test. I included the final version that Kevin went with for his and what appeared to be the second best option as well.

Options tested:  
1. HoloInt_methylseq.sh: clip_r1 = 10, clip_r2 = 10, three_prime_clip_r1 = 10, three_prime_clip_r2 = 10    
2. HoloInt_methylseq2.sh: clip_r1 = 15, clip_r2 = 30, three_prime_clip_r1 = 15, three_prime_clip_r2 = 15 (options that worked best for Kevin Past workflow)   
3. HoloInt_methylseq3.sh: clip_r1 = 15, clip_r2 = 30, three_prime_clip_r1 = 30, three_prime_clip_r2 = 15    

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
--input '/data/putnamlab/estrand/HoloInt_WGBS/test_set/*_R{1,2}_001.fastq.gz' \
--clip_r1 10 \
--clip_r2 10 \
--three_prime_clip_r1 10 --three_prime_clip_r2 10 \
--non_directional \
--cytosine_report \
--relax_mismatches \
--unmapped \
--outdir /data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq \
-name WGBS_methylseq_HoloInt-10
```

The multiqc report ran into this error: `Missing output file(s) multiqc_plots expected by process multiqc (1)`.  

I ran this command in the terminal and it worked :

```
$ module load MultiQC/1.9-intel-2020a-Python-3.8.2

$ multiqc -f --title "WGBS_methylseq_HoloInt-10" --filename WGBS_methylseq_HoloInt_10_multiqc_report  . \
      -m custom_content -m picard -m qualimap -m bismark -m samtools -m preseq -m cutadapt -m fastqc
```

Ouptut: WGBS_methylseq_HoloInt_10_multiqc_report.html.

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq/WGBS_methylseq_HoloInt_10_multiqc_report.html /Users/emmastrand/MyProjects/Acclim_Dynamics/Molecular_paper/WGBS/output/WGBS_methylseq_HoloInt_10_multiqc_report.html
```


### HoloInt_methylseq2

```
nano HoloInt_methylseq2.sh
```

```
#!/bin/bash
#SBATCH --job-name="methylseq2"
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

nextflow run nf-core/methylseq \
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
--outdir /data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq2 \
-name WGBS_methylseq_HoloInt2
```

The multiqc report ran into this error: `Missing output file(s) multiqc_plots expected by process multiqc (1)`.  

I ran this command in the terminal and it worked (within the HoloInt_methylseq2 folder):

```
$ module load MultiQC/1.9-intel-2020a-Python-3.8.2

$ multiqc -f --title "WGBS_methylseq_HoloInt2" --filename WGBS_methylseq_HoloInt2_multiqc_report  . \
      -m custom_content -m picard -m qualimap -m bismark -m samtools -m preseq -m cutadapt -m fastqc
```

Ouptut: WGBS_methylseq_HoloInt2_multiqc_report.html.

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq2/WGBS_methylseq_HoloInt2_multiqc_report.html /Users/emmastrand/MyProjects/Acclim_Dynamics/Molecular_paper/WGBS/output/WGBS_methylseq_HoloInt2_multiqc_report.html
```

### HoloInt_methylseq3

```
nano HoloInt_methylseq3.sh
```

```
#!/bin/bash
#SBATCH --job-name="methylseq3"
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

nextflow run nf-core/methylseq \
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
--outdir /data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq3 \
-name WGBS_methylseq_HoloInt3
```

The multiqc report ran into this error: `Missing output file(s) multiqc_plots expected by process multiqc (1)`.  

I ran this command in the terminal and it worked (within the HoloInt_methylseq2 folder):

```
$ module load MultiQC/1.9-intel-2020a-Python-3.8.2

$ multiqc -f --title "WGBS_methylseq_HoloInt3" --filename WGBS_methylseq_HoloInt3_multiqc_report  . \
      -m custom_content -m picard -m qualimap -m bismark -m samtools -m preseq -m cutadapt -m fastqc
```

Ouptut: WGBS_methylseq_HoloInt3_multiqc_report.html.

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq3/WGBS_methylseq_HoloInt3_multiqc_report.html /Users/emmastrand/MyProjects/Acclim_Dynamics/Molecular_paper/WGBS/output/WGBS_methylseq_HoloInt3_multiqc_report.html
```

### Results of the multiqc on the three reports above

HoloInt_methylseq full report: https://github.com/hputnam/Acclim_Dynamics/blob/master/Molecular_paper/WGBS/output/WGBS_methylseq_HoloInt_10_multiqc_report.html     
HoloInt_methylseq2 full report:  https://github.com/hputnam/Acclim_Dynamics/blob/master/Molecular_paper/WGBS/output/WGBS_methylseq_HoloInt2_multiqc_report.html  
HoloInt_methylseq3 full report:  https://github.com/hputnam/Acclim_Dynamics/blob/master/Molecular_paper/WGBS/output/WGBS_methylseq_HoloInt3_multiqc_report.html  

Comparison of methylseq statistics found here: https://github.com/hputnam/Acclim_Dynamics/blob/master/Molecular_paper/scripts/methylseq_statistics.md

*HoloInt_methylseq*

![](https://github.com/hputnam/Acclim_Dynamics/blob/master/Molecular_paper/WGBS/output/methylseq_multiqc_comparison/HoloInt_methylseq/m-bias%20CpG%20R1.png?raw=true)

![](https://github.com/hputnam/Acclim_Dynamics/blob/master/Molecular_paper/WGBS/output/methylseq_multiqc_comparison/HoloInt_methylseq/m-bias%20CpG%20R2.png?raw=true)

*HoloInt_methylseq2*

![](https://github.com/hputnam/Acclim_Dynamics/blob/master/Molecular_paper/WGBS/output/methylseq_multiqc_comparison/HoloInt_methylseq2/M-bias%20CpG%20R1.png?raw=true)

![](https://github.com/hputnam/Acclim_Dynamics/blob/master/Molecular_paper/WGBS/output/methylseq_multiqc_comparison/HoloInt_methylseq2/M-bias%20CpG%20R2.png?raw=true)

*HoloInt_methylseq3*

![](https://github.com/hputnam/Acclim_Dynamics/blob/master/Molecular_paper/WGBS/output/methylseq_multiqc_comparison/HoloInt_methylseq3/M-bias%20CpG%20R1.png?raw=true)

![](https://github.com/hputnam/Acclim_Dynamics/blob/master/Molecular_paper/WGBS/output/methylseq_multiqc_comparison/HoloInt_methylseq3/M-bias%20CpG%20R2.png?raw=true)

Based on the above, I am moving forward with HoloInt_methylseq trimming of clip 10 for all four options.


## <a name="methylseq_final"></a> **Methylseq: final script run**

`HoloInt_methylseq_final.sh`. This timed out after 10 days so I ran again with the -resume flag and changed the output name to `WGBS_methylseq_HoloInt_final2`. Total this took 2 weeks. 

```
#!/bin/bash
#SBATCH --job-name="methylseq_final"
#SBATCH -t 250:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=500GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq_final
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
--outdir /data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq_final \
-name WGBS_methylseq_HoloInt_final
```

The multiqc function is running into errors from the above script so I ran:

```
multiqc -f --title "WGBS_methylseq_HoloInt_final2" --filename WGBS_methylseq_HoloInt_final2_multiqc_report  . \
      -m custom_content -m picard -m qualimap -m bismark -m samtools -m preseq -m cutadapt -m fastqc
```

This was part of the output file. Shouldn't there be 60 preseq files, not 59? 

```
[INFO   ]        qualimap : Found 60 BamQC reports
[INFO   ]          preseq : Found 59 reports
[INFO   ]         bismark : Found 60 alignment reports
[INFO   ]         bismark : Found 60 dedup reports
[INFO   ]         bismark : Found 60 methextract reports
[INFO   ]        cutadapt : Found 120 reports
[INFO   ]          fastqc : Found 240 reports
``` 

Copying this file to project folder: 

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq_final/WGBS_methylseq_HoloInt_final2_multiqc_report.html /Users/emmastrand/MyProjects/Acclim_Dynamics/Molecular_paper/WGBS/output/WGBS_methylseq_HoloInt_final2_multiqc_report.html
```

## <a name="final_multiqc"></a> **Methylseq: Final Multiqc Report Output**




## <a name="troubleshooting"></a> **Troubleshooting**

### Original methylseq parameters (old_HoloInt_methylseq) - the first time it was run (which I don't think was fully which is why I ran this again)

This doesn't look right.. I don't think this script ran all the way..

```
#!/bin/bash
#SBATCH --job-name="methylseq"
#SBATCH -t 120:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=128GB
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS
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
--outdir /data/putnamlab/estrand/HoloInt_WGBS
```

I couldn't find the multiqc report from this script so I ran this command in the terminal and it worked (in the old_HoloInt_methylseq folder):

```
$ module load MultiQC/1.9-intel-2020a-Python-3.8.2

$ multiqc -f --filename WGBS_methylseq_HoloInt_original_multiqc_report  . \
      -m custom_content -m picard -m qualimap -m bismark -m samtools -m preseq -m cutadapt -m fastqc

[WARNING]         multiqc : MultiQC Version v1.12 now available!
[INFO   ]         multiqc : This is MultiQC v1.9
[INFO   ]         multiqc : Template    : default
[INFO   ]         multiqc : Searching   : /data/putnamlab/estrand/HoloInt_WGBS/old_HoloInt_methylseq
[INFO   ]         multiqc : Only using modules custom_content, picard, qualimap, bismark, samtools, preseq, cutadapt, fastqc
Searching 3881 files..  [####################################]  100%          
[INFO   ]  custom_content : nf-core-methylseq-summary: Found 1 sample (html)
[INFO   ]        qualimap : Found 50 BamQC reports
[INFO   ]          preseq : Found 49 reports
[INFO   ]         bismark : Found 60 alignment reports
[INFO   ]         bismark : Found 50 dedup reports
[INFO   ]         bismark : Found 29 methextract reports
[INFO   ]        cutadapt : Found 120 reports
[INFO   ]          fastqc : Found 240 reports
[INFO   ]         multiqc : Compressing plot data
[INFO   ]         multiqc : Report      : WGBS_methylseq_HoloInt_original_multiqc_report.html
[INFO   ]         multiqc : Data        : WGBS_methylseq_HoloInt_original_multiqc_report_data
[INFO   ]         multiqc : MultiQC complete
```

The above numbers look wonky.. Should be 60 preseq reports?

Ouptut: WGBS_methylseq_HoloInt_original_multiqc_report.html.

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/HoloInt_WGBS/old_HoloInt_methylseq/WGBS_methylseq_HoloInt_original_multiqc_report.html /Users/emmastrand/MyProjects/Acclim_Dynamics/Molecular_paper/WGBS/output/WGBS_methylseq_HoloInt_original_multiqc_report.html
```
