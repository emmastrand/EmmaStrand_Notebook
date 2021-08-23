---
layout: post
title: 16s Analysis Pipeline
date: '2021-06-21'
categories: Bioinformatics
tags: bioinformatics, 16s, coral, dna
projects: HoloInt
---

# 16s Analysis Pipeline

Lab protocol for 16s: [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-02-01-16s-Sequencing-HoloInt.md).  

251 samples with the 515F and 806RB primers (Apprill et al 2015) from *M. capitata* and *P. acuta* samples in the Holobiont Integration project.  

Sequenced at URI's GSC. Information found [here](https://web.uri.edu/gsc/).

Platemap, sample IDs, and manifest sheet found [here](https://docs.google.com/spreadsheets/d/1ePRCiBFAKLnapxBVCbzIo4Qzjxv-7t0zPcrdJDk2Oo8/edit?ts=6064f16c#gid=0). Order name = Putnam_NGS_20210520_16sITS2_Wong_Strand. My samples start HPW060 - HPW322.  

## General workflow

1. Log into Andromeda using VPN if not on campus.    
2. cd to the 16s folder in the putnamlab folder `cd ../../data/putnamlab/estrand/HoloInt_16s`  
3. Start conda environment `conda activate HoloInt_16s`
4. Load all modules `sbatch module-load.sh`  
5. Fastqc on all seqs `sbatch fastqc.sh`  
6. View multiqc report (generated in #5) in internet browser.    
7. Create metadata files.   
8. Decide on parameters for all sections of QIIME2.  
9. Run qiime2.

## Related resources

Fastq vs fasta format  
16s
Shell and linux/unix coding

Resources on creating 'jobs'/scripts:  
- [Putnam Lab Management: submitting jobs](https://github.com/Putnam-Lab/Lab_Management/blob/master/Bioinformatics_%26_Coding/Bluewaves/Submitting_Job.md)

## Bluewaves and Andromeda for URI

Logging into bluewaves and andromeda. Information for creating an account on [Andromeda](https://web.uri.edu/hpc-research-computing/using-andromeda/).

```
# Bluewaves
$ ssh -l username@bluewaves.uri.edu
$ pw: (your own password)

# Andromeda
$ ssh -l emma_strand ssh3.hac.uri.edu
```

## Initial Upload

Hollie uploaded all files into the 16s HoloInt folder. Each sample will have a R1 and R2 fastq.gz file.

HPW### = Sample ID Number    
S### =    
L001 = Lane number  
R1/R2 = Forward (R1) and reverse (R2) b/c they are paired end reads  
001 = Read number  
.fastq = fastq file format   
.gz = gunzipped file format  

```
$ cd ../../data/putnamlab/estrand/HoloInt_16s
$ ls

## first three lines

filenames_md5.txt                 HPW147_S174_L001_R1_001.fastq.gz  HPW235_S221_L001_R2_001.fastq.gz
HPW060_S44_L001_R1_001.fastq.gz   HPW147_S174_L001_R2_001.fastq.gz  HPW236_S233_L001_R1_001.fastq.gz
HPW060_S44_L001_R2_001.fastq.gz   HPW148_S186_L001_R1_001.fastq.gz  HPW236_S233_L001_R2_001.fastq.gz
```

## CONDA Environment

Download [miniconda](https://docs.conda.io/en/latest/miniconda.html).

Resources on using conda environments:  

### Create a conda environment

```
# Creating an environment to work in
$ conda create -n HoloInt_16s
  Proceed ([y]/n)?
$ y

# Activate the created environment
$ conda activate HoloInt_16s
```

When finished working, deactivate your conda environment.

```
$ conda deactivate HoloInt_16s
```

Every time you start working on the project again, you'll need to reactivate the environment. The below line should start every command when the conda environment is activated.

```
(HoloInt_16s) [emma_strand@]/data/putnamlab/estrand/HoloInt_16s% $
```

### Download all programs that you will need

Ask Kevin Bryan to download any programs you need and specify if you will be working on Andromeda or bluewaves. Andromeda and bluewaves have different versions of programs.

The command `module avail` lists all previously downloaded modules that you can use on whichever server you are logged into.

The command `module list` will list the programs currently loaded and ready to use. You must first ask Kevin Bryan to download that program onto the server, then when ready to use you must load that module into your conda environment to actually use it.

Make note of the ones you will use and add to each module to that function's script.

The ones we used:

```
module load Miniconda3/4.9.2
module load FastQC/0.11.9-Java-11
module load MultiQC/1.9-intel-2020a-Python-3.8.2
module load cutadapt/2.10-GCCcore-9.3.0-Python-3.8.2
module load QIIME2/2021.4
```

## FASTQC: Quality control of raw read files.

Fastqc resources:  
- https://github.com/s-andrews/FastQC  
- https://raw.githubusercontent.com/s-andrews/FastQC/master/README.txt  
- How to interpret fastqc results [link](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)

Create the report from all of the fastqc files using MultiQC.

#### Create a new directory for fastqc results

```
$ mkdir fastqc_results
$ cd fastqc_results
```

#### Write script to run fastqc

```
# Create script
$ cd scripts
$ nano fastqc.sh
```

Write script command: This will be on the putnamlab node and updates sent to my email.

```
#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/HoloInt_16s/raw-data                   
#SBATCH --error="script_error" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load FastQC/0.11.9-Java-11
module load MultiQC/1.9-intel-2020a-Python-3.8.2

for file in /data/putnamlab/estrand/HoloInt_16s/raw-data/*fastq.gz
do
fastqc $file --outdir /data/putnamlab/estrand/HoloInt_16s/fastqc_results         
done

multiqc fastqc_results  

mv multiqc_report.html 16S_raw_qc_multiqc_report_ES.html #renames file
```

#### Run fastqc

Run script outlined. When the script either fails or finishes, the email included in the slurm sh code will sent a notification.

```
$ cd [to the HoloInt_16s folder]
$ sbatch /data/putnamlab/estrand/HoloInt_16s/scripts/fastqc.sh

# Check the wait list for running scripts
$ squeue
```

Double check all files were processed. Output should be 251 x 2 (F and R reads) x 2 (html and zip file) = 1004.

```
$ cd fastqc_results
$ ls -1 | wc -l

output:
1004
```

#### Troubleshooting during module load and fastqc steps

How to check where an error occured in your script.

```
$ nano script_error
```

The first time I ran the .sh scripts for fastqc and module loading I got an error message that the function 'fastqc' and 'module' wasn't recognized. Once I added this line `source /usr/share/Modules/init/sh` to the slurm script, then the scripts worked.

I tried to add `#!/usr/bin/zsh` to the beginning of my script for my slurm jobs to run. Instead of `#!/bin/bash`. But this didn't work. I canged it back to bash.

I need to have the module load within each script not loading them all before and include the source module line above in every script.

## Multiqc report: visualization of fastqc

Copy the report to your home desktop so that you are able to open this report. Run this outside of Andromeda and use the bluewaves login.

```
$ scp emma_strand@bluewaves.uri.edu:/data/putnamlab/estrand/HoloInt_16s/16S_raw_qc_multiqc_report_ES.html /Users/emmastrand/MyProjects/Acclim_Dynamics/16S_seq/ES-run
```

#### Raw QC Results

Link to the qc report in our github repo: [Acclim Dynamics 16s multiqc](https://github.com/hputnam/Acclim_Dynamics/blob/master/16S_seq/ES-run/16S_raw_qc_multiqc_report_ES.html).

How to interpret MultiQC Reports [video](https://www.youtube.com/watch?v=qPbIlO_KWN0).

General notes:  
- Sequence Counts: HPW270 has very little reads  
- Good mean quality scores start around 40-50 bp and drop around 175 bp (important for quality trimming later)    
- Per sequence GC content has three main peaks instead of a normal distribution  
- Adapter content 210 - 290. These need to be cut out

Per sequence GC content:  
- High GC can give you G-runs in primers or products. 3 or more Gs in a run may result in intermolecular quadruplexes forming in the PCR mix before or during amplification ([link](https://www.researchgate.net/post/How_does_a_difference_in_GC_content_in_primers_affect_PCR))  
- Seems to be an artifact of PCR

# QIIME2

Program webpage [here](https://docs.qiime2.org/2021.4/getting-started/), beginners guide [here](https://docs.qiime2.org/2021.4/tutorials/overview/).  
**Read the above links thoroughly before continuing on.**

I wrote one script to complete the following steps in QIIME2:  
1. Import metadata files (2)  
2. Import sample data  
3. Quality control with DADA2  

## 1. Import metadata files

#### Create metadata directory

```
$ cd [to the general HoloInt_16s folder]
$ mkdir metadata
```
#### Creating a list of all raw files

In a separate terminal window, not logged into Andromeda, secure copy these files.

```
# In andromeda
$ find raw-data -type f -print | sed 's_/_,_g' > ~/filelist.csv
$ mv ~/filelist.csv /data/putnamlab/estrand/HoloInt_16s

# Outside of andromeda
$ scp emma_strand@bluewaves.uri.edu:/data/putnamlab/estrand/HoloInt_16s/filelist.csv /Users/emmastrand/MyProjects/Acclim_Dynamics/16S_seq/
```

### Start with two metadata files

#### I. Sample manifest file

QIIME2 instructions on a sample manifest file [here](https://docs.qiime2.org/2021.4/tutorials/importing/#importing-seqs) under 'Fastq manifest formats'.

Created in the `16s.Rmd` script. Secure copy this file outside of andromeda.
```
$ scp /Users/emmastrand/MyProjects/Acclim_Dynamics/16S_seq/ES-run/HoloInt_sample-manifest-ES.csv emma_strand@bluewaves.uri.edu:/data/putnamlab/estrand/HoloInt_16s/metadata
```

Example of a sample manifest:

![sample-manifest](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/16S-workflow/sample-manifest.png?raw=true)

#### II. Sample metadata file

The metadata will have all the experimental data you need to make comparisons. The first row will be the headers and the 2nd row will be the type of data each column is.

Metadata formatting requirements [here](https://docs.qiime2.org/2021.4/tutorials/metadata/).

Example of metadata:

![meta](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/16S-workflow/sample-metadata.png?raw=true)

Secure copy this file outside of andromeda.

```
$ scp /Users/emmastrand/MyProjects/Acclim_Dynamics/16S_seq/HoloInt_Metadata.txt emma_strand@bluewaves.uri.edu:/data/putnamlab/estrand/HoloInt_16s/metadata
```

## 2. Sample data input

General sample Input information from QIIME2: [here](https://docs.qiime2.org/2021.4/tutorials/importing/#id34). We chose the below for our samples:  
- Sequence Data with Sequence Quality Information: because we have fastq files, not fasta files.
- FASTQ data in the Casava 1.8 paired-end demultiplexed format: because our samples are already demultiplexed and we have 1 file per F and R.  
- Script format came from [here](https://docs.qiime2.org/2021.4/tutorials/importing/#casava-1-8-paired-end-demultiplexed-fastq).  
- PairedEndFastqManifestPhred33 option requires a forward and reverse read. This assumes that the PHRED (more info on that [here](http://scikit-bio.org/docs/latest/generated/skbio.io.format.fastq.html#quality-score-variants)) offset for positional quality scores is 33.

```
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path $MANIFEST \
  --input-format PairedEndFastqManifestPhred33 \
  --output-path processed_data/HoloInt_16S-paired-end-sequences.qza
```

## 3. Denoising with DADA2

Description from QIIME2 documentation:  
- We *denoise* our sequences to remove and/or correct noisy reads.  
- To put it simply, these methods filter out noisy sequences, correct errors in marginal sequences (in the case of DADA2), remove chimeric sequences, remove singletons, join denoised paired-end reads (in the case of DADA2), and then dereplicate those sequences.  

Full DADA2 options from qiime2 on this page: [here](https://docs.qiime2.org/2021.4/plugins/available/dada2/denoise-paired/)

We adjust our parameters based on read length and 16S primer length:  
- `--i-demultiplexed-seqs` followed by the sequences artifact to be denoised  
- `--p-trunc-len-f INTEGER`: position to be truncated due to decreased quality. This truncates the 3' end of sequences which are the bases that were sequenced in the last cycles. On the forward read.    
- `--p-trunc-len-r INTEGER`: same as above but on the reverse read.      
- `p-trim-left-f INTEGER`: Position at which forward read sequences should be trimmed due to low quality. This trims the 5' end of the input sequences, which will be the bases that were sequenced in the first cycles.    
- `p-trim-left-r INTEGER`: Position at which reverse read sequences should be trimmed due to low quality. This trims the 5' end of the input sequences, which will be the bases that were sequenced in the first cycles.    
- `o-table`: The resulting feature table.    
- `o-representative-sequences`: The resulting feature sequences. Each feature in the feature table will be represented by exactly one sequence, and these sequences will be the joined paired-end sequences.    
- `o-denoising-stats`: SampleData[DADA2Stats]  
- `p-n-threads`: The number of threads to use for multithreaded processing. If 0 is provided, all available cores will be used.  

`--p-trunc-len` choice: 150 reverse and 260 forward. This was based on the  
- Resources: [forum post](https://forum.qiime2.org/t/dada2-truncation-lengths-and-features-number/1940/6), [exercises in picking trunc and left values](https://web.stanford.edu/class/bios221/Pune/Labs/Lab_dada2/Lab_dada2_workflow.html),

**pre-filtering sequence quality scores**
![seqqual]()

**post-filtering sequence quality scores**

`--p-trim-left` choice: 52 reverse and 54 forward. This was based on the primer lengths: 515F = 52 bp long; 806RB = 54 bp long. This include adapter overhang. See [sequencing protocol](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-02-01-16s-Sequencing-HoloInt.md) to see primer choice.  

**pre-filtering adapter content**  
![adapter]()

**post-filtering adapter content**

`o-table` choice: our classifier choice was ___ because .

`p-n-threads` choice: 20 because

**Questions/come back to**:  
- Adapter content seems to start at ~210 bp. 40-210 bp seems to be where the good data is.. Come back to chat to HP about this  


```
# QC using dada2
# Adjust the params based on read length and 16S primer length

qiime dada2 denoise-paired --verbose --i-demultiplexed-seqs HoloInt_16S-paired-end-sequences.qza \
  --p-trunc-len-r 150 --p-trunc-len-f 260 \
  --p-trim-left-r 52 --p-trim-left-f 54 \
  --o-table table.qza \
  --o-representative-sequences rep-seqs.qza \
  --o-denoising-stats denoising-stats.qza \
  --p-n-threads 20
```

### Clustering

Description from QIIME2 documentation:  
- We *dereplicate* our sequences to reduce repetition and file size/memory requirements in downstream steps (don’t worry! we keep count of each replicate).  
- We *cluster* sequences to collapse similar sequences (e.g., those that are ≥ 97% similar to each other) into single replicate sequences. This process, also known as OTU picking, was once a common procedure, used to simultaneously dereplicate but also perform a sort of quick-and-dirty denoising procedure (to capture stochastic sequencing and PCR errors, which should be rare and similar to more abundant centroid sequences). Use denoising methods instead if you can. Times have changed. Welcome to the future.

```
# Summarize feature table and sequences
qiime metadata tabulate \
  --m-input-file denoising-stats.qza \
  --o-visualization denoising-stats.qzv
qiime feature-table summarize \
  --i-table table.qza \
  --o-visualization table.qzv \
  --m-sample-metadata-file $METADATA
qiime feature-table tabulate-seqs \
  --i-data rep-seqs.qza \
  --o-visualization rep-seqs.qzv
```

## Script used to run QIIME2

Create script.

```
$ cd [into scripts folder]  
$ nano qiime2_script.sh
```

This script imports and quality controls data using DADA2

```
#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=300GB
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/hputnam/HoloInt_16S

source /usr/share/Modules/init/sh # load the module function
module load QIIME2/2021.4

echo "QIIME2 bash script for 16S samples started running at: "; date

#### METADATA FILES ####
# File path
cd /data/putnamlab/hputnam/HoloInt_16S

# Metadata path
METADATA="metadata/HoloInt_Metadata.txt"

# Sample manifest path
MANIFEST="metadata/HoloInt_sample-manifest-ES.csv"

#########################

#### IMPORT DATA FILES  

qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path $MANIFEST \
  --input-format PairedEndFastqManifestPhred33 \
  --output-path processed_data/HoloInt_16S-paired-end-sequences1.qza

#### DENOISING WITH DADA2

#### CLUSTERING

```


# UNUSED SCRIPT (NOTES)

## OTU vs. ASV and program choices

Nicola did:  
1.) Retain only PE reads that match amplicon primer.  
2.) Remove reads containing Illumina sequencing adapters.  
3.) Cut out first 4 'de-generate' basepairs.  
4.) Cut out reads that don't start with the 16s primer  
5.) Removes primer  
6.) DADA2 pipeline  

Seems like there a couple programs to use choose from..

DADA2: [here](https://benjjneb.github.io/dada2/tutorial.html).  
Qiime2: [here](https://docs.qiime2.org/2021.4/about/).  

Apparently DADA2 is a newer version for bacteria (good to use if that's what you're working on) and Qiime2 is established/tried & true methods. Qiime2 might be safer option?

DADA2 produces an amplicon sequence variant (ASV) table which is a higher resolution analogue of the traditional OTU table and records the number of times each exact amplicon sequence variant was observed in each sample.

Qiime2 produces OTUs ("tried and true")

OTU vs. ASV information [here](https://www.zymoresearch.com/blogs/blog/microbiome-informatics-otu-vs-asv).

**There was no checksum file from URI GSC but I created one once Hollie transfered them to my folder on andromeda to reference back to if needed.**

#### Create a new checksum file (md5sum)

```
# Create file (takes ~6-7 min to complete)
$ md5sum *.fastq.gz > 16s-checksum2.md5  

# Read the created file above
$ nano 16s-checksum2.md5

Output (first six lines):
210b589620ef946cd5c51023b0f90d8d  HPW060_S44_L001_R1_001.fastq.gz
227032c7b7f7fa8c407cb0509a1fcd6a  HPW060_S44_L001_R2_001.fastq.gz
2f8d8892b7be06cf047a1085dd8bbbf1  HPW061_S56_L001_R1_001.fastq.gz
b603f7ff519130555527bec4c8f8e2c6  HPW061_S56_L001_R2_001.fastq.gz
32c549eb8422ac2ba7affe3dedfb4d3b  HPW062_S68_L001_R1_001.fastq.gz
4caef9d9f684e8345060fdc5896159c8  HPW062_S68_L001_R2_001.fastq.gz

# Check that the individual files went into the new md5 file OK
$ md5sum -c 16s-checksum2.md5

Output: all files = OK
```
## CUTADAPT

**We trimmed based on primer length within the Qiime2 program.**

User guide for cutadapt [here](https://cutadapt.readthedocs.io/en/stable/guide.html). Basic function:

`cutadapt -g F_PRIMER -G R_PRIMER --untrimmed-output file --untrimmed-paired-output file -o R1 file -p R2 file input1 input2 `.

Flags in the command:  
- `-g`: corresponds to the adapter type. We used regular 5' adapters which calls for `-g`.  
- `-G` corresponds to R2 read.  
- `-q (or --quality-cutoff)`: Illumina reads are high quality at the beginning and degrade towards the 3' end. cutadapt uses 10 as their example.  
- `--untrimmed-output`: Write all reads without adapters to FILE (in FASTA/FASTQ format) instead of writing them to the regular output file.    
- `--untrimmed-paired-output`: Used together with --untrimmed-output. The second read in a pair is written to this file when the processed pair was not trimmed.  
- `-p`: for paired end; R2 file  
-

Primer sequences with the URI GSC adapter overhang:  
- 515 Forward: TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGGTGCCAGCMGCCGCGGTAA
- 806 Reverse (RB): GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGGGACTACNVGGGTWTCTAAT

#### Make a directory for processed data

```
$ mkdir processed_data
```

#### Make a script to run cut adapt program

I took out the mail notification for the beginning of the slurm script to reduce the number of emails. Include the source message for the script to recognize bash and zsh functions.

```
#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/HoloInt_16s/raw-data                   
#SBATCH --error="script_error" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # this is used so that them function can be found in zsh and bash

# Trims the forward and reverse primers from the forward and reverse read file respectively in paired-end sequences

for file in /data/putnamlab/estrand/HoloInt_16s/raw-data/*fastq.gz
do
cutadapt -g F -G R
done

# Trims the reverse complement of the reverse primer and reverse complement of the forward primer from the forward and reverse read file respectively in paired-end sequences

for file in /data/putnamlab/estrand/HoloInt_16s/raw-data/*fastq.gz
do

done

```

### Creating a script to load the downloaded programs

Make a directory for that script
```
$ mkdir scripts
$ cd scripts
```
Create the file and input the commands you need.

```
$ nano module-load.sh #creates the file

#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/HoloInt_16s/                    
#SBATCH --error="script_error" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # this is used so that them function can be found in zsh and bash

module load Miniconda3/4.9.2
module load FastQC/0.11.9-Java-11
module load MultiQC/1.9-intel-2020a-Python-3.8.2
module load cutadapt/2.10-GCCcore-9.3.0-Python-3.8.2
module load QIIME2/2021.4
```

Run the script:
```
$ sbatch module-load.sh
```
