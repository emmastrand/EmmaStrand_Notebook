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


Test results with other 16S runs in this google sheet: https://docs.google.com/spreadsheets/d/1ZHO469WzDxJ7PwNkERvx11j54PQk54sZM_B1KnaKIt0/edit#gid=1005240003

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

All samples run together. The RED indicates ITS2 samples, the grey indicates 16S samples.

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/Test_V3V4_16S/V3V4Test_initial_multiqc_report.html /Users/emmastrand/MyProjects/EmmaStrand_Notebook/Lab-work/V3V4Test_initial_multiqc_report.html
```

Full multiqc report here: https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/Lab-work/V3V4Test_initial_multiqc_report.html

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/V3V4_test_multiqc_report/seq_quality.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/V3V4_test_multiqc_report/seq_counts.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/V3V4_test_multiqc_report/per%20seq%20quality.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/V3V4_test_multiqc_report/per%20seq%20GC%20content.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/V3V4_test_multiqc_report/per%20base%20N%20content.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/V3V4_test_multiqc_report/seq%20length%20dist.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/V3V4_test_multiqc_report/seq%20dup%20levels.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/V3V4_test_multiqc_report/overrep.png?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/V3V4_test_multiqc_report/adapter%20content.png?raw=true)

## <a name="separate"></a> **Separate 16S projects**

Made a new directory `sample_sets`. 1.) `V3V4_338F`. 2.) `V3V4_341F`. 3.) `V4_515F`.

Copying files into each folder:

1.) `V3V4_338F`

```
$ cp /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/ELS12_S30_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_338F
$ cp /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/ELS13_S31_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_338F
$ cp /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/ELS14_S32_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_338F
$ cp /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/ELS15_S33_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_338F
$ cp /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/ELS16_S34_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_338F
$ cp /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/ELS17_S35_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_338F
$ cp /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/ELS18_S36_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_338F
$ cp /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/ELS19_S37_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_338F
$ cp /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/ELS28_S46_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_338F
```

2.) `V3V4_341F`

```
$ cp /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/ELS20_S38_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_341F
$ cp /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/ELS21_S39_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_341F
$ cp /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/ELS22_S40_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_341F
$ cp /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/ELS23_S41_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_341F
$ cp /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/ELS24_S42_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_341F
$ cp /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/ELS29_S47_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_341F
```

3.) `V4_515F`.

```
$ cp /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/ELS25_S43_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V4_515F
$ cp /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/ELS26_S44_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V4_515F
$ cp /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/ELS27_S45_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V4_515F
$ cp /data/putnamlab/KITT/hputnam/2022728_16sTest_Coral/ELS30_S48_L001_R{1,2}_001.fastq.gz /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V4_515F
```

### Cut-offs for each set of primers:

*Based on sequence quality*

- Truncating R = 220  
- Truncating F = 250

*Based on primer length*

- Trim R = 20 (all 806R)  
- Trim F = 19 (338F and 515F)  
- Trim F = 17 (341F)

## <a name="metadata"></a> **Create metadata files**

### 1. Sample manifest files

```
$ cd V3V4_338F
$ find raw_data -type f -print | sed 's_/_,_g' > metadata/filelist_V3V4_338F.csv

$ cd V3V4_341F
$ find raw_data -type f -print | sed 's_/_,_g' > metadata/filelist_V3V4_341F.csv

$ cd V4_515F
$ find raw_data -type f -print | sed 's_/_,_g' > metadata/filelist_V4_515F.csv
```

copy those outside of andromeda

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_338F/metadata/filelist_V3V4_338F.csv /Users/emmastrand/MyProjects/EmmaStrand_Notebook/Lab-work/V3V4_test/

scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_341F/metadata/filelist_V3V4_341F.csv /Users/emmastrand/MyProjects/EmmaStrand_Notebook/Lab-work/V3V4_test/

scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V4_515F/metadata/filelist_V4_515F.csv /Users/emmastrand/MyProjects/EmmaStrand_Notebook/Lab-work/V3V4_test/
```

Run R metadata creation script and scp back onto andromeda (in a window outside andromeda)

```
scp /Users/emmastrand/MyProjects/EmmaStrand_Notebook/Lab-work/V3V4_test/sample_manifest338.txt emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_338F/metadata/sample_manifest338.txt

scp /Users/emmastrand/MyProjects/EmmaStrand_Notebook/Lab-work/V3V4_test/sample_manifest341.txt emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_341F/metadata/sample_manifest341.txt

scp /Users/emmastrand/MyProjects/EmmaStrand_Notebook/Lab-work/V3V4_test/sample_manifest515.txt emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V4_515F/metadata/sample_manifest515.txt
```

### 2. Sample metadata list
