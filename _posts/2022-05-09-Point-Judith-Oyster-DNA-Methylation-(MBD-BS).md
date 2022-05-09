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

C. virginica genome (the reference we will be using): https://www.ncbi.nlm.nih.gov/genome/398.

`$ wget https://www.ncbi.nlm.nih.gov/genome/398` into desired directory.

Proposed workflow:  
1. FastQC and multiqc report on raw files.  
2. Based on the quality of those reads, decide the num_mismatches parameter option. If we think we will have a higher number of mismatches if we have poorer quality data, then we use the `--relax_mismatches` flag. If we have really high quality data, then we an set a different cut-off for this. [See methylation QC markdown in lab repo](https://github.com/Putnam-Lab/Lab_Management/blob/master/Bioinformatics_%26_Coding/Workflows/Methylation_QC.md#-nextflow-methylseq-pipeline-methylation-quantification).   
3. Based on the quality those reads, establish a few cut-off parameters to test and compare.    
4. Run 3-4 different parameter choices for the four clipping values.  
5. Based on the results from that parameter comparison (goal = lowest m-bias), then choose final 4 clipping values.  

#### Proposed methylseq script

```
#!/bin/bash
#SBATCH --job-name="methylseq"
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=120GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=emma_strand@uri.edu
#SBATCH -D ####insert directory####
#SBATCH --exclusive

# load modules needed

module load Nextflow/21.03.0

# make directory for Output

mkdir PJ_methylseq1  # only run this line if you don't have the directory created

# run nextflow methylseq

nextflow run nf-core/methylseq \
-profile singularity \
--aligner bismark \
--skip_deduplication \ ##because this is from the MBD-BS method
--igenomes_ignore \
--resume \
--fasta <PATH_TO_GENOME_FASTA> \
--save_reference \
--input '<PATH_TO_RAW_SEQUENCES>/*_R{1,2}_001.fastq.gz' \
--clip_r1 <INSERT HERE> \
--clip_r2 <INSERT HERE> \
--three_prime_clip_r1 <INSERT HERE> \  
--three_prime_clip_r2 <INSERT HERE> \  
--non_directional \
--cytosine_report \
--relax_mismatches \ ##### DECIDE IF WE KEEP THIS OR NOT #####
--unmapped \
--outdir PJ_methylseq1 #Change if you want to change the name of the output folder
```
