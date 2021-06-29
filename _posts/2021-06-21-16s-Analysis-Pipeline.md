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

## Related resources

Fastq vs fasta format  
16s
Shell and linux/unix coding

## Bluewaves and Andromeda for URI

Logging into bluewaves and andromeda. Information for creating an account on [Andromeda](https://web.uri.edu/hpc-research-computing/using-andromeda/).

```
# Bluewaves
$ ssh -l username@bluewaves.uri.edu
$ pw: (your own password)

# Andromeda
$ ssh -l emma_strand.hac.uri.edu
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

## CONDA Environment

Download [miniconda](https://docs.conda.io/en/latest/miniconda.html).

Resources on using conda environments:  



#### Create a conda environment and download all programs that you will need

Ask Kevin Bryan to download any programs you need and specify if you will be working on Andromeda or bluewaves.  

```
# Must load any modules available to use with the module load command
$ module load Miniconda3/4.6.14 # Bluewaves
$ module load Miniconda3/4.9.2 # Andromeda

# Creating an environment to work in
$ conda create -n HoloInt_16s
  Proceed ([y]/n)?
$ y

# Activate the created environment
$ conda activate HoloInt_16s
```

Download all programs. These will be different on bluewaves and andromeda.

```
# The `module avail` command lists all previously downloaded modules that you can use on bluewaves/andromeda

# Bluewaves load
$ module load FastQC/0.11.8-Java-1.8
$ module load MultiQC/1.7-foss-2018b-Python-3.6.6

# Andromeda load
$ module load FastQC/0.11.9-Java-11
$ module load MultiQC/1.9-intel-2020a-Python-3.8.2
$ module load cutadapt/2.10-GCCcore-9.3.0-Python-3.8.2
$ module load QIIME2/2021.4

# List the currently loaded programs
$ module list

Currently Loaded Modulefiles:
  1) Miniconda3/4.6.14                              22) Python/3.8.2-GCCcore-9.3.0
  2) Java/1.8.0_291(1.8)                            23) pybind11/2.4.3-GCCcore-9.3.0-Python-3.8.2
  3) FastQC/0.11.8-Java-1.8                         24) SciPy-bundle/2020.03-intel-2020a-Python-3.8.2
  4) GCCcore/9.3.0                                  25) libpng/.1.6.37-GCCcore-9.3.0
  5) zlib/.1.2.11-GCCcore-9.3.0                     26) freetype/.2.10.1-GCCcore-9.3.0
  6) binutils/.2.34-GCCcore-9.3.0                   27) expat/2.2.9-GCCcore-9.3.0
  7) iccifort/2020.1.217                            28) util-linux/2.35-GCCcore-9.3.0
  8) numactl/2.0.13-GCCcore-9.3.0                   29) fontconfig/2.13.92-GCCcore-9.3.0
  9) UCX/1.8.0-GCCcore-9.3.0                        30) xorg-macros/1.19.2-GCCcore-9.3.0
 10) impi/2019.7.217-iccifort-2020.1.217            31) libpciaccess/0.16-GCCcore-9.3.0
 11) iimpi/2020a                                    32) X11/20200222-GCCcore-9.3.0
 12) imkl/2020.1.217-iimpi-2020a                    33) Tk/.8.6.10-GCCcore-9.3.0
 13) intel/2020a                                    34) Tkinter/3.8.2-GCCcore-9.3.0
 14) bzip2/.1.0.8-GCCcore-9.3.0                     35) matplotlib/3.2.1-intel-2020a-Python-3.8.2
 15) ncurses/.6.2-GCCcore-9.3.0                     36) libyaml/0.2.2-GCCcore-9.3.0
 16) libreadline/.8.0-GCCcore-9.3.0                 37) PyYAML/5.3-GCCcore-9.3.0
 17) Tcl/.8.6.10-GCCcore-9.3.0                      38) networkx/2.4-intel-2020a-Python-3.8.2
 18) SQLite/.3.31.1-GCCcore-9.3.0                   39) MultiQC/1.9-intel-2020a-Python-3.8.2
 19) XZ/.5.2.5-GCCcore-9.3.0                        40) cutadapt/2.10-GCCcore-9.3.0-Python-3.8.2
 20) GMP/.6.2.0-GCCcore-9.3.0                       41) QIIME2/2021.4
 21) libffi/3.3-GCCcore-9.3.0

```

When finished working, deactivate your conda environment.

```
$ conda deactivate HoloInt_16s
```

Every time you start working on the project again, you'll need to reactivate the environment. The below line should start every command when the conda environment is activated.

```
(HoloInt_16s) [emma_strand@]/data/putnamlab/estrand/HoloInt_16s% $
```

#### Creating a script to load the above programs

Make a directory for that script
```
$ mkdir scripts
$ cd scripts
```

I kept getting kicked out of Andromeda because of wifi errors and didn't want to load in each module individually repeatedly.

Resources on creating 'jobs':  
- [Putnam Lab Management: submitting jobs](https://github.com/Putnam-Lab/Lab_Management/blob/master/Bioinformatics_%26_Coding/Bluewaves/Submitting_Job.md)

```
$ nano module-load.sh

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

$ sbatch module-load.sh
```

## FASTQC: Quality control of raw read files.

Fastqc resources:  
- https://github.com/s-andrews/FastQC  
- https://raw.githubusercontent.com/s-andrews/FastQC/master/README.txt  
- How to interpret fastqc results [link](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)

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

for file in /data/putnamlab/estrand/HoloInt_16s/raw-data/*fastq.gz
do
fastqc $file --outdir /data/putnamlab/estrand/HoloInt_16s/fastqc_results         
done
```

#### Run fastqc

Run script outlined. When the script either fails or finishes, the email included in the slurm sh code will sent a notification.

```
$ sbatch /data/putnamlab/estrand/HoloInt_16s/scripts/fastqc.sh

# Check the wait list for running scripts
$ squeue
```

How to check where an error occured in your script.

```
$ nano script_error
```

In the command line. I ran this while my script was not working:
```
$ for file in /data/putnamlab/estrand/HoloInt_16s/raw-data/*fastq.gz
for> do
for> fastqc $file --outdir /data/putnamlab/estrand/HoloInt_16s/fastqc_results
for> done

# Run time = ~45 min
```

Double check all files were processed. Output should be 251.

```
$ cd fastqc_results
$ ls -1 | wc -l

output:
1000
```

#### Troubleshooting

The first time I ran the .sh scripts for fastqc and module loading I got an error message that the function 'fastqc' and 'module' wasn't recognized.

## Multiqc report: visualization of fastqc

Create the report

```
$ multiqc /data/estrand/HoloInt_16s/fastqc_results/qc
```

Copy the report to your home desktop so that you are able to open this report.

```
$ scp -r emma_strand@ssh3.hac.uri.edu:/data/putnamlab/estrand/HoloInt_16s/fastqc_results/qc/*.html /Users/emmastrand/MyProjects/Acclim_Dynamics/
```

#### Results

Link to the qc report in our github repo: [Acclim Dynamics 16s multiqc]()




## CUTADAPT

## QIIME2

Program webpage [here](https://docs.qiime2.org/2021.4/getting-started/), beginners guide [here](https://docs.qiime2.org/2021.4/tutorials/overview/).
