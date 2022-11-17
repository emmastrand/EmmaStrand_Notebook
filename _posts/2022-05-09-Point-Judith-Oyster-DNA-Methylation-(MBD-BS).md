---
layout: post
title: Point Judith Oyster DNA Methylation (MBD-BS)
date: '2022-05-09'
categories: Analysis
tags: MBD-BS, oyster, DNA, methylation
projects: Point Judith Oyster
---

# Point Judith Oyster DNA Methylation

We used MBD-BS for our 2022 lab meetings oyster methylation paper: [Cvir github page](https://github.com/hputnam/Cvir_Nut_Int); [laboratory protocol details post](https://github.com/hputnam/Cvir_Nut_Int#m-schedl-mbdbs-library-preps). Sequenced on a single Illumina NovaSeq S4 flow cell lane for 2 x 150 bp sequencing at Genewiz.

Proposed workflow:  
1. FastQC and multiqc report on raw files.  
2. Based on the quality of those reads, decide the num_mismatches parameter option. If we think we will have a higher number of mismatches if we have poorer quality data, then we use the `--relax_mismatches` flag. If we have really high quality data, then we an set a different cut-off for this. [See methylation QC markdown in lab repo](https://github.com/Putnam-Lab/Lab_Management/blob/master/Bioinformatics_%26_Coding/Workflows/Methylation_QC.md#-nextflow-methylseq-pipeline-methylation-quantification).   
3. Based on the quality those reads, establish a few cut-off parameters to test and compare.    
4. Run 3-4 different parameter choices for the four clipping values.  
5. Based on the results from that parameter comparison (goal = lowest m-bias), then choose final 4 clipping values.  

Contents:  
- [**Setting Up Andromeda**](#Setting_up)  
- [**Initial fastqc on files**](#fastqc)    
- [**Initial Multiqc Report**](#multiqc)    
- [**NF-core: Methylseq**](#methylseq)    

## <a name="Setting_up"></a> **Setting Up Andromeda**

Original data lives here: /data/putnamlab/KITT/hputnam/20200119_Oyst_Nut/MBDBS.

#### Make a new directory for output files

```
$ mkdir /data/putnamlab/estrand/PointJudithData_MBDBS
## within the new PointJudithData_MBDBS folder
$ mkdir fastqc_results
$ mkdir scripts
$ mkdir PJ_methylseq1 ### for methylseq output
```

### Creating a test run folder

Creating a test set folder in case I need to run different iterations of the methylseq script.

```
$ mkdir test_set
$ cp /data/putnamlab/KITT/hputnam/20200119_Oyst_Nut/MBDBS/HPB10_S44_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/PointJudithData_MBDBS/test_set
$ cp /data/putnamlab/KITT/hputnam/20200119_Oyst_Nut/MBDBS/HPB11_S45_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/PointJudithData_MBDBS/test_set
$ cp /data/putnamlab/KITT/hputnam/20200119_Oyst_Nut/MBDBS/HPB12_S46_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/PointJudithData_MBDBS/test_set
```

#### Download genome file  

C. virginica genome (the reference we will be using): https://www.ncbi.nlm.nih.gov/genome/398.

`$ wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/022/765/GCF_002022765.2_C_virginica-3.0/GCF_002022765.2_C_virginica-3.0_genomic.fna.gz` into desired directory.   

fna = FastA format file containing Nucleotide sequence (DNA)

## <a name="fastqc"></a> **Initial fastqc on files**

`fastqc.sh`.  This took less than 10 minutes.

```
#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/PointJudithData_MBDBS/scripts               
#SBATCH --error="script_error_fastqc" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_fastqc" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

cd /data/putnamlab/estrand/PointJudithData_MBDBS

module load FastQC/0.11.9-Java-11
module load MultiQC/1.9-intel-2020a-Python-3.8.2

for file in /data/putnamlab/KITT/hputnam/20200119_Oyst_Nut/MBDBS/*fastq.gz
do
fastqc $file --outdir /data/putnamlab/estrand/PointJudithData_MBDBS/fastqc_results         
done

multiqc --interactive fastqc_results
```

## <a name="multiqc"></a> **Initial MultiQC Report**

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/PointJudithData_MBDBS/multiqc_report.html /Users/emmastrand/MyProjects/Cvir_Nut_Int/output/MBDBS/initial_multiqc_report.html
```

Full report here: https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/MBDBS/initial_multiqc_report.html

Number of reads range from 820k to 1550k but most fall around 900-100k per sample. Most sequences are the full 300 bp length, and none lower than 280 bp.

**Mean quality sequencing is low**

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/MBDBS/multiqc/mean%20quality.png?raw=true)

We might need to mess with cut off variations in the methylseq because of this. We'll see how low cut-offs go first.

## <a name="methylseq"></a> **NF-core: Methylseq**

#### Methylseq1

`PJ_methylseq1.sh`: 

Run this first to assess m-bias and then decide if we need more trial runs. See Emma Strand and Kevin Wong's notebook posts for methylation scripts and how they dealt with these issues. 

Run time: 3h 49m 45s

```
#!/bin/bash
#SBATCH --job-name="1methylseq"
#SBATCH -t 200:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=128GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/PointJudithData_MBDBS
#SBATCH --error=../"%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output=../"%x_output.%j" #once your job is completed, any final job report comments will be put in this file

# load modules needed
source /usr/share/Modules/init/sh # load the module function
module load Nextflow/21.03.0

# run nextflow methylseq

nextflow run nf-core/methylseq -profile singularity \
--aligner bismark \
--igenomes_ignore \
--fasta /data/putnamlab/estrand/PointJudithData_MBDBS/GCF_002022765.2_C_virginica-3.0_genomic.fa \
--save_reference \
--input '/data/putnamlab/KITT/hputnam/20200119_Oyst_Nut/MBDBS/*_R{1,2}_001.fastq.gz' \
--clip_r1 10 \
--clip_r2 10 \
--three_prime_clip_r1 10 --three_prime_clip_r2 10 \
--non_directional \
--cytosine_report \
--relax_mismatches \
--unmapped \
--outdir /data/putnamlab/estrand/PointJudithData_MBDBS/PJ_methylseq1
```

The multiqc function is running into errors from the above script so I ran (this took much longer than KBay and HoloInt?):

```
interactive 

module load MultiQC/1.9-intel-2020a-Python-3.8.2

multiqc -f --filename MBDBS_methylseq_PJ_multiqc_report  . \
      -m custom_content -m picard -m qualimap -m bismark -m samtools -m preseq -m cutadapt -m fastqc

mv MBDBS_methylseq_PJ_multiqc_report.html MBDBS_methylseq_PJ_multiqc_report2.html
```

I found another multiqc report that I think is what I'm looking for?

Copying this file to project folder: 

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/PointJudithData_MBDBS/PJ_methylseq1/MultiQC/multiqc_report.html /Users/emmastrand/MyProjects/Cvir_Nut_Int/output/MBDBS/MBDBS_methylseq_PJ_multiqc_report.html

scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/PointJudithData_MBDBS/MBDBS_methylseq_PJ_multiqc_report.html /Users/emmastrand/MyProjects/Cvir_Nut_Int/output/MBDBS/MBDBS_methylseq_PJ_multiqc_report2.html
```

### Full Multiqc Report 

https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/MBDBS/MBDBS_methylseq_PJ_multiqc_report.html

