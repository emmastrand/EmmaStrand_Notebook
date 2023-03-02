---
layout: post
title: Point Judith Oyster DNA Methylation (MBD-BS)
date: '2022-05-09'
categories: Analysis
tags: MBD-BS, oyster, DNA, methylation
projects: Point Judith Oyster
---

# Point Judith Oyster DNA Methylation

We used MBD-BS for our 2022 lab meetings oyster methylation paper: [Cvir github page](https://github.com/hputnam/Cvir_Nut_Int); [laboratory protocol details post](https://github.com/hputnam/Cvir_Nut_Int#m-schedl-mbdbs-library-preps). Sequenced on a single Illumina NovaSeq S4 flow cell lane for 2 x 300 bp sequencing at Genewiz.

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

#### Different runs 

**Parameters** 

`PJ_methylseq1.sh`: --clip_r1 10 \ --clip_r2 10 \ --three_prime_clip_r1 10 --three_prime_clip_r2 10 \
- Run this first to assess m-bias and then decide if we need more trial runs. See Emma Strand and Kevin Wong's notebook posts for methylation scripts and how they dealt with these issues. 

`PJ_methylseq2.sh`: --clip_r1 10 \ --clip_r2 10 \ --three_prime_clip_r1 20 --three_prime_clip_r2 20 \
- Because the run time seemed oddly short, I wanted to run this again to be sure it worked. 

`PJ_methylseq3.sh`: --clip_r1 150 \ --clip_r2 150 \ --three_prime_clip_r1 150 --three_prime_clip_r2 150 \
- We think that methylseq isn't properly recognizing the adapters because 1.) the multiqc report says 300 bp length when usually for methylation data we use 2x150 bp. 2.) If the program isn't trimming the adapter fully that would explain the extreme m-bias, adapter content, and decreased quality all after 150 bp length. 3.) Usually Illumina adapters are ~150 bp of the read length and are not included in multiqc reports (if recognized appropriately). 
- I'm cutting 150 here to see if this makes a difference but unsure if we trust methylseq if it's not recognizing the adapters (i.e. what other problems might we have and don't see yet?)

**Run Time** 

`PJ_methylseq1.sh` Run time: 3h 49m 45s (**this seems weirdly short..**)

`PJ_methylseq2.sh` Run time: 20+hr  

`PJ_methylseq3.sh` Run time:    

#### Methylseq script 

```
#!/bin/bash
#SBATCH --job-name="1methylseq" # EDIT HERE FOR PJ METHYLSEQ#
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
--clip_r1 10 \ # EDIT HERE FOR PJ METHYLSEQ#
--clip_r2 10 \ # EDIT HERE FOR PJ METHYLSEQ#
--three_prime_clip_r1 10 \ # EDIT HERE FOR PJ METHYLSEQ#
--three_prime_clip_r2 10 \ # EDIT HERE FOR PJ METHYLSEQ#
--non_directional \
--cytosine_report \
--relax_mismatches \
--unmapped \
--outdir /data/putnamlab/estrand/PointJudithData_MBDBS/PJ_methylseq1 # EDIT HERE FOR PJ METHYLSEQ#
-name PJ_3 # EDIT HERE FOR PJ METHYLSEQ#
```

The multiqc function is running into errors from the above script so I ran (this took much longer than KBay and HoloInt?):

#### creating multiqc report 

The multiqc report fails with methylseq b/c we need a more updated versinon. The below code also works. 

**PJ_methylseq1** 

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

**PJ_methylseq2** 

```
interactive 

module load MultiQC/1.9-intel-2020a-Python-3.8.2

multiqc -f --filename MBDBS_methylseq_PJ_multiqc_report_methylseq2  . \
      -m custom_content -m picard -m qualimap -m bismark -m samtools -m preseq -m cutadapt -m fastqc
```

Copying this file to project folder: 

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/PointJudithData_MBDBS/PJ_methylseq2/MBDBS_methylseq_PJ_multiqc_report_methylseq2.html /Users/emmastrand/MyProjects/Cvir_Nut_Int/output/MBDBS/MBDBS_methylseq_PJ_multiqc_report_methylseq2.html
```



### Methylseq 1: Full Multiqc Report 

https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/MBDBS/MBDBS_methylseq_PJ_multiqc_report.html

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/MBDBS/multiqc/alignment-rates.png?raw=true)

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/MBDBS/multiqc/deduplication.png?raw=true)

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/MBDBS/multiqc/strand-alignment.png?raw=true)

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/MBDBS/multiqc/cytosine-perc-meth.png?raw=true)
![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/MBDBS/multiqc/read1-mbias.png?raw=true)
![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/MBDBS/multiqc/read2-mbias.png?raw=true)
![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/MBDBS/multiqc/covhist.png?raw=true)
![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/MBDBS/multiqc/genomecov.png?raw=true)
![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/MBDBS/multiqc/insertsizehist.png?raw=true)
![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/MBDBS/multiqc/gc-content.png?raw=true)
![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/MBDBS/multiqc/complexity-curve.png?raw=true)
![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/MBDBS/multiqc/cutadapt-filt.png?raw=true)
![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/MBDBS/multiqc/trimseqlengths.png?raw=true)

**The remaining multiqc reports are on our Cvir repo..** 