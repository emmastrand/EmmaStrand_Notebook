---
layout: post
title: Point Judith Oyster Gut 16S V4V5 Analysis
date: '2022-03-02'
categories: Processing
tags: oyster, 16S, QIIME2
projects: Point Judith Oyster Nutrition
---

# Point Judith Oyster Gut 16S V4V5 QIIME2 Analysis

*Insert project information.*

Primer information from `/data/putnamlab/estrand/PointJudithData_16S/metadata/primers_v4v5.txt`:

```
Quince et al. 2011

518F: 5’ TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGCCAGCAGCYGCGGTAAN
926R: 5’ GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGCCGTCAATTCNTTTRAGT
	5’ GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGCCGTCAATTTCTTTGAGT
	5’ GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGCCGTCTATTCCTTTGANT

R mixed at 8:1:1
```

```
v4v5:
518F: CCAGCAGCYGCGGTAAN
926R: CCGTCAATTCNTTTRAGT
	CCGTCAATTTCTTTGAGT
	CCGTCTATTCCTTTGANT

Nextera partial tails:
Forward overhang: 5’ TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG‐[locus‐ specific sequence]
Reverse overhang: 5’ GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG‐[locus‐ specific sequence]

v4v5 with Nextera partial tails:
Forward overhang: 5’ TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGCCAGCAGCYGCGGTAAN
Reverse overhang: 5’ GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGCCGTCAATTCNTTTRAGT
			  5’ GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGCCGTCAATTTCTTTGAGT
  5’ GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGCCGTCTATTCCTTTGANT
```


Beginners to 16S: see my [16S Central Working Document](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-02-22-16S-Analysis-Central-Working-Document.md) for other QIIME2 pipelines with more detailed descriptions on each command (Holobiont Integration QIIME2 pipeline will be most helpful for beginners).

Sequenced at URI's GSC. Information found [here](https://web.uri.edu/gsc/).

Project path: /data/putnamlab/shared/PointJudithData_Rebecca/amplicons16s/gut_v4v5.

Contents:  
- [**Setting Up Andromeda**](#Setting_up)  
- [**FastQC**](#FastQC)  
- [**QIIME2 Metadata**](#Metadata)  
- [**QIIME2 Sample data import**](#Import)  
- [**QIIME2 Denoising with DADA2**](#Denoise)  


## <a name="Setting_up"></a> **Setting Up Andromeda**

Creating directories for this project.

```
(base) [emma_strand@ssh3]/data/putnamlab/estrand% mkdir PointJudithData_16S
$ cd PointJudithData_16S
$ mkdir scripts
$ mkdir fastqc_results
$ mkdir metadata
```

Secure copy paste the raw files from shared directory to mine.

```
$ scp -r /data/putnamlab/shared/PointJudithData_Rebecca/amplicons16s/gut_v4v5 /data/putnamlab/estrand/PointJudithData_16S
```

Moved the 3 metadata files from gut_v4v5 folder to my metadata folder.

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
#SBATCH -D /data/putnamlab/estrand/PointJudithData_16S                  
#SBATCH --error="script_error_fastqc" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_fastqc" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

cd /data/putnamlab/estrand/PointJudithData_16S

module load FastQC/0.11.9-Java-11
module load MultiQC/1.9-intel-2020a-Python-3.8.2

for file in /data/putnamlab/estrand/PointJudithData_16S/gut_v4v5/00_RAW_gz/*fastq.gz
do
fastqc $file --outdir /data/putnamlab/estrand/PointJudithData_16S/fastqc_results         
done

multiqc --interactive fastqc_results  
```

`less output_script_fastqc`:

```
## for each sample
Analysis complete for RS10_S7_L001_R1_001.fastq.gz
```

`less script_error_fastqc`:

```
[WARNING]         multiqc : MultiQC Version v1.12 now available!
[INFO   ]         multiqc : This is MultiQC v1.9
[INFO   ]         multiqc : Template    : default
[INFO   ]         multiqc : Searching   : /glfs/brick01/gv0/putnamlab/estrand/PointJudithData_16S/fastqc_results
[INFO   ]          fastqc : Found 74 reports
[INFO   ]         multiqc : Compressing plot data
[INFO   ]         multiqc : Report      : multiqc_report.html
[INFO   ]         multiqc : Data        : multiqc_data
[INFO   ]         multiqc : MultiQC complete
```

### multiqc results

copy this report outside of andromeda.

```
scp emma_strand@bluewaves.uri.edu:/data/putnamlab/estrand/PointJudithData_16S/multiqc_report.html /Users/emmastrand/MyProjects/Cvir_Nut_Int/output/16S_gutv4v5/QIIME2
```

#### Red = R1 (forward); Blue = R2 (reverse)

**Sequence Counts**

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/16S_gutv4v5/QIIME2/Seq-counts.png?raw=true)

There is one sample that doesn't appear to have any reads..

**Sequence Quality Histogram**

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/16S_gutv4v5/QIIME2/seq-quality-split.png?raw=true)

Based on this figure I'll try cut-offs of 240 for forward and 230 and 210 for the reverse.

**Per Sequence Quality Score**

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/16S_gutv4v5/QIIME2/per-seq-quality.png?raw=true)

**Per Sequence GC Content**

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/16S_gutv4v5/QIIME2/per-seq-GC.png?raw=true)

**Per Base N Content**

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/16S_gutv4v5/QIIME2/per%20base%20n%20content.png?raw=true)

**Sequence Length Distribution**

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/16S_gutv4v5/QIIME2/seq-length-dist.png?raw=true)

**Sequence Duplication Levels**

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/16S_gutv4v5/QIIME2/seq-duplication-levels.png?raw=true)

**Adapter Content:** "No samples found with any adapter contamination > 0.1%""


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

`/data/putnamlab/estrand/PointJudithData_16S/metadata/sample-manifest.csv` looks like:

```
sample-id,absolute-filepath,direction
RS1_S1,$PWD/00_RAW_gz/RS1_S1_L001_R1_001.fastq.gz,forward
RS2_S6,$PWD/00_RAW_gz/RS2_S6_L001_R1_001.fastq.gz,forward
RS3_S11,$PWD/00_RAW_gz/RS3_S11_L001_R1_001.fastq.gz,forward
RS4_S16,$PWD/00_RAW_gz/RS4_S16_L001_R1_001.fastq.gz,forward
RS5_S22,$PWD/00_RAW_gz/RS5_S22_L001_R1_001.fastq.gz,forward
RS6_S28,$PWD/00_RAW_gz/RS6_S28_L001_R1_001.fastq.gz,forward
RS7_S33,$PWD/00_RAW_gz/RS7_S33_L001_R1_001.fastq.gz,forward
RS8_S38,$PWD/00_RAW_gz/RS8_S38_L001_R1_001.fastq.gz,forward
RS9_S2,$PWD/00_RAW_gz/RS9_S2_L001_R1_001.fastq.gz,forward
```

`$PWD` = Path working directory which will be `PWD="/data/putnamlab/estrand/PointJudithData_16S/gut_v4v5` for us.

2. Sample metadata file

`/data/putnamlab/estrand/PointJudithData_16S/metadata/PJ_GutSamples_Metadata.txt` looks like:

```
#SampleID	SampleName	StationName	Treatment	StationTreatGroup	BucketNumber	OysterNumber	SampleType
#q2:types	categorical	categorical	categorical	categorical	categorical	categorical	categorical
RS1_S1	BHC.1.1	BHC	Control	BHCControl	1	1	gut
RS2_S6	BHC.1.2	BHC	Control	BHCControl	1	2	gut
RS3_S11	BHC.1.3	BHC	Control	BHCControl	1	3	gut
RS4_S16	BHC.2.1	BHC	Control	BHCControl	2	1	gut
RS5_S22	BHC.2.2	BHC	Control	BHCControl	2	2	gut
RS6_S28	BHC.2.4	BHC	Control	BHCControl	2	4	gut
RS7_S33	BHC.3.1	BHC	Control	BHCControl	3	1	gut
RS8_S38	BHC.3.2	BHC	Control	BHCControl	3	2	gut
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
#SBATCH -D /data/putnamlab/estrand/PointJudithData_16S
#SBATCH --error="script_error_import" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_import" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function
module load QIIME2/2021.4

#### METADATA FILES ####
# Path working directory to the raw files (referenced in the metadata)
# metadata says: $PWD/00_RAW_gz/RS1_S1_L001_R1_001.fastq.gz so this needs to lead the command to this path
PWD="/data/putnamlab/estrand/PointJudithData_16S/gut_v4v5"

# Metadata path
METADATA="metadata/PJ_GutSamples_Metadata.txt"

# Sample manifest path
MANIFEST="metadata/sample-manifest.csv"

#########################

qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path $MANIFEST \
  --input-format PairedEndFastqManifestPhred33 \
  --output-path PJ-paired-end-sequences.qza
```

Output from `output_script_import`:

```
$ less output_script_import

Imported metadata/sample-manifest.csv as PairedEndFastqManifestPhred33 to PJ-paired-end-sequences.qza
```

Output from `script_error_import`:

```
$ less script_error_import

#nothing in file means no errors
```

`PJ-paired-end-sequences.qza` is the output file that we will input in the next denoising step.

## <a name="Denoise"></a> **Denoising with DADA2 and Clustering**

*Confirm these parameters are correct: primer length.*

Description from QIIME2 documentation:  
- We *denoise* our sequences to remove and/or correct noisy reads.  
- To put it simply, these methods filter out noisy sequences, correct errors in marginal sequences (in the case of DADA2), remove chimeric sequences, remove singletons, join denoised paired-end reads (in the case of DADA2), and then dereplicate those sequences.  

Full DADA2 options from qiime2 on this page: [here](https://docs.qiime2.org/2021.4/plugins/available/dada2/denoise-paired/)

`p-n-threads` choice: 20 because this will give us multi-thread processing capability to speed up the qiime2 pipeline but won't take all available threads on the putnam lab node.   

I tried the following denoise parameters:
- With 52/50 primer length; F: 240 R: 230 (`denoise-230.sh`)  
- With 52/50 primer length; F: 240 R: 210 (`denoise-210.sh`)  
- Without 52/50 primer length; no truncating (`denoise-no.sh`)  
- Without 52/50 primer length; F: 240 R: 210 (`denoise-no-210.sh`)  
- With 20/20 bp trimming; F: 220 R: 210 (`denoise-220-210.sh`)  
- With 20/20 bp trimming; F: 240 R: 210 (`denoise-240-210.sh`)  

#### denoise paramter trials

Output from these trials in this directory: `PointJudithData_16S/denoise_trials`.

All parameter trials will have:  
- `#SBATCH -D /data/putnamlab/estrand/PointJudithData_16S/denoise_trials`  
- `#SBATCH --error="script_error_denoise"` with script name  
- `#SBATCH --output="output_script_denoise"` with script name   
- Change paths for: `../PJ-paired-end-sequences.qza`, `../metadata`  
- `#SBATCH --job-name="240-denoise"`

#### no trimming step because we don't have primers?

Originally I had `--p-trim-left-r 52 --p-trim-left-f 50 \`: 50 bp forward primer and 52 for reverse, but when I use the command `grep -c "TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGCCAGCAGCYGCGGTAAN" RS10_S7_L001_R1_001.fastq` the result is 0. Same thing when I use the reverse primer sequence.

### with primer sequence

I want to try the following cut-offs based on the seq quality histogram:  
- F: 240 R: 230  
- F: 240 R: 210

`denoise-230.sh` will look indentical to `denoise.sh` except:  
-  `--p-trunc-len-r 230 --p-trunc-len-f 240 \`  

`denoise-210.sh` will look indentical to `denoise.sh` except:  
-  `--p-trunc-len-r 210 --p-trunc-len-f 240 \`

With full primer trimming:  
`--p-trim-left-r 52 --p-trim-left-f 50 \`

### without primer sequence

I want to try the following cut-offs based on the seq quality histogram:  
- F: 250 R: 210  
- F: 250 R: 250 (no trimming the sequences)

Took out `--p-trim-left-r 52 --p-trim-left-f 50 \`

`denoise-no210.sh` will look indentical to `denoise.sh` except:  
-  `--p-trunc-len-r 210 --p-trunc-len-f 250 \`  

`denoise-210.sh` will look indentical to `denoise.sh` except:  
-  `--p-trunc-len-r 210 --p-trunc-len-f 240 \`

### with primer trimming of only 20 to cut off decreased quality at the beginning

I want to try the following cut-offs based on the results from above and seq quality histogram:  
- With 20/20 bp trimming; F: 220 R: 210 (`denoise-220-210.sh`)  
- With 20/20 bp trimming; F: 240 R: 210 (`denoise-240-210.sh`)

`denoise-no210.sh` will look indentical to `denoise.sh` except:  
-  `--p-trunc-len-r 210 --p-trunc-len-f 220 \`  

`denoise-210.sh` will look indentical to `denoise.sh` except:  
-  `--p-trunc-len-r 210 --p-trunc-len-f 240 \`

With minimal trimming at the front end of reads:  
`--p-trim-left-r 20 --p-trim-left-f 20 \`


copy denoise output to desktop.  

```
scp emma_strand@bluewaves.uri.edu:/data/putnamlab/estrand/PointJudithData_16S/denoise_trials/table-240-210.qzv /Users/emmastrand/MyProjects/Cvir_Nut_Int/output/16S_gutv4v5/QIIME2/

denoising-stats-220-210.qzv
denoising-stats-240-210.qzv
denoising-stats-no210.qzv
denoising-stats-210.qzv
denoising-stats-230.qzv
denoising-stats-no.qzv
table-230.qzv
table-210.qzv
table-no210.qzv
table-no.qzv
table-220-210.qzv
table-240-210.qzv
```

Put the above files into QIIME2 view and download as tsv files.

Output from R script to visualize the above denoising statistics. R script: `denoise-stats.R` is in our Cvir repo.

**Results from the trials above:**

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/16S_gutv4v5/QIIME2/denoise.percent.plot.png?raw=true)

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/16S_gutv4v5/QIIME2/denoise.reads.plot.png?raw=true)

|                                                      	| Metric            	|                    	|                 	| Frequency         	|              	|                  	|              	|                   	|                	|
|------------------------------------------------------	|-------------------	|--------------------	|-----------------	|-------------------	|--------------	|------------------	|--------------	|-------------------	|----------------	|
| Denoise parameter                                    	| Number of samples 	| Number of features 	| Total frequency 	| Minimum frequency 	| 1st quartile 	| Median frequency 	| 3rd quartile 	| Maximum frequency 	| Mean frequency 	|
| Reverse 250 Forward 250 no primer trimming           	| 37                	| 177                	| 32,074          	| 39                	| 271          	| 659              	| 915          	| 4,405             	| 886.86         	|
| Reverse 210 Forward 250 no primer trimming           	| 37                	| 283                	| 46,111          	| 42                	| 500          	| 794              	| 1,608        	| 6,507             	| 1,246.24       	|
| Reverse 210 Forward 240; primer trim 20 both F/R     	| 37                	| 291                	| 63,040          	| 59                	| 695          	| 1,292.00         	| 2,190.00     	| 8,574.00          	| 1,703.78       	|
| Reverse 230 Forward 240 50/52 bp trim                	| 37                	| 272                	| 63,868          	| 59                	| 706          	| 1,325            	| 2,242        	| 8,385             	| 1,726.16       	|
| Reverse 210 Forward 240 50/52 bp trim                	| 37                	| 320                	| 73,433          	| 60                	| 819          	| 1,358            	| 2,417        	| 9,380             	| 1,984          	|
| **Reverse 210 Forward 220; primer trim 20 both F/R** 	| **37**            	| **329**            	| **89,490**      	| **87**            	| **928**      	| **1,751**        	| **2,674**    	| **11,719**        	| **2,418.65**   	|

#### Reverse 230 Forward 240  

Sample frequency

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/16S_gutv4v5/QIIME2/F240-R230-denoise-histogram.png?raw=true)

CSV of the above data: /Users/emmastrand/MyProjects/Cvir_Nut_Int/output/16S_gutv4v5/QIIME2/sample-frequency-detail-230.csv

#### Reverse 210 Forward 240

Sample frequency

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/16S_gutv4v5/QIIME2/F240-R210-denoise-histogram.png?raw=true)

CSV of the above data: /Users/emmastrand/MyProjects/Cvir_Nut_Int/output/16S_gutv4v5/QIIME2/sample-frequency-detail-210.csv

#### Reverse 210 Forward 250 no primer trimming

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/16S_gutv4v5/QIIME2/F250-R210-no-postdenoise-histogram.png?raw=true)

#### Reverse 250 Forward 250 no primer trimming

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/16S_gutv4v5/QIIME2/F250-R250-no-postdenoise-histogram.png?raw=true)

#### Reverse 210 Forward 220; primer trim 20 both F/R

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/16S_gutv4v5/QIIME2/F-220-R-210-20bp-trim-histogram.png?raw=true)

#### Reverse 210 Forward 240; primer trim 20 both F/R

![](https://github.com/hputnam/Cvir_Nut_Int/blob/master/output/16S_gutv4v5/QIIME2/F-240-R-210-20bp-trim-histogram.png?raw=true)


### denoise.sh

```
#!/bin/bash
#SBATCH --job-name="240-denoise"
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab
#SBTACH -q putnamlab
#SBATCH -D /data/putnamlab/estrand/PointJudithData_16S/denoise_trials
#SBATCH --error="script_error_denoise-240-210" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_denoise-240-210" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function
module load QIIME2/2021.4

#### METADATA FILES ####
# Path working directory to the raw files (referenced in the metadata)
# metadata says: $PWD/00_RAW_gz/RS1_S1_L001_R1_001.fastq.gz so this needs to lead the command to this path
PWD="/data/putnamlab/estrand/PointJudithData_16S/gut_v4v5"

# Metadata path
METADATA="../metadata/PJ_GutSamples_Metadata.txt"

# Sample manifest path
MANIFEST="../metadata/sample-manifest.csv"

#########################

#### DENOISING WITH DADA2

qiime dada2 denoise-paired --verbose --i-demultiplexed-seqs ../PJ-paired-end-sequences.qza \
  --p-trunc-len-r 210 --p-trunc-len-f 240 \
  --p-trim-left-r 20 --p-trim-left-f 20 \
  --o-table table-240-210.qza \
  --o-representative-sequences rep-seqs-240-210.qza \
  --o-denoising-stats denoising-stats-240-210.qza \
  --p-n-threads 20

#### CLUSTERING

# Summarize feature table and sequences
qiime metadata tabulate \
  --m-input-file denoising-stats-240-210.qza \
  --o-visualization denoising-stats-240-210.qzv
qiime feature-table summarize \
  --i-table table-240-210.qza \
  --o-visualization table-240-210.qzv \
  --m-sample-metadata-file $METADATA
qiime feature-table tabulate-seqs \
  --i-data rep-seqs-240-210.qza \
  --o-visualization rep-seqs-240-210.qzv
```

#### Processing stopped here to switch to gut V6 samples for Northern region
