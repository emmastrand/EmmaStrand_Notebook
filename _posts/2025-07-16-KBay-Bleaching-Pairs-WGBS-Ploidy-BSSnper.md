---
layout: post
title: BSSnper on WGBS data for KBay Bleaching Pairs
date: '2025-07-16'
categories: Processing
tags: KBay-Bleaching-Pairs, WGBS, SNP
projects: KBay Bleaching Pairs
---

## Previous workflow 

I used nextflow on WGBS data from KBay Bleaching pairs, [workflow here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-10-21-KBay-Bleaching-Pairs-WGBS-Analysis-Pipeline.md). But I want to add BS-Snper program to identify SNPs in our dataset. 

Corresponding [github repo]().

This time I will do nextflow on Unity within the scratch directory.

### Set up a shared scratch directory

**7-15-2025** I set up shared directory in scratch for me and Hollie when re-running this with the ploidy dataset. 

https://docs.unity.uri.edu/documentation/managing-files/hpc-workspace/. Max days = 30 

Options for creating shared workspaces:

```
Usage: ws_allocate: [options] workspace_name duration
Options:
  -h [ --help ]            produce help message
  -V [ --version ]         show version
  -d [ --duration ] arg    duration in days
  -n [ --name ] arg        workspace name
  -F [ --filesystem ] arg  filesystem
  -r [ --reminder ] arg    reminder to be sent n days before expiration
  -m [ --mailaddress ] arg mailaddress to send reminder to
  -x [ --extension ]       extend workspace
  -u [ --username ] arg    username
  -g [ --group ]           group workspace
  -G [ --groupname ] arg   groupname
  -c [ --comment ] arg     comment
```

Creating space shared between me and Hollie 

```
ws_allocate -G pi_hputnam_uri_edu shared -m emma_strand@uri.edu -r 1
## that successfully created it but then I tried:

ws_allocate -G pi_hputnam_uri_edu shared -m emma_strand@uri.edu -r 2 -d 30 -n Strand_Putnam
## this also worked but just re-used previous.. The max is 30 days so I must need to extend the workspace 5 times (6x5=30)

ws_list

id: shared
     workspace directory  : /scratch3/workspace/emma_strand_uri_edu-shared
     remaining time       : 6 days 23 hours
     creation time        : Wed Jul 16 23:19:35 2025
     expiration date      : Wed Jul 23 23:19:35 2025
     filesystem name      : workspace
     available extensions : 5
```

### Download genome 

Navigate to the proper folder: `/work/pi_hputnam_uri_edu/estrand/BleachingPairs_WGBS`

Download the genome:  
- `wget http://cyanophora.rutgers.edu/montipora/Montipora_capitata_HIv3.assembly.fasta.gz`     
- `gunzip Montipora_capitata_HIv3.assembly.fasta.gz`

### Creating samplesheet

Create a list of rawdata files: `ls -d /project/pi_hputnam_uri_edu/raw_sequencing_data/20211008_BleachingPairs_WGBS/*.gz > /work/pi_hputnam_uri_edu/estrand/BleachingPairs_WGBS/rawdata_file_list`

Use RStudio in OOD to run the following R script to create a sample sheet `create_metadata.R`

```
### Creating samplesheet for nextflow methylseq
### Bleaching Pairs

## Load libraries 
library(dplyr)
library(stringr)
library(strex) 

### Read in sample sheet 

sample_list <- read.delim2("/work/pi_hputnam_uri_edu/estrand/BleachingPairs_WGBS/rawdata_file_list", header=F) %>% 
  dplyr::rename(forwardReads = V1) %>%
  mutate(sampleID = str_after_nth(forwardReads, "WGBS/", 1),
         sampleID = str_before_nth(sampleID, "_S", 1),
         sampleID = paste0("KB_", sampleID)
         )

# creating sample ID 
sample_list$sampleID <- gsub("-", "_", sample_list$sampleID)

# keeping only rows with R1
sample_list <- filter(sample_list, grepl("R1", forwardReads, ignore.case = TRUE))

# duplicating column 
sample_list$reverseReads <- sample_list$forwardReads

# replacing R1 with R2 in only one column 
sample_list$reverseReads <- gsub("R1", "R2", sample_list$reverseReads)

# rearranging columns 
sample_list <- sample_list[,c(2,1,3)]

sample_list %>% write.csv("/work/pi_hputnam_uri_edu/estrand/BleachingPairs_WGBS/samplesheet.csv", 
                          row.names=FALSE, quote = FALSE)
```

 
### Nextflow methyl-seq

`01-KBay_WGBS_nexflow.sh`

```
#!/usr/bin/env bash
#SBATCH --export=NONE
#SBATCH --nodes=2 --ntasks-per-node=24
#SBATCH --partition=uri-cpu
#SBATCH --no-requeue
#SBATCH --mem=400GB
#SBATCH -t 120:00:00
#SBATCH -o output/"%x_output.%j"
#SBATCH -e output/"%x_error.%j"

## Load Nextflow and Apptainer environment modules
module purge
module load nextflow/24.10.3
module load apptainer/latest

## Set Nextflow directories to use scratch
out="/scratch3/workspace/emma_strand_uri_edu-shared/BleachingPairs_WGBS"

#export NXF_WORK=${out}/nextflow_work
#export NXF_TEMP=${out}/nextflow_temp
#export NXF_LAUNCHER=${out}/nextflow_launcher

export APPTAINER_CACHEDIR=${out}/apptainer_cache
export SINGULARITY_CACHEDIR=${out}/apptainer_cache
export NXF_SINGULARITY_CACHEDIR=${out}/apptainer_cache

## set paths
samplesheet="/work/pi_hputnam_uri_edu/estrand/BleachingPairs_WGBS/samplesheet.csv"
ref="/work/pi_hputnam_uri_edu/estrand/BleachingPairs_WGBS/Montipora_capitata_HIv3.assembly.fasta"

# run nextflow methylseq
nextflow run nf-core/methylseq -resume \
-profile singularity \
--aligner bismark \
--igenomes_ignore \
--fasta ${ref} \
--input ${samplesheet} \
--clip_r1 10 --clip_r2 10 \
--three_prime_clip_r1 10 --three_prime_clip_r2 10 \
--non_directional \
--cytosine_report \
--relax_mismatches \
--unmapped \
--outdir ${out}
```

Testing to see if .sh works, `salloc` to grab an interactive node and `bash 01-KBay_WGBS_nexflow.sh`

#### Troubleshooting 



