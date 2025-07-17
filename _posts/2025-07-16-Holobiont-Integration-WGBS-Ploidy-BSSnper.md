---
layout: post
title: BSSnper on WGBS data for Holobiont Integration Ploidy
date: '2025-07-16'
categories: Processing
tags: Holobiont-Integration, WGBS, SNP
projects: Holobiont Integration
---

## Previous workflow 

I used nextflow on WGBS data from Holobiont Integration, [workflow here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/8cbb3a598e769d25816f0f8b0f19d4ca741e1115/_posts/2021-10-21-HoloInt-WGBS-Analysis-Pipeline.md). But I want to add BS-Snper program to identify SNPs in our dataset. 

Corresponding [github repo](https://github.com/emmastrand/Ploidy_methylation/tree/main).

This time I will do nextflow on Unity within the scratch directory.

### Set up a shared scratch directory

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

Navigate to the proper folder: `/work/pi_hputnam_uri_edu/estrand/HoloInt_WGBS`

Download the genome:  
- `wget http://cyanophora.rutgers.edu/Pocillopora_acuta/Pocillopora_acuta_HIv2.assembly.fasta.gz`     
- `gunzip Pocillopora_acuta_HIv2.assembly.fasta.gz`

### Creating samplesheet

Create a list of rawdata files: `ls -d /project/pi_hputnam_uri_edu/raw_sequencing_data/20211008_HoloInt_WGBS/*.gz > /work/pi_hputnam_uri_edu/estrand/HoloInt_WGBS/rawdata_file_list`

Use RStudio in OOD to run the following R script to create a sample sheet `create_metadata.R`

```
### Creating samplesheet for nextflow methylseq
### Holobiont Integration

## Load libraries 
library(dplyr)
library(stringr)
library(strex) 

### Read in sample sheet 

sample_list <- read.delim2("/work/pi_hputnam_uri_edu/estrand/HoloInt_WGBS/rawdata_file_list", header=F) %>% 
  dplyr::rename(forwardReads = V1) %>%
  mutate(sampleID = str_after_nth(forwardReads, "WGBS/", 1),
         sampleID = str_before_nth(sampleID, "_S", 1),
         sampleID = paste0("HI_", sampleID)
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

sample_list %>% write.csv("/work/pi_hputnam_uri_edu/estrand/HoloInt_WGBS/samplesheet.csv", 
                          row.names=FALSE, quote = FALSE)
```

 
### Nextflow methyl-seq

`01-HoloInt_WGBS_nexflow.sh`

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
out="/scratch3/workspace/emma_strand_uri_edu-shared/HoloIntWGBS"

#export NXF_WORK=${out}/nextflow_work
#export NXF_TEMP=${out}/nextflow_temp
#export NXF_LAUNCHER=${out}/nextflow_launcher

export APPTAINER_CACHEDIR=${out}/apptainer_cache
export SINGULARITY_CACHEDIR=${out}/apptainer_cache
export NXF_SINGULARITY_CACHEDIR=${out}/apptainer_cache

## set paths
samplesheet="/work/pi_hputnam_uri_edu/estrand/HoloInt_WGBS/samplesheet.csv"
ref="/work/pi_hputnam_uri_edu/estrand/HoloInt_WGBS/Pocillopora_acuta_HIv2.assembly.fasta"

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

Testing to see if .sh works, `salloc` to grab an interactive node and `bash 01-HoloInt_WGBS_nexflow.sh`

#### Troubleshooting 

**7-16-2025**: I tried to run this in an interactive node and got the below error. I was previously using `--input ${raw_data}/*_R{1,2}_001.fastq.gz` in 2021 but now nextflow needs a csv samplesheet. Adding instructions to the top of this doc.

```
ERROR ~ Input length = 1
 -- Check script '/home/emma_strand_uri_edu/.nextflow/assets/nf-core/methylseq/./workflows/methylseq/../../subworkflows/local/utils_nfcore_methylseq_pipeline/../../nf-core/utils_nfsc
hema_plugin/main.nf' at line: 39 or see '.nextflow.log' file for more details
```

**7-17-2025**: Zoe shared how she ran nextflow on Unity: https://github.com/zdellaert/LaserCoral/blob/e673c9f98194578d1e1efeadc4274731e162c4bc/scripts/methylseq_V3_bwa.sh#L11. I changed my export scratch parameters to reflect how she ran this. Made samplesheet and tried again 

```
ERROR ~ Validation of pipeline parameters failed!
 -- Check '.nextflow.log' file for details
The following invalid input values have been detected:
* --input (/work/pi_hputnam_uri_edu/estrand/HoloInt_WGBS/samplesheet.csv): Validation of file failed:
        -> Entry 1: Missing required field(s): fastq_1, sample
        -> Entry 2: Missing required field(s): fastq_1, sample

 -- Check script '/home/emma_strand_uri_edu/.nextflow/assets/nf-core/methylseq/./workflows/methylseq/../../subworkflows/local/utils_nfcore_methylseq_pipeline/../../nf-core/utils_nfschema_plugin/main.nf' at line: 39 or see '.nextf
low.log' file for more details
```

I then tried to add the right header names: sample,fastq_1,fastq_2,genome. This got better but I ran into this error now.

```
Pulling Singularity image https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/9b/9becad054093ad4083a961d12733f2a742e11728fe9aa815d678b882b3ede520/data [cache /scratch3/workspace/emma_strand_uri_edu-shared/HoloIntW
GBS/nextflow_work/singularity/community-cr-prod.seqera.io-docker-registry-v2-blobs-sha256-9b-9becad054093ad4083a961d12733f2a742e11728fe9aa815d678b882b3ede520-data.img]
WARN: Singularity cache directory has not been defined -- Remote image will be stored in the path: /scratch3/workspace/emma_strand_uri_edu-shared/HoloIntWGBS/nextflow_work/singularity -- Use the environment variable NXF_SINGULARI
TY_CACHEDIR to specify a different location
ERROR ~ Error executing process > 'NFCORE_METHYLSEQ:METHYLSEQ:TRIMGALORE (1)'
Caused by:
  Failed to pull singularity image
    command: singularity pull  --name community-cr-prod.seqera.io-docker-registry-v2-blobs-sha256-9b-9becad054093ad4083a961d12733f2a742e11728fe9aa815d678b882b3ede520-data.img.pulling.1752769214465 https://community-cr-prod.seqera
.io/docker/registry/v2/blobs/sha256/9b/9becad054093ad4083a961d12733f2a742e11728fe9aa815d678b882b3ede520/data > /dev/null
    status : 255
    hint   : Try and increase singularity.pullTimeout in the config (current is "20m")
    message:
      FATAL:   Failed to create an image cache handle: failed initializing caching directory: unable to stat /work/pi_hputnam_uri_edu/.apptainer/cache/cache/library: stat /work/pi_hputnam_uri_edu/.apptainer/cache/cache/library: p
ermission denied
 -- Check '.nextflow.log' file for details
ERROR ~ Pipeline failed. Please refer to troubleshooting docs: https://nf-co.re/docs/usage/troubleshooting
 -- Check '.nextflow.log' file for details
-[nf-core/methylseq] Pipeline completed with errors-
```

I added a mkdir `apptainer_cache` instead of the previous nextflow folders... try now. OK better... but now I get this:

```
Pulling Singularity image https://depot.galaxyproject.org/singularity/bismark:0.24.2--hdfd78af_0 [cache /scratch3/workspace/emma_strand_uri_edu-shared/HoloIntWGBS/apptainer_cache/depot.galaxyproject.org-singularity-bismark-0.24.2
--hdfd78af_0.img]
Pulling Singularity image https://depot.galaxyproject.org/singularity/fastqc:0.12.1--hdfd78af_0 [cache /scratch3/workspace/emma_strand_uri_edu-shared/HoloIntWGBS/apptainer_cache/depot.galaxyproject.org-singularity-fastqc-0.12.1--
hdfd78af_0.img]
Pulling Singularity image https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/9b/9becad054093ad4083a961d12733f2a742e11728fe9aa815d678b882b3ede520/data [cache /scratch3/workspace/emma_strand_uri_edu-shared/HoloIntW
GBS/apptainer_cache/community-cr-prod.seqera.io-docker-registry-v2-blobs-sha256-9b-9becad054093ad4083a961d12733f2a742e11728fe9aa815d678b882b3ede520-data.img]
01-HoloInt_WGBS_nexflow.sh: line 44: 1354057 Killed                  nextflow run nf-core/methylseq -resume -profile singularity --aligner bismark --igenomes_ignore --fasta ${ref} --input ${samplesheet} --clip_r1 10 --clip_r2 10 
--three_prime_clip_r1 10 --three_prime_clip_r2 10 --non_directional --cytosine_report --relax_mismatches --unmapped --outdir ${out}
```

Ah, this is probably out of memory issue which is because I'm on an interactive node! Hooray. Moving to sbatch. 

Que'd -- 

```
emma_strand_uri_edu@login1:/work/pi_hputnam_uri_edu/estrand/HoloInt_WGBS/scripts$ squeue -u emma_strand_uri_edu
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
          40061850       cpu interact emma_str  R      14:47      1 gypsum-gpu091
          40061953   uri-cpu 01-HoloI emma_str PD       0:00      2 (Resources)
```






