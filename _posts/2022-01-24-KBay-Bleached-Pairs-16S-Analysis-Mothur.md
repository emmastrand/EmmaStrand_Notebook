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

Make a scrip to take the Silva database reference alignment and select the V4 region, and then rename this to something more helpful to us.

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

We have now removed sequences outside of the window of interest in our alignment to the Silva reference 16S V4 region.


## <a name="Troubleshooting"></a> **Troubleshooting**

I got this error while running the contigs.sh file. I copied all raw files into the mothur folder I created and this fixed that issue.



```
mothur > make.file(inputdir=data/putnamlab/estrand/BleachingPairs_16S/raw_data, type=gz, prefix=kbay)
[ERROR]: cannot access data/putnamlab/estrand/BleachingPairs_16S/raw_data/
[ERROR]: cannot access data/putnamlab/estrand/BleachingPairs_16S/raw_data/
[ERROR]: did not complete make.file.
```
