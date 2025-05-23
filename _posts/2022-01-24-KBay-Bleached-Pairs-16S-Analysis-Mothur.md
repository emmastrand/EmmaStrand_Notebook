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
- [**QC with screen.seqs**](#QC_screen)  
- [**Determining and counting unique sequences**](#Unigue)
- [**Aligning to a reference database**](#Reference)   
- [**Pre-clustering**](#Pre-clustering)   
- [**Identifying Chimeras**](#Chimeras)    
- [**Classifying sequences**](#Classify_seq)  
- [**OTU Clustering**](#OTU)   
- [**Subsampling for sequencing depth**](#Subsample)   
- [**Calculate Ecological Statistics**](#Ecostats)    
- [**Population Level Analyses**](#Popstats)  
- [**Exporting for R Analyses**](#RExport)                
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

primer GTGCCAGCMGCCGCGGTAA GGACTACNVGGGTWTCTAAT V4
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
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_16S/Mothur
#SBATCH --error="script_error_contigs" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_contigs" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur "#make.file(inputdir=., type=gz, prefix=kbay)"

mothur "#make.contigs(inputdir=., outputdir=., file=kbay.files, trimoverlap=T, oligos=oligos.oligos, pdiffs=2, checkorient=t)"

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

Summary of the sequences from the `output_script_contigs` file.

```
It took 889 secs to process 920864 sequences.

Output File Names:
/glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_16S/Mothur/kbay.trim.contigs.fasta
/glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_16S/Mothur/kbay.scrap.contigs.fasta
/glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_16S/Mothur/kbay.contigs.report
/glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_16S/Mothur/kbay.contigs.groups

mothur > summary.seqs(fasta=kbay.trim.contigs.fasta)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       1       1       0       1       1
2.5%-tile:      1       206     206     0       4       13770
25%-tile:       1       207     207     0       7       137700
Median:         1       207     207     0       7       275400
75%-tile:       1       207     207     0       7       413099
97.5%-tile:     1       253     253     3       7       537029
Maximum:        1       278     278     83      15      550798
Mean:   1       210     210     0       6
# of Seqs:      550798

It took 18 secs to summarize 550798 sequences.

Output File Names:
kbay.trim.contigs.summary
```

This table shows quantile values about the distribution of sequences for a few things:

- Start position: All at 1 now, will start at different point after some QC.  
- End position: We see that there are some sequences that are very short and we may need to remove those later.  
- Number of bases: length (we see most are in expected range here, but one is super long! This might tell us there is no overlap so they are butted up against each other. We will remove things like this.  
- Ambigs: Number of ambiguous calls in sequences. Here there are a few that have ambiguous base calls. We will remove any sequence with an ambiguous call or any longer than we would expect for V4 region.  
- Polymer: Length of polymer repeats.  
- NumSeqs: Number of sequences.  

Output from `kbay.contigs.report`:

```
Name    Length  Overlap_Length  Overlap_Start   Overlap_End     MisMatches      Num_Ns  Expected_Errors
M00763_26_000000000-K4TML_1_1101_19611_2209     34      34      19      53      0       0       3.52092e-07
M00763_26_000000000-K4TML_1_1101_17506_2376     207     207     74      281     1       0       0.0631158
M00763_26_000000000-K4TML_1_1101_20031_2402     207     207     20      227     0       0       1.89366e-05
M00763_26_000000000-K4TML_1_1101_19337_2438     207     207     20      227     1       0       0.00126611
M00763_26_000000000-K4TML_1_1101_19268_3410     207     207     74      281     0       0       3.48957e-06
M00763_26_000000000-K4TML_1_1101_21820_3478     207     207     20      227     1       0       0.0251465
M00763_26_000000000-K4TML_1_1101_21813_3498     207     207     74      281     9       0       0.341299
M00763_26_000000000-K4TML_1_1101_7214_4084      207     207     74      281     0       0       1.77554e-05
M00763_26_000000000-K4TML_1_1101_13185_4307     207     207     20      227     0       0       2.72989e-05
M00763_26_000000000-K4TML_1_1101_6294_4481      207     207     74      281     0       0       3.40429e-05
M00763_26_000000000-K4TML_1_1101_25301_4556     207     207     20      227     3       0       0.0159083
M00763_26_000000000-K4TML_1_1101_5355_4591      207     207     74      281     0       0       1.07377e-05
M00763_26_000000000-K4TML_1_1101_9016_4727      207     207     20      227     0       0       1.00201e-05
M00763_26_000000000-K4TML_1_1101_13997_5201     207     207     20      227     0       0       3.36024e-05
M00763_26_000000000-K4TML_1_1101_8613_5464      207     207     74      281     0       0       4.30783e-05
M00763_26_000000000-K4TML_1_1101_21755_5516     207     207     74      281     0       0       3.40183e-05
M00763_26_000000000-K4TML_1_1101_6519_5798      207     207     74      281     1       0       0.00136203
M00763_26_000000000-K4TML_1_1101_20163_5935     207     207     20      227     0       0       2.23257e-05
M00763_26_000000000-K4TML_1_1101_12656_1637     207     207     74      281     0       0       4.72312e-05

```

The `kbay.trim.contigs.summary` file will also give you more of this information along with the number of polymers in each sequence. We use a cut off of 8 later on but this can be changed depending on the number of poylmers you have in your dataset.

#### Check for primers

Primers we are looking for: `F GTGCCAGCMGCCGCGGTAA R GGACTACNVGGGTWTCTAAT`.

Search for the primers in our contigs.

We have M, W, N, V in our primers (degenerate bases). Generate multiple possibilities for each primer to search for.

Here is the key for degenerate bases:
R=A+G Y=C+T M=A+C K=G+T S=G+C W=A+T H=A+T+C B=G+T+C D=G+A+T V=G+A+C N=A+C+G+T (remove if on the end)

Search for forward primers:

```
grep -c "GTGCCAGCAGCCGCGGTAA" kbay.trim.contigs.fasta # output = 1
grep -c "GTGCCAGCCGCCGCGGTAA" kbay.trim.contigs.fasta # output = 1
```

These primers show up <1 time in our file.

Search for a couple examples of the reverse primers:

```
grep -c "GGACTACAGGGGTATCTAAT" kbay.trim.contigs.fasta # output = 0
grep -c "GGACTACCAGGGTTTCTAAT" kbay.trim.contigs.fasta # output = 0
grep -c "GGACTACGCGGGTATCTAAT" kbay.trim.contigs.fasta # output = 0
grep -c "GGACTACTGGGGTTTCTAAT" kbay.trim.contigs.fasta # output = 0
```

These primers show up 0 times in our files.

Success! Our primers are removed.


## <a name="QC_screen"></a> **QC with screen.seqs**

Removing all poor quality sequences with an ambiguous call ("N") and >300 nt as well as set a minimum size at 200 nt. Parameters should be adjusted based on specific experiments and variable region.

Make script for the screen.seqs function.

```
$ cd ../../data/putnamlab/estrand/BleachingPairs_16S/Mothur/scripts
$ nano screen.sh
$ cd ..

## copy and paste the below text into the script file

#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --job-name="KB-screen"
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab        
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_16S/Mothur          
#SBATCH --error="script_error_screen" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_screen" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#screen.seqs(inputdir=., outputdir=., fasta=kbay.trim.contigs.fasta, group=kbay.contigs.groups, maxambig=0, maxlength=350, minlength=200)"

mothur "#summary.seqs(fasta=kbay.trim.contigs.good.fasta)"

```

Run script `$ sbatch scripts/screen.sh`

Output below. This script kept

```
$ less output_script_screen
# shift + G to scroll to the end

It took 10 secs to screen 550798 sequences, removed 99301.

/******************************************/
Running command: remove.seqs(accnos=/glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_16S/Mothur/kbay.trim.contigs.bad.accnos.temp, group=/glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_16S/Mothur/kbay.contigs.groups)
Removed 99301 sequences from your group file.

Output File Names:
/glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_16S/Mothur/kbay.contigs.pick.groups

/******************************************/

Output File Names:
/glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_16S/Mothur/kbay.trim.contigs.good.fasta
/glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_16S/Mothur/kbay.trim.contigs.bad.accnos
/glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_16S/Mothur/kbay.contigs.good.groups


It took 41 secs to screen 550798 sequences.

mothur > summary.seqs(fasta=kbay.trim.contigs.good.fasta)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       201     201     0       3       1
2.5%-tile:      1       207     207     0       4       11288
25%-tile:       1       207     207     0       7       112875
Median:         1       207     207     0       7       225749
75%-tile:       1       207     207     0       7       338623
97.5%-tile:     1       253     253     0       7       440210
Maximum:        1       278     278     0       11      451497
Mean:   1       213     213     0       6
# of Seqs:      451497

It took 15 secs to summarize 451497 sequences.

Output File Names:
kbay.trim.contigs.good.summary
```

"good" seqs satisfied criteria and "bad" seqs did not meet criteria.

Count the number of "good" and "bad" sequences. This removed ~19% of sequences due to length and ambiguous bases.

```
grep -c "^>" kbay.trim.contigs.good.fasta #451497
grep -c ".*" kbay.trim.contigs.bad.accnos #99301
```

## <a name="Unique"></a> **Determining and counting unique sequences**

This portion determines the unique sequences and then counts how many times each unique sequence shows up in each sample. See [A. Huffmyer notebook post](https://github.com/AHuffmyer/ASH_Putnam_Lab_Notebook/blob/master/_posts/2022-01-12-16S-Analysis-in-Mothr-Part-1.md) for a description on each function in this script.

Make a script to run these functions.

```
$ cd ../../data/putnamlab/estrand/BleachingPairs_16S/Mothur/scripts
$ nano unique.sh
$ cd ..

## copy and paste the below text into the script file

#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --job-name="KB-unique"
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab        
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_16S/Mothur             
#SBATCH --error="script_error_unique" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_unique" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#unique.seqs(fasta=kbay.trim.contigs.good.fasta)"

mothur "#count.seqs(name=kbay.trim.contigs.good.names, group=kbay.contigs.good.groups)"

mothur "#summary.seqs(fasta=kbay.trim.contigs.good.unique.fasta, count=kbay.trim.contigs.good.count_table)"
```

Run the above script `sbatch scripts/unique.sh`.

Output below from `output_script_unique`.

```
Output File Names:
kbay.trim.contigs.good.names
kbay.trim.contigs.good.unique.fasta

mothur > count.seqs(name=kbay.trim.contigs.good.names, group=kbay.contigs.good.groups)

It took 2 secs to create a table for 451497 sequences.

Total number of sequences: 451497

Output File Names:
kbay.trim.contigs.good.count_table

mothur > summary.seqs(fasta=kbay.trim.contigs.good.unique.fasta, count=kbay.trim.contigs.good.count_table)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       201     201     0       3       1
2.5%-tile:      1       207     207     0       4       11288
25%-tile:       1       207     207     0       7       112875
Median:         1       207     207     0       7       225749
75%-tile:       1       207     207     0       7       338623
97.5%-tile:     1       253     253     0       7       440210
Maximum:        1       278     278     0       11      451497
Mean:   1       213     213     0       6
# of unique seqs:       6041
total # of seqs:        451497

It took 1 secs to summarize 451497 sequences.

Output File Names:
kbay.trim.contigs.good.unique.summary
```

In this run, there were 451,497 sequences and 6,041 were unique = ~1%.

Now we can align just the unique sequences, which will be much faster than aligning the full data set and is an indicator of how polished and clean the data are.

From this, we have our unique sequences identified and can proceed with further cleaning and polishing of the data. Next we will look at alignment, error rate, chimeras, classification and further analysis.

## <a name="Reference"></a> **Aligning to a reference database**

#### Prepare and download reference sequences from [Mothur wiki](https://mothur.org/wiki/silva_reference_files/)

The silva reference is used and recommended by the Mothur team. It is a manually curated data base with high diversity and high alignment quality.

```
$ cd ../../data/putnamlab/estrand/BleachingPairs_16S/Mothur

$ wget https://mothur.s3.us-east-2.amazonaws.com/wiki/silva.bacteria.zip

--2022-01-25 13:48:33--  https://mothur.s3.us-east-2.amazonaws.com/wiki/silva.bacteria.zip
Resolving mothur.s3.us-east-2.amazonaws.com (mothur.s3.us-east-2.amazonaws.com)... 52.219.104.128
Connecting to mothur.s3.us-east-2.amazonaws.com (mothur.s3.us-east-2.amazonaws.com)|52.219.104.128|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 25531698 (24M) [application/zip]
Saving to: ‘silva.bacteria.zip’

100%[================================================================================================>] 25,531,698  35.9MB/s   in 0.7s   

2022-01-25 13:48:34 (35.9 MB/s) - ‘silva.bacteria.zip’ saved [25531698/25531698]



$ wget https://mothur.s3.us-east-2.amazonaws.com/wiki/trainset9_032012.pds.zip

--2022-01-25 13:48:56--  https://mothur.s3.us-east-2.amazonaws.com/wiki/trainset9_032012.pds.zip
Resolving mothur.s3.us-east-2.amazonaws.com (mothur.s3.us-east-2.amazonaws.com)... 52.219.143.26
Connecting to mothur.s3.us-east-2.amazonaws.com (mothur.s3.us-east-2.amazonaws.com)|52.219.143.26|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 2682257 (2.6M) [application/zip]
Saving to: ‘trainset9_032012.pds.zip’

100%[================================================================================================>] 2,682,257   --.-K/s   in 0.1s    

2022-01-25 13:48:57 (17.3 MB/s) - ‘trainset9_032012.pds.zip’ saved [2682257/2682257]


$ unzip silva.bacteria.zip
$ unzip trainset9_032012.pds.zip
```

Make a script to take the Silva database reference alignment and select the V4 region, and then rename this to something more helpful to us.

```
$ cd ../../data/putnamlab/estrand/BleachingPairs_16S/Mothur/scripts
$ nano silva_ref.sh
$ cd ..

## copy and paste the below text into the script file

#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab                  
#SBATCH --error="script_error_silva_ref" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_silva_ref" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#pcr.seqs(fasta=silva.bacteria/silva.bacteria.fasta, start=11894, end=25319, keepdots=F)"

mothur "#summary.seqs(fasta=silva.bacteria/silva.bacteria.pcr.fasta)"

mothur "#rename.file(input=silva.bacteria/silva.bacteria.pcr.fasta, new=silva.v4.fasta)"
```

Make sure you are in the Mothur directory and run the above script `$ sbatch scripts/silva_ref.sh`.

Output reference file we will use moving forward: `silva.v4.fasta`.

View output from the script that includes sequence summary `$ nano output_script_silva_ref`. These statistics should be the same as [A. Huffmyer post](https://github.com/AHuffmyer/ASH_Putnam_Lab_Notebook/blob/master/_posts/2022-01-12-16S-Analysis-in-Mothr-Part-1.md#Align).

```
mothur > summary.seqs(fasta=silva.bacteria/silva.bacteria.pcr.fasta)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1	13424   270     0	3	1
2.5%-tile:	1	13425   292     0	4	374
25%-tile:	1	13425   293     0	4	3740
Median:         1       13425   293     0	4	7479
75%-tile:       1	13425   293     0	5	11218
97.5%-tile:     1       13425   294     1	6	14583
Maximum:        3	13425   351     5	9	14956
Mean:   1       13424   292     0	4
# of Seqs:	14956

It took 6 secs to summarize 14956 sequences.
```

#### Align our sequences to the new reference database we've created

Make a script to align sequences to the reference file we just created.

```
$ cd ../../data/putnamlab/estrand/BleachingPairs_16S/Mothur/scripts
$ nano align.sh
$ cd ..

## copy and paste the below text into the script file

#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab         
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_16S/Mothur          
#SBATCH --error="script_error_align" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_align" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#align.seqs(fasta=kbay.trim.contigs.good.unique.fasta, reference=silva.v4.fasta)"

mothur "#summary.seqs(fasta=kbay.trim.contigs.good.unique.align)"
```

Make sure you are in the Mothur directory and run the above script `$ sbatch scripts/align.sh`.

Output File Names:
```
kbay.trim.contigs.good.unique.align
kbay.trim.contigs.good.unique.align.report
kbay.trim.contigs.good.unique.flip.accnos
```

View the summary from the `output_script_align` file. There are 30,487 unique sequences and all aligned to the reference. We want most sequences to be 292 bp long.

```
[WARNING]: 2899 of your sequences generated alignments that eliminated too many bases, a list is provided in kbay.trim.contigs.good.unique.flip.accnos.
[NOTE]: 418 of your sequences were reversed to produce a better alignment.

It took 12 seconds to align 6041 sequences.

Output File Names:
kbay.trim.contigs.good.unique.align
kbay.trim.contigs.good.unique.align.report
kbay.trim.contigs.good.unique.flip.accnos

mothur > summary.seqs(fasta=kbay.trim.contigs.good.unique.align)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       3       2       0       1       1
2.5%-tile:      1       1250    4       0       2       152
25%-tile:       1       1250    11      0       3       1511
Median:         1968    11550   252     0       4       3021
75%-tile:       1968    11550   253     0       4       4531
97.5%-tile:     13391   13425   254     0       6       5890
Maximum:        13424   13425   260     0       11      6041
Mean:   1962    7460    136     0       3
# of Seqs:      6041

It took 3 secs to summarize 6041 sequences.

Output File Names:
kbay.trim.contigs.good.unique.summary
```

#### QC sequences that were aligned to the reference file we created.

The sequences are aligned at the correct positions to the reference but now we need to remove those that are outside the reference window. This removes all sequences that start after the `start` and those that end before the `end`. This also takes out any sequences that have repeats greater than 8 (i.e. 8 A's in a row) because we are confident those are not real.

Make a script to do the above commands.

```
$ cd ../../data/putnamlab/estrand/BleachingPairs_16S/Mothur/scripts
$ nano screen2.sh
$ cd ..

## copy and paste the below text into the script file

#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab                  
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_16S/Mothur     
#SBATCH --error="script_error_screen2" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_screen2" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#screen.seqs(fasta=kbay.trim.contigs.good.unique.align, count=kbay.trim.contigs.good.count_table, start=1968, end=11550, maxhomop=8)"

mothur "#summary.seqs(fasta=kbay.trim.contigs.good.unique.good.align, count=kbay.trim.contigs.good.good.count_table)"

mothur "#count.groups(count=kbay.trim.contigs.good.good.count_table)"
```

Output files are:

```
kbay.trim.contigs.good.unique.good.align
kbay.trim.contigs.good.unique.bad.accnos
kbay.trim.contigs.good.good.count_table
```

View output from the output file `output_script_screen2`:

```
It took 3 secs to screen 6041 sequences, removed 2964.

/******************************************/
Running command: remove.seqs(accnos=kbay.trim.contigs.good.unique.bad.accnos.temp, count=kbay.trim.contigs.good.count_table)
Removed 392907 sequences from your count file.

Output File Names:
kbay.trim.contigs.good.pick.count_table

/******************************************/

Output File Names:
kbay.trim.contigs.good.unique.good.align
kbay.trim.contigs.good.unique.bad.accnos
kbay.trim.contigs.good.good.count_table

mothur > summary.seqs(fasta=kbay.trim.contigs.good.unique.good.align, count=kbay.trim.contigs.good.good.count_table)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1965    11550   249     0       3       1
2.5%-tile:      1968    11550   253     0       4       1465
25%-tile:       1968    11550   253     0       4       14648
Median:         1968    11550   253     0       4       29296
75%-tile:       1968    11550   253     0       4       43943
97.5%-tile:     1968    11550   254     0       6       57126
Maximum:        1968    12065   260     0       8       58590
Mean:   1967    11550   253     0       4
# of unique seqs:       3077
total # of seqs:        58590

It took 2 secs to summarize 58590 sequences.

Output File Names:
kbay.trim.contigs.good.unique.good.summary

mothur > count.groups(count=kbay.trim.contigs.good.good.count_table)
WSH217 contains 115.
WSH218 contains 122.
WSH219 contains 192.
WSH220 contains 123.
WSH221 contains 169.
WSH222 contains 122.
WSH223 contains 95.
WSH224 contains 73.
WSH225 contains 72.
WSH226 contains 213.
WSH227 contains 4469.
WSH228 contains 1630.
WSH229 contains 289.
WSH230 contains 4476.
WSH231 contains 839.
WSH232 contains 65.
WSH233 contains 157.
WSH234 contains 16658.
WSH235 contains 278.
WSH236 contains 152.
WSH237 contains 777.
WSH238 contains 2166.
WSH239 contains 222.
WSH240 contains 179.
WSH241 contains 284.
WSH242 contains 218.
WSH243 contains 242.
WSH244 contains 383.
WSH245 contains 864.
WSH246 contains 330.
WSH247 contains 2547.
WSH248 contains 173.
WSH249 contains 631.
WSH250 contains 385.
WSH251 contains 459.
WSH252 contains 164.
WSH253 contains 8789.
WSH254 contains 7926.
WSH255 contains 214.
WSH256 contains 1328.

Size of smallest group: 65.
Total seqs: 58590.

Output File Names:
kbay.trim.contigs.good.good.count.summary
```

We have now identified the sequences outside of the window of interest in our alignment to the Silva reference 16S V4 region. The next step will be filtering those out.

#### Filter out those sequences identified in screen2.sh

Make a script that uses filter.seqs function to take out those sequences that did not meet our criteria.

```
$ cd ../../data/putnamlab/estrand/BleachingPairs_16S/Mothur/scripts
$ nano filter.sh
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
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_16S/Mothur     
#SBATCH --error="script_error_filter" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_filter" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#filter.seqs(fasta=kbay.trim.contigs.good.unique.good.align, vertical=T, trump=.)"

mothur "#summary.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.fasta, count=kbay.trim.contigs.good.good.count_table)"
```

Make sure you are in the Mothur directory and run the above script `$ sbatch scripts/filter.sh`.

Output from the `output_script_filter` file:

```
Length of filtered alignment: 355
Number of columns removed: 13070
Length of the original alignment: 13425
Number of sequences used to construct filter: 3077

Output File Names:
kbay.filter
kbay.trim.contigs.good.unique.good.filter.fasta

mothur > summary.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.fasta, count=kbay.trim.contigs.good.good.count_table)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       355     249     0       3       1
2.5%-tile:      1       355     253     0       4       1465
25%-tile:       1       355     253     0       4       14648
Median:         1       355     253     0       4       29296
75%-tile:       1       355     253     0       4       43943
97.5%-tile:     1       355     254     0       6       57126
Maximum:        1       355     258     0       8       58590
Mean:   1       355     253     0       4
# of unique seqs:       3077
total # of seqs:        58590

It took 2 secs to summarize 58590 sequences.

Output File Names:
kbay.trim.contigs.good.unique.good.filter.summary
```


## <a name="Pre-clustering"></a> **Pre clustering**

In this step we want to remove noise due to sequencing error. Sequences are not reduced but grouped into ASVs to reduce error rate. DADA2 is an alternate for this but that program takes out rare sequences and singletons and this one does not. See [A. Huffmyer post - preclustering step](https://github.com/AHuffmyer/ASH_Putnam_Lab_Notebook/blob/master/_posts/2022-01-12-16S-Analysis-in-Mothr-Part-1.md#-7-polish-the-data-with-pre-clustering) for further explanation.


Make a script to run the pre.cluster functions. `diffs=1` can be changed based on requirements.

```
$ cd ../../data/putnamlab/estrand/BleachingPairs_16S/Mothur/scripts
$ nano preclustering.sh
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
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_16S/Mothur           
#SBATCH --error="script_error_precluster" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_precluster" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#unique.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.fasta, count=kbay.trim.contigs.good.good.count_table)"

mothur "#pre.cluster(fasta=kbay.trim.contigs.good.unique.good.filter.unique.fasta, count=kbay.trim.contigs.good.unique.good.filter.count_table, diffs=1)"

mothur "#summary.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.fasta, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.count_table)"
```

Make sure you are in the Mothur directory and run the above script `$ sbatch scripts/preclustering.sh`.

Ouput from the `output_script_precluster` file.

```
mothur > unique.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.fasta, count=kbay.trim.contigs.good.good.count_table)
1000    1000
2000    2000
3000    3000
3077    3077

Output File Names:
kbay.trim.contigs.good.unique.good.filter.count_table
kbay.trim.contigs.good.unique.good.filter.unique.fasta

mothur > summary.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.fasta, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.count_table)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       355     249     0       3       1
2.5%-tile:      1       355     253     0       4       1465
25%-tile:       1       355     253     0       4       14648
Median:         1       355     253     0       4       29296
75%-tile:       1       355     253     0       4       43943
97.5%-tile:     1       355     254     0       6       57126
Maximum:        1       355     258     0       8       58590
Mean:   1       355     253     0       4
# of unique seqs:       1380
total # of seqs:        58590

It took 2 secs to summarize 58590 sequences.

Output File Names:
kbay.trim.contigs.good.unique.good.filter.unique.precluster.summary
```

## <a name="Chimeras"></a> **Identifying Chimeras**

Chimeras = seqs that did not extend during PCR and served as templates for other PCR products and results in sequences that are half from one PCR product and half from another. Make a script to use the `chimera.vsearch` function and then remove those sequences.

Vsearch is already available on our server. See [A. Huffmyer post #8 chimera step for instructions on vsearch install](https://github.com/AHuffmyer/ASH_Putnam_Lab_Notebook/blob/master/_posts/2022-01-12-16S-Analysis-in-Mothr-Part-1.md#-8-identify-chimeras).

```
$ cd ../../data/putnamlab/estrand/BleachingPairs_16S/Mothur/scripts
$ nano chimera.sh
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
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_16S/Mothur           
#SBATCH --error="script_error_chimera" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_chimera" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

module load VSEARCH/2.18.0-GCC-10.2.0

mothur

mothur "#chimera.vsearch(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.fasta, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.count_table, dereplicate=T)"

mothur "#remove.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.fasta, accnos=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.accnos)"

mothur "#summary.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table)"

mothur "#count.groups(count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table)"

```

Make sure you are in the Mothur directory and run the above script `$ sbatch scripts/chimera.sh`.

Output from `output_script_chimera` file.

```
## for every sample
Output File Names:
kbay.trim.contigs.good.unique.good.filter.unique.precluster.WSH217.count_table
kbay.trim.contigs.good.unique.good.filter.unique.precluster.WSH217.fasta

Output File Names:
kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table
kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.chimeras
kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.accnos

mothur > remove.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.fasta, accnos=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.accnos)
Removed 88 sequences from your fasta file.

Output File Names:
kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta

mothur > summary.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table)

mothur > summary.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       355     249     0       3       1
2.5%-tile:      1       355     253     0       4       1460
25%-tile:       1       355     253     0       4       14598
Median:         1       355     253     0       4       29196
75%-tile:       1       355     253     0       4       43794
97.5%-tile:     1       355     254     0       6       56932
Maximum:        1       355     258     0       8       58391
Mean:   1       355     253     0       4
# of unique seqs:       1292
total # of seqs:        58391

It took 1 secs to summarize 58391 sequences.

Output File Names:
kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.summary
```


## <a name="Classify_seq"></a> **Classifying Sequences**

The cleaning steps are now complete and we can classify our sequences. We have already downloaded the silva database in previous step from the Mothur wiki page. Download the mothur-formatted version of training set - this is version 9.

```
$ cd ../../data/putnamlab/estrand/BleachingPairs_16S/Mothur
$ wget https://mothur.s3.us-east-2.amazonaws.com/wiki/trainset9_032012.pds.zip
```

Make a script to classify and remove lineages.

```
$ cd ../../data/putnamlab/estrand/BleachingPairs_16S/Mothur/scripts
$ nano classify.sh
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
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_16S/Mothur     
#SBATCH --error="script_error_classify" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_classify" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#classify.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table, reference=trainset9_032012.pds.fasta, taxonomy=trainset9_032012.pds.tax)"

mothur "#remove.lineage(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table, taxonomy=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.taxonomy, taxon=Chloroplast-Mitochondria-unknown-Archaea-Eukaryota)"

mothur "#summary.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table)"
```

Make sure you are in the Mothur directory and run the above script `$ sbatch scripts/classify.sh`.

Output files:  
- The output file .taxonomy has name of sequence and the classification with % confidence in parentheses for each level. It will end at the level that is has confidence.  

```
$ head kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.taxonomy

M00763_26_000000000-K4TML_1_1119_13050_13859	Bacteria(100);"Bacteroidetes"(100);Flavobacteria(100);"Flavobacteriales"(100);Flavobacteriaceae(100);Flavobacteriaceae_unclassified(100);
M00763_26_000000000-K4TML_1_2116_16978_14079	Bacteria(100);"Proteobacteria"(100);Gammaproteobacteria(100);Alteromonadales(100);Alteromonadaceae(100);Aestuariibacter(90);
M00763_26_000000000-K4TML_1_2101_18738_8601	Bacteria(100);"Proteobacteria"(100);Gammaproteobacteria(100);Oceanospirillales(100);Hahellaceae(100);Endozoicomonas(100);
M00763_26_000000000-K4TML_1_1115_12384_22538	Bacteria(100);"Proteobacteria"(100);Gammaproteobacteria(100);Oceanospirillales(100);Hahellaceae(100);Endozoicomonas(100);
M00763_26_000000000-K4TML_1_1107_14898_14570	Bacteria(100);"Proteobacteria"(100);Gammaproteobacteria(100);Oceanospirillales(100);Hahellaceae(100);Endozoicomonas(100);
M00763_26_000000000-K4TML_1_1115_16787_5952	Bacteria(100);"Proteobacteria"(100);Gammaproteobacteria(100);Oceanospirillales(100);Hahellaceae(100);Endozoicomonas(100);
M00763_26_000000000-K4TML_1_1109_22272_17525	Bacteria(100);Bacteria_unclassified(100);Bacteria_unclassified(100);Bacteria_unclassified(100);Bacteria_unclassified(100);Bacteria_unclassified(100);
M00763_26_000000000-K4TML_1_2115_11476_16702	Bacteria(99);"Proteobacteria"(83);"Proteobacteria"_unclassified(83);"Proteobacteria"_unclassified(83);"Proteobacteria"_unclassified(83);"Proteobacteria"_unclassified(83);
M00763_26_000000000-K4TML_1_1117_20093_24570	Bacteria(100);"Proteobacteria"(100);Gammaproteobacteria(100);Oceanospirillales(100);Hahellaceae(100);Endozoicomonas(100);
M00763_26_000000000-K4TML_1_1112_18656_4547	Bacteria(100);"Proteobacteria"(100);Gammaproteobacteria(100);Oceanospirillales(100);Hahellaceae(100);Endozoicomonas(100);
```

- The tax.summary file has the taxonimc level, the name of the taxonomic group, and the number of sequences in that group for each sample.

```
$ head kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.tax.summary

taxlevel	rankID	taxon	daughterlevels	total	WSH217	WSH218	WSH219	WSH220	WSH221	WSH222	WSH223	WSH224	WSH225	WSH226	WSH227	WSH228	WSH229	WSH230	WSH231	WSH232	WSH233	WSH234	WSH235	WSH236	WSH237	WSH238	WSH239	WSH240	WSH241	WSH242	WSH243	WSH244	WSH245	WSH246	WSH247	WSH248	WSH249	WSH250	WSH251	WSH252	WSH253	WSH254	WSH255	WSH256
0	0	Root	3	58391	115	122	192	123	169	122	95	73	72	213	4469	1629	289	4475	839	65	157	1649278	151	777	2150	222	179	283	218	242	383	864	330	2546	172	631	385	459	164	8778	7924	214	1328
1	0.1	Archaea	2	48	0	3	12	0	0	0	0	0	0	0	1	0	0	0	0	0	0	14	11	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0
2	0.1.1	"Euryarchaeota"	3	41	0	3	12	0	0	0	0	0	0	0	1	0	0	0	0	0	0	11	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0
3	0.1.1.1	"Euryarchaeota"_unclassified	1	28	0	3	0	0	0	0	0	0	0	0	1	0	0	0	0	11	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
4	0.1.1.1.1	"Euryarchaeota"_unclassified	1	28	0	3	0	0	0	0	0	0	0	0	1	0	0	0	11	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
5	0.1.1.1.1.1	"Euryarchaeota"_unclassified	1	28	0	3	0	0	0	0	0	0	0	0	1	0	0	0	11	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
6	0.1.1.1.1.1.1	"Euryarchaeota"_unclassified	0	28	0	3	0	0	0	0	0	0	0	0	1	0	0	0	11	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
3	0.1.1.2	Halobacteria	1	12	0	0	12	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
4	0.1.1.2.1	Halobacteriales	1	12	0	0	12	0	0	0	0	0	0	0	0	0	0	0	0	0	0
```


From `output_script_classify` file:

```
[WARNING]: M00763_26_000000000-K4TML_1_1108_7696_14236 could not be classified. You can use the remove.lineage command with taxon=unknown; to remove such sequences.
[WARNING]: M00763_26_000000000-K4TML_1_2107_25953_15962 could not be classified. You can use the remove.lineage command with taxon=unknown; to remove such sequences.
[WARNING]: M00763_26_000000000-K4TML_1_2104_25236_17477 could not be classified. You can use the remove.lineage command with taxon=unknown; to remove such sequences.
[WARNING]: M00763_26_000000000-K4TML_1_2110_10039_12459 could not be classified. You can use the remove.lineage command with taxon=unknown; to remove such sequences.
53

Output File Names:
kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.taxonomy
kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.tax.summary

Running command: remove.seqs(accnos=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.accnos, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table, fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta)

[WARNING]: Are you run the remove.seqs command after running a chimera command with dereplicate=t? If so, the count file has already been modified to remove all chimeras and adjust group counts. Including the count file here will cause downstream file mismatches.

Removed 81 sequences from your fasta file.
Removed 1479 sequences from your count file.

Output File Names:
kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta
kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table

Output File Names:
kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.pick.taxonomy
kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.accnos
kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table
kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta

mothur > summary.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       355     249     0       3       1
2.5%-tile:      1       355     253     0       4       1423
25%-tile:       1       355     253     0       4       14229
Median:         1       355     253     0       4       28457
75%-tile:       1       355     253     0       4       42685
97.5%-tile:     1       355     254     0       6       55490
Maximum:        1       355     258     0       8       56912
Mean:   1       355     253     0       4
# of unique seqs:       1211
total # of seqs:        56912

It took 2 secs to summarize 56912 sequences.

Output File Names:
kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.summary
```

## <a name="OTU"></a> **OTU Clustering**

Make a script to calculate pairwise distances between sequences prior to clustering. See [A. Huffmyer Step #10 OTU Clustering](https://github.com/AHuffmyer/ASH_Putnam_Lab_Notebook/blob/master/_posts/2022-01-12-16S-Analysis-in-Mothr-Part-1.md#-10-cluster-for-otus) for more explanation on each command.

```
$ cd ../../data/putnamlab/estrand/BleachingPairs_16S/Mothur/scripts
$ nano cluster.sh
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
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_16S/Mothur    
#SBATCH --error="script_error_cluster" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_cluster" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#dist.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta)"

mothur "#cluster(column=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.dist, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table, cutoff=0.03)"

mothur "#make.shared(list=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.list, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table)"

mothur "#classify.otu(list=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.list, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table, taxonomy=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.pick.taxonomy)"

mothur "#rename.file(taxonomy=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.0.03.cons.taxonomy, shared=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.shared)"

mothur "#count.groups(shared=kbay.opti_mcc.shared)"
```

Make sure you are in the Mothur directory and run the above script `$ sbatch scripts/cluster.sh`.

From the `output_script_cluster`:

```
It took 7 secs to find distances for 1211 sequences. 732655 distances below cutoff 1.
Output File Names:
kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.dist

Clustering kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.dist


iter    time    label   num_otus        cutoff  tp      tn      fp      fn      sensitivity     specificity     ppv     npv     fdr     accuracy        mcc     f1score

0.03
0       0       0.03    1211    0.03    0       693282  0       39373   0       1       0       0.94626 1       0.94626 0       0       
1       0       0.03    513     0.03    39114   693249  33      259     0.993422        0.999952        0.999157        0.999627        0.999157        0.999601        0.996075
        0.996281        
2       0       0.03    501     0.03    39139   693235  47      234     0.994057        0.999932        0.998801        0.999663        0.998801        0.999616        0.996224
        0.996423        
3       0       0.03    501     0.03    39141   693233  49      232     0.994108        0.999929        0.99875 0.999665        0.99875 0.999616        0.996224        0.996423

It took 1 seconds to cluster

Output File Names:
kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.list
kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.steps
kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.sensspec

mothur > make.shared(list=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.list, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table)
0.03

Output File Names:
kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.shared

mothur > count.groups(shared=kbay.opti_mcc.shared)
WSH217 contains 113.
WSH218 contains 111.
WSH219 contains 180.
WSH220 contains 120.
WSH221 contains 168.
WSH222 contains 122.
WSH223 contains 62.
WSH224 contains 73.
WSH225 contains 67.
WSH226 contains 213.
WSH227 contains 4468.
WSH228 contains 719.
WSH229 contains 264.
WSH230 contains 4466.
WSH231 contains 839.
WSH232 contains 65.
WSH233 contains 146.
WSH234 contains 16452.
WSH235 contains 257.
WSH236 contains 146.
WSH237 contains 760.
WSH238 contains 2020.
WSH239 contains 222.
WSH240 contains 175.
WSH241 contains 272.
WSH242 contains 217.
WSH243 contains 235.
WSH244 contains 383.
WSH245 contains 864.
WSH246 contains 328.
WSH247 contains 2545.
WSH248 contains 170.
WSH249 contains 631.
WSH250 contains 373.
WSH251 contains 277.
WSH252 contains 161.
WSH253 contains 8769.
WSH254 contains 7924.
WSH255 contains 210.
WSH256 contains 1325.

Size of smallest group: 62
```

## <a name="Subsample"></a> **Subsampling for sequencing depth**

**Stopped here for now to address sequencing issue from very beginning.**

The next set of commands can be run outside of andromeda in the interactive mode. See [A. Huffmyer post step #11 subsample for sequence depth](https://github.com/AHuffmyer/ASH_Putnam_Lab_Notebook/blob/master/_posts/2022-01-12-16S-Analysis-in-Mothr-Part-1.md#-11-subsampling-for-sequencing-depth) for more explanation on these steps.

Open mothur in interactive mode.

```
$ interactive
$ source /usr/share/Modules/init/sh
$ module load Mothur/1.46.1-foss-2020b
$ mothur
```

#### Subsample cut-offs

Subsample with a minimum of 57 based on the lowest read depth per sample. This parameter will need to be adjusted for what you need in each dataset. If you don't include a size minimum then the default is the lowest of all of the samples (in our case 57).

```
$ sub.sample(shared=kbay.opti_mcc.shared)

## output from default



Output File Names:
kbay.opti_mcc.0.03.subsample.shared

$ sub.sample(shared=kbay.opti_mcc.shared, size=300) code to include a minimum

## output from size = 300:


Output File Names:
kbay.opti_mcc.0.03.subsample.shared
```


#### Rarefraction calculation

We are going to generate a rarefaction. Calculating the observed number of OTUS using the Sobs metric (observed number of taxa) with a freq=100 to output the data for every 100 sequences samples - if you did every single sample that would be way too much data to output.

```
$ rarefaction.single(shared=mcap.opti_mcc.shared, calc=sobs, freq=100)
$ summary.single(shared=mcap.opti_mcc.shared, calc=nseqs-sobs-shannon-invsimpson, subsample=300)
```

I'm going to wait on this command and run the output without subsampling and rarefying our data to see our general output and then come back to these steps.

## <a name="Ecostats"></a> **Calculate Ecological Statistics**

## <a name="Popstats"></a> **Population Level Analyses**

## <a name="RExport"></a> **Export for R Analyses**

Files needed to export from andromeda to desktop for R analysis:  
- kbay.opti_mcc.braycurtis.0.03.lt.dist  
- kbay.opti_mcc.braycurtis.0.03.lt.ave.dist  
- kbay.taxonomy  
- kbay.opti_mcc.0.03.subsample.shared  
- kbay.opti_mcc.shared

Run outside of andromeda.

```
$ scp emma_strand@bluewaves.uri.edu:/data/putnamlab/estrand/BleachingPairs_16S/Mothur/kbay.opti_mcc.shared /Users/emmastrand/MyProjects/HI_Bleaching_Timeseries/data/16S/mothur_output/

$ scp emma_strand@bluewaves.uri.edu:/data/putnamlab/estrand/BleachingPairs_16S/Mothur/kbay.taxonomy /Users/emmastrand/MyProjects/HI_Bleaching_Timeseries/data/16S/mothur_output/
```




## <a name="Troubleshooting"></a> **Troubleshooting**

I got this error while running the contigs.sh file. I copied all raw files into the mothur folder I created and this fixed that issue.

```
mothur > make.file(inputdir=data/putnamlab/estrand/BleachingPairs_16S/raw_data, type=gz, prefix=kbay)
[ERROR]: cannot access data/putnamlab/estrand/BleachingPairs_16S/raw_data/
[ERROR]: cannot access data/putnamlab/estrand/BleachingPairs_16S/raw_data/
[ERROR]: did not complete make.file.
```

Post filter step (filter.sh), A. Huffmyer got alignment window that spans ~500 bp in length but mine is 424 bp.. With sequences that are closer to 290 nt instead of 254 nt. **Come back to this**.

When I ran the precluster.sh script, I got the following error. The last step in the script could not find an input file. **Come back to this**.

```
mothur > count.groups(count=current)
[WARNING]: no file was saved for count parameter.
You have no current groupfile, countfile or sharedfile and one is required.
[ERROR]: did not complete count.groups.
```

The total # of seqs does not stay the same between steps.. Double check this OK?
