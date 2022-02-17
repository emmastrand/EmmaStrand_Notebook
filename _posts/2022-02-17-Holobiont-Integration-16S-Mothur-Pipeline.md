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

## <a name="Contigs"></a> **Make Contigs**

### contigs.sh script with default trimoverlap=false

Script to make contigs.

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
Minimum:        1	22	22	0	2	1
2.5%-tile:	1	215     215     0	4	125048
25%-tile:	1	215     215     0	11	1250474
Median:         1	301     301     0	11	2500948
75%-tile:	1	301     301     0	11	3751421
97.5%-tile:     1	388     388     6	16	4876847
Maximum:        1	563     563     97	280     5001894
Mean:   1	287     287     0	10
# of Seqs:	5001894

It took 187 secs to summarize 5001894 sequences.

Output File Names:
HoloInt.trim.contigs.summary


mothur > quit()


It took 187 seconds to run 2 commands from your script.

Logfile : mothur.1645126847.logfile
```

Warning generated: `[WARNING]: your oligos file does not contain any group names.  mothur will not create a groupfile.`.


#### Check that the primers are gone.

`$ head HoloInt.trim.contigs.fasta`

We are looking to see that these primers `F GTGCCAGCMGCCGCGGTAA R GGACTACNVGGGTWTCTAAT` have been taken out.

Output:

```
>M00763_59_000000000-JR652_1_1101_20554_1826	ee=5.62825	fbdiffs=0(match), rbdiffs=0(match) fpdiffs=0(match), rpdiffs=0(match)
TTCCAGCTCCAATAGCATATATTAAAGTTGTTGCGGTTAAAAAGCTCGTAGTTGGATTTCTGTTGAGGATGACCGGTCCGCCCTCTGGGTGTGCATCTGGCTCAGCCTTGACATCTTCCTGAAGAACGTATCTGCACTTGATTGTGTGGTGCGGTATTTGGGACATTTACCTTGAGGAAATTAGAGTGTTTCAAGCAAGCGCACGCTTTGAATACCGTAGCATGGANTAATAAGATAGGGCCTCAGTTCTATTTTGTTGGTTTCTAGAGCTGAGGTAATGGTTGATAGGGATAGTTGGGGGCATTCGTATTTAACTGGCAGAGGTGAAATTCGTGGATTTGTTAAAGACGGACTACTGCGAAAATATTTGCCAAGGATGTTTTCATTGATCAAGAACGAAAATTAGGGAATCGAAGACG
>M00763_59_000000000-JR652_1_1101_22277_2798	ee=2.34858	fbdiffs=0(match), rbdiffs=0(match) fpdiffs=0(match), rpdiffs=0(match)
AGAGACAGGGGCCAGCAGCCGGGGGAATACGGGGGGTCCAAGCGTTAATCAGAATTACTGGGCGTAAAGGGTCTGTAGGTGGTTTGGTAAGTCAGATGTGAAATCCCAGGGCTCAACCTTGGAATTGCATTTGATACTGTCAAACTAGAGTATAGTAGAGGAATAAGGAATTTCTGGTGTAGCGGTGAAATGCGTAGAGATCAGAAGGAACACCAATGGCGAAGGCAATATTCTAGACTAATACTGACATTGAAAGACGAAAGCGTGGGGATCAAACAGGATTAGATACCCCGGTAGTCCCTGTCACTT
>M00763_59_000000000-JR652_1_1101_10688_1769	ee=16.2035	fbdiffs=0(match), rbdiffs=0(match) fpdiffs=0(match), rpdiffs=0(match)
GTATGTGTAAATGGAAAGAGTAAGGGGAAGACCGAGAGGGAAACTATCAGCTGAGGCGGGAGGGGCAGAGGGGGAGAAAAGACAGGGGAGAGCAGCAGAGGTAAGACTTAAGGATTTATTTTTTAATAAAAAGCAAAAAGCGTGTTAAGGATTTTTTAAAAAAAAAAATAAATAGAATTTTTTTCGTAATTGTAATATGTTAAAATGAAAAAAAGAATTTTTTATATGAAGATAATTTATTTTTTTTTTCTTAAATACGAAGGTTTGGGGAGCAAATAGGATTAGATACCCTAGTTGTCCCTGTCTCTTCTCCTCCTCTCCCCTCCCACTCCACATCTCTGGTCCTCGTATGCCGTCTTCTGCTTGAACAAAAAAACTATTATAC
>M00763_59_000000000-JR652_1_1101_15630_1932	ee=3.83715	fbdiffs=0(match), rbdiffs=0(match) fpdiffs=0(match), rpdiffs=0(match)
ATGAAACAGTTTCCAGCATCCTCGGTAAAACGAGAAGGGTTAGCGTTATTCAGATTAATTTGGCGTAAAGGATGCGTAGGTTGAAAATTAATTAAATAATAAAATTTCAAAATTAACTTTGAATTATTTTTACTAAAAATATTTTCTTGAGTTTAATAGNGGATTGTAGAACTTTAAATGTAACAGTAAAATGTATTGATATTTAAAAGAATTTCTAAAGCGAAGGCAACAATCTAAATTAAGACTGACATTGAGGTATTAAAGCATGGGGAGCAAAGGGGATTAGATACCCGCGTAGGCCATGTCTCTT
>M00763_59_000000000-JR652_1_1101_14973_1797	ee=11.1698	fbdiffs=0(match), rbdiffs=0(match) fpdiffs=0(match), rpdiffs=0(match)
TAGGTGGGTGGGTGAAAGGAGAGGGGGGAAAACGAGTGGTACACGAGACACTGCGTCGGCAGCGTAAGAGGTGGAGAAGAGACAGGGGGAAGCAGCCGCGGTAAGANTTAAGGATTTATTTTTTAATAAAAAGCAAAAAGCGTGTTAAGGATTTTTTAAAAAAAAAAATAAATAGAATTTTTTTCGTAATTGTAATATGTTAAAATGAAAAAAAGAATTTTTTATATGAAGATAATTTATTTTTTTTTTCTTAAATACGAAGGTTTGGGGAGCAAATAGGATTAGATACCCCAGTTGTCC
```

### contigs2.sh script with trimoverlap=true

`contigs2.sh` script made with same settings as contigs.sh file, except the following changes:

`mothur”#make.contigs(inputdir=.,outputdir=.,file=mcap.files,oligos=oligos.oligos,trimoverlap=T)”`  

--output="output_script_contigs2"    
--error="script_error_contigs2"

Trimoverlap=TRUE is used when you have 2x300 bp reads. Reads that are longer than the expected 254 bp. Based on our multiqc report, we have a spike at 290 bp. This setting should more correctly align our contigs.

This output from this version of creating contigs will be changed to `mothur "#summary.seqs(fasta=HoloInt.trim.contigs2.fasta)"`.

From `output_script_contigs2`:

```

```

### trimoverlap decision based on two outputs above



Move forward with `fasta=XX` output file and `XX.sh`.


## <a name="QC_screen"></a> **QC with screen.seqs**

### screen.sh script with trimoverlap=true output

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

mothur "#screen.seqs(inputdir=., outputdir=., fasta=HoloInt.trim.contigs.fasta, group=HoloInt.contigs.groups, maxambig=0, maxlength=350, minlength=250)"

mothur "#summary.seqs(fasta=HoloInt.trim.contigs.good.fasta)"
```

From `output_script_screen`:

```
mothur > summary.seqs(fasta=HoloInt.trim.contigs.good.fasta)

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
# of Seqs:	1886901

It took 70 secs to summarize 1886901 sequences.

Output File Names:
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
#SBATCH --error="script_error_unique" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_unique" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#unique.seqs(fasta=HoloInt.trim.contigs.good.fasta)"

mothur "#count.seqs(name=HoloInt.trim.contigs.good.names, group=HoloInt.contigs.good.groups)"

mothur "#summary.seqs(fasta=HoloInt.trim.contigs.good.unique.fasta, count=HoloInt.trim.contigs.good.count_table)"

mothur "#count.groups(count= HoloInt.trim.contigs.good.unique.fasta)"
```

From `output_script_unique`:

```
#### Insert output here
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

#### Align our sequences to the new reference database we've created

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
#### Insert output here
```

#### QC sequences that were aligned to the reference file we created.

The sequences are aligned at the correct positions to the reference but now we need to remove those that are outside the reference window. This removes all sequences that start after the `start` and those that end before the `end`. This also takes out any sequences that have repeats greater than 8 (i.e. 8 A's in a row) because we are confident those are not real.

Make a script to do the above commands.

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
#SBATCH --error="script_error_screen2" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_screen2" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Mothur/1.46.1-foss-2020b

mothur

mothur "#screen.seqs(fasta=HoloInt.trim.contigs.good.unique.align, count=HoloInt.trim.contigs.good.count_table, start=1968, end=11550, maxhomop=8)"

mothur "#summary.seqs(fasta=HoloInt.trim.contigs.good.unique.good.align, count=HoloInt.trim.contigs.good.good.count_table)"

mothur "#count.groups(count=HoloInt.trim.contigs.good.good.count_table)"
```

From `output_script_screen2`:

```
#### Insert output here
```

#### Filter out those sequences identified in screen2.sh

Make a script that uses filer.seqs function to take out those sequences that did not meet our criteria.

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

```

- The tax.summary file has the taxonimc level, the name of the taxonomic group, and the number of sequences in that group for each sample.

```
$ head HoloInt.trim.contigs.good.unique.good.filter.unique.precluster.pick.pds.wang.tax.summary
```

From `output_script_classify` file:

```
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
