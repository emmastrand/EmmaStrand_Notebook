---
layout: post
title: Point Judith Oyster Gut 16S V6 Analysis
date: '2022-03-07'
categories: Processing
tags: Point Judith, oyster, 16S, bioinformatics
projects: Point Judith oysters
---

# Point Judith Oyster Gut 16S V6 QIIME2 Analysis

*Insert project information.*

We also have V4V5 sequencing but those data are not great quality and we want to move forward with the V6 region sequencing to avoid amplifying the host. [Notebook post on the analysis of V4V5 through QIIME2](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-03-02-Point-Judith-Oyster-Gut-16S-V4V5-Analysis.md).

Primer information (from `primers_v6.txt`):

```
Huber et al. 2007

967F: TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGCTAACCGANGAACCTYACC
        TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGCNACGCGAAGAACCTTANC
        TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGCAACGCGMARAACCTTACC
        TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGATACGCGARGAACCTTACC
1046R: GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGCGACRRCCATGCANCACCT
```


Beginners to 16S: see my [16S Central Working Document](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-02-22-16S-Analysis-Central-Working-Document.md) for other QIIME2 pipelines with more detailed descriptions on each command (Holobiont Integration QIIME2 pipeline will be most helpful for beginners).

Sequenced at URI's GSC. Information found [here](https://web.uri.edu/gsc/).

Project Path: /data/putnamlab/shared/PointJudithData_Rebecca/amplicons16s  
Path in my directory: /data/putnamlab/estrand/PointJudithData_16S/QIIME2_v6

Contents:  
- [**Setting Up Andromeda**](#Setting_up)  
- [**FastQC**](#FastQC)  
- [**QIIME2 Metadata**](#Metadata)  
- [**QIIME2 Sample data import**](#Import)  
- [**QIIME2 Denoising with DADA2**](#Denoise)  
- [**QIIME2 Taxonomy classification**](#Taxonomy)   
- [**QIIME2 Subsample and diversity indices**](#Diversity)    
- [**Switch to R to visualize the feature tables**](#R)   


## <a name="Setting_up"></a> **Setting Up Andromeda**

Creating directories for this project.

```
$ cd /data/putnamlab/estrand/PointJudithData_16S
$ mkdir QIIME2_v6
$ cd QIIME2_v6
$ mkdir scripts
$ mkdir metadata
$ mkdir fastqc_results
$ mkdir denoise_trials
$ mkdir 00_RAW_gz
```

Create symbolic links from raw files to this directory.

```
ln -s /data/putnamlab/shared/PointJudithData_Rebecca/amplicons16s/allsamples_V6/*.txt /data/putnamlab/estrand/PointJudithData_16S/QIIME2_v6/metadata

ln -s /data/putnamlab/shared/PointJudithData_Rebecca/amplicons16s/allsamples_V6/*.csv /data/putnamlab/estrand/PointJudithData_16S/QIIME2_v6/metadata

ln -s /data/putnamlab/shared/PointJudithData_Rebecca/amplicons16s/allsamples_V6/00_RAW_gz/*.fastq.gz /data/putnamlab/estrand/PointJudithData_16S/QIIME2_v6/00_RAW_gz
```

## <a name="FastQC"></a> **FASTQC: Quality control of raw read files**

Fastqc resources:  
- https://github.com/s-andrews/FastQC  
- https://raw.githubusercontent.com/s-andrews/FastQC/master/README.txt  
- How to interpret fastqc results [link](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)

Create the report from all of the fastqc files using MultiQC.

### fastqc.sh

```
# Create script
$ cd scripts
$ nano fastqc.sh
```

Write script (`fastqc.sh`) to run fastqc and multiqc on the .qz files.

```
#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/PointJudithData_16S/QIIME2_v6                  
#SBATCH --error="script_error_fastqc" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_fastqc" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

cd /data/putnamlab/estrand/PointJudithData_16S/QIIME2_v6

module load FastQC/0.11.9-Java-11
module load MultiQC/1.9-intel-2020a-Python-3.8.2

for file in /data/putnamlab/estrand/PointJudithData_16S/QIIME2_v6/00_RAW_gz/*fastq.gz
do
fastqc $file --outdir /data/putnamlab/estrand/PointJudithData_16S/QIIME2_v6/fastqc_results         
done

multiqc --interactive fastqc_results  
```

Output from `output_script_fastqc`:  
Output from `script_error_fastqc`:

### multiqc results

copy this report outside of andromeda.

```
scp emma_strand@bluewaves.uri.edu:/data/putnamlab/estrand/PointJudithData_16S/QIIME2_v6/multiqc_report.html /Users/emmastrand/MyProjects/Cvir_Nut_Int/output/16S_allv6/QIIME2
```

#### Red = R1 (forward); Blue = R2 (reverse)

**Sequence Counts**

![]()

**Sequence Quality Histogram**

![]()

**Per Sequence Quality Score**

![]()

**Per Sequence GC Content**

![]()

**Per Base N Content**

![]()

**Sequence Length Distribution**

![]()

**Sequence Duplication Levels**

![]()

**Adapter Content:**

# QIIME2

Program webpage [here](https://docs.qiime2.org/2021.4/getting-started/), beginners guide [here](https://docs.qiime2.org/2021.4/tutorials/overview/).  
**Read the above links thoroughly before continuing on.**

General steps:  
1. Import metadata files (2). See above links on how to create metadata files and 16S central document link at the top of this document for example pipelines.  
2. Import sample data  
3. Quality control with DADA2  
4. Clustering methods  
5. Taxonomy classification based on imported database  

## <a name="Metadata"></a> **Import metadata files**

1. Sample Manifest file

`/data/putnamlab/estrand/PointJudithData_16S/QIIME2_v6/metadata/sample-manifest_PJ_V6.csv` looks like:

```
sample-id,absolute-filepath,direction
RS126_S16,$PWD/00_RAW_gz/RS126_S16_L001_R1_001.fastq.gz,forward
RS126_S16,$PWD/00_RAW_gz/RS126_S16_L001_R2_001.fastq.gz,reverse
RS127_S28,$PWD/00_RAW_gz/RS127_S28_L001_R1_001.fastq.gz,forward
RS127_S28,$PWD/00_RAW_gz/RS127_S28_L001_R2_001.fastq.gz,reverse
RS128_S40,$PWD/00_RAW_gz/RS128_S40_L001_R1_001.fastq.gz,forward
RS128_S40,$PWD/00_RAW_gz/RS128_S40_L001_R2_001.fastq.gz,reverse
RS129_S52,$PWD/00_RAW_gz/RS129_S52_L001_R1_001.fastq.gz,forward
RS129_S52,$PWD/00_RAW_gz/RS129_S52_L001_R2_001.fastq.gz,reverse
RS130_S64,$PWD/00_RAW_gz/RS130_S64_L001_R1_001.fastq.gz,forward
```

`$PWD` = Path working directory which will be `PWD="/data/putnamlab/estrand/PointJudithData_16S/QIIME2_v6` for us.

2. Sample metadata file

`/data/putnamlab/estrand/PointJudithData_16S/QIIME2_v6/metadata/PJ_V6Samples_Metadata.txt` looks like:

```
#SampleID	SampleName	SampleType	Station	Location	Treatment	TypeGroup	Group	Bucket	OysterNumber	Growth	Biomass	Mortality	Denitrification_18C	Denitrification_24C	NitrousOxide_18C	NitrousOxide_24C	August_NH4_low	August_NH4_high	August_NO3_low	August_NO3_high	August_NO2_low	August_NO2_high				
#q2:types	categorical	categorical	categorical	categorical	categorical	categorical	categorical	categorical	categorical	numeric	numeric	numeric	numeric	numeric	numeric	numeric	numeric	numeric	numeric	numeric	numeric	numeric				
RS126_S16	BHC.1.1g	gut	BHC	Southern 	Control	gut_Southern_Control	Southern_Control	1	1	7.35	9.657	0.067	4.74	0.000.08	0.08	17.47	15.47	0.44	0.37	0.04	0.11				
RS127_S28	BHC.1.2g	gut	BHC	Southern 	Control	gut_Southern_Control	Southern_Control	1	2	7.35	9.657	0.067	4.74	0.000.08	0.08	17.47	15.47	0.44	0.37	0.04	0.11				
RS128_S40	BHC.1.3g	gut	BHC	Southern 	Control	gut_Southern_Control	Southern_Control	1	3	7.35	9.657	0.067	4.74	0.000.08	0.08	17.47	15.47	0.44	0.37	0.04	0.11				
RS129_S52	BHC.2.1g	gut	BHC	Southern 	Control	gut_Southern_Control	Southern_Control	2	1	8.55	10.458	0.130	69.60	49.10.04	0.22	32.27	19.07	0.34	0.46	0.20	0.10				
RS130_S64	BHC.2.2g	gut	BHC	Southern 	Control	gut_Southern_Control	Southern_Control	2	2	8.55	10.458	0.130	69.60	49.10.04	0.22	32.27	19.07	0.34	0.46	0.20	0.10				
RS131_S76	BHC.2.4g	gut	BHC	Southern 	Control	gut_Southern_Control	Southern_Control	2	4	8.55	10.458	0.130	69.60	49.10.04	0.22	32.27	19.07	0.34	0.46	0.20	0.10				
RS132_S88	BHC.3.1g	gut	BHC	Southern 	Control	gut_Southern_Control	Southern_Control	3	1	8.58	10.980	0.067	10.67	128.40	0.00	0.00	26.13	24.40	0.16	0.14	0.06	0.06				
RS133_S5	BHC.3.2g	gut	BHC	Southern 	Control	gut_Southern_Control	Southern_Control	3	2	8.58	10.980	0.067	10.67	128.40	0.00	0.00	26.13	24.40	0.16	0.14	0.06	0.06
```

## <a name="Import"></a> **Sample data import**

*Confirm these parameters are correct: input-format.*

Create a script to import these data files into QIIME2.

### import.sh

```
#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab
#SBTACH -q putnamlab
#SBATCH -D /data/putnamlab/estrand/PointJudithData_16S/QIIME2_v6
#SBATCH --error="script_error_import" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_import" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function
module load QIIME2/2021.4

#### METADATA FILES ####
# Path working directory to the raw files (referenced in the metadata)
# metadata says: $PWD/00_RAW_gz/RS1_S1_L001_R1_001.fastq.gz so this needs to lead the command to this path
PWD="/data/putnamlab/estrand/PointJudithData_16S/QIIME2_v6"

# Metadata path
METADATA="metadata/PJ_V6Samples_Metadata.txt"

# Sample manifest path
MANIFEST="metadata/sample-manifest_PJ_V6.csv"

#########################

qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path $MANIFEST \
  --input-format PairedEndFastqManifestPhred33 \
  --output-path PJ-paired-end-sequences.qza
```

Output from `output_script_import`:  
Output from `script_error_import`:

`PJ-paired-end-sequences.qza` is the output file that we will input in the next denoising step.

## <a name="Denoise"></a> **Denoising with DADA2 and Clustering**

*Confirm these parameters are correct: primer length.*

I tried the following denoise parameters:
