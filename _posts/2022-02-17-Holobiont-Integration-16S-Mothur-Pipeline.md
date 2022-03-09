---
layout: post
title: Holobiont Integration 16S Mothur Pipeline
date: '2022-02-17'
categories: Analysis
tags: 16S, bioinformatics, Mothur, Holobiont Integration
projects: Holobiont Integration
---

# Holobiont Integration 16S V4 Mothur Pipeline

We tried QIIME2 for this project originally (notebook post [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-06-21-16s-Analysis-Pipeline.md)) but after using both the Mothur and QIIME2 pipeline for the KBay Bleaching Pairs project we found Mothur might be better suited for our data ([KBay QIIME2](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-01-07-KBay-Pairs-16S-Analysis-Pipeline.md); [KBay Mothur](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-01-24-KBay-Bleached-Pairs-16S-Analysis-Mothur.md)).

See [Holobiont Integration 16S page](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-06-21-16s-Analysis-Pipeline.md) for more information on sequencing, primers, URI GSC, and laboratory related information.

Raw data path (edit-able): ../../data/putnamlab/estrand/HoloInt_16s/raw-data
Output data path: ../../data/putnamlab/estrand/BleachingPairs_16S/Mothur

Contents:  
- [**Setting Up Andromeda**](#Setting_up)  
- [**Threshold decisions**](#Threshold)  
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


**For a more detailed description of Mothur commands, see A.Huffmyer's notebook post: [link here](https://github.com/AHuffmyer/ASH_Putnam_Lab_Notebook/blob/master/_posts/2022-01-12-16S-Analysis-in-Mothr-Part-1.md).**

## <a name="Setting_up"></a> **Setting Up Andromeda**

Make a directory for Mothur within HoloInt_16s directory.

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s
$ mkdir Mothur
$ cd Mothur
$ mkdir processed_data
$ mkdir scripts
```

Make a file with the primer sequence information (515F and 806RB; see notebook post at the top of this document that describes the laboratory work for this protocol).

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s/Mothur
$ nano oligos.oligos

## copy and paste the following text into that file

primer GTGCCAGCMGCCGCGGTAA GGACTACNVGGGTWTCTAAT
```

Copy all raw files into the mothur folder.

```
$ cp /data/putnamlab/estrand/HoloInt_16s/raw-data/*.gz /data/putnamlab/estrand/HoloInt_16s/Mothur
```

## <a name="Threshold"></a> **Threshold Decisions**

Change these values based on the project and sequencing run details.

1. **contigs.sh:** trimoverlap=TRUE vs. trimoverlap=FALSE. Use TRUE when sequenced 2x300 bp and use FALSE when 2x250 bp sequencing.  
2. **screen.sh:** A.) maxambig=0. Setting this to 0 will take out any sequences with an ambigous call ("N"). B.) maxlength=350. This takes out any sequences over 350 bp long. C.) minlength=200. This takes out any sequences that are below 200 bp long.  
3. **unique.sh**: This script does not have any threshold values to change.    
4. **silva_ref.sh**: A.) start=11894 and end=25319 is the region of interest (V4 region). B.) keepdots=F. Silva database uses periods as placeholders and we don't need these so setting to false removes them.  
5. **align.sh**: This script does not have any threshold values to change.    
6. **screen2.sh**: A.) start=1968 and end=11550. This is our alignment window (1968-11550bp) and we don't want any sequences that are outside of that. This removes anything that starts after start and ends before end. B.) maxhomop=8. This removes anything that has repeats greater than the threshold - e.g., 8 A's in a row = polymer 8. Here we will removes polymers >8 because we are confident these are likely not "real".  
7. **filter.sh**: A.) vertical=T. This aligns vertically. B.) trump=. This aligns the sequences accounting for periods in the reference.  
8. **precluster.sh**: diffs=1. The rational behind this step assumes that the most abundant sequences are the most trustworthy and likely do not have sequencing errors. Pre-clustering then looks at the relationship between abundant and rare sequences - rare sequences that are "close" (e.g., 1 nt difference) to highly abundant sequences are likely due to sequencing error. This step will pool sequences and look at the maximum differences between sequences within this group to form ASV groupings.  
9. **chimera.sh**: dereplicate=T. Uses dereplicate method: In this method, we are again using the assumption that the highest abundance sequences are most trustworthy. This program looks for chimeras by comparing each sequences to the next highest abundance sequences to determine if a sequence is a chimera of the more abundance sequences.  
10. **classify.sh**: taxon=Chloroplast-Mitochondria-unknown-Archaea-Eukaryota. Identified taxon will be removed in this step.
11. **cluster.sh**: A.) cutoff=0.03 in cluster function. =3% difference. This equates to sequences with 97% similarity are grouped together. B.) taxlevel=4 and splitmethod=classify.   

## <a name="Contigs"></a> **Make Contigs**

Make a script to assemble contigs.

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s/Mothur/scripts
$ nano contigs.sh
$ cd .. ### need to be in mothur directory when running script

## copy and paste the below text into the nano file

#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --job-name="HI-contigs"
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab           
#SBATCH -D /data/putnamlab/estrand/HoloInt_16s/Mothur       
#SBATCH --error="script_error_contigs" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_contigs" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur "#make.file(inputdir=., type=gz, prefix=HoloInt)"

mothur "#make.contigs(inputdir=., outputdir=., file=HoloInt.files, trimoverlap=T, oligos=oligos.oligos, pdiffs=2, checkorient=t)"

mothur "#summary.seqs(fasta=HoloInt.trim.contigs.fasta)"
```

From `output_script_contigs`:

```
[WARNING]: your oligos file does not contain any group names.  mothur will not create a groupfile.

mothur > summary.seqs(fasta=HoloInt.trim.contigs.fasta)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       1       1       0       1       1
2.5%-tile:      1       175     175     0       4       208839
25%-tile:       1       176     176     0       7       2088386
Median:         1       177     177     0       10      4176772
75%-tile:       1       207     207     0       11      6265158
97.5%-tile:     1       253     253     7       11      8144705
Maximum:        1       282     282     97      46      8353543
Mean:   1       195     195     0       8
# of Seqs:      8353543

It took 271 secs to summarize 8353543 sequences.

Output File Names:
HoloInt.trim.contigs.summary
```

Output from `HoloInt.contigs.report`. Size distribution throws a red flag.. This should be closer to 253 bp length. Low number of ambiguous calls.  

```
Name    Length  Overlap_Length  Overlap_Start   Overlap_End     MisMatches      Num_Ns  Expected_Errors
M00763_59_000000000-JR652_1_1101_20554_1826     143     143     139     282     23      1       1.93348
M00763_59_000000000-JR652_1_1101_15630_1932     253     253     28      281     10      1       0.682934
M00763_59_000000000-JR652_1_1101_24419_2273     177     177     104     281     5       1       0.668573
M00763_59_000000000-JR652_1_1101_23710_2319     176     176     19      195     13      0       0.103801
M00763_59_000000000-JR652_1_1101_12208_2643     176     176     105     281     2       0       0.0527102
M00763_59_000000000-JR652_1_1101_19952_2677     176     176     19      195     0       0       8.78931e-06
M00763_59_000000000-JR652_1_1101_7489_2776      176     176     19      195     4       0       0.00923581
M00763_59_000000000-JR652_1_1101_18962_2854     176     176     105     281     2       0       0.00427462
M00763_59_000000000-JR652_1_1101_17242_1844     207     207     74      281     3       0       0.106088
M00763_59_000000000-JR652_1_1101_14171_1919     207     207     20      227     2       0       0.00307295
M00763_59_000000000-JR652_1_1101_21019_2148     207     207     74      281     4       0       0.0214246
M00763_59_000000000-JR652_1_1101_18924_2951     176     176     19      195     1       0       0.00129149
M00763_59_000000000-JR652_1_1101_18791_2992     176     176     19      195     1       0       0.00205114
M00763_59_000000000-JR652_1_1101_20846_3008     176     176     105     281     1       0       0.00147671
M00763_59_000000000-JR652_1_1101_8803_3029      176     176     19      195     1       0       0.00766643
M00763_59_000000000-JR652_1_1101_8222_2205      207     207     74      281     2       0       0.00386266
M00763_59_000000000-JR652_1_1101_18249_2419     207     207     74      281     1       0       0.00256561
M00763_59_000000000-JR652_1_1101_18233_2428     207     207     20      227     1       0       0.00204914
M00763_59_000000000-JR652_1_1101_7521_3431      176     176     105     281     0       0       0.000108334
M00763_59_000000000-JR652_1_1101_20500_3555     175     175     106     281     5       1       0.649032
M00763_59_000000000-JR652_1_1101_19386_2231     207     207     74      281     28      5       3.89183
M00763_59_000000000-JR652_1_1101_22918_2581     207     207     20      227     0       0       7.54931e-05
M00763_59_000000000-JR652_1_1101_21845_3621     176     176     19      195     0       0       2.59382e-05
M00763_59_000000000-JR652_1_1101_16990_3731     176     176     19      195     1       0       0.125926
M00763_59_000000000-JR652_1_1101_13658_3807     176     176     105     281     5       0       0.0851757
M00763_59_000000000-JR652_1_1101_9343_3814      208     208     73      281     39      7       5.52194
M00763_59_000000000-JR652_1_1101_16651_2582     207     207     20      227     0       0       2.05011e-06
M00763_59_000000000-JR652_1_1101_22702_2712     207     207     74      281     1       0       0.00160392
M00763_59_000000000-JR652_1_1101_22277_2798     253     253     27      280     0       0       0.000113608
M00763_59_000000000-JR652_1_1101_19614_2577     207     207     20      227     0       0       6.10371e-06
M00763_59_000000000-JR652_1_1101_15250_2762     207     207     20      227     1       0       0.00127164
M00763_59_000000000-JR652_1_1101_9927_2816      207     207     74      281     0       0       3.82799e-05
M00763_59_000000000-JR652_1_1101_12931_2834     207     207     74      281     14      0       0.152143
M00763_59_000000000-JR652_1_1101_7395_2881      207     207     74      281     57      10      8.5191
```

~Half are close to 207 bp length and half are close to 176 bp length. Polymers are ~11 for the 176 bp length seqs and ~7 for the 207 bp length.

#### Check for primers

Primers we are looking for: `F GTGCCAGCMGCCGCGGTAA R GGACTACNVGGGTWTCTAAT`.

Search for the primers in our contigs.

We have M, W, N, V in our primers (degenerate bases). Generate multiple possibilities for each primer to search for.

Here is the key for degenerate bases:
R=A+G Y=C+T M=A+C K=G+T S=G+C W=A+T H=A+T+C B=G+T+C D=G+A+T V=G+A+C N=A+C+G+T (remove if on the end)

Search for forward primers:

```
grep -c "GTGCCAGCAGCCGCGGTAA" HoloInt.trim.contigs.fasta # output = 22
grep -c "GTGCCAGCCGCCGCGGTAA" HoloInt.trim.contigs.fasta # output = 12
```

**Come back to the 22 and 12 output here..**

Search for a couple examples of the reverse primers:

```
grep -c "GGACTACAGGGGTATCTAAT" HoloInt.trim.contigs.fasta # output = 0
grep -c "GGACTACCAGGGTTTCTAAT" HoloInt.trim.contigs.fasta # output = 0
grep -c "GGACTACGCGGGTATCTAAT" HoloInt.trim.contigs.fasta # output = 0
grep -c "GGACTACTGGGGTTTCTAAT" HoloInt.trim.contigs.fasta # output = 0
```

These primers show up 0 times in our files.

Success! Our primers are removed.


## <a name="QC_screen"></a> **QC with screen.seqs**

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s/Mothur/scripts
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
#SBATCH -D /data/putnamlab/estrand/HoloInt_16s/Mothur                
#SBATCH --error="script_error_screen" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_screen" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#screen.seqs(inputdir=., outputdir=., fasta=HoloInt.trim.contigs.fasta, group=HoloInt.contigs.groups, maxambig=0, maxlength=350, minlength=150)"

mothur "#summary.seqs(fasta=HoloInt.trim.contigs.good.fasta)"
```

From `output_script_screen`:

```
It took 167 secs to screen 8353543 sequences, removed 1859472.

/******************************************/
Running command: remove.seqs(accnos=/glfs/brick01/gv0/putnamlab/estrand/HoloInt_16s/Mothur/HoloInt.trim.contigs.bad.accnos.temp, group=/glfs/brick01/gv0/putnamlab/estrand/HoloInt_16s/Mothur/HoloInt.
contigs.groups)
Removed 1859472 sequences from your group file.

Output File Names:
/glfs/brick01/gv0/putnamlab/estrand/HoloInt_16s/Mothur/HoloInt.contigs.pick.groups

/******************************************/

Output File Names:
/glfs/brick01/gv0/putnamlab/estrand/HoloInt_16s/Mothur/HoloInt.trim.contigs.good.fasta
/glfs/brick01/gv0/putnamlab/estrand/HoloInt_16s/Mothur/HoloInt.trim.contigs.bad.accnos
/glfs/brick01/gv0/putnamlab/estrand/HoloInt_16s/Mothur/HoloInt.contigs.good.groups


It took 731 secs to screen 8353543 sequences.


mothur > summary.seqs(fasta=HoloInt.trim.contigs.good.fasta)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       150     150     0       3       1
2.5%-tile:      1       176     176     0       4       162352
25%-tile:       1       176     176     0       7       1623518
Median:         1       177     177     0       10      3247036
75%-tile:       1       207     207     0       11      4870554
97.5%-tile:     1       253     253     0       11      6331720
Maximum:        1       281     281     0       20      6494071
Mean:   1       196     196     0       8
# of Seqs:      6494071

It took 204 secs to summarize 6494071 sequences.

Output File Names:
HoloInt.trim.contigs.good.summary
```

Output files from screen.sh step:

```
HoloInt.contigs.pick.groups
HoloInt.trim.contigs.good.fasta
HoloInt.trim.contigs.bad.accnos
HoloInt.contigs.good.groups
HoloInt.trim.contigs.good.summary
```

## <a name="Unique"></a> **Determining and counting unique sequences**

Make script to run unique.seqs function.

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s/Mothur/scripts
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
#SBATCH -D /data/putnamlab/estrand/HoloInt_16s/Mothur        
#SBATCH --error="script_error_unique" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_unique" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#unique.seqs(fasta=HoloInt.trim.contigs.good.fasta)"

mothur "#count.seqs(name=HoloInt.trim.contigs.good.names, group=HoloInt.contigs.good.groups)"

mothur "#summary.seqs(fasta=HoloInt.trim.contigs.good.unique.fasta, count=HoloInt.trim.contigs.good.count_table)"
```

From `output_script_unique`:

```
mothur > summary.seqs(fasta=HoloInt.trim.contigs.good.unique.fasta, count=HoloInt.trim.contigs.good.count_table)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       150     150     0       3       1
2.5%-tile:      1       176     176     0       4       162352
25%-tile:       1       176     176     0       7       1623518
Median:         1       177     177     0       10      3247036
75%-tile:       1       207     207     0       11      4870554
97.5%-tile:     1       253     253     0       11      6331720
Maximum:        1       281     281     0       20      6494071
Mean:   1       196     196     0       8
# of unique seqs:       91239
total # of seqs:        6494071

It took 6 secs to summarize 6494071 sequences.

Output File Names:
HoloInt.trim.contigs.good.unique.summary
```

Output files from unique.sh step:

```
HoloInt.trim.contigs.good.names
HoloInt.trim.contigs.good.unique.fasta
HoloInt.trim.contigs.good.count_table
HoloInt.trim.contigs.good.unique.summary
```


## <a name="Reference"></a> **Aligning to a reference database**

#### Prepare and download reference sequences from [Mothur wiki](https://mothur.org/wiki/silva_reference_files/)

The silva reference is used and recommended by the Mothur team. It is a manually curated data base with high diversity and high alignment quality.

```
$ cd ../../data/putnamlab/estrand/BleachingPairs_16S/Mothur

$ wget https://mothur.s3.us-east-2.amazonaws.com/wiki/silva.bacteria.zip

--2022-02-17 11:55:46--  https://mothur.s3.us-east-2.amazonaws.com/wiki/silva.bacteria.zip
Resolving mothur.s3.us-east-2.amazonaws.com (mothur.s3.us-east-2.amazonaws.com)... 52.219.93.42
Connecting to mothur.s3.us-east-2.amazonaws.com (mothur.s3.us-east-2.amazonaws.com)|52.219.93.42|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 25531698 (24M) [application/zip]
Saving to: ‘silva.bacteria.zip’

100%[======================================================================================================================>] 25,531,698  41.6MB/s   in 0.6s   

2022-02-17 11:55:48 (41.6 MB/s) - ‘silva.bacteria.zip’ saved [25531698/25531698]

$ wget https://mothur.s3.us-east-2.amazonaws.com/wiki/trainset9_032012.pds.zip

--2022-02-17 11:56:01--  https://mothur.s3.us-east-2.amazonaws.com/wiki/trainset9_032012.pds.zip
Resolving mothur.s3.us-east-2.amazonaws.com (mothur.s3.us-east-2.amazonaws.com)... 52.219.88.88
Connecting to mothur.s3.us-east-2.amazonaws.com (mothur.s3.us-east-2.amazonaws.com)|52.219.88.88|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 2682257 (2.6M) [application/zip]
Saving to: ‘trainset9_032012.pds.zip’

100%[======================================================================================================================>] 2,682,257   --.-K/s   in 0.1s    

2022-02-17 11:56:02 (20.9 MB/s) - ‘trainset9_032012.pds.zip’ saved [2682257/2682257]

$ unzip silva.bacteria.zip
$ unzip trainset9_032012.pds.zip
```

Make a script to take the Silva database reference alignment and select the V4 region, and then rename this to something more helpful to us.

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s/Mothur/scripts
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

Output reference file we will use moving forward: `silva.bacteria/silva.v4.fasta`.

### Align our sequences to the new reference database we've created

Make a script to align sequences to the reference file we just created.

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s/Mothur/scripts
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
#SBATCH -D /data/putnamlab/estrand/HoloInt_16s/Mothur          
#SBATCH --error="script_error_align" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_align" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#align.seqs(fasta=HoloInt.trim.contigs.good.unique.fasta, reference=silva.v4.fasta)"

mothur "#summary.seqs(fasta=HoloInt.trim.contigs.good.unique.align)"
```

From `output_script_align`:

```
[WARNING]: 36306 of your sequences generated alignments that eliminated too many bases, a list is provided in HoloInt.trim.contigs.good.unique.flip.accnos.
[NOTE]: 6142 of your sequences were reversed to produce a better alignment.

It took 173 seconds to align 91239 sequences.

Output File Names:
HoloInt.trim.contigs.good.unique.align
HoloInt.trim.contigs.good.unique.align.report
HoloInt.trim.contigs.good.unique.flip.accnos

mothur > summary.seqs(fasta=HoloInt.trim.contigs.good.unique.align)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        0       0       0       0       1       1
2.5%-tile:      1       1250    3       0       2       2281
25%-tile:       1       1250    11      0       3       22810
Median:         1968    11550   253     0       4       45620
75%-tile:       1968    11550   253     0       4       68430
97.5%-tile:     13406   13425   254     0       6       88959
Maximum:        13425   13425   274     0       14      91239
Mean:   2152    8339    156     0       3
# of Seqs:      91239

It took 31 secs to summarize 91239 sequences.

Output File Names:
HoloInt.trim.contigs.good.unique.summary
```


### QC sequences that were aligned to the reference file we created.


The sequences are aligned at the correct positions to the reference but now we need to remove those that are outside the reference window. This removes all sequences that start after the `start` and those that end before the `end`. This also takes out any sequences that have repeats greater than 8 (i.e. 8 A's in a row) because we are confident those are not real.

Make a script to do the above commands.

`maxhomop=12` set to 12 instead of 8 because a majority of the polymer values in this dataset were 11.... **come back to why this may be and deciding this cut-off.**

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s/Mothur/scripts
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
#SBATCH -D /data/putnamlab/estrand/HoloInt_16s/Mothur    
#SBATCH --error="script_error_screen2" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_screen2" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#screen.seqs(fasta=HoloInt.trim.contigs.good.unique.align, count=HoloInt.trim.contigs.good.count_table, start=1968, end=11550, maxhomop=12)"

mothur "#summary.seqs(fasta=HoloInt.trim.contigs.good.unique.good.align, count=HoloInt.trim.contigs.good.good.count_table)"

mothur "#count.groups(count=HoloInt.trim.contigs.good.good.count_table)"
```

From `output_script_screen2`:

```
It took 36 secs to screen 91239 sequences, removed 37971.

/******************************************/
Running command: remove.seqs(accnos=HoloInt.trim.contigs.good.unique.bad.accnos.temp, count=HoloInt.trim.contigs.good.count_table)
Removed 5699697 sequences from your count file.

Output File Names:
HoloInt.trim.contigs.good.pick.count_table

/******************************************/

Output File Names:
HoloInt.trim.contigs.good.unique.good.align
HoloInt.trim.contigs.good.unique.bad.accnos
HoloInt.trim.contigs.good.good.count_table


It took 42 secs to screen 91239 sequences.

mothur > summary.seqs(fasta=HoloInt.trim.contigs.good.unique.good.align, count=HoloInt.trim.contigs.good.good.count_table)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       11550   241     0       3       1
2.5%-tile:      1968    11550   253     0       4       19860
25%-tile:       1968    11550   253     0       4       198594
Median:         1968    11550   253     0       4       397188
75%-tile:       1968    11550   253     0       5       595781
97.5%-tile:     1968    11550   254     0       6       774515
Maximum:        1968    13425   272     0       12      794374
Mean:   1967    11550   253     0       4
# of unique seqs:       53268
total # of seqs:        794374

It took 19 secs to summarize 794374 sequences.

Output File Names:
HoloInt.trim.contigs.good.unique.good.summary

Size of smallest group: 27.

Total seqs: 794374.

Output File Names:
HoloInt.trim.contigs.good.good.count.summary
```


#### Filter out those sequences identified in screen2.sh

Make a script that uses filter.seqs function to take out those sequences that did not meet our criteria.

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s/Mothur/scripts
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
#SBATCH -D /data/putnamlab/estrand/HoloInt_16s/Mothur       
#SBATCH --error="script_error_filter" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_filter" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#filter.seqs(fasta=HoloInt.trim.contigs.good.unique.good.align, vertical=T, trump=.)"

mothur "#summary.seqs(fasta=HoloInt.trim.contigs.good.unique.good.filter.fasta, count=HoloInt.trim.contigs.good.good.count_table)"

```

Output from the `output_script_filter` file:

```
Length of filtered alignment: 505
Number of columns removed: 12920
Length of the original alignment: 13425
Number of sequences used to construct filter: 53268

Output File Names:
HoloInt.filter
HoloInt.trim.contigs.good.unique.good.filter.fasta

mothur > summary.seqs(fasta=HoloInt.trim.contigs.good.unique.good.filter.fasta, count=HoloInt.trim.contigs.good.good.count_table)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       504     241     0       3       1
2.5%-tile:      1       505     253     0       4       19860
25%-tile:       1       505     253     0       4       198594
Median:         1       505     253     0       4       397188
75%-tile:       1       505     253     0       5       595781
97.5%-tile:     1       505     254     0       6       774515
Maximum:        1       505     263     0       12      794374
Mean:   1       504     253     0       4
# of unique seqs:       53268
total # of seqs:        794374

It took 4 secs to summarize 794374 sequences.

Output File Names:
HoloInt.trim.contigs.good.unique.good.filter.summary

```

## <a name="Pre-clustering"></a> **Pre clustering**

Make a script to run the pre.cluster functions. `diffs=1` can be changed based on requirements.

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s/Mothur/scripts
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
#SBATCH -D /data/putnamlab/estrand/HoloInt_16s/Mothur       
#SBATCH --error="script_error_precluster" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_precluster" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#unique.seqs(fasta=HoloInt.trim.contigs.good.unique.good.filter.fasta, count=HoloInt.trim.contigs.good.good.count_table)"

mothur "#pre.cluster(fasta=HoloInt.trim.contigs.good.unique.good.filter.unique.fasta, count=HoloInt.trim.contigs.good.unique.good.filter.count_table, diffs=1)"

mothur "#summary.seqs(fasta=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.fasta, count=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.count_table)"
```

Ouput from the `output_script_precluster` file:


```
Output File Names:
HoloInt.trim.contigs.good.unique.good.filter.count_table
HoloInt.trim.contigs.good.unique.good.filter.unique.fasta

mothur > summary.seqs(fasta=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.fasta, count=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.count_table)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       504     241     0       3       1
2.5%-tile:      1       505     253     0       4       19860
25%-tile:       1       505     253     0       4       198594
Median:         1       505     253     0       4       397188
75%-tile:       1       505     253     0       5       595781
97.5%-tile:     1       505     254     0       6       774515
Maximum:        1       505     263     0       12      794374
Mean:   1       504     253     0       4
# of unique seqs:       23895
total # of seqs:        794374

It took 2 secs to summarize 794374 sequences.

Output File Names:
HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.summary
```

## <a name="Chimeras"></a> **Identifying Chimeras**

Make a script to use the `chimera.vsearch` function and then remove those sequences.

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s/Mothur/scripts
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
#SBATCH -D /data/putnamlab/estrand/HoloInt_16s/Mothur                 
#SBATCH --error="script_error_chimera" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_chimera" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

module load VSEARCH/2.18.0-GCC-10.2.0

mothur

mothur "#chimera.vsearch(fasta=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.fasta, count=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.count_table, dereplicate=T)"

mothur "#remove.seqs(fasta=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.fasta, accnos=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.accnos)"

mothur "#summary.seqs(fasta=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta, count=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table)"

mothur "#count.groups(count=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table)"
```

Output from `output_script_chimera` file:

```
mothur > summary.seqs(fasta=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta, count=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch
.pick.count_table)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       504     241     0       3       1
2.5%-tile:      1       505     253     0       4       19756
25%-tile:       1       505     253     0       4       197552
Median:         1       505     253     0       4       395104
75%-tile:       1       505     253     0       5       592656
97.5%-tile:     1       505     254     0       6       770452
Maximum:        1       505     263     0       12      790207
Mean:   1       504     253     0       4
# of unique seqs:       21197
total # of seqs:        790207

It took 3 secs to summarize 790207 sequences.

Size of smallest group: 27.

Total seqs: 790207.

Output File Names:
HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count.summary
```

## <a name="Classify_seq"></a> **Classifying Sequences**

The cleaning steps are now complete and we can classify our sequences. We have already downloaded the silva database in previous step from the Mothur wiki page. Download the mothur-formatted version of training set - this is version 9.

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s/Mothur
$ wget https://mothur.s3.us-east-2.amazonaws.com/wiki/trainset9_032012.pds.zip

--2022-02-17 12:14:46--  https://mothur.s3.us-east-2.amazonaws.com/wiki/trainset9_032012.pds.zip
Resolving mothur.s3.us-east-2.amazonaws.com (mothur.s3.us-east-2.amazonaws.com)... 52.219.142.66
Connecting to mothur.s3.us-east-2.amazonaws.com (mothur.s3.us-east-2.amazonaws.com)|52.219.142.66|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 2682257 (2.6M) [application/zip]
Saving to: ‘trainset9_032012.pds.zip.1’

100%[======================================================================================================================>] 2,682,257   --.-K/s   in 0.1s    

2022-02-17 12:14:47 (18.3 MB/s) - ‘trainset9_032012.pds.zip.1’ saved [2682257/2682257]
```

Make a script to classify and remove lineages.

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s/Mothur/scripts
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
#SBATCH -D /data/putnamlab/estrand/HoloInt_16s/Mothur    
#SBATCH --error="script_error_classify" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_classify" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#classify.seqs(fasta=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta, count=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table, reference=trainset9_032012.pds.fasta, taxonomy=trainset9_032012.pds.tax)"

mothur "#remove.lineage(fasta=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta, count=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table, taxonomy=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.taxonomy, taxon=Chloroplast-Mitochondria-unknown-Archaea-Eukaryota)"
```

Output files:  
- The output file .taxonomy has name of sequence and the classification with % confidence in parentheses for each level. It will end at the level that is has confidence.  

```
$ head HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.taxonomy


```

- The tax.summary file has the taxonimc level, the name of the taxonomic group, and the number of sequences in that group for each sample.

```
$ head HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.tax.summary


```

From `output_script_classify` file:

```
[WARNING]: M00763_59_000000000-JR652_1_1104_13447_5072 could not be classified. You can use the remove.lineage command with taxon=unknown; to remove such sequences.
[WARNING]: M00763_59_000000000-JR652_1_1118_26370_4487 could not be classified. You can use the remove.lineage command with taxon=unknown; to remove such sequences.
[WARNING]: M00763_59_000000000-JR652_1_1105_12992_6638 could not be classified. You can use the remove.lineage command with taxon=unknown; to remove such sequences.
[WARNING]: M00763_59_000000000-JR652_1_2104_5847_16644 could not be classified. You can use the remove.lineage command with taxon=unknown; to remove such sequences.
[WARNING]: M00763_59_000000000-JR652_1_1118_15442_7329 could not be classified. You can use the remove.lineage command with taxon=unknown; to remove such sequences.
[WARNING]: M00763_59_000000000-JR652_1_2113_13939_20861 could not be classified. You can use the remove.lineage command with taxon=unknown; to remove such sequences.
[WARNING]: M00763_59_000000000-JR652_1_1111_8017_7390 could not be classified. You can use the remove.lineage command with taxon=unknown; to remove such sequences.
[WARNING]: M00763_59_000000000-JR652_1_2102_11368_19966 could not be classified. You can use the remove.lineage command with taxon=unknown; to remove such sequences.

It took 167 secs to classify 21197 sequences.


It took 3 secs to create the summary file for 21197 sequences.


Output File Names:
HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.taxonomy
HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.tax.summary

mothur > remove.lineage(fasta=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta, count=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table, taxonomy=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.taxonomy, taxon=Chloroplast-Mitochondria-unknown-Archaea-Eukaryota)

/******************************************/
Running command: remove.seqs(accnos=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.accnos, count=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.count_table, fasta=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta)

[WARNING]: Are you run the remove.seqs command after running a chimera command with dereplicate=t? If so, the count file has already been modified to remove all chimeras and adjust group counts. Including the count file here will cause downstream file mismatches.

Removed 2967 sequences from your fasta file.
Removed 131963 sequences from your count file.

Output File Names:
HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta
HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table

/******************************************/

Output File Names:
HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.pick.taxonomy
HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.accnos
HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table
HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta
```

## <a name="OTU"></a> **OTU Clustering**

Make a script to calculate pairwise distances between sequences prior to clustering. See [A. Huffmyer Step #10 OTU Clustering](https://github.com/AHuffmyer/ASH_Putnam_Lab_Notebook/blob/master/_posts/2022-01-12-16S-Analysis-in-Mothr-Part-1.md#-10-cluster-for-otus) for more explanation on each command.

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s/Mothur/scripts
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
#SBATCH -D /data/putnamlab/estrand/HoloInt_16s/Mothur     
#SBATCH --error="script_error_cluster" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_cluster" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#dist.seqs(fasta=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta)"

mothur "#cluster(column=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.dist, count=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table, cutoff=0.03)"

mothur "#make.shared(list=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.list, count=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table)"

mothur "#classify.otu(list=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.list, count=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table, taxonomy=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.pick.taxonomy)"

mothur "#rename.file(taxonomy=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.0.03.cons.taxonomy, shared=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.shared)"

mothur "#count.groups(shared=HoloInt.opti_mcc.shared)"
```

From the `output_script_cluster`:

```
mothur > classify.otu(list=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.list, count=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.de
novo.vsearch.pick.pick.count_table, taxonomy=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.pick.taxonomy)
0.03

Output File Names:
HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.0.03.cons.taxonomy
HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.0.03.cons.tax.summary

mothur > rename.file(taxonomy=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.0.03.cons.taxonomy, shared=HoloInt.trim.contigs.good.unique.good.filter.un
ique.precluster.pick.pick.opti_mcc.shared)

Current files saved by mothur:
shared=HoloInt.opti_mcc.shared
taxonomy=HoloInt.taxonomy
processors=24

Size of smallest group: 14.

Total seqs: 658244.
```

# We are stopping here to return to lab work to sequence the V3/V4 region instead

## <a name="Subsample"></a> **Subsampling for sequencing depth**

#### Subsample cut-offs

#### Rarefraction calculation

## <a name="Ecostats"></a> **Calculate Ecological Statistics**

## <a name="Popstats"></a> **Population Level Analyses**

## <a name="RExport"></a> **Export for R Analyses**

Files needed to export from andromeda to desktop for R analysis:  
- HoloInt.opti_mcc.braycurtis.0.03.lt.dist  
- HoloInt.opti_mcc.braycurtis.0.03.lt.ave.dist  
- HoloInt.taxonomy  
- HoloInt.opti_mcc.0.03.subsample.shared  
- HoloInt.opti_mcc.shared

Run outside of andromeda.

```
$ scp emma_strand@bluewaves.uri.edu:/data/putnamlab/estrand/HoloInt_16s/Mothur/HoloInt.opti_mcc.shared /Users/emmastrand/MyProjects/Acclim_Dynamics/16S_seq/mothur_output/

$ scp emma_strand@bluewaves.uri.edu:/data/putnamlab/estrand/HoloInt_16s/Mothur/HoloInt.taxonomy /Users/emmastrand/MyProjects/Acclim_Dynamics/16S_seq/mothur_output/
```

## <a name="Troubleshooting"></a> **Troubleshooting**

### Contigs.sh

Script to make contigs. Originally I did this as `contigs.sh` with trimoverlap=FALSE which is the default. I did this again as `contigs2.sh` for the correct command trimoverlap=TRUE for 2x300 bp sequencing.

All files already generated with `HoloInt` prefixes are with trimoverlap=FALSE. Move forward with prefix `HoloInt2` which is trimoverlap=TRUE. All scripts following Contigs.sh should have `HoloInt2`.

### trimoverlap=FALSE (default); HoloInt

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s/Mothur/scripts
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

mothur "#make.file(inputdir=., type=gz, prefix=HoloInt)"

mothur "#make.contigs(inputdir=., outputdir=., file=HoloInt.files, oligos=oligos.oligos)"

mothur "#summary.seqs(fasta=HoloInt.trim.contigs.fasta)"
```

From `output_script_contigs`:

```
mothur > summary.seqs(fasta=HoloInt.trim.contigs.fasta)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       22      22      0       2       1
2.5%-tile:      1       215     215     0       4       125048
25%-tile:       1       215     215     0       11      1250474
Median:         1       301     301     0       11      2500948
75%-tile:       1       301     301     0       11      3751421
97.5%-tile:     1       388     388     6       16      4876847
Maximum:        1       563     563     97      280     5001894
Mean:   1       287     287     0       10
# of Seqs:      5001894

It took 170 secs to summarize 5001894 sequences.

Output File Names:
HoloInt.trim.contigs.summary
```

Head from `HoloInt.contigs.report`:

```
Name    Length  Overlap_Length  Overlap_Start   Overlap_End     MisMatches      Num_Ns  Expected_Errors
M00763_59_000000000-JR652_1_1101_20554_1826     419     143     139     282     23      1       5.62825
M00763_59_000000000-JR652_1_1101_22277_2798     309     253     27      280     0       0       2.34858
M00763_59_000000000-JR652_1_1101_13828_1806     300     176     104     280     11      0       11.2844
M00763_59_000000000-JR652_1_1101_11156_1815     301     176     105     281     5       0       9.74297
M00763_59_000000000-JR652_1_1101_20642_1770     386     176     104     280     37      1       20.2676
M00763_59_000000000-JR652_1_1101_20625_1774     386     176     104     280     40      1       21.592
M00763_59_000000000-JR652_1_1101_10688_1769     385     176     104     280     17      0       16.2035
M00763_59_000000000-JR652_1_1101_21994_1881     301     176     105     281     2       0       8.53798
M00763_59_000000000-JR652_1_1101_10081_1903     301     176     105     281     0       0       7.56337
M00763_59_000000000-JR652_1_1101_11583_2021     215     176     19      195     0       0       0.559736
M00763_59_000000000-JR652_1_1101_9558_2149      215     176     19      195     5       0       1.59155
M00763_59_000000000-JR652_1_1101_11323_1867     301     253     28      281     34      9       11.0915
M00763_59_000000000-JR652_1_1101_14973_1797     300     176     104     280     10      1       11.1698
M00763_59_000000000-JR652_1_1101_12254_1851     215     176     19      195     4       0       1.39373
M00763_59_000000000-JR652_1_1101_17477_1890     215     176     19      195     2       0       1.11177
M00763_59_000000000-JR652_1_1101_15836_1922     215     176     19      195     0       0       0.580719
M00763_59_000000000-JR652_1_1101_15630_1932     310     253     28      281     10      1       3.83715
M00763_59_000000000-JR652_1_1101_17412_1988     310     253     28      281     1       0       3.64066
M00763_59_000000000-JR652_1_1101_13803_1830     300     176     104     280     9       0       10.9099
```


### trimoverlap=TRUE; HoloInt2

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s/Mothur/scripts
$ nano contigs2.sh
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
#SBATCH --error="script_error_contigs2" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_contigs2" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur "#make.file(inputdir=., type=gz, prefix=HoloInt2)"

mothur "#make.contigs(inputdir=., outputdir=., file=HoloInt2.files, oligos=oligos.oligos,trimoverlap=T)"

mothur "#summary.seqs(fasta=HoloInt2.trim.contigs.fasta)"
```

From `output_script_contigs2`:

```
mothur > summary.seqs(fasta=HoloInt2.trim.contigs.fasta)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1	1	1	0	1	1
2.5%-tile:	1	175     175     0	4	125047
25%-tile:       1       176     176     0       11      1250464
Median:         1	176     176     0	11	2500928
75%-tile:       1       176     176     0	11	3751392
97.5%-tile:     1	253     253     6	11	4876809
Maximum:        1	280     280     97	46	5001855
Mean:   1	191     191     0	9
# of Seqs:      5001855

It took 163 secs to summarize 5001855 sequences.

Output File Names:
HoloInt2.trim.contigs.summary
```

Head from `HoloInt2.contigs.report `:

```
Name    Length  Overlap_Length  Overlap_Start   Overlap_End     MisMatches      Num_Ns  Expected_Errors
M00763_59_000000000-JR652_1_1101_20554_1826     143     143     139     282     23      1       1.93348
M00763_59_000000000-JR652_1_1101_22277_2798     253     253     27      280     0       0       0.000113608
M00763_59_000000000-JR652_1_1101_10688_1769     176     176     104     280     17      0       0.117051
M00763_59_000000000-JR652_1_1101_15630_1932     253     253     28      281     10      1       0.682934
M00763_59_000000000-JR652_1_1101_14973_1797     176     176     104     280     10      1       0.785857
M00763_59_000000000-JR652_1_1101_12254_1851     176     176     19      195     4       0       0.00852637
M00763_59_000000000-JR652_1_1101_17477_1890     176     176     19      195     2       0       0.00388221
M00763_59_000000000-JR652_1_1101_15836_1922     176     176     19      195     0       0       1.2168e-05
M00763_59_000000000-JR652_1_1101_19183_1966     176     176     105     281     2       0       0.00414464
M00763_59_000000000-JR652_1_1101_17412_1988     253     253     28      281     1       0       0.00217848
M00763_59_000000000-JR652_1_1101_17429_1998     253     253     24      277     56      17      12.5534
M00763_59_000000000-JR652_1_1101_23710_2319     176     176     19      195     13      0       0.103801
M00763_59_000000000-JR652_1_1101_12208_2643     176     176     105     281     2       0       0.0527102
M00763_59_000000000-JR652_1_1101_19952_2677     176     176     19      195     0       0       8.78931e-06
M00763_59_000000000-JR652_1_1101_14665_1981     176     176     104     280     25      2       1.48208
M00763_59_000000000-JR652_1_1101_12899_1997     176     176     19      195     1       0       0.0013659
M00763_59_000000000-JR652_1_1101_7489_2776      176     176     19      195     4       0       0.00923581
M00763_59_000000000-JR652_1_1101_18962_2854     176     176     105     281     2       0       0.00427462
```

Warning generated: `[WARNING]: your oligos file does not contain any group names.  mothur will not create a groupfile.`. You can label groups if you have several primer sets in your dataset. We don't need this since we are only using V4 and one primer set.

#### Choice for trimoverlap=TRUE vs. FALSE

Moving forward with the prefix:


### Check that the primers are gone.

`$ head HoloInt2.trim.contigs.fasta`

We are looking to see that these primers `F GTGCCAGCMGCCGCGGTAA R GGACTACNVGGGTWTCTAAT` have been taken out.

Output:

```
>M00763_59_000000000-JR652_1_1101_20554_1826	ee=1.93348	fbdiffs=0(match), rbdiffs=0(match) fpdiffs=0(match), rpdiffs=0(match)
GATTGTGTGGTGCGGTATTTGGGACATTTACCTTGAGGAAATTAGAGTGTTTCAAGCAAGCGCACGCTTTGAATACCGTAGCATGGANTAATAAGATAGGGCCTCAGTTCTATTTTGTTGGTTTCTAGAGCTGAGGTAATGGT
>M00763_59_000000000-JR652_1_1101_22277_2798	ee=0.000113608	fbdiffs=0(match), rbdiffs=0(match) fpdiffs=0(match), rpdiffs=0(match)
TACGGGGGGTCCAAGCGTTAATCAGAATTACTGGGCGTAAAGGGTCTGTAGGTGGTTTGGTAAGTCAGATGTGAAATCCCAGGGCTCAACCTTGGAATTGCATTTGATACTGTCAAACTAGAGTATAGTAGAGGAATAAGGAATTTCTGGTGTAGCGGTGAAATGCGTAGAGATCAGAAGGAACACCAATGGCGAAGGCAATATTCTAGACTAATACTGACATTGAAAGACGAAAGCGTGGGGATCAAACAGG
>M00763_59_000000000-JR652_1_1101_10688_1769	ee=0.117051	fbdiffs=0(match), rbdiffs=0(match) fpdiffs=0(match), rpdiffs=0(match)
GACTTAAGGATTTATTTTTTAATAAAAAGCAAAAAGCGTGTTAAGGATTTTTTAAAAAAAAAAATAAATAGAATTTTTTTCGTAATTGTAATATGTTAAAATGAAAAAAAGAATTTTTTATATGAAGATAATTTATTTTTTTTTTCTTAAATACGAAGGTTTGGGGAGCAAATAGG
>M00763_59_000000000-JR652_1_1101_15630_1932	ee=0.682934	fbdiffs=0(match), rbdiffs=0(match) fpdiffs=0(match), rpdiffs=0(match)
AACGAGAAGGGTTAGCGTTATTCAGATTAATTTGGCGTAAAGGATGCGTAGGTTGAAAATTAATTAAATAATAAAATTTCAAAATTAACTTTGAATTATTTTTACTAAAAATATTTTCTTGAGTTTAATAGNGGATTGTAGAACTTTAAATGTAACAGTAAAATGTATTGATATTTAAAAGAATTTCTAAAGCGAAGGCAACAATCTAAATTAAGACTGACATTGAGGTATTAAAGCATGGGGAGCAAAGGGG
>M00763_59_000000000-JR652_1_1101_14973_1797	ee=0.785857	fbdiffs=0(match), rbdiffs=0(match) fpdiffs=0(match), rpdiffs=0(match)
GANTTAAGGATTTATTTTTTAATAAAAAGCAAAAAGCGTGTTAAGGATTTTTTAAAAAAAAAAATAAATAGAATTTTTTTCGTAATTGTAATATGTTAAAATGAAAAAAAGAATTTTTTATATGAAGATAATTTATTTTTTTTTTCTTAAATACGAAGGTTTGGGGAGCAAATAGG
```

Primers are gone. Success! Move forward with `HoloInt2` prefix in all following scripts.


### Screen.sh step

I looked at different max ambig calls to see if this changed the output.. it didn't really. This was done on HoloInt2 with the trimoverlap=TRUE for 2x300 bp sequencing.

**maxambig=0**

From `output_script_screen`:


```
Removed 4233708 sequences from your group file.

mothur > summary.seqs(fasta=HoloInt2.trim.contigs.good.fasta)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1	201     201     0	3	1
2.5%-tile:	1	253     253     0	4	19204
25%-tile:	1	253     253     0	4	192037
Median:         1	253     253     0	4	384074
75%-tile:	1	253     253     0	5	576111
97.5%-tile:     1	254     254     0	6	748944
75%-tile:	1	253     253     0	5	576111
97.5%-tile:     1	254     254     0	6	748944
Maximum:        1       280     280     0       14	768147
Mean:   1	252     252     0	4
# of Seqs:	768147

It took 26 secs to summarize 768147 sequences.
```

**maxambig=1**

From `output_script_screen-N`:

```
mothur > summary.seqs(fasta=HoloInt2.trim.contigs.good.fasta)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1 	200     200     0	3	1
2.5%-tile:      1       253     253     0       4       21843
25%-tile:       1       253     253     0       4       218422
Median:         1       253     253     0       4       436843
75%-tile:	1	253     253     0	5	655264
97.5%-tile:     1	254     254     1	6	851843
Maximum:        1       280     280     1       14	873685
Mean:   1	252     252     0	4
# of Seqs:	873685

It took 29 secs to summarize 873685 sequences.

Output File Names:
HoloInt2.trim.contigs.good.summary
```

From `output_script_screen-N5`:

```
mothur > summary.seqs(fasta=HoloInt2.trim.contigs.good.fasta)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1       200     200     0       3       1
2.5%-tile:      1       252     252     0       4       23935
25%-tile:       1       253     253     0       4       239350
Median:         1       253     253     0       4       478700
75%-tile:       1       253     253     0       5       718050
97.5%-tile:     1       254     254     4       6       933465
Maximum:        1       280     280     5       16      957399
Mean:   1       252     252     0       4
# of Seqs:      957399

It took 32 secs to summarize 957399 sequences.

Output File Names:
HoloInt2.trim.contigs.good.summary
```
