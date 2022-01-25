---
layout: post
title: KBay Bleached Pairs 16S Analysis Mothur
date: '2022-01-24'
categories: Analysis
tags: 16S, bioinformatics, DNA, sequencing
projects: KBay
---

# KBay Bleached Pairs 16S Sequencing Analysis Pipeline with Mothur

**This pipeline uses Mothur. See this [notebook post](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-01-07-KBay-Pairs-16S-Analysis-Pipeline.md) for the pipeline using QIIME2.**

For more detailed pipeline and 16S information see:  
- 16S Laboratory Protocol [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-02-01-16s-Sequencing-HoloInt.md).  
- 16S QIIME2 pipeline workflow explained [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-06-21-16s-Analysis-Pipeline.md) from the Hawai'i Holobiont Integration project. If beginner to this workflow, I would recommend following this notebook post.      
- Another QIIME2 example of 16S pipeline for Mo'orea E5 project [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-10-06-E5-16S-Analysis.md).  

Based on A. Huffmyer Mothur pipeline [notebook post here](https://github.com/AHuffmyer/ASH_Putnam_Lab_Notebook/blob/master/_posts/2022-01-12-16S-Analysis-in-Mothr-Part-1.md).

#### KBay Bleaching Pairs project

Project github: [HI_Bleaching_Pairs](https://github.com/hputnam/HI_Bleaching_Timeseries)  
Molecular laboratory work spreadsheet: [excel doc](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/data/Molecular-labwork.xlsx)  

40 adult coral biopsies of *M. capitata* used for molecular analysis from July 2019 and December 2019 time points. Laboratory work for this project found [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-11-09-KBay-Bleaching-Pairs-16S-Processing.md).

Raw data path (not edit-able): ../../data/putnamlab/shared/ES_BP_16S  
Raw data path (edit-able): ../../data/putnamlab/estrand/BleachingPairs_16S/raw_data    
Output data path: ../../data/putnamlab/estrand/BleachingPairs_16S

Contents:
- [**Setting Up Andromeda**](#Setting_up)  
- [**Make contigs**](#Contigs)  
- [**Troubleshooting**](#Troubleshooting)

## <a name="Setting_up"></a> **Setting Up Andromeda**

Sign into andromeda: `$ ssh -l emma_strand ssh3.hac.uri.edu`.  
Raw files have been copied already (see how in this [post](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-01-07-KBay-Pairs-16S-Analysis-Pipeline.md)).

Data files path: ../../data/putnamlab/estrand/BleachingPairs_16S/raw_data to work with in this pipeline.

Create a directory for data processed with Mothur.

```
$ cd ../../data/putnamlab/estrand/BleachingPairs_16S
$ mkdir Mothur
$ cd Mothur
$ mkdir processed_data
$ mkdir scripts
```

Make a file with the primer sequence information (515F and 806RB; see notebook post at the top of this document that describes the laboratory work for this protocol).

```
$ cd ../../data/putnamlab/estrand/BleachingPairs_16S/Mothur
$ nano oligos.oligos

## copy and paste the following text into that file

primer GTGCCAGCMGCCGCGGTAA GGACTACNVGGGTWTCTAAT
```

Copy all raw files into the mothur folder.  

```
$ cp /data/putnamlab/estrand/BleachingPairs_16S/raw_data/*.gz /data/putnamlab/estrand/BleachingPairs_16S/Mothur
```

## <a name="Contigs"></a> **Make Contigs**

The current mothur module available is: Mothur/1.46.1-foss-2020b

As of 21 January 2022, this is the current version of Mothur available.

Create a script to make contigs. See [A. Huffmyer Mothur pipeline](https://github.com/AHuffmyer/ASH_Putnam_Lab_Notebook/blob/master/_posts/2022-01-12-16S-Analysis-in-Mothr-Part-1.md) for explanations on these commands and steps. I highly recommend referencing that notebook post to learn more information on the outputs of this script.

1.) Load Mothur module and start this program with the command `mothur`.  
2.) `make.file()` function finds the raw fastq files and identifies forward and reverse reads. The prefix function gives the output a name. I chose this to be the project name.  
3.) `make.contigs()` function will assemble a contig for each pair of files. This requires a file with the primers we used (made above in a previous step).  
4.) `summary.seqs()` function generates summary information on our sequences.  

```
$ cd ../../data/putnamlab/estrand/BleachingPairs_16S/Mothur/scripts
$ nano contigs.sh
$ cd .. ### need to be in mothur directory when running script

## copy and paste the below text into the nano file

#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab                  
#SBATCH --error="script_error_contigs" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_contigs" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur "#make.file(inputdir=., type=gz, prefix=kbay)"

mothur "#make.contigs(inputdir=., outputdir=., file=kbay.files, oligos=oligos.oligos)"

mothur "#summary.seqs(fasta=kbay.trim.contigs.fasta)"
```

Run this bash scripts `sbatch scripts/contigs.sh`. Stay in Mothur directory when running script and this will take ~30 minutes for 40 samples (80 files).

Output from make.files: `kbay.files`  
Output from make.contigs:  
```
kbay.contigs.groups               
kbay.contigs.report                                      
kbay.scrap.contigs.fasta          
kbay.trim.contigs.fasta
kbay.trim.contigs.summary
```

See [A. Huffmyer notebook post](https://github.com/AHuffmyer/ASH_Putnam_Lab_Notebook/blob/master/_posts/2022-01-12-16S-Analysis-in-Mothr-Part-1.md) for description of what each file is.

Summary of the sequences from the `output_script_contigs` file. These values are total sequences are much lower than they should be. **This is a problem!!**

```
                Start   End     NBases  Ambigs  Polymer   NumSeqs
Minimum:        1	      44	    44	    0	      3	        1
2.5%-tile:	    1	      292     292     0	      4	        1830
25%-tile:	1	292     292     0	4	18300
Median:         1	292     292     0	4	36600
75%-tile:	1	301     301     0	5	54900
97.5%-tile:     1	414     414     5	6	71370
Maximum:        1	562     562     56	26	73199
Mean:   1	300     300     0	4
# of Seqs:	73199

It took 3 secs to summarize 73199 sequences.
```




## <a name="Troubleshooting"></a> **Troubleshooting**

I got this error while running the contigs.sh file. I copied all raw files into the mothur folder I created and this fixed that issue.



```
mothur > make.file(inputdir=data/putnamlab/estrand/BleachingPairs_16S/raw_data, type=gz, prefix=kbay)
[ERROR]: cannot access data/putnamlab/estrand/BleachingPairs_16S/raw_data/
[ERROR]: cannot access data/putnamlab/estrand/BleachingPairs_16S/raw_data/
[ERROR]: did not complete make.file.
```
