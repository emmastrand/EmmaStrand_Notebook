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

**7-23-2025** I'm extending this workspace: `ws_extend shared 30`

```
emma_strand_uri_edu@login1:/scratch3/workspace/emma_strand_uri_edu-shared$ ws_extend shared 30
Info: extending workspace.
Info: reused mail address emma_strand@uri.edu
/scratch3/workspace/emma_strand_uri_edu-shared
remaining extensions  : 4
remaining time in days: 30
```

Did this again 8-22 but accidentally did it twice so now only 2 remaining for 30 days. Hopefully that should be fine.

Did this again 9-21 but I need to transfer data soon. 

```
emma_strand_uri_edu@login1:/project/pi_hputnam_uri_edu$ ws_extend shared 30
Info: could not read email from users config ~/.ws_user.conf.
Info: reminder email will be sent to local user account
Info: extending workspace.
Info: changed mail address to emma_strand_uri_edu
Info: changed reminder setting.
/scratch3/workspace/emma_strand_uri_edu-shared
remaining extensions  : 1
remaining time in days: 30
```

**10-21-2025**: Extending this workspace. I should move this data to another folder for safe-keeping. 

```
emma_strand_uri_edu@login4:/scratch3/workspace/emma_strand_uri_edu-shared$ ws_extend shared 30
Info: could not read email from users config ~/.ws_user.conf.
Info: reminder email will be sent to local user account
Info: extending workspace.
Info: changed mail address to emma_strand_uri_edu
Info: changed reminder setting.
/scratch3/workspace/emma_strand_uri_edu-shared
remaining extensions  : 0
remaining time in days: 30
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
  dplyr::rename(fastq_1 = V1) %>%
  mutate(sample = str_after_nth(fastq_1, "WGBS/", 1),
         sample = str_before_nth(sample, "_S", 1),
         sample = paste0("HI_", sample)
         )

# creating sample ID 
sample_list$sample <- gsub("-", "_", sample_list$sample)

# keeping only rows with R1
sample_list <- filter(sample_list, grepl("R1", fastq_1, ignore.case = TRUE))

# duplicating column 
sample_list$fastq_2 <- sample_list$fastq_1

# replacing R1 with R2 in only one column 
sample_list$fastq_2 <- gsub("R1", "R2", sample_list$fastq_2)

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
#SBATCH --nodes=1 --ntasks-per-node=48
#SBATCH --partition=uri-cpu
#SBATCH --no-requeue
#SBATCH --mem=600GB
#SBATCH -t 120:00:00
#SBATCH -o output/"%x_output.%j"
#SBATCH -e output/"%x_error.%j"

## Load Nextflow and Apptainer environment modules
module purge
module load nextflow/24.10.3
module load apptainer/latest

## Set Nextflow directories to use scratch
out="/scratch3/workspace/emma_strand_uri_edu-shared/BleachingPairs_WGBS"

export NXF_WORK=${out}/nextflow_work
export NXF_TEMP=${out}/nextflow_temp
export NXF_LAUNCHER=${out}/nextflow_launcher

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
--outdir ${out} \
--skip_fastqc --skip_multiqc
```


#### Troubleshooting 

Testing to see if .sh works, `salloc` to grab an interactive node and `bash 01-KBay_WGBS_nexflow.sh`

**7-17-2025**: Interactive node test script. HoloInt started running but I need to change samplesheet headers to sample, fastq_1, fastq_2. Edited samplesheet and ran again on interactive node. Got a node required error which is because of interactive so now I can switch this to sbatch! 

```

Execution cancelled -- Finishing pending tasks before exit
Pulling Singularity image https://depot.galaxyproject.org/singularity/multiqc:1.29--pyhdfd78af_0 [cache /scratch3/workspace/emma_strand_uri_edu-shared/BleachingPairs_WGBS/apptainer_cache/depot.galaxyproject.org-singularity-multiq
c-1.29--pyhdfd78af_0.img]
-[nf-core/methylseq] Pipeline completed with errors-
ERROR ~ Error executing process > 'NFCORE_METHYLSEQ:METHYLSEQ:TRIMGALORE (HI_17)'
Caused by:
  Process requirement exceeds available CPUs -- req: 12; avail: 1
```

**7-18-2025**: The work directory didn't export to /scratch so I stopped and changed memory, added skip fastqc, multiqc, took out the save unmapped reads, and up'd the memory and tasks. I got an error and need to unzip this again. Got a node required error which is because of interactive so now I can switch this to sbatch! 

Take out windows characters: `sed -i 's/\r$//' 01-KBay_WGBS_nexflow.sh`

Finished!! 

### Sorting deduplicated bam files 

*The pipeline does already, yay.*

### Running biscuit on deduplicated bam files 

https://shellywanamaker.github.io/401th-post/

https://huishenlab.github.io/biscuit/

Start conda environment to download biscuit in

```
## path to putnamlab conda environments 
/work/pi_hputnam_uri_edu/conda/envs

## I need to set up conda channels (only once)
conda config --add channels defaults
conda config --add channels conda-forge
conda config --add channels bioconda
conda config --set channel_priority strict

## making new conda environment inthat path so all can use it
conda create --prefix /work/pi_hputnam_uri_edu/conda/envs/biscuit biscuit

## test that 
conda activate /work/pi_hputnam_uri_edu/conda/envs/biscuit
```

Run the script. Shelly had trouble with the sample name not retained through subsequent steps so she can a foor loop. This below will do a slurm array. 

`nano 02-biscuit_SNP.sh`:

```
#!/usr/bin/env bash
#SBATCH --export=NONE
#SBATCH --nodes=1 --ntasks-per-node=12
#SBATCH --partition=uri-cpu
#SBATCH --no-requeue
#SBATCH --mem=50GB
#SBATCH -t 120:00:00
#SBATCH -o output/biscuit/"%x_output.%j"
#SBATCH -e output/biscuit/"%x_error.%j"

## Load Conda environment with biscuit downloaded 
module load conda/latest
conda activate /work/pi_hputnam_uri_edu/conda/envs/biscuit

## Set output directories to use scratch
out="/scratch3/workspace/emma_strand_uri_edu-shared/BleachingPairs_WGBS/biscuit"
ref="/work/pi_hputnam_uri_edu/estrand/BleachingPairs_WGBS/Montipora_capitata_HIv3.assembly.fasta"

## set paths
deduplicated_bams="/scratch3/workspace/emma_strand_uri_edu-shared/BleachingPairs_WGBS/bismark/deduplicated"
biscuit_path="/work/pi_hputnam_uri_edu/conda/envs/biscuit/bin"

## CREATE SAMPLE LIST FOR SLURM ARRAY
### 1. Create list of all .gz files in raw data path
ls -d ${deduplicated_bams}/*sorted.bam > ${deduplicated_bams}/samplelist

### 2. Create a list of filenames based on that list created in step 1
mapfile -t FILENAMES < ${deduplicated_bams}/samplelist

### 3. Create variable i that will assign each row of FILENAMES to a task ID
i=${FILENAMES[$SLURM_ARRAY_TASK_ID]}

# Create a pileup VCF of DNA methylation and genetic information
# Also compresses and indexes the VCF

filename=${i##*/}

${biscuit_path}/biscuit pileup -q 48 -o ${out}/${filename}.vcf ${ref} ${i}

bgzip --threads 48 ${out}/${filename}.vcf
tabix -p vcf ${out}/${filename}.vcf.gz

# Extract DNA methylation into BED format
# Also compresses and indexes the BED
${biscuit_path}/biscuit vcf2bed ${out}/${filename}.vcf.gz > ${out}/${filename}.bed

bgzip ${out}/${filename}.bed
tabix -p bed ${out}/${filename}.bed.gz
```

To run that with 40 files: `sbatch --array=1-40 02-biscuit_SNP.sh`. 

Because I didn't use the `-t snp` flag on the vcf2bed command above, I decided to make a new script instead of running the above all over again.

`nano 03-biscuit_vcf2bed.sh`:

Prior to running, I installed `conda install -c bioconda bcftools`

```
#!/usr/bin/env bash
#SBATCH --export=NONE
#SBATCH --nodes=1 --ntasks-per-node=12
#SBATCH --partition=uri-cpu
#SBATCH --no-requeue
#SBATCH --mem=50GB
#SBATCH -t 120:00:00
#SBATCH -o output/biscuit/"%x_output.%j"
#SBATCH -e output/biscuit/"%x_error.%j"

## Load Conda environment with biscuit downloaded 
module load conda/latest
conda activate /work/pi_hputnam_uri_edu/conda/envs/biscuit

## Set paths
biscuit_path="/work/pi_hputnam_uri_edu/conda/envs/biscuit/bin"
input="/scratch3/workspace/emma_strand_uri_edu-shared/BleachingPairs_WGBS/biscuit"
out="/scratch3/workspace/emma_strand_uri_edu-shared/BleachingPairs_WGBS/biscuit/filtered_vcfs"

## Filter with bcftools 
for i in ${input}/*.vcf.gz; do
    filename=$(basename "$i" .vcf.gz)

    bcftools view -i 'FILTER="PASS" && QUAL>=15 && FORMAT/DP>=3 && FORMAT/GQ>=15' "$i" -Oz -o "${out}/${filename}.filtered.vcf.gz"

    tabix -p vcf "${out}/${filename}.filtered.vcf.gz"
done
```

To run: `sbatch 03-biscuit_vcf2bed.sh`

## Filtering to CT SNPs only 

`nano 04-CT_SNP.sh` 

```
#!/usr/bin/env bash
#SBATCH --export=NONE
#SBATCH --nodes=1 --ntasks-per-node=12
#SBATCH --partition=uri-cpu
#SBATCH --no-requeue
#SBATCH --mem=50GB
#SBATCH -t 120:00:00
#SBATCH -o output/biscuit/"%x_output.%j"
#SBATCH -e output/biscuit/"%x_error.%j"

## Load Conda environment with biscuit downloaded 
module load conda/latest
conda activate /work/pi_hputnam_uri_edu/conda/envs/biscuit

## Set paths
biscuit_path="/work/pi_hputnam_uri_edu/conda/envs/biscuit/bin"
input="/scratch3/workspace/emma_strand_uri_edu-shared/BleachingPairs_WGBS/biscuit"
out="/scratch3/workspace/emma_strand_uri_edu-shared/BleachingPairs_WGBS/biscuit/filtered_vcfs"

## Merge to one large vcf file
bcftools merge ${out}/*.filtered.vcf.gz -Oz -o ${out}/merged.filtered.vcf.gz
tabix -p vcf ${out}/merged.filtered.vcf.gz

## Focus on CT/GA SNPs only
bcftools view -i '((REF="C" & ALT="T") | (REF="G" & ALT="A"))' ${out}/merged.filtered.vcf.gz -Oz -o ${out}/ct_snps.vcf.gz
bcftools index ${out}/ct_snps.vcf.gz

## CT SNPs in at least 10% of samples
bcftools view -i 'N_PASS(GT!="mis")>=4' ${out}/ct_snps.vcf.gz -Oz -o ${out}/ct_snps.10p.vcf.gz
```

To create list of locations:

```
srun --pty bash 
module load conda/latest
conda activate /work/pi_hputnam_uri_edu/conda/envs/biscuit

out="/scratch3/workspace/emma_strand_uri_edu-shared/BleachingPairs_WGBS/biscuit/filtered_vcfs"
bcftools query -f '%CHROM\t%POS\n' ${out}/ct_snps.10p.vcf > ${out}/ct_snps.10p.locations.txt
bcftools query -f '%CHROM\t%POS\n' ${out}/ct_snps.vcf > ${out}/ct_snps.locations.txt
```


#### Troubleshooting

**7-23-2025**: I tried this for the first time with array of 1-40. This couldn't find the conda command so I added `module load conda/latest` to load the latest version of conda. 

**7-25-2025/7-28-2025** OK this worked but now get the below error because I don't have bgzip and tabix (`conda install -c bioconda htslib`). Successfully installed and will try again. 

```
pileup: invalid option -- '@'
[main_pileup:1302] Unrecognized command/option: ?.
/var/spool/slurm/slurmd/job40305031/slurm_script: line 42: bgzip: command not found
/var/spool/slurm/slurmd/job40305031/slurm_script: line 43: tabix: command not found
[wzopen:20] Fatal, cannot open file: filename.vcf.gz
/var/spool/slurm/slurmd/job40305031/slurm_script: line 49: bgzip: command not found
/var/spool/slurm/slurmd/job40305031/slurm_script: line 50: tabix: command not found
```

Added the full path to biscuit too just in case it's not finding this program. OK this is better now! Now this error that tells me I need to remove the extra 'biscuit' in the file path.


```
/var/spool/slurm/slurmd/job40371768/slurm_script: line 38: /work/pi_hputnam_uri_edu/conda/envs/biscuit/bin/biscuit/biscuit: Not a directory
[bgzip] No such file or directory: filename.vcf
tbx_index_build failed: filename.vcf.gz
/var/spool/slurm/slurmd/job40371768/slurm_script: line 45: /work/pi_hputnam_uri_edu/conda/envs/biscuit/bin/biscuit/biscuit: Not a directory
[bgzip] can't create filename.bed.gz: File exists
[tabix] the index file exists. Please use '-f' to overwrite.
```

I still get the filename.vcf issue:

```
[bgzip] No such file or directory: filename.vcf
tbx_index_build failed: filename.vcf.gz
[wzopen:20] Fatal, cannot open file: filename.vcf.gz
[bgzip] can't create filename.bed.gz: File exists
[tabix] the index file exists. Please use '-f' to overwrite.
```

OK this is now recognizing the file name, but still no biscuit... using -p instead for pileup and --threads for bgzip. 

```
pileup: invalid option -- '@'
[main_pileup:1302] Unrecognized command/option: ?.
[bgzip] No such file or directory: /scratch3/workspace/emma_strand_uri_edu-shared/BleachingPairs_WGBS/biscuit/HI_17.deduplicated.sorted.bam.vcf
tbx_index_build failed: /scratch3/workspace/emma_strand_uri_edu-shared/BleachingPairs_WGBS/biscuit/HI_17.deduplicated.sorted.bam.vcf.gz
[wzopen:20] Fatal, cannot open file: /scratch3/workspace/emma_strand_uri_edu-shared/BleachingPairs_WGBS/biscuit/HI_17.deduplicated.sorted.bam.vcf.gz
```

OK now I get this error. This can't find the {i} file so it aborts that function. Realized that it needs to be ${i}. 

```
[E::hts_open_format] fail to open file '{i}'
[main_pileup:1361] Cannot open {i}
Abort.
[bgzip] No such file or directory: /scratch3/workspace/emma_strand_uri_edu-shared/BleachingPairs_WGBS/biscuit/HI_18.deduplicated.sorted.bam.vcf
tbx_index_build failed: /scratch3/workspace/emma_strand_uri_edu-shared/BleachingPairs_WGBS/biscuit/HI_18.deduplicated.sorted.bam.vcf.gz
[wzopen:20] Fatal, cannot open file: /scratch3/workspace/emma_strand_uri_edu-shared/BleachingPairs_WGBS/biscuit/HI_18.deduplicated.sorted.bam.vcf.gz
[bgzip] can't create /scratch3/workspace/emma_strand_uri_edu-shared/BleachingPairs_WGBS/biscuit/HI_18.deduplicated.sorted.bam.bed.gz: File exists
[tabix] the index file exists. Please use '-f' to overwrite.
```

**8-4-2025** Running this again after adding $. This ran! I now have vcf and bam.bed outputs. Some files have an average tsv output.. What is this? Eg `HI_39.deduplicated.sorted.bam.vcf_meth_average.tsv`. Files that don't have this: 17, 18. 

From the error file in 17 and 18. This error file also had building reference... Maybe this was happening simultaneously and then was fine for the rest? Maybe I can just re-run these two files? This also didn't run HI-16, probably because I did 1-40 instead of 0-39 within the slurm array. 

```
[fai_load] build FASTA index.
[refcache_fetch:95] Error, cannot retrieve reference Montipora_capitata_HIv3___Scaffold_1:0-0.
```

**8-5-2025** I made 3 new scripts with just the 16, 17, and 18 input files so they are running individually.

Next Steps:
- How to analyze vcf files   
- How to get CT snps from bed files?


**8-13-2025**: I need to add `-t snp` to extract snp information into the bed file. Edited line: `${biscuit_path}/biscuit vcf2bed -t cg ${out}/${filename}.vcf.gz > ${out}/${filename}.bed`. 

Then from bed file do but probably only one direction... re-visit to figure out which

`awk '($5=="C" && $6=="T") || ($5=="T" && $6=="C")' yourfile.snp.bed > yourfile.CT_snp.bed`

Get this for every sample, then do I filter those sites. Picked only the CT SNPs. 

**8-14-2025** Ran script 03 to create SNP bed file and then wrote 04 to filter to CT SNPs. Script 3 worked and running script #4 to produce CT list. I can read that into R and filter out of the DNA methylation matrix. 


**8-18-2025**: No error or output file but `head X file` produces an empty file. Because I was originally calling columsn 5 and 6 but it's supposed to be 4 and 5.

Checking for what unique values in the 7th column: `awk '!/^#/ {print $7}' HI_45.deduplicated.sorted.bam.vcf | sort | uniq` after unzipping that file. That is taking too long.. Need to filter for high quality SNPs in between current script 3 and 4 since the vcf is the only file with this column...

**8-25-2025 / 8-26-2025**: Re-running script #3 for filtering for high quality SNPs and then prepping script 4 re-run on the filtered vcfs. 

I then added more stringent filtering and combined script 3 and 4. 

**8-27-2025**: I added the filtering but this resulted in 0 SNPs and empty file... Testing a couple filters on one vcf file. Maybe our quality is too poor?

```
module load conda/latest
conda activate /work/pi_hputnam_uri_edu/conda/envs/biscuit

bcftools view -i 'FILTER="PASS" && QUAL>=30 && TYPE="snp"' HI_16.deduplicated.sorted.bam.vcf -Oz -o HI_16.deduplicated.sorted.bam.filtered.PASS30snp.vcf.gz
```

This worked! Let's try the full thing. If this works then I was missing the 1 on AF1. Yes it did! 

```
bcftools view -i 'FILTER="PASS" && QUAL>=30 && FORMAT/DP>=10 && FORMAT/DP<=150 && FORMAT/GQ>=20 && FORMAT/AF1>=0.3' HI_16.deduplicated.sorted.bam.vcf -Oz -o HI_16.deduplicated.sorted.bam.filtered.PASS30snp.vcf.gz
```

**9-2-2025**: There were hardly any SNPs so I changed the DP to 5 and will see what the output looks like. This still has no SNPs... Chagning to GT to 10 not 20 and see what happens.

**9-3-2025**: Count number of SNPs in the merged file: `grep -v "^#" merged.filtered.vcf | wc -l` = 1,488,240 and in the 100% file: `grep -v "^#" merged.filtered.100pct.vcf | wc -l`

```
grep -v "^#" merged.filtered.vcf | wc -l ## 1,488,240
grep -v "^#" merged.filtered.39.vcf | wc -l ## 7
grep -v "^#" merged.filtered.36.vcf | wc -l ## 19
grep -v "^#" merged.filtered.28.vcf | wc -l ## 132
grep -v "^#" merged.filtered.20.vcf | wc -l ## 1,202
```

I must be not understanding the filtering to SNPs in X samples correctly.

**9-3-2025**: My filtering is likely way too strict. `&& FORMAT/AF1>=0.3` and trying that. This is better! Still not a lot. 

```
grep -v "^#" merged.filtered.39.vcf | wc -l ## 1,187 
grep -v "^#" merged.filtered.28.vcf | wc -l ## 49,192 
grep -v "^#" merged.filtered.20.vcf | wc -l ## 423,795 
```

**10-15-2025**: I'm lowering the quality thresholds and the max depth filter to see if this retains more. I'll probably land on a middle ground of quality and data. I could probably go back up to 20/20 for the quality thresholds or at least 15. 

`unzip.sh`

```
#!/usr/bin/env bash
#SBATCH --export=NONE
#SBATCH --nodes=1 --ntasks-per-node=12
#SBATCH --partition=uri-cpu
#SBATCH --no-requeue
#SBATCH --mem=50GB
#SBATCH -t 120:00:00

cd /scratch3/workspace/emma_strand_uri_edu-shared/BleachingPairs_WGBS/biscuit/filtered_vcfs

gunzip *merged.filtered.*.vcf.gz 
```

```
grep -v "^#" merged.filtered.vcf | wc -l ##  ## accidentally deleted this one. 

grep -v "^#" merged.filtered.39.vcf | wc -l ## 378,220
grep -v "^#" merged.filtered.36.vcf | wc -l ## 3,187,236
grep -v "^#" merged.filtered.28.vcf | wc -l ## 22,341,447
grep -v "^#" merged.filtered.20.vcf | wc -l ## too big 
```

**10-21-2025**: Rethinking this filtering and think it needs to be lower... A SNP isn't likely to come up in all of the samples. 10%? 

```

# Filter merged VCF to SNPs present in all samples (no missing genotypes)
bcftools view -g ^miss ${out}/merged.filtered.vcf.gz -Oz -o ${out}/merged.filtered.100pct.vcf.gz

bcftools view -i 'N_PASS(GT!="mis")>=39' ${out}/merged.filtered.vcf.gz -Oz -o ${out}/merged.filtered.39.vcf.gz
bcftools view -i 'N_PASS(GT!="mis")>=36' ${out}/merged.filtered.vcf.gz -Oz -o ${out}/merged.filtered.36.vcf.gz
bcftools view -i 'N_PASS(GT!="mis")>=28' ${out}/merged.filtered.vcf.gz -Oz -o ${out}/merged.filtered.28.vcf.gz
bcftools view -i 'N_PASS(GT!="mis")>=20' ${out}/merged.filtered.vcf.gz -Oz -o ${out}/merged.filtered.20.vcf.gz

tabix -p vcf ${out}/merged.filtered.100pct.vcf.gz

## Create SNP.bed file from merged.filtered.36.vcf.gz
${biscuit_path}/biscuit vcf2bed -t snp ${out}/merged.filtered.36.vcf.gz > ${out}/merged.filtered.36.SNP.bed

bgzip ${out}/merged.filtered.100pct.SNP.bed
tabix -p bed ${out}/merged.filtered.36.SNP.bed.gz

## Filter merged.filtered.100pct.SNP.bed.gz to only C>T SNPs (settled on present in 90%)
zcat ${out}/merged.filtered.36.SNP.bed | awk '($4=="C" && $5=="T")' > ${out}/merged.filtered.36.CTonly_SNP.bed
```

**10-22-2025**: Ran script 4 now that script 3 with 15 values mininums run. I think a low % is better for methylation here. 

```
gunzip ct_snps.*gz

grep -v "^#" ct_snps.10p.vcf | wc -l  ## 703,807 SNPs
grep -v "^#" ct_snps.vcf | wc -l ## 804,220 
```

Create list of the locations and now I can use that to filter my methylation matrix!! 