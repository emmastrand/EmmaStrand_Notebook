---
layout: post
title: Holobiont Integration 16S Mothur Pipeline
date: '2022-02-17'
categories: Analysis
tags: 16S, bioinformatics, Mothur, Holobiont Integration
projects: Holobiont Integration
---

# Holobiont Integration 16S Mothur Pipeline

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
11. **cluster.sh**: A.) cutoff=0.03 in cluster function. =3% difference. This equates to sequences with 97% similarity are grouped together. B.) taxlevel=4 and splitmethod=classify. XXXX  

## <a name="Contigs"></a> **Make Contigs**

Script to make contigs. Originally I did this as `contigs.sh` with trimoverlap=FALSE which is the default. I did this again as `contigs2.sh` for the correct command trimoverlap=TRUE for 2x300 bp sequencing.

All files already generated with `HoloInt` prefixes are with trimoverlap=FALSE. Move forward with prefix `HoloInt2` which is trimoverlap=TRUE. All scripts following Contigs.sh should have `HoloInt2`.

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

Warning generated: `[WARNING]: your oligos file does not contain any group names.  mothur will not create a groupfile.`. You can label groups if you have several primer sets in your dataset. We don't need this since we are only using V4 and one primer set.


#### Check that the primers are gone.

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

## <a name="QC_screen"></a> **QC with screen.seqs**

Make script for screen.seqs function.

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
#SBATCH --error="script_error_screen" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_screen" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#screen.seqs(inputdir=., outputdir=., fasta=HoloInt2.trim.contigs.fasta, group=HoloInt.contigs.groups, maxambig=0, maxlength=350, minlength=200)"

mothur "#summary.seqs(fasta=HoloInt2.trim.contigs.good.fasta)"
```

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
#SBATCH --error="script_error_unique" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_unique" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#unique.seqs(fasta=HoloInt2.trim.contigs.good.fasta)"

mothur "#count.seqs(name=HoloInt2.trim.contigs.good.names, group=HoloInt2.contigs.good.groups)"

mothur "#summary.seqs(fasta=HoloInt2.trim.contigs.good.unique.fasta, count=HoloInt2.trim.contigs.good.count_table)"

mothur "#count.groups(count= HoloInt2.trim.contigs.good.unique.fasta)"
```

From `output_script_unique`:

```
mothur > summary.seqs(fasta=HoloInt.trim.contigs.good.unique.fasta, count=HoloInt.trim.contigs.good.count_table)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1	253     253     0	3	1
2.5%-tile:	1	292     292     0	4	47173
25%-tile:	1	300     300     0	4	471726
Median:         1	301     301     0	11	943451
75%-tile:	1	301     301     0	11	1415176
97.5%-tile:     1	309     309     0	16	1839729
Maximum:        1	350     350     0	105     1886901
Mean:   1	299     299     0	8
# of unique seqs:	1592091
total # of seqs:        1886901

It took 93 secs to summarize 1886901 sequences.

Output File Names:
HoloInt.trim.contigs.good.unique.summary

[ERROR]: Your count table contains a sequence named AGAGACAGGGGCCAGCAGCCGGGGGAATACGGGGGGTCCAAGCGTTAATCAGAATTACTGGGCGTAAAGGGTCTGTAGGTGGTTTGGTAAGTCAGATGTGAAATCCCAGGGCTCAACCTTGGAATTGCATTTGATACTGTCAAACTAGAGTATAGTAGAGGAATAAGGATAAGGAATTTCTGGTGTAGCGGTGAAATGCGTAGAGATCAGAAGGAACACCAATGGCGAAGGCAATATTCTAGACTAATACTGACATTGAAAGACGAAAGCGTGGGGATCAAACAGGATTAGATACCCCGGTAGTCCCTGTCACTT with a total=0. Please correct.
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

### align.sh script with HoloInt prefix

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
mothur > summary.seqs(fasta=HoloInt.trim.contigs.good.unique.align)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        0	0	0	0	1	1
2.5%-tile:	1	1248    5	0	2	39803
25%-tile:	1	13424   8	0	2	398023
Median:         10648   13425   22	0	3	796046
75%-tile:	13398   13425   292     0	4	1194069
97.5%-tile:     13404   13425   293     0	6	1552289
Maximum:        13425   13425   302     0	21	1592091
Mean:   6350    11064   98	0	3
# of Seqs:	1592091

It took 529 secs to summarize 1592091 sequences.

[WARNING]: 1124043 of your sequences generated alignments that eliminated too many bases, a list is provided in HoloInt.trim.contigs.good.unique.flip.accnos.

[NOTE]: 930937 of your sequences were reversed to produce a better alignment.
```

### align2.sh script with HoloInt2 prefix

Same as above but with:

```
#SBATCH --error="script_error_align2" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_align2" #once your job is completed, any final job report comments will be put in this file

mothur "#align.seqs(fasta=HoloInt2.trim.contigs.good.unique.fasta, reference=silva.v4.fasta)"

mothur "#summary.seqs(fasta=HoloInt2.trim.contigs.good.unique.align)"
```

From `output_script_align2`:

```
#### Insert output here
```

### QC sequences that were aligned to the reference file we created.

#### screen2.sh script with HoloInt prefix

The sequences are aligned at the correct positions to the reference but now we need to remove those that are outside the reference window. This removes all sequences that start after the `start` and those that end before the `end`. This also takes out any sequences that have repeats greater than 8 (i.e. 8 A's in a row) because we are confident those are not real.

Make a script to do the above commands.

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s/Mothur/scripts
$ nano screen2-HolotInt.sh
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
#SBATCH --error="script_error_screen2-HoloInt" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_screen2-HoloInt" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#screen.seqs(fasta=HoloInt.trim.contigs.good.unique.align, count=HoloInt.trim.contigs.good.count_table, start=1968, end=11550, maxhomop=8)"

mothur "#summary.seqs(fasta=HoloInt.trim.contigs.good.unique.good.align, count=HoloInt.trim.contigs.good.good.count_table)"

mothur "#count.groups(count=HoloInt.trim.contigs.good.good.count_table)"
```

From `output_script_screen2-HoloInt`:

```
mothur > summary.seqs(fasta=HoloInt.trim.contigs.good.unique.good.align, count=HoloInt.trim.contigs.good.good.count_table)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1	11550   271     0	3	1
2.5%-tile:	1	13424   292     0	4	19038
25%-tile:	1	13424   292     0	4	190374
Median:         1	13424   292     0	4	380748
75%-tile:	1	13424   292     0	5	571122
97.5%-tile:     1       13425   293     0	6	742458
Maximum:        1965    13425   302     0	8	761495
Mean:   1       13424   292     0	4
# of unique seqs:       467358
total # of seqs:        761495

It took 165 secs to summarize 761495 sequences.

Output File Names:
HoloInt.trim.contigs.good.unique.good.summary
```


#### screen2-HolotInt2.sh script with HoloInt2 prefix

same as above but with:

```
#SBATCH --error="script_error_screen2-HolotInt2" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_screen2-HolotInt2" #once your job is completed, any final job report comments will be put in this file

mothur "#screen.seqs(fasta=HoloInt2.trim.contigs.good.unique.align, count=HoloInt2.trim.contigs.good.count_table, start=1968, end=11550, maxhomop=8)"

mothur "#summary.seqs(fasta=HoloInt2.trim.contigs.good.unique.good.align, count=HoloInt2.trim.contigs.good.good.count_table)"

mothur "#count.groups(count=HoloInt2.trim.contigs.good.good.count_table)"
```

From `output_script_screen2-HolotInt2`:

```
#### Insert output here
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
#SBATCH --error="script_error_filter" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_filter" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#filter.seqs(fasta=HoloInt.trim.contigs.good.unique.good.align, vertical=T, trump=.)"

mothur "#summary.seqs(fasta=HoloInt.trim.contigs.good.unique.good.filter.fasta, count=HoloInt.trim.contigs.good.good.count_table)"

mothur "#count.groups(count= HoloInt.trim.contigs.good.good.count_table)"
```

Output from the `output_script_filter` file:

```
mothur > summary.seqs(fasta=HoloInt.trim.contigs.good.unique.good.filter.fasta, count=HoloInt.trim.contigs.good.good.count_table)

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1	522     234     0	3	1
2.5%-tile:      1       523     255     0	4	19038
25%-tile:	1	523     255     0	4	190374
Median:         1 	523     255     0	4	380748
75%-tile:	1	523     255     0	5	571122
97.5%-tile:     1       523     256     0	6	742458
Maximum:        4	523     271     0	8	761495
Mean:   1       522     255     0	4
# of unique seqs:       467358
total # of seqs:        761495

It took 40 secs to summarize 761495 sequences.

Output File Names:
HoloInt.trim.contigs.good.unique.good.filter.summary

Length of filtered alignment: 523
Number of columns removed: 12902
Length of the original alignment: 13425
Number of sequences used to construct filter: 467358

Output File Names:
HoloInt.filter
HoloInt.trim.contigs.good.unique.good.filter.fasta
```

**Filter.sh with HoloInt2 prefix**

Exact same as above but with the following changes:

```
#SBATCH --error="script_error_filter2" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_filter2" #once your job is completed, any final job report comments will be put in this file

mothur "#filter.seqs(fasta=HoloInt2.trim.contigs.good.unique.good.align, vertical=T, trump=.)"

mothur "#summary.seqs(fasta=HoloInt2.trim.contigs.good.unique.good.filter.fasta, count=HoloInt2.trim.contigs.good.good.count_table)"

mothur "#count.groups(count= HoloInt2.trim.contigs.good.good.count_table)"
```

Output from the `output_script_filter2` file:

```

```

## <a name="Pre-clustering"></a> **Pre clustering**

#### script with HoloInt prefix

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
#SBATCH --error="script_error_precluster" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_precluster" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#unique.seqs(fasta=HoloInt.trim.contigs.good.unique.good.filter.fasta, count=HoloInt.trim.contigs.good.good.count_table)"

mothur "#pre.cluster(fasta=HoloInt.trim.contigs.good.unique.good.filter.unique.fasta, count=HoloInt.trim.contigs.good.unique.good.filter.count_table, diffs=1)"

mothur "#summary.seqs(fasta=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.fasta, count=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.count_table)"

mothur "#count.groups(count=current)"
```

Ouput from the `output_script_precluster` file:

Count=current doesn't exist - come back to changing input.

```
mothur > summary.seqs(fasta=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.fasta, count=HoloInt.trim.contigs.good.unique.good.filter.unique.precl$

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1	522     234     0	3	1
2.5%-tile:      1       523     255     0	4	19038
25%-tile:	1	523     255     0	4	190374
Median:         1       523     255     0	4	380748
75%-tile:       1       523     255     0	5	571122
97.5%-tile:     1	523     256     0	6	742458
Maximum:        4       523     271     0	8	761495
Mean:   1       522     255     0       4
# of unique seqs:	27053
total # of seqs:        761495

It took 3 secs to summarize 761495 sequences.

Output File Names:
HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.summary
```

#### script with HoloInt2 prefix

Exact same as above but with the following changes:

```
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
Using vsearch version v2.18.0.

Removed 2644 sequences from your fasta file.

mothur > summary.seqs(fasta=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.fasta, count=HoloInt.trim.contigs.good.unique.good.filter.unique.$

Using 24 processors.

                Start   End     NBases  Ambigs  Polymer NumSeqs
Minimum:        1	522     234     0	3	1
2.5%-tile:      1       523     255     0	4	18938
25%-tile:	1	523     255     0	4	189371
Median:         1       523     255     0	4	378742
75%-tile:       1       523     255     0	5	568112
97.5%-tile:     1	523     256     0	6	738545
Maximum:        4       523     271     0	8	757482
Mean:   1       522     255     0       4
# of unique seqs:	24409
total # of seqs:        757482

It took 3 secs to summarize 757482 sequences.

Output File Names:
HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.summary


Size of smallest group: 25.

Total seqs: 757482.
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

M00763_59_000000000-JR652_1_2109_12262_19717	Bacteria(99);"Bacteroidetes"(99);Flavobacteria(99);"Flavobacteriales"(99);Flavobacteriaceae(97);Flavobacteriaceae_unclassified(97);
M00763_59_000000000-JR652_1_1101_20579_10161	Bacteria(100);Cyanobacteria_Chloroplast(100);Chloroplast(100);Chloroplast_order_incertae_sedis(100);Chloroplast(100);Bacillariophyta(100);
M00763_59_000000000-JR652_1_1102_11832_8675	Bacteria(100);Cyanobacteria_Chloroplast(100);Chloroplast(100);Chloroplast_order_incertae_sedis(100);Chloroplast(100);Bacillariophyta(100);
M00763_59_000000000-JR652_1_2111_19314_21078	Bacteria(100);"Bacteroidetes"(98);Flavobacteria(97);"Flavobacteriales"(97);Flavobacteriaceae(95);Flavobacteriaceae_unclassified(95);
M00763_59_000000000-JR652_1_2109_5504_17162	Bacteria(100);Cyanobacteria_Chloroplast(100);Chloroplast(100);Chloroplast_order_incertae_sedis(100);Chloroplast(100);Bacillariophyta(100);
M00763_59_000000000-JR652_1_2109_7708_9096	Bacteria(100);Cyanobacteria_Chloroplast(82);Cyanobacteria_Chloroplast_unclassified(82);Cyanobacteria_Chloroplast_unclassified(82);Cyanobacteria_Chloroplast_unclassified(82);Cyanobacteria_Chloroplast_unclassified(82);
M00763_59_000000000-JR652_1_1116_2813_17174	Bacteria(100);"Proteobacteria"(100);Gammaproteobacteria(100);Oceanospirillales(100);Hahellaceae(100);Endozoicomonas(100);
M00763_59_000000000-JR652_1_1102_18212_20368	Bacteria(99);Bacteria_unclassified(99);Bacteria_unclassified(99);Bacteria_unclassified(99);Bacteria_unclassified(99);Bacteria_unclassified(99);
M00763_59_000000000-JR652_1_1114_3699_15219	Bacteria(100);"Proteobacteria"(100);Gammaproteobacteria(100);Oceanospirillales(100);Hahellaceae(100);Endozoicomonas(100);
M00763_59_000000000-JR652_1_1105_14263_3063	Bacteria(100);Cyanobacteria_Chloroplast(100);Cyanobacteria(100);Cyanobacteria_order_incertae_sedis(100);Family_XIII(100);GpXIII(100);
```

- The tax.summary file has the taxonimc level, the name of the taxonomic group, and the number of sequences in that group for each sample.

```
$ head HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.tax.summary

taxlevel	rankID	taxon	daughterlevels	total	HPW060	HPW061	HPW062	HPW063	HPW064	HPW065	HPW066	HPW067	HPW068	HPW069	HPW070	HPW07HPW072	HPW073	HPW074	HPW075	HPW076	HPW077	HPW078	HPW079	HPW080	HPW081	HPW082	HPW083	HPW084	HPW085	HPW086	HPW087	HPW088	HPW089	HPW09HPW091	HPW092	HPW093	HPW094	HPW095	HPW096	HPW101	HPW102	HPW103	HPW104	HPW105	HPW106	HPW107	HPW108	HPW109	HPW110	HPW111	HPW112	HPW11HPW114	HPW115	HPW116	HPW117	HPW118	HPW119	HPW120	HPW121	HPW122	HPW123	HPW124	HPW125	HPW126	HPW127	HPW128	HPW129	HPW130	HPW131	HPW13HPW133	HPW134	HPW135	HPW136	HPW137	HPW138	HPW139	HPW140	HPW141	HPW142	HPW143	HPW144	HPW145	HPW146	HPW147	HPW148	HPW149	HPW150	HPW15HPW152	HPW153	HPW154	HPW155	HPW156	HPW157	HPW158	HPW159	HPW160	HPW161	HPW162	HPW163	HPW164	HPW165	HPW166	HPW167	HPW168	HPW169	HPW17HPW171	HPW172	HPW173	HPW174	HPW175	HPW176	HPW177	HPW178	HPW179	HPW180	HPW181	HPW182	HPW183	HPW184	HPW185	HPW186	HPW187	HPW188	HPW18HPW190	HPW191	HPW192	HPW193	HPW194	HPW195	HPW196	HPW201	HPW202	HPW203	HPW204	HPW205	HPW206	HPW207	HPW208	HPW209	HPW210	HPW211	HPW21HPW213	HPW214	HPW215	HPW216	HPW217	HPW218	HPW219	HPW220	HPW221	HPW222	HPW223	HPW224	HPW225	HPW226	HPW227	HPW228	HPW229	HPW230	HPW23HPW232	HPW233	HPW234	HPW235	HPW236	HPW237	HPW238	HPW239	HPW240	HPW241	HPW242	HPW243	HPW244	HPW245	HPW246	HPW247	HPW248	HPW249	HPW25HPW251	HPW252	HPW253	HPW254	HPW255	HPW256	HPW257	HPW258	HPW259	HPW260	HPW261	HPW262	HPW263	HPW264	HPW265	HPW266	HPW267	HPW268	HPW26HPW270	HPW271	HPW272	HPW273	HPW274	HPW275	HPW276	HPW277	HPW278	HPW279	HPW280	HPW281	HPW282	HPW283	HPW284	HPW285	HPW286	HPW287	HPW28HPW289	HPW290	HPW291	HPW292	HPW293	HPW294	HPW295	HPW296	HPW301	HPW302	HPW303	HPW304	HPW305	HPW306	HPW307	HPW308	HPW309	HPW310	HPW31HPW312	HPW313	HPW314	HPW315	HPW316	HPW317	HPW318	HPW319	HPW320	HPW321	HPW322
0	0	Root	3	757482	706	14396	2985	7008	24437	8907	1435	15208	8925	6246	1246	1269	454	425	959	2979	33962	412	564	276	150	11735	4474	1431	612	110	1655	845	1333	2490	938	693	5403	202	314	138	366	1173	5465	505	425	1447	218	2361	904	687	5970	6296	4315	408	539	345	631	999	840	1034	5224	373	437	1362	311	8189	676	427	374	3266	15166	2626	1698	574	1722	2750	2268	2134	384	371	18815	1605	1587	17740	569	596	2198	1641	6697	24211	4156	159	1645	997	6643	1441	5528	617	3091	482	2301	767	1474	4929	12742	20209	2558	527	8260	133	3590	460	5006	1739	4010	830	778	1340	474	2957	475	747	355	805	2979	1380	346	3406	697	12937	879	773	769	1477	92	1994	745	450	1366	1894	308	965	319	1811	6542	1858	214	688	8592	8354	774	1168	1076	3721	888	247	185	3100	253	3185	8100	795	853	279	758	977	12238	1204	957	3010	1110	1597	603	2568	2026	408	8672	1616	696	244	514	1512	2891	1080	766	1016	229	2095	575	446	4383	1278	1057	5933	747	820	1052	864	2961	396	1120	1080	592	1678	788	937	25	2851	1449	687	3112	15649	1034	9509	683	2038	1270	2393	1280	2752	3453	1065	2953	1362	1788	596	750	27294	272	781	9425	1474	956	1990	927	223	596	531	493	189	26229	1008	7651	1351	181	6356	1030	1318	1429	866	2079	429	6980	7553	753
1	0.1	Archaea	2	145	0	0	0	0	0	0	0	0	0	0	0	0	2	0	20	0	3	0	0	0	7	0	0	0	0	0	0	0	1	0	1	0	0	11	0	1	1	3	0	0	0	0	0	0	0	0	0	0	0	0	6	0	22	0	0	0	0	0	0	0	0	0	2	0	0	0	0	0	0	0	0	0
2	0.1.1	"Euryarchaeota"	4	95	0	0	0	0	0	0	0	0	0	0	0	0	2	20	0	3	0	0	0	0	0	0	0	0	0	0	0	1	0	1	0	0	11	0	1	1	3	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
3	0.1.1.1	"Euryarchaeota"_unclassified	1	57	0	0	0	0	0	0	0	0	0	0	0	11	0	0	1	3	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
4	0.1.1.1.1	"Euryarchaeota"_unclassified	1	57	0	0	0	0	0	0	0	0	0	0	11	0	0	1	3	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
5	0.1.1.1.1.1	"Euryarchaeota"_unclassified	1	57	0	0	0	0	0	0	0	0	0	0	11	0	0	1	3	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
6	0.1.1.1.1.1.1	"Euryarchaeota"_unclassified	0	57	0	0	0	0	0	0	0	0	0	0	11	0	0	1	3	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
3	0.1.1.2	"Methanomicrobia"	1	19	0	0	0	0	0	0	0	0	0	0	0	0	19	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
4	0.1.1.2.1	Methanosarcinales	1	19	0	0	0	0	0	0	0	0	0	0	0	19	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0
```

From `output_script_classify` file:

```
[WARNING]: Are you run the remove.seqs command after running a chimera command with dereplicate=t? If so, the count file has already been modified to remove all chimeras and adjust group counts. Including the count file here will cause downstream file mismatches.

Removed 3305 sequences from your fasta file.
Removed 126080 sequences from your count file.

Output File Names:
HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta
HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table
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
#SBATCH --error="script_error_cluster" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_cluster" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#dist.seqs(fasta=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta)"

mothur "#cluster(column=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.dist, count=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table, cutoff=0.03)"

mothur "#cluster.split(fasta=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.fasta, count=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table, taxonomy=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.pick.taxonomy, taxlevel=4, cutoff=0.03, splitmethod=classify)"

mothur "#make.shared(list=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.list, count=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table)"

mothur "#classify.otu(list=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.list, count=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.denovo.vsearch.pick.pick.count_table, taxonomy=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.pick.taxonomy)"

mothur "#rename.file(taxonomy=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.0.03.cons.taxonomy, shared=HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.shared)"

mothur "#count.groups(shared=HoloInt.opti_mcc.shared)"
```

From the `output_script_cluster`:

```

```

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
