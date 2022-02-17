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

Summary of the sequences from the `output_script_contigs` file. These values are total sequences are much lower than they should be. **This is a problem!!** Compare # of sequences to Kevin and Ariana's output.

```
Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1	44	44	0	3	1
2.5%-tile:	1	292     292     0	4	1830
25%-tile:	1	292     292     0	4	18300
Median:         1	292     292     0	4	36600
75%-tile:	1	301     301     0	5	54900
97.5%-tile:     1	414     414     5	6	71370
Maximum:        1	562     562     56	26	73199
Mean:   1	300     300     0	4
# of Seqs:	73199

It took 3 secs to summarize 73199 sequences.
```

This table shows quantile values about the distribution of sequences for a few things:

- Start position: All at 1 now, will start at different point after some QC.  
- End position: We see that there are some sequences that are very short and we may need to remove those later.  
- Number of bases: length (we see most are in expected range here, but one is super long! This might tell us there is no overlap so they are butted up against each other. We will remove things like this.  
- Ambigs: Number of ambiguous calls in sequences. Here there are a few that have ambiguous base calls. We will remove any sequence with an ambiguous call or any longer than we would expect for V4 region.  
- Polymer: Length of polymer repeats.  
- NumSeqs: Number of sequences.  

#### Check that the primers are gone.

`$ head kbay.trim.contigs.fasta`

We are looking to see that these primers `F GTGCCAGCMGCCGCGGTAA R GGACTACNVGGGTWTCTAAT` have been taken out.

Output:

```
>M00763_26_000000000-K4TML_1_1101_12354_2514	ee=2.05713	fbdiffs=0(match), rbdiffs=0(match) fpdiffs=0(match), rpdiffs=0(match)
GGACAGGGGTCAGCCGCCGCGGTGATACGGAGGATGCAAGCGTTATTCGGAATTATTGGGCGTAAAGCGTCTGTAGGTGGTTTTTTAAGTCTACTGTTAAATATTAAGGCTTAACCTTAAAAAAGCGGTATGAAACTAAAAAACTTGAGTTTAGTAGAGGTAGAGGGAATTCTCGGTGTAGTGGTGAAATGCGTAGAGATCGAGAAGAACACCGGTAGCGAAAGCGCTCTACTGGGCTAAAACTGACACTGAGAGACGAAAGCTAGGGGAGCAAATAGGATTAGATACCCGTGTAGTCC
>M00763_26_000000000-K4TML_1_1101_13549_1963	ee=2.59576	fbdiffs=0(match), rbdiffs=0(match) fpdiffs=0(match), rpdiffs=0(match)
AAGAGACATGTGCCCGCAGCCGCGGTAATACGGAGGGTGCAAGCGTTAATCGGAATTACTGGGCGTAAAGCGTGCGTAGGCGGCCTTTTAAGTTGGATGTGAAAGCCCCGGGCTTAACCTGGGAACGGCATCCAAAACTGGGAGGCTCGAGTGCGGAAGAGGAGTGTGGAATTTCCTGTGTAGCGGTGAAATGCGTAGATATAGGAAAGAACACCAGTGGCGAAGGCGACACTCTGGTCTGACACTGACGCTGAGGTACGAAAGCGTGGGGAGCAAACAGGAATAGATACCCCCGTAGTCACTGGCTCTT
>M00763_26_000000000-K4TML_1_1101_17445_1653	ee=2.85104	fbdiffs=0(match), rbdiffs=0(match) fpdiffs=0(match), rpdiffs=0(match)
GGTACAGTGGCCGGTAGCCGCTGTAATACGGAGGGTGCAAGCGTTAATCGGAATTACTGGGCGTAAAGCGTGCGTAGGCGGCTGCCTAAGTTGGATGTGAAAGCCCCGGGCTCAACCTGGGAACTGCATCCAAAACTGGGCAGCTAGAGTGCGGAAGAGGAGTGTGGAATTTCCTGTGTAGCGGTGAAATGCGTAGATATAGGAAGGAACACCAGTGGCGAAGGCGACACTCTGGTCTGACACTGACGCTGAGGTACGAAAGCGTGGGGAGCAAACAGGATTAGATACCCTCGTAGACC
>M00763_26_000000000-K4TML_1_1101_13550_2109	ee=9.22223	fbdiffs=0(match), rbdiffs=0(match) fpdiffs=0(match), rpdiffs=0(match)
AATAGACAGGTGGCCGTGGTGTCGGGAATACGGAGGGTGNAAGCGTTNATCGGAATTACTGGGCGTAAAGCGTGCGTAGGCGGCTGCCTAAGTTGGATGTGAAAGCCCCGGGCTCAACCTGGGAACTGCATCCAAAACTGGGCAGNTAGAGTGCGGAAGAGGGGTGGGGAATTTCCTGTGTAGCGGTGAAATGCGTAGATATNGGAAGGAACACCAGTGGCGANGGCGACACTCTGGTCTGACACTGACGCTGAGGTACGAAAGCGTGGGGAGCAAACAGGACAAGATACCACAGTAGCCCCCGTCTGTT
>M00763_26_000000000-K4TML_1_1101_13530_2111	ee=1.65454	fbdiffs=0(match), rbdiffs=0(match) fpdiffs=0(match), rpdiffs=0(match)
GTGCCAGCTGCCGCGGTAATACGGAGGGTGCAAGCGTTAATCGGAATTACTGGGCGTAAAGCGTGCGTAGGCGGCTGCCTAAGTTGGATGTGAAAGCCCCGGGCTCAACCTGGGAACTGCATCCAAAACTGGGCAGCTAGAGTGCGGAAGAGGAGTGTGGAATTTCCTGTGTAGCGGTGAAATGCGTAGATATAGGAAGGAACACCAGTGGCGAAGGCGACACTCTGGTCTGACACTGACGCTGAGGTACGAAAGCGTGGGGAGCAAACAGGATTAGATACCCCAGTAGTCC
```

Success.

## <a name="QC_screen"></a> **QC with screen.seqs**

Removing all poor quality sequences with an ambiguous call ("N") and >300 nt as well as set a minimum size at 260 nt. Parameters should be adjusted based on specific experiments and variable region.

Make script for the screen.seqs function.

```
$ cd ../../data/putnamlab/estrand/BleachingPairs_16S/Mothur/scripts
$ nano screen.sh
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
#SBATCH --error="script_error_screen" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_screen" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#screen.seqs(inputdir=., outputdir=., fasta=kbay.trim.contigs.fasta, group=kbay.contigs.groups, maxambig=0, maxlength=350, minlength=250)"

mothur "#summary.seqs(fasta=kbay.trim.contigs.good.fasta)"

```

Make sure you are in the Mothur directory, not scripts directory. Run script `$ sbatch scripts/screen.sh`

Output below. This script kept 55,133/73,199 sequences.  

```
$ nano output_script_screen

## output:

mothur > summary.seqs(fasta=kbay.trim.contigs.good.fasta)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1	253     253     0	3	1
2.5%-tile:	1	292     292     0	4	1379
25%-tile:	1	292     292     0	4	13784
Median:         1	292     292     0	4	27567
75%-tile:	1	301     301     0	4	41350
97.5%-tile:     1	310     310     0	6	53755
Maximum:        1	340     340     0	20	55133
Mean:   1	295     295     0	4
# of Seqs:	55133

It took 2 secs to summarize 55133 sequences.
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
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab                  
#SBATCH --error="script_error_unique" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_unique" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#unique.seqs(fasta=kbay.trim.contigs.good.fasta)"

mothur "#count.seqs(name=kbay.trim.contigs.good.names, group=kbay.contigs.good.groups)"

mothur "#summary.seqs(fasta=kbay.trim.contigs.good.unique.fasta, count=kbay.trim.contigs.good.count_table)"

mothur "#count.groups(count= kbay.trim.contigs.good.unique.fasta)"

```

Make sure you are in the Mothur directory and run the above script `sbatch scripts/unique.sh`.

Output below. Unique reads: 30,487 (55%).

```
mothur > summary.seqs(fasta=kbay.trim.contigs.good.unique.fasta, count=kbay.trim.contigs.good.count_table)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       253     253     0	3	1
2.5%-tile:	1	292     292     0	4	1379
25%-tile:       1 	292     292     0	4	13784
Median:         1	292     292     0	4	27567
75%-tile:       1       301     301     0	4	41350
97.5%-tile:     1	310     310     0	6	53755
Maximum:        1       340     340     0	20	55133
Mean:   1       295     295     0	4
# of unique seqs:	30487
total # of seqs:        55133

It took 2 secs to summarize 55133 sequences.
```

Error received. This sequence returned a count number of zero.

```
mothur > count.groups(count= kbay.trim.contigs.good.unique.fasta)
[ERROR]: Your count table contains a sequence named GGACAGGGGTCAGCCGCCGCGGTGATACGGAGGATGCAAGCGTTATTCGGAATTATTGGGCGTAAAGCGTCTGTAGGTGGTTTTTCACCGGTAGCGAAAGCGCTCTACTGGGCTAAAACTGACACTGAGAGACGAAAGCTAGGGGAGCAAATAGGATTAGATACCCGTGTAGTCC with a total=0. Please correct.
```

Come back to this? I'm not sure yet how to remove this..

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
mothur > summary.seqs(fasta=kbay.trim.contigs.good.unique.align)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       1233    1       0       1       1
2.5%-tile:      1	13424   291     0	4	763
25%-tile:	1	13424   292     0	4	7622
Median:         1       13424   292     0	4	15244
75%-tile:       1	13424   292     0	4	22866
97.5%-tile:     1       13425   293     0	6	29725
Maximum:        13425   13425   299     0	11	30487
Mean:   89      13344   288     0	4
# of Seqs:	30487

It took 12 secs to summarize 30487 sequences.

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
mothur > summary.seqs(fasta=kbay.trim.contigs.good.unique.good.align, count=kbay.trim.contigs.good.good.count_table)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1	13422   288     0	3	1
2.5%-tile:	1	13424   292     0	4	1368
25%-tile:	1	13424   292     0	4	13678
Median:         1	13424   292     0	4	27356
75%-tile:	1	13424   292     0	4	41033
97.5%-tile:     1	13425   293     0	6	53343
Maximum:        3	13425   299     0	8	54710
Mean:   1	13424   292     0	4
# of unique seqs:	30066
total # of seqs:        54710

It took 11 secs to summarize 54710 sequences.

Output File Names:
kbay.trim.contigs.good.unique.good.summary
```

We have now identified the sequences outside of the window of interest in our alignment to the Silva reference 16S V4 region. The next step will be filtering those out.

#### Filter out those sequences identified in screen2.sh

Make a script that uses filer.seqs function to take out those sequences that did not meet our criteria.

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
#SBATCH --error="script_error_filter" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_filter" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#filter.seqs(fasta=kbay.trim.contigs.good.unique.good.align, vertical=T, trump=.)"

mothur "#summary.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.fasta, count=kbay.trim.contigs.good.good.count_table)"

mothur "#count.groups(count= kbay.trim.contigs.good.good.count_table)"
```

Make sure you are in the Mothur directory and run the above script `$ sbatch scripts/filter.sh`.

Output from the `output_script_filter` file:

```
It took 11 secs to filter 30066 sequences.

Length of filtered alignment: 424
Number of columns removed: 13001
Length of the original alignment: 13425
Number of sequences used to construct filter: 30066

mothur > summary.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.fasta, count=kbay.trim.contigs.good.good.count_table)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1	424     286     0	3	1
2.5%-tile:      1	424     290     0	4	1368
25%-tile:	1	424     290     0	4	13678
Median:         1       424     290     0	4	27356
75%-tile:       1	424     290     0	4	41033
97.5%-tile:     1       424     291     0	6	53343
Maximum:        1	424     297     0	8	54710
Mean:   1       424     290     0	4
# of unique seqs:	30066
total # of seqs:        54710

It took 3 secs to summarize 54710 sequences.

Output File Names:
kbay.trim.contigs.good.unique.good.filter.summary

mothur > count.groups(count= kbay.trim.contigs.good.good.count_table)
WSH217 contains 111.
WSH218 contains 116.
WSH219 contains 182.
WSH220 contains 110.
WSH221 contains 154.
WSH222 contains 111.
WSH223 contains 88.
WSH224 contains 68.
WSH223 contains 88.
WSH224 contains 68.
WSH225 contains 68.
WSH226 contains 201.
WSH227 contains 4169.
WSH228 contains 1533.
WSH229 contains 273.
WSH230 contains 4183.
WSH231 contains 785.
WSH232 contains 62.
WSH233 contains 149.
WSH234 contains 15576.
WSH235 contains 266.
WSH236 contains 146.
WSH237 contains 722.
WSH238 contains 2021.
WSH239 contains 206.
WSH240 contains 168.
WSH241 contains 261.
WSH242 contains 200.
WSH243 contains 225.
WSH244 contains 357.
WSH245 contains 794.
WSH246 contains 305.
WSH247 contains 2388.
WSH248 contains 163.
WSH249 contains 586.
WSH250 contains 357.
WSH251 contains 426.
WSH252 contains 150.
WSH253 contains 8186.
WSH254 contains 7413.
WSH255 contains 196.
WSH256 contains 1235.

Size of smallest group: 62.
```

A. Huffmyer got alignment window that spans ~500 bp in length but mine is 424 bp.. With sequences that are closer to 290 nt instead of 254 nt. **Come back to this**.

## <a name="Pre-clustering"></a> **Pre clustering**

In this step we want to remove noise due to sequencing error. Sequences are not reduced but grouped into ASVs to reduce error rate. DADA2 is an alternate for this but that program takes out rare sequences and singletons and this one does not. See [A. Huffmyer post - preclustering step](https://github.com/AHuffmyer/ASH_Putnam_Lab_Notebook/blob/master/_posts/2022-01-12-16S-Analysis-in-Mothr-Part-1.md#-7-polish-the-data-with-pre-clustering) for further explanation.


Make a script to run the pre.cluster functions. `diffs=1` can be changed based on requirements.

```
$ cd ../../data/putnamlab/estrand/BleachingPairs_16S/Mothur/scripts
$ nano precluster.sh
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
#SBATCH --error="script_error_precluster" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_precluster" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#unique.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.fasta, count=kbay.trim.contigs.good.good.count_table)"

mothur "#pre.cluster(fasta=kbay.trim.contigs.good.unique.good.filter.unique.fasta, count=kbay.trim.contigs.good.unique.good.filter.count_table, diffs=1)"

mothur "#summary.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.fasta, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.count_table)"

mothur "#count.groups(count=current)"

```

Make sure you are in the Mothur directory and run the above script `$ sbatch scripts/preclustering.sh`.

Ouput from the `output_script_precluster` file. We kept 19,008 unique sequences from the previous 30,066 sequences. But get an error from the count.groups function -- that the input file does not exist. **Come back to this.**

```
mothur > summary.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.fasta, count=kbay.trim.contigs.good.unique.good.filter.u$

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       424     286     0	3	1
2.5%-tile:	1	424     290     0	4	1368
25%-tile:       1       424     290     0	4	13678
Median:         1       424     290     0	4	27356
75%-tile:	1	424     290     0	4	41033
97.5%-tile:     1       424     291     0	6	53343
Maximum:        1	424     297     0	8	54710
Mean:   1	424     290     0	4
# of unique seqs:	19008
total # of seqs:        54710

It took 2 secs to summarize 54710 sequences.

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

Output from `output_script_chimera` file. We kept 18,821 sequences post removing chimeras out of 19,008 sequences (0.009% chimeras).

```
mothur > summary.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta, count=kbay.trim.contigs.good.unique.good.fil$

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1	424     286     0	3	1
2.5%-tile:      1       424     290     0       4       1363
25%-tile:	1	424     290     0	4	13621
Median:         1       424     290     0       4       27241
75%-tile:	1	424     290     0	4	40861
97.5%-tile:     1       424     291     0	6	53119
Maximum:        1	424     295     0	8	54480
Mean:   1       424     290     0       4
# of unique seqs:	18821
total # of seqs:        54480

It took 1 secs to summarize 54480 sequences.

Output File Names:
kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.summary
```

Count groups for each sample output:

```
mothur > count.groups(count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table)
WSH217 contains 111.
WSH218 contains 116.
WSH219 contains 182.
WSH220 contains 108.
WSH221 contains 154.
WSH222 contains 111.
WSH223 contains 88.
WSH224 contains 68.
WSH225 contains 68.
WSH226 contains 200.
WSH227 contains 4167.
WSH228 contains 1533.
WSH229 contains 271.
WSH230 contains 4179.
WSH231 contains 785.
WSH232 contains 62.
WSH233 contains 149.
WSH234 contains 15415.
WSH235 contains 265.
WSH236 contains 145.
WSH237 contains 722.
WSH238 contains 2002.
WSH239 contains 206.
WSH240 contains 168.
WSH241 contains 261.
WSH242 contains 200.
WSH243 contains 224.
WSH244 contains 355.
WSH245 contains 794.
WSH246 contains 305.
WSH247 contains 2386.
WSH246 contains 305.
WSH247 contains 2386.
WSH248 contains 163.
WSH249 contains 586.
WSH250 contains 357.
WSH251 contains 425.
WSH252 contains 150.
WSH253 contains 8170.
WSH254 contains 7406.
WSH255 contains 196.
WSH256 contains 1227.
```

The lowest is 62.

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
#SBATCH --error="script_error_classify" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_classify" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#classify.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table, reference=trainset9_032012.pds.fasta, taxonomy=trainset9_032012.pds.tax)"

mothur "#remove.lineage(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table, taxonomy=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.taxonomy, taxon=Chloroplast-Mitochondria-unknown-Archaea-Eukaryota)"
```

Make sure you are in the Mothur directory and run the above script `$ sbatch scripts/classify.sh`.

Output files:  
- The output file .taxonomy has name of sequence and the classification with % confidence in parentheses for each level. It will end at the level that is has confidence.  

```
$ head kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.taxonomy

M00763_26_000000000-K4TML_1_1113_24267_7936	Bacteria(99);Bacteria_unclassified(99);Bacteria_unclassified(99);Bacteria_unclassified(99);Bacteria_unclassified(99);Bacteria_unclassified(99);
M00763_26_000000000-K4TML_1_2116_18812_8249	Bacteria(100);"Proteobacteria"(100);Gammaproteobacteria(100);Oceanospirillales(100);Hahellaceae(100);Endozoicomonas(100);
M00763_26_000000000-K4TML_1_2116_9711_8317	Bacteria(100);"Proteobacteria"(100);Gammaproteobacteria(100);Oceanospirillales(100);Hahellaceae(100);Endozoicomonas(100);
M00763_26_000000000-K4TML_1_2105_9657_19148	Bacteria(100);"Proteobacteria"(100);Gammaproteobacteria(100);Oceanospirillales(100);Hahellaceae(100);Endozoicomonas(100);
M00763_26_000000000-K4TML_1_2105_27916_19174	Bacteria(100);"Proteobacteria"(100);Gammaproteobacteria(100);Oceanospirillales(100);Hahellaceae(100);Endozoicomonas(100);
M00763_26_000000000-K4TML_1_2108_16288_18152	Bacteria(100);"Proteobacteria"(86);"Proteobacteria"_unclassified(86);"Proteobacteria"_unclassified(86);"Proteobacteria"_unclassified(86);"Proteobacteria"_unclassified(86);
M00763_26_000000000-K4TML_1_2116_27748_8440	Bacteria(100);"Proteobacteria"(100);Gammaproteobacteria(100);Oceanospirillales(100);Hahellaceae(100);Endozoicomonas(100);
M00763_26_000000000-K4TML_1_2116_27732_8447	Bacteria(100);"Proteobacteria"(100);Gammaproteobacteria(100);Oceanospirillales(100);Hahellaceae(100);Endozoicomonas(100);
M00763_26_000000000-K4TML_1_2116_4664_8484	Bacteria(100);"Proteobacteria"(100);Gammaproteobacteria(100);Oceanospirillales(100);Hahellaceae(100);Endozoicomonas(100);
M00763_26_000000000-K4TML_1_1119_22200_14846	Bacteria(100);"Bacteroidetes"(100);Flavobacteria(100);"Flavobacteriales"(100);Cryomorphaceae(100);Crocinitomix(100);
```

- The tax.summary file has the taxonimc level, the name of the taxonomic group, and the number of sequences in that group for each sample.

```
$ head kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.tax.summary

taxlevel	rankID	taxon	daughterlevels	total	WSH217	WSH218	WSH219	WSH220	WSH221	WSH222	WSH223	WSH224	WSH225	WSH226	WSH227	WSH228	WSH229	WSH230	WSH231	WSH232	WSH233	WSH234	WSH235	WSH236	WSH237	WSH238	WSH239	WSH240	WSH241	WSH242	WSH243	WSH244	WSH245	WSH246	WSH247	WSH248	WSH249	WSH250	WSH251	WSH252	WSH253	WSH254	WSH255	WSH256
0	0	Root	3	54480	111	116	182	108	154	111	88	68	68	200	4167	1533	271	4179	785	62	149	15415	265	145	722	2002	206	168	261	200	224	355	794	305	2386	163	586	357	425	150	8170	7406	196	1227
1	0.1	Archaea	2	45	0	3	12	0	0	0	0	0	0	0	1	0	0	0	0	0	0	11	11	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0
2	0.1.1	"Euryarchaeota"	3	40	0	3	12	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0
3	0.1.1.1	"Euryarchaeota"_unclassified	1	27	0	3	0	0	0	0	0	0	0	0	1	0	0	0	0	0
4	0.1.1.1.1	"Euryarchaeota"_unclassified	1	27	0	3	0	0	0	0	0	0	0	0	1	0	0	0	0
5	0.1.1.1.1.1	"Euryarchaeota"_unclassified	1	27	0	3	0	0	0	0	0	0	0	0	1	0	0	0	0
6	0.1.1.1.1.1.1	"Euryarchaeota"_unclassified	0	27	0	3	0	0	0	0	0	0	0	0	1	0	0	0	0
3	0.1.1.2	Halobacteria	1	12	0	0	12	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
4	0.1.1.2.1	Halobacteriales	1	12	0	0	12	0	0	0	0	0	0	0	0	0	0	0	0	0	0
```


From `output_script_classify` file:

```
Removed 824 sequences from your fasta file.
Removed 1487 sequences from your count file.

[WARNING]: Are you run the remove.seqs command after running a chimera command with dereplicate=t? If so, the count file has already been modified to remove all chimeras and adjust group counts. Including the count file here will cause downstream file mismatches.

[WARNING]: M00763_26_000000000-K4TML_1_1117_23518_11903 could not be classified. You can use the remove.lineage command with taxon=unknown; to remove such sequences.
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
#SBATCH --error="script_error_cluster" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_cluster" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#dist.seqs(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta)"

mothur "#cluster(column=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.dist, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table, cutoff=0.03)"

mothur "#cluster.split(fasta=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table, taxonomy=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.pick.taxonomy, taxlevel=4, cutoff=0.03, splitmethod=classify)"

mothur "#make.shared(list=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.list, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table)"

mothur "#classify.otu(list=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.list, count=kbay.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table, taxonomy=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.pick.taxonomy)"

mothur "#rename.file(taxonomy=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.0.03.cons.taxonomy, shared=kbay.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.shared)"

mothur "#count.groups(shared=kbay.opti_mcc.shared)"
```

Make sure you are in the Mothur directory and run the above script `$ sbatch scripts/cluster.sh`.

From the `output_script_cluster`:

```
mothur > count.groups(shared=kbay.opti_mcc.shared)
WSH217 contains 105.
WSH218 contains 105.
WSH219 contains 169.
WSH220 contains 105.
WSH219 contains 169.
WSH220 contains 105.
WSH221 contains 153.
WSH222 contains 109.
WSH223 contains 57.
WSH224 contains 67.
WSH225 contains 63.
WSH226 contains 199.
WSH227 contains 4166.
WSH228 contains 677.
WSH229 contains 244.
WSH230 contains 4170.
WSH231 contains 785.
WSH232 contains 61.
WSH233 contains 127.
WSH234 contains 15338.
WSH235 contains 244.
WSH236 contains 140.
WSH237 contains 696.
WSH238 contains 1880.
WSH239 contains 203.
WSH240 contains 158.
WSH241 contains 250.
WSH242 contains 196.
WSH243 contains 217.
WSH244 contains 352.
WSH245 contains 794.
WSH246 contains 301.
WSH247 contains 2385.
WSH248 contains 161.
WSH247 contains 2385.
WSH248 contains 161.
WSH249 contains 586.
WSH250 contains 346.
WSH251 contains 257.
WSH252 contains 147.
WSH253 contains 8156.
WSH254 contains 7405.
WSH255 contains 192.
WSH256 contains 1227.

Size of smallest group: 57.
```

## <a name="Subsample"></a> **Subsampling for sequencing depth**

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

0.03
Sampling 57 from each group.

Output File Names:
kbay.opti_mcc.0.03.subsample.shared

$ sub.sample(shared=kbay.opti_mcc.shared, size=300) code to include a minimum

## output from size = 300:
0.03
WSH217 contains 105. Eliminating.
WSH218 contains 105. Eliminating.
WSH219 contains 169. Eliminating.
WSH220 contains 105. Eliminating.
WSH221 contains 153. Eliminating.
WSH222 contains 109. Eliminating.
WSH223 contains 57. Eliminating.
WSH224 contains 67. Eliminating.
WSH225 contains 63. Eliminating.
WSH226 contains 199. Eliminating.
WSH229 contains 244. Eliminating.
WSH232 contains 61. Eliminating.
WSH233 contains 127. Eliminating.
WSH235 contains 244. Eliminating.
WSH236 contains 140. Eliminating.
WSH239 contains 203. Eliminating.
WSH240 contains 158. Eliminating.
WSH241 contains 250. Eliminating.
WSH242 contains 196. Eliminating.
WSH243 contains 217. Eliminating.
WSH248 contains 161. Eliminating.
WSH251 contains 257. Eliminating.
WSH252 contains 147. Eliminating.
WSH255 contains 192. Eliminating.
Sampling 300 from each group.

Output File Names:
kbay.opti_mcc.0.03.subsample.shared
```

The above is a large chunk of our 40 samples if we use a cut-off like 300. Moving forward I used to the default of 57 but might want to come back to this step later.


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
