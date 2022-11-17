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
- [**Merge Strands**](#merge)  
- [**Sort CpG .cov file**](#sort)   
- [**Filter for a specific coverage (5X, 10X)**](#filter_cov)   
- [**Create a file with positions found in all samples**](#filter_pos)   
- [**Gene Annotation file**](#gene_anno)  
- [**IntersectBed: Loci mapped to annotated gene**](#intersectBed_map) 
- [**IntersectBed: File to only positions found in all samples**](#intersectBed_all) 
- [**Export File**](#export) 
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

### GENOME VERSION 1

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

### GENOME VERSION 1 

*I created a new github repo for the molecular portion of this project: MyProjects/Acclim_Dynamics_molecular/.* 

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/methylseq%20multiqc/coverage%20histogram.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/methylseq%20multiqc/cumulative%20genome%20coverage.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/methylseq%20multiqc/insert%20size%20histogram.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/methylseq%20multiqc/GC%20content%20distribution.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/methylseq%20multiqc/complexity%20curve.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/methylseq%20multiqc/alignment%20rates.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/methylseq%20multiqc/deduplication.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/methylseq%20multiqc/strand%20alignment.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/methylseq%20multiqc/cytosine%20methylation.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/methylseq%20multiqc/m-bias-cpg-R1.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/methylseq%20multiqc/m-bias-cpg-R2.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20Multiqc%20Report/methylseq%20multiqc/trimmed%20seq%20lengths.png?raw=true)

Based on this assessment we will likely take a few of the wonky samples out prior to analysis, but will keep them in through the next following steps. 

### GENOME VERSION 2

A newer version of the genome was released while I was analyzing this data so I want to run this again with the newer version (http://cyanophora.rutgers.edu/Pocillopora_acuta/).

`wget http://cyanophora.rutgers.edu/Pocillopora_acuta/Pocillopora_acuta_HIv2.assembly.fasta.gz` and `gunzip Pocillopora_acuta_HIv2.assembly.fasta.gz`. 

`HoloInt_methylseq_genomev2.sh`: 

```
#!/bin/bash
#SBATCH --job-name="methylseq_v2"
#SBATCH -t 600:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=128GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq_genomev2
#SBATCH -p putnamlab
#SBATCH --cpus-per-task=3
#SBATCH --error="script_error_methylseq_v2" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_methylseq_v2" #once your job is completed, any final job report comments will be put in this file

# load modules needed
source /usr/share/Modules/init/sh # load the module function

module load Nextflow/21.03.0
module load FastQC/0.11.9-Java-11
module load MultiQC/1.9-intel-2020a-Python-3.8.2

# run nextflow methylseq

nextflow run nf-core/methylseq -resume \
-profile singularity \
--aligner bismark \
--igenomes_ignore \
--fasta /data/putnamlab/estrand/Pocillopora_acuta_HIv2.assembly.fasta \
--save_reference \
--input '/data/putnamlab/KITT/hputnam/20211008_HoloInt_WGBS/*_R{1,2}_001.fastq.gz' \
--clip_r1 10 \
--clip_r2 10 \
--three_prime_clip_r1 10 --three_prime_clip_r2 10 \
--non_directional \
--cytosine_report \
--relax_mismatches \
--unmapped \
--outdir /data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq_genomev2 \
-name HoloInt_methylseq_genomev2_3 ### I had to change this any time running a new project or running this script again
```

The multiqc function is running into errors from the above script so I ran:

```
interactive 

module load MultiQC/1.9-intel-2020a-Python-3.8.2

multiqc -f --filename WGBS_methylseq_HoloInt_genomev2_multiqc_report  . \
      -m custom_content -m picard -m qualimap -m bismark -m samtools -m preseq -m cutadapt -m fastqc
```

Copying this file to project folder: 

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq_genomev2/WGBS_methylseq_HoloInt_genomev2_multiqc_report.html /Users/emmastrand/MyProjects/Acclim_Dynamics_molecular/data/WGBS/output/WGBS_methylseq_HoloInt_genomev2_multiqc_report.html
```

### MultiQC Report 

![](https://github.com/emmastrand/Acclim_Dynamics_molecular/blob/main/data/WGBS/output/genomev2-multiqc/cov%20hist.png?raw=true)
![](https://github.com/emmastrand/Acclim_Dynamics_molecular/blob/main/data/WGBS/output/genomev2-multiqc/cumulative%20genome%20cov.png?raw=true)
![](https://github.com/emmastrand/Acclim_Dynamics_molecular/blob/main/data/WGBS/output/genomev2-multiqc/insert%20size%20hist.png?raw=true)
![](https://github.com/emmastrand/Acclim_Dynamics_molecular/blob/main/data/WGBS/output/genomev2-multiqc/gc%20content.png?raw=true)
![](https://github.com/emmastrand/Acclim_Dynamics_molecular/blob/main/data/WGBS/output/genomev2-multiqc/complexity%20curve.png?raw=true)
![](https://github.com/emmastrand/Acclim_Dynamics_molecular/blob/main/data/WGBS/output/genomev2-multiqc/bismark%20alignment.png?raw=true)
![](https://github.com/emmastrand/Acclim_Dynamics_molecular/blob/main/data/WGBS/output/genomev2-multiqc/deduplication.png?raw=true)
![](https://github.com/emmastrand/Acclim_Dynamics_molecular/blob/main/data/WGBS/output/genomev2-multiqc/strand%20alignment.png?raw=true)
![](https://github.com/emmastrand/Acclim_Dynamics_molecular/blob/main/data/WGBS/output/genomev2-multiqc/cytosine%20methylation.png?raw=true)
![](https://github.com/emmastrand/Acclim_Dynamics_molecular/blob/main/data/WGBS/output/genomev2-multiqc/m%20bias.png?raw=true)
![](https://github.com/emmastrand/Acclim_Dynamics_molecular/blob/main/data/WGBS/output/genomev2-multiqc/trimmed%20seq%20lengths.png?raw=true)


## <a name="merge"></a> **Merge Strands**

The file output from the methylseq pipeline that is used for the following steps: `bismark_methylation_calls/methylation_coverage/*deduplicated.bismark.cov.gz`. 

The Bismark `coverage2cytosine` command re-reads the genome-wide report and merges methylation evidence of both top and bottom strand to create one file. 

Input: `*deduplicated.bismark.cov.gz`.  
Output: `*merged_CpG_evidence.cov`.

### GENOME VERSION 1

Make a new directory for this output: `mkdir merged_cov`. 

This takes ~7 hours (60 samples). 

`merge_strands.sh` (named cov_to_cyto in other lab members' pipelines): 

```
#!/bin/bash
#SBATCH --job-name="merge"
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=500GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS/merged_cov #### this should be your new output directory so all the outputs ends up here
#SBATCH --cpus-per-task=3
#SBATCH --error="script_error_merge" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_merge" #once your job is completed, any final job report comments will be put in this file

# load modules needed (specific need for my computer)
source /usr/share/Modules/init/sh # load the module function

# load modules needed

module load Bismark/0.20.1-foss-2018b

# run coverage2cytosine merge of strands
# change paths below 
# change file names below (_S0_L001_*)
# there can't be any spaces after the \

find /data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq_final/bismark_methylation_calls/methylation_coverage/*deduplicated.bismark.cov.gz \
 | xargs basename -s _S0_L001_R1_001_val_1_bismark_bt2_pe.deduplicated.bismark.cov.gz \
 | xargs -I{} coverage2cytosine \
 --genome_folder /data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq_final/reference_genome/BismarkIndex \
 -o {} \
 --merge_CpG \
 --zero_based \
/data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq_final/bismark_methylation_calls/methylation_coverage/{}_S0_L001_R1_001_val_1_bismark_bt2_pe.deduplicated.bismark.cov.gz
```

### GENOME VERSION 2

Make a new directory for this output: `mkdir merged_cov_genomev2`. 

`scripts/genomev2/merge_strandsv2.sh` 

```
#!/bin/bash
#SBATCH --job-name="v2merge"
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=128GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2 #### this should be your new output directory so all the outputs ends up here
#SBATCH --cpus-per-task=3
#SBATCH --error="script_error_merge_v2" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_merge_v2" #once your job is completed, any final job report comments will be put in this file

# load modules needed (specific need for my computer)
source /usr/share/Modules/init/sh # load the module function

# load modules needed

module load Bismark/0.20.1-foss-2018b

# run coverage2cytosine merge of strands
# change paths below 
# change file names below (_S0_L001_*)
# there can't be any spaces after the \

find /data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq_genomev2/bismark_methylation_calls/methylation_coverage/*deduplicated.bismark.cov.gz \
 | xargs basename -s _S0_L001_R1_001_val_1_bismark_bt2_pe.deduplicated.bismark.cov.gz \
 | xargs -I{} coverage2cytosine \
 --genome_folder /data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq_genomev2/reference_genome/BismarkIndex \
 -o {} \
 --merge_CpG \
 --zero_based \
/data/putnamlab/estrand/HoloInt_WGBS/HoloInt_methylseq_genomev2/bismark_methylation_calls/methylation_coverage/{}_S0_L001_R1_001_val_1_bismark_bt2_pe.deduplicated.bismark.cov.gz
```

### OVERVIEW 

The script is saying:  
- for every file in `methylation_coverage` repo that ends with `deduplicated.bismark.cov.gz` (there should be 60 for this project),  
- and has basename of `_S0_L001_R1_001_val_1_bismark_bt2_pe.deduplicated.bismark.cov.gz` (everything that comes after the sample ID)
- perform the function `coverage2cytosine` within the Bismark module 
- identifies where the output genome is located (folder `reference_genome/BismarkIndex` within methylseq output folder)
- `--zero_based`: uses 0-based genomic coordinates instead of 1-based coordinates. Default is OFF  
- `-o`: output file names; {} identifies these remain the same 
- `merge_CpG`: write out additional coverage files that has the top and bottom strand methylation evidence pooled into a single CpG dinucleotide entity. 

Help on merge_CpG function: https://github.com/FelixKrueger/Bismark/issues/86/. 

The output files will look like (without the headers): 

| **Scaffold** | **Start Position** | **Stop Position** | **% Methylated** | **Methylated** | **Unmethylated** |
|--------------|--------------------|-------------------|------------------|----------------|------------------|
| 000000F      | 29076              | 29078             | 0.000000         | 0              | 5                |
| 000000F      | 29158              | 29160             | 0.000000         | 0              | 12               |
| 000000F      | 29185              | 29187             | 0.000000         | 0              | 8                |
| 000000F      | 29215              | 29217             | 0.000000         | 0              | 4                |
| 000000F      | 29232              | 29234             | 0.000000         | 0              | 3                |
| 000000F      | 29241              | 29243             | 11.111111        | 1              | 8                |
| 000000F      | 29277              | 29279             | 0.000000         | 0              | 11               |
| 000000F      | 29282              | 29284             | 0.000000         | 0              | 12               |
| 000000F      | 29313              | 29315             | 0.000000         | 0              | 11               |
| 29335        | 29335              | 29337             | 0.000000         | 0              | 10               |

Each CpG dinucleotide will have data for % methylation, and how many times that CpG was methylated or unmethylated. 


## <a name="sort"></a> **Sort CpG .cov file**

This function sorts all the merged files so that all scaffolds are in the same order. This needs to be done for multiIntersectBed to run correctly. This sets up a loop to do this for every sample (file). 

### GENOME VERSION 1

`bedtools_sort.sh`: 

```
#!/bin/bash
#SBATCH --job-name="H-sort"
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=500GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS/merged_cov #### this is the output from the merge cov step above 
#SBATCH --cpus-per-task=3
#SBATCH --error="script_error_sort" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_sort" #once your job is completed, any final job report comments will be put in this file

# load modules needed (specific need for my computer)
source /usr/share/Modules/init/sh # load the module function

# load BEDTools 
module load BEDTools/2.27.1-foss-2018b

for f in *merged_CpG_evidence.cov
do
  STEM=$(basename "${f}" .CpG_report.merged_CpG_evidence.cov)
  bedtools sort -i "${f}" \
  > "${STEM}"_sorted.cov
done
```

### GENOME VERSION 2

`bedtools_sortv2.sh`: 

```
#!/bin/bash
#SBATCH --job-name="v2H-sort"
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=500GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2 #### this is the output from the merge cov step above 
#SBATCH --cpus-per-task=3
#SBATCH --error="script_error_sortv2" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_sortv2" #once your job is completed, any final job report comments will be put in this file

# load modules needed (specific need for my computer)
source /usr/share/Modules/init/sh # load the module function

# load BEDTools 
module load BEDTools/2.27.1-foss-2018b

for f in *merged_CpG_evidence.cov
do
  STEM=$(basename "${f}" .CpG_report.merged_CpG_evidence.cov)
  bedtools sort -i "${f}" \
  > "${STEM}"_sorted.cov
done
```

No errors - move on.

### OVERVIEW 

The script is saying: 
- For every sample's .cov file in the output folder `merged_cov`, use bedtools function to sort and then output a file with the same name plus `_sorted.cov`. 

No errors reported with this script, move on to the next one. Viewing one file to make sure this worked and it appears to be sorted. 

```
less 1536_sorted.cov

# example of output from this step V1
Pocillopora_acuta_HIv1___Scaffold_000000F___length_7015273      3246    3248    0.000000        0       2
Pocillopora_acuta_HIv1___Scaffold_000000F___length_7015273      3517    3519    0.000000        0       3
Pocillopora_acuta_HIv1___Scaffold_000000F___length_7015273      3538    3540    0.000000        0       3
Pocillopora_acuta_HIv1___Scaffold_000000F___length_7015273      3555    3557    0.000000        0       3
```


## <a name="filter_cov"></a> **Filter for a specific coverage (5X, 10X)**

This script is running a loop to filter CpGs for a specified coverage and creating tab files.

Essentially, the loop in this script will take columns 5 (Methylated) and 6 (Unmethylated) positions and keeps that row if it is greater than or equal to 5. This means that we have 5x coverage for this position. This limits our interpretation to 0%, 20%, 40%, 60%, 80%, 100% methylation resolution per position.

Input File: `*merged_CpG_evidence.cov`  
Output File: `5x_sorted.tab` and `10x_sorted.tab`

### GENOME VERSION 1

`covX.sh`: 

```
#!/bin/bash
#SBATCH --job-name="H-covX"
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=500GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS/merged_cov #### this is the output from the merge cov step above 
#SBATCH --cpus-per-task=3
#SBATCH --error="script_error_covX" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_covX" #once your job is completed, any final job report comments will be put in this file

# load modules needed (specific need for my computer)
source /usr/share/Modules/init/sh # load the module function

### Filtering for CpG for 5x coverage. To change the coverage, replace X with your desired coverage in ($5+6 >= X)

for f in *_sorted.cov
do
  STEM=$(basename "${f}" _sorted.cov)
  cat "${f}" | awk -F $'\t' 'BEGIN {OFS = FS} {if ($5+$6 >= 5) {print $1, $2, $3, $4, $5, $6}}' \
  > "${STEM}"_5x_sorted.tab
done

### Filtering for CpG for 10x coverage. To change the coverage, replace X with your desired coverage in ($5+6 >= X)

for f in *_sorted.cov
do
  STEM=$(basename "${f}" _sorted.cov)
  cat "${f}" | awk -F $'\t' 'BEGIN {OFS = FS} {if ($5+$6 >= 10) {print $1, $2, $3, $4, $5, $6}}' \
  > "${STEM}"_10x_sorted.tab
done
```

### GENOME VERSION 2

`covX-v2.sh`: 

```
#!/bin/bash
#SBATCH --job-name="v2H-covX"
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=128GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2 #### this is the output from the merge cov step above 
#SBATCH --cpus-per-task=3
#SBATCH --error="script_error_covX-v2" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_covX-v2" #once your job is completed, any final job report comments will be put in this file

# load modules needed (specific need for my computer)
source /usr/share/Modules/init/sh # load the module function

### Filtering for CpG for 5x coverage. To change the coverage, replace X with your desired coverage in ($5+6 >= X)

for f in *_sorted.cov
do
  STEM=$(basename "${f}" _sorted.cov)
  cat "${f}" | awk -F $'\t' 'BEGIN {OFS = FS} {if ($5+$6 >= 5) {print $1, $2, $3, $4, $5, $6}}' \
  > "${STEM}"_5x_sorted.tab
done

### Filtering for CpG for 10x coverage. To change the coverage, replace X with your desired coverage in ($5+6 >= X)

for f in *_sorted.cov
do
  STEM=$(basename "${f}" _sorted.cov)
  cat "${f}" | awk -F $'\t' 'BEGIN {OFS = FS} {if ($5+$6 >= 10) {print $1, $2, $3, $4, $5, $6}}' \
  > "${STEM}"_10x_sorted.tab
done
```

No error messages. Move on

### OVERVIEW 

Moving forward I want to see the differences in data we get from 5X and 10X. We'll have to decide which threshold to use moving forward. We want confidence and high resolution but also a large dataset so we need a happy medium. 

No errors or output messages so we are good to move on. 

At this point all samples have the following files: 
- `1755.CpG_report.txt`  
- `1755.CpG_report.merged_CpG_evidence.cov`  
- `1755_5x_sorted.tab`  
- `1755_10x_sorted.tab`   


## <a name="filter_pos"></a> **Create a file with positions found in all samples**

We need to create a file that is filtered to only positions that are found in all samples (both methylated and unmethylated). `multiIntersectBed` creates a file that merges all samples together. The 4th column then tells you how samples have that position. We can then filter positions based on this column that is equal to our sample size. n=60 for this project. 

Here is where we can loose the most reads. 

Input file: `5x_sorted.tab` and `10x_sorted.tab`  
Output file: `CpG.filt.all.samps.5x_sorted.bed` and `CpG.filt.all.samps.10x_sorted.bed` (one file for each coverage that has positions found in all samples)

### GENOME VERSION 1

`cov_allsamples.sh`: 

```
#!/bin/bash
#SBATCH --job-name="H-all_cov"
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=500GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS/merged_cov #### this is the output from the merge cov step above 
#SBATCH --cpus-per-task=3
#SBATCH --error="script_error_all_cov" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_all_cov" #once your job is completed, any final job report comments will be put in this file

# load modules needed  
source /usr/share/Modules/init/sh # load the module function (specific to my computer)
module load BEDTools/2.27.1-foss-2018b

multiIntersectBed -i *_5x_sorted.tab > CpG.all.samps.5x_sorted.bed
multiIntersectBed -i *_10x_sorted.tab > CpG.all.samps.10x_sorted.bed

cat CpG.all.samps.5x_sorted.bed | awk '$4 ==60' > CpG.filt.all.samps.5x_sorted.bed

cat CpG.all.samps.10x_sorted.bed | awk '$4 ==60' > CpG.filt.all.samps.10x_sorted.bed
```

No errors in the script and all four files were created. 

### GENOME VERSION 2

`cov_allsamples-v2.sh`: 

```
#!/bin/bash
#SBATCH --job-name="v2H-all_cov"
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=128GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2 #### this is the output from the merge cov step above 
#SBATCH --cpus-per-task=3
#SBATCH --error="script_error_all_cov-v2" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_all_cov-v2" #once your job is completed, any final job report comments will be put in this file

# load modules needed  
source /usr/share/Modules/init/sh # load the module function (specific to my computer)
module load BEDTools/2.27.1-foss-2018b

multiIntersectBed -i *_5x_sorted.tab > CpG.all.samps.5x_sorted.bed
multiIntersectBed -i *_10x_sorted.tab > CpG.all.samps.10x_sorted.bed

cat CpG.all.samps.5x_sorted.bed | awk '$4 ==60' > CpG.filt.all.samps.5x_sorted.bed

cat CpG.all.samps.10x_sorted.bed | awk '$4 ==60' > CpG.filt.all.samps.10x_sorted.bed
```

## <a name="gene_anno"></a> **Gene Annotation file**

http://cyanophora.rutgers.edu/Pocillopora_acuta/. This is the step I switched to version 2 fully and did not do with version 1. 

### GENOME VERSION 2

#### Download the genome. 

`wget http://cyanophora.rutgers.edu/Pocillopora_acuta/Pocillopora_acuta_HIv2.genes.gff3.gz`  
`gunzip Pocillopora_acuta_HIv2.genes.gff3.gz` 

#### View the contents. 

```
$ head Pocillopora_acuta_HIv2.genes.gff3

Pocillopora_acuta_HIv2___Sc0000016	AUGUSTUS	transcript	151	2746	.	+	.	ID=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016	AUGUSTUS	CDS	151	172	.	+	0	Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016	AUGUSTUS	exon	151	172	.	+	0	Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016	AUGUSTUS	CDS	264	304	.	+	2	Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016	AUGUSTUS	exon	264	304	.	+	2	Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016	AUGUSTUS	CDS	1491	1602	.	+	0	Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016	AUGUSTUS	exon	1491	1602	.	+	0	Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016	AUGUSTUS	CDS	1889	1990	.	+	2	Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016	AUGUSTUS	exon	1889	1990	.	+	2	Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016	AUGUSTUS	CDS	2107	2127	.	+	2	Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
```

#### Filtering the 3rd column for only 'genes': 

```
$ awk '{if ($3 == "gene") {print}}' Pocillopora_acuta_HIv2.genes.gff3  > Pocillopora_acuta_HIv2.genes_genesonly.gff3
```

This came up empty so the original file is only genes and we don't need to filter to this. I removed the file created. 


## <a name="intersectBed_map"></a> **IntersectBed: Loci mapped to annotated gene**

### GENOME VERSION 2

Next, merge each sample file with gene annotation file using `intersectBed`. 

Input files: `*5x_sorted.tab` and `*10x_sorted.tab` and `Montipora_capitata_HIv2.genes.gff3`  
Output files: `*_5x_sorted.tab_gene` and `*_10x_sorted.tab_gene`

`intersectBed-v2.sh`:

```
#!/bin/bash
#SBATCH --job-name="v2H-intersectBed"
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=500GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2 #### this is the output from the merge cov step above 
#SBATCH --cpus-per-task=3
#SBATCH --error="script_error_intersectBed-v2" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_intersectBed-v2" #once your job is completed, any final job report comments will be put in this file

#  load modules needed  
source /usr/share/Modules/init/sh # load the module function (specific to my computer)
module load BEDTools/2.27.1-foss-2018b

for i in *5x_sorted.tab
do
  intersectBed \
  -wb \
  -a ${i} \
  -b /data/putnamlab/estrand/Pocillopora_acuta_HIv2.genes.gff3 \
  > ${i}_gene
done

for i in *10x_sorted.tab
do
  intersectBed \
  -wb \
  -a ${i} \
  -b /data/putnamlab/estrand/Pocillopora_acuta_HIv2.genes.gff3 \
  > ${i}_gene
done
```

## <a name="intersectBed_all"></a> **IntersectBed: File to only positions found in all samples**

### GENOME VERSION 2

`intersect_enrichment-v2.sh`: 

```
#!/bin/bash
#SBATCH --job-name="v2H-enrich"
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=500GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2 #### this is the output from the merge cov step above 
#SBATCH --cpus-per-task=3
#SBATCH --error="script_error_v2H-enrich" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_v2H-enrich" #once your job is completed, any final job report comments will be put in this file

# load modules needed  
source /usr/share/Modules/init/sh # load the module function (specific to my computer)
module load BEDTools/2.27.1-foss-2018b

for i in *_5x_sorted.tab_gene
do
  intersectBed \
  -a ${i} \
  -b CpG.filt.all.samps.5x_sorted.bed \
  > ${i}_CpG_5x_enrichment.bed
done

for i in *_10x_sorted.tab_gene
do
  intersectBed \
  -a ${i} \
  -b CpG.filt.all.samps.10x_sorted.bed \
  > ${i}_CpG_10x_enrichment.bed
done
```

Within merged_cov_genomev2 folder: 

```
wc -l *10x_enrichment.bed > 10x_enrichment_sample_size.txt 
wc -l *5x_enrichment.bed > 5x_enrichment_sample_size.txt
```

### 5X COVERAGE 



### 10X COVERAGE 


## <a name="export"></a> **Export Files**

```
scp 'emma_strand@ssh3.hac.uri.edu:/data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*_5x_enrichment.bed' ~/MyProjects/Acclim_Dynamics_molecular/data/WGBS/output/meth_counts_5x

scp 'emma_strand@ssh3.hac.uri.edu:/data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*_10x_enrichment.bed' ~/MyProjects/Acclim_Dynamics_molecular/data/WGBS/output/meth_counts_10x
```


## <a name="troubleshooting"></a> **Troubleshooting**

### Versions 1 and 2 of the Pacuta genome

Halfway through my analysis, a new and improved P. acuta genome was released. I did the analysis with both of these files. 



### Gene annotation with the wrong Pacuta file 

This step needs a modified gff file that is only includes gene positions. 

http://ihpe.univ-perp.fr/acces-aux-donnees/. This website has a `Data_to_downoload.rar` file that I downloaded to Andromeda using `wget http://ihpe.univ-perp.fr/telechargement/Data_to_downoload.rar`. Kevin Bryan downloaded the module `unrar/6.0.2-GCCcore-10.2.0` for me to use the function `unrar` to see what files are stored in this `Data_to_downoload.rar` file. 

`Data_to_downoload.rar` is not mispelled. There is an extra "o" after "down". 

```
# mkdir /data/putnamlab/estrand/Pacuta_download_genome_rar
# wget command above

# load the module 
$ module load unrar/6.0.2-GCCcore-10.2.0

# to see all files that are in this .rar file
$ unrar -l Data_to_downoload.rar 

Some files of interest in the output: 
/Pocillopora_acuta_genome_v1.fasta
/READ_ME.txt
/Structural_annotation_abintio.gff
/Structural_annotation_experimental.gff
/Functionnal_annotation_orthoMCL_abinitio

# download only one file from the .rar file 
unrar x Data_to_downoload.rar Data_to_downoload/READ_ME.txt 
# then deleted the Data_to_downoload directory folder made in the above command (b/c mispelled)

unrar x Data_to_downoload.rar Data_to_downoload/Structural_annotation_abintio.gff
```

After opening the READ_ME.txt file, I belive this is the .gff I'm looking for: 
- `Data_to_downoload/Structural_annotation_abintio.gff` (not spelled the same as in the READ_ME.txt file. File name is missing an "i").  
- This file is the results of the structural annotation performed on the genes predicted from AUGUSTUS. It give the position of genes, transcripts, exon (initial, internal and terminal) CDS, intron, start codon and stop codon  on the genome sequence. It is in gff format.

Contents of that file: 

```
scaffold7cov100 b2h     ep      12544   12555   0       .       .       grp=TCONS00053944;pri=4;src=E "3.16e+04;0.995;16:2"
scaffold7cov100 b2h     ep      12533   12556   0       .       .       grp=TCONS00035771;pri=4;src=E "1.58e+03;0.995;3:2"
scaffold7cov100 b2h     ep      12532   12564   0       .       .       grp=TCONS00018041;pri=4;src=E "316;0.995;0:2"
scaffold7cov100 b2h     ep      12535   12564   0       .       .       grp=TCONS00051924;pri=4;src=E "1.58e+03;0.995;3:2"
scaffold7cov100 b2h     ep      12533   12565   0       .       .       grp=TCONS00013753;pri=4;src=E "588;0.995;1:2"
```

Filtering the 3rd column for only 'genes': 

```
$ awk '{if ($3 == "gene") {print}}' Structural_annotation_abintio.gff  > Structural_annotation_abintio_genes.gff
```

**This filters out exon and CDS? Those are parts of genes so don't we want those too? I'm filtering for 'genes' for now but I might need to come back to this step and use a version that has all the parts of a gene..** 

### **IntersectBed: Loci mapped to annotated gene**

Next, merge each sample file with gene annotation file using `intersectBed`. 

Input files: `*5x_sorted.tab` and `*10x_sorted.tab` and `Montipora_capitata_HIv2.genes.gff3`  
Output files: `*_5x_sorted.tab_gene` and `*_10x_sorted.tab_gene`

`intersectBed.sh`:

```
#!/bin/bash
#SBATCH --job-name="H-intersectBed"
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=500GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS/merged_cov #### this is the output from the merge cov step above 
#SBATCH --cpus-per-task=3
#SBATCH --error="script_error_intersectBed" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_intersectBed" #once your job is completed, any final job report comments will be put in this file

# load modules needed  
source /usr/share/Modules/init/sh # load the module function (specific to my computer)
module load BEDTools/2.27.1-foss-2018b

for i in *5x_sorted.tab
do
  intersectBed \
  -wb \
  -a ${i} \
  -b /data/putnamlab/estrand/Pacuta_download_genome_rar/Data_to_downoload/Structural_annotation_abintio_genes.gff \
  > ${i}_gene
done

for i in *10x_sorted.tab
do
  intersectBed \
  -wb \
  -a ${i} \
  -b /data/putnamlab/estrand/Pacuta_download_genome_rar/Data_to_downoload/Structural_annotation_abintio_genes.gff \
  > ${i}_gene
done
```

The _gene files came back empty..

I think it's because the Structural_annotation_abintio.gff (and genes subset file I made) and the sorted tab files for coverage don't have the same gene names? So intersectBed is coming up with a blank file because none of them are the same. 

`Structural_annotation_abintio_genes.gff`: 

```
# start gene g1
scaffold6cov64  AUGUSTUS        gene    1       5652    0.46    -       .       g1
# end gene g1
# start gene g2
scaffold6cov64  AUGUSTUS        gene    5805    6678    0.57    +       .       g2
# end gene g2
# start gene g3
scaffold7cov100 AUGUSTUS        gene    1       2566    0.96    +       .       g3
# end gene g3
# start gene g4
```

Sample ID File: `2197_5x_sorted.tab`

```
Pocillopora_acuta_HIv1___Scaffold_000000F___length_7015273      3981    3983    0.000000        0       5
Pocillopora_acuta_HIv1___Scaffold_000000F___length_7015273      11833   11835   0.000000        0       5
Pocillopora_acuta_HIv1___Scaffold_000000F___length_7015273      11869   11871   0.000000        0       5
Pocillopora_acuta_HIv1___Scaffold_000000F___length_7015273      11880   11882   0.000000        0       5
Pocillopora_acuta_HIv1___Scaffold_000000F___length_7015273      14825   14827   0.000000        0       10
Pocillopora_acuta_HIv1___Scaffold_000000F___length_7015273      14876   14878   0.000000        0       10
Pocillopora_acuta_HIv1___Scaffold_000000F___length_7015273      14904   14906   0.000000        0       8
Pocillopora_acuta_HIv1___Scaffold_000000F___length_7015273      14910   14912   0.000000        0       10
Pocillopora_acuta_HIv1___Scaffold_000000F___length_7015273      14947   14949   0.000000        0       10
Pocillopora_acuta_HIv1___Scaffold_000000F___length_7015273      14970   14972   0.000000        0       10
```

#### left off here: might be using wrong gff file... try one not built with augustus? what other files are in the .rar file? Do we have this correct file anywhere else on andromeda?

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
