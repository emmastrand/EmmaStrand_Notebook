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
### headers: sample,fastq_1,fastq_2,genome

## Load libraries 
library(dplyr)
library(stringr)
library(strex) 

### Read in sample sheet 

sample_list <- read.delim2("/work/pi_hputnam_uri_edu/estrand/HoloInt_WGBS/rawdata_file_list", header=F) %>% 
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

sample_list %>% write.csv("/work/pi_hputnam_uri_edu/estrand/HoloInt_WGBS/samplesheet.csv", 
                          row.names=FALSE, quote = FALSE)
```

### Nextflow methyl-seq

`01-HoloInt_WGBS_nexflow.sh`

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
out="/scratch3/workspace/emma_strand_uri_edu-shared/HoloIntWGBS"

export NXF_WORK=${out}/nextflow_work
export NXF_TEMP=${out}/nextflow_temp
export NXF_LAUNCHER=${out}/nextflow_launcher

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
--outdir ${out} \
--skip_fastqc --skip_multiqc
```

Testing to see if .sh works, `salloc` to grab an interactive node and `bash 01-HoloInt_WGBS_nexflow.sh`

### Moving all output to one folder

I did this in batches so I need to move all the deduplicated files to one spot for biscuit. 

`mkdir /scratch3/workspace/emma_strand_uri_edu-shared/HoloInt_all_deduplicated` 

## Biscuit to identify SNPs 

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
out="/scratch3/workspace/emma_strand_uri_edu-shared/HoloInt_all_deduplicated/biscuit"
ref="/work/pi_hputnam_uri_edu/estrand/HoloInt_WGBS/Pocillopora_acuta_HIv2.assembly.fasta"

## set paths
deduplicated_bams="/scratch3/workspace/emma_strand_uri_edu-shared/HoloInt_all_deduplicated"
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
```

To run that with 60 files: `sbatch --array=0-59 02-biscuit_SNP.sh`. 

## SNP filtering 

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
input="/scratch3/workspace/emma_strand_uri_edu-shared/HoloInt_all_deduplicated/biscuit"
out="/scratch3/workspace/emma_strand_uri_edu-shared/HoloInt_all_deduplicated/biscuit/filtered_vcfs"

## Filter with vcftools 
for i in ${input}/*.vcf.gz; do
    filename=$(basename "$i" .vcf.gz)

    bcftools view -i 'FILTER="PASS" && QUAL>=20 && FORMAT/DP>=3 && FORMAT/GQ>=20' "$i" -Oz -o "${out}/${filename}.filtered.vcf.gz"

    tabix -p vcf "${out}/${filename}.filtered.vcf.gz"
done

## Merge to one large vcf file
bcftools merge ${out}/*.filtered.vcf.gz -Oz -o ${out}/merged.filtered.vcf.gz
#tabix -p vcf ${out}/merged.filtered.vcf.gz
```

To run: `sbatch 03-biscuit_vcf2bed.sh`

Headers within the merged file are: HI_1051.deduplicated.sorted 

I need a metadata file that matches these column headers to the ploidy group they are in.
Create triploid and diploid files:

```
awk -F, '{gsub(/\r/,""); if(tolower($2)=="triploid") print $1}' /work/pi_hputnam_uri_edu/estrand/HoloInt_WGBS/vcf_metadata.csv > triploid_samples.txt
awk -F, '{gsub(/\r/,""); if(tolower($2)=="diploid") print $1}' /work/pi_hputnam_uri_edu/estrand/HoloInt_WGBS/vcf_metadata.csv > diploid_samples.txt
```

Install python and pandas for the python script included:

```
module load conda/latest
conda activate /work/pi_hputnam_uri_edu/conda/envs/biscuit
conda install -c conda-forge python=3.9 pandas -y
```

## Filtering SNPs

`nano 04-ploidy_SNPs.sh`

```
#!/usr/bin/env bash
#SBATCH --export=NONE
#SBATCH --nodes=1 --ntasks-per-node=12
#SBATCH --partition=uri-cpu
#SBATCH --no-requeue
#SBATCH --mem=50GB
#SBATCH -t 120:00:00
#SBATCH -o output/SNP_ploidy/"%x_output.%j"
#SBATCH -e output/SNP_ploidy/"%x_error.%j"

## Load Conda environment with biscuit downloaded 
module load conda/latest
conda activate /work/pi_hputnam_uri_edu/conda/envs/biscuit

## Set paths
biscuit_path="/work/pi_hputnam_uri_edu/conda/envs/biscuit/bin"
input="/scratch3/workspace/emma_strand_uri_edu-shared/HoloInt_all_deduplicated/biscuit"
out="/scratch3/workspace/emma_strand_uri_edu-shared/HoloInt_all_deduplicated/biscuit/filtered_vcfs"

## 1. Focus on CT/GA SNPs only
bcftools view -i '((REF="C" & ALT="T") | (REF="G" & ALT="A"))' ${out}/merged.filtered.vcf.gz -Oz -o ${out}/ct_snps.vcf.gz
bcftools index ${out}/ct_snps.vcf.gz

## 2. Split merged SNPs by group
bcftools view -S ${out}/triploid_samples.txt ${out}/ct_snps.vcf.gz -Oz -o ${out}/triploid.vcf.gz
bcftools view -S ${out}/diploid_samples.txt ${out}/ct_snps.vcf.gz -Oz -o ${out}/diploid.vcf.gz

## 3. Generate genotype tables
bcftools query -f '%CHROM\t%POS[\t%GT]\n' ${out}/triploid.vcf.gz > ${out}/triploid_genotypes.tsv
bcftools query -f '%CHROM\t%POS[\t%GT]\n' ${out}/diploid.vcf.gz > ${out}/diploid_genotypes.tsv

# 4. Python analysis: find SNPs ≥90% triploids and ≤10% diploids, vice versa, and ≥70% overall
python <<'EOF'
import pandas as pd

out = "/scratch3/workspace/emma_strand_uri_edu-shared/HoloInt_all_deduplicated/biscuit/filtered_vcfs"
trip = pd.read_csv(f"{out}/triploid_genotypes.tsv", sep="\t", header=None)
dip = pd.read_csv(f"{out}/diploid_genotypes.tsv", sep="\t", header=None)

def is_variant(gt):
    return gt not in ["0/0", "./."]

trip["trip_count"] = trip.iloc[:, 2:].apply(lambda r: sum(is_variant(x) for x in r), axis=1)
dip["dip_count"] = dip.iloc[:, 2:].apply(lambda r: sum(is_variant(x) for x in r), axis=1)

trip_frac = trip["trip_count"] / (trip.shape[1] - 2)
dip_frac = dip["dip_count"] / (dip.shape[1] - 2)

# Triploid-specific: ≥80% triploid, ≤20% diploid
trip_specific = trip[(trip_frac >= 0.8) & (dip_frac <= 0.2)]
trip_specific[[0, 1]].to_csv(f"{out}/triploid_specific_ct_snps.txt", sep="\t", index=False, header=False)

# Diploid-specific: ≥80% diploid, ≤20% triploid
dip_specific = trip[(dip_frac >= 0.8) & (trip_frac <= 0.2)]
dip_specific[[0, 1]].to_csv(f"{out}/diploid_specific_ct_snps.txt", sep="\t", index=False, header=False)

# Combine all samples and find SNPs in ≥10% of total
merged = pd.concat([trip, dip], axis=1)
merged = merged.loc[:, ~merged.columns.duplicated()]  # remove duplicate CHROM/POS
all_gt = pd.concat([trip.iloc[:, 2:-2], dip.iloc[:, 2:-2]], axis=1)
merged["all_count"] = all_gt.apply(lambda r: sum(is_variant(x) for x in r), axis=1)
all_frac = merged["all_count"] / all_gt.shape[1]

common = merged[all_frac >= 0.1]
common[[0, 1]].to_csv(f"{out}/common_10pct_ct_snps.txt", sep="\t", index=False, header=False)
EOF

## creating location file 
bcftools query -f '%CHROM\t%POS\n' ${out}/ct_snps.10p.vcf > ${out}/ct_snps.10p.locations.txt
bcftools query -f '%CHROM\t%POS\n' ${out}/ct_snps.vcf > ${out}/ct_snps.locations.txt
```

To run: `sbatch 04-ploidy_SNPs.sh`


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

**7-18-2025**: The work directory was in the /work putnam folder not my scratch. Changed memory/node allocation, skip fastqc and multiqc steps. Que'd again 

Take out windows characters: `sed -i 's/\r$//' 01-HoloInt_WGBS_nexflow.sh`

**7-23-2025** This worked! but only got through 50/50. I used `seff` to see that 90% CPUs were used and 100% of memory allocation was used. I up'd both of those and then made a subset of csv and script to run just the last 10 files in a new output folder. The steps/samples aren't dependent on each other so this should be fine. 

`(head -n 1 samplesheet.csv && tail -n 10 samplesheet.csv) > samplesheet_last10.csv`

Que'd again. This worked! 

**7-25-2025**: But I need to re-run one with the 50 samples. I also changed the output directory and then que'd again. 

`(head -n 51 samplesheet.csv) > samplesheet_first50.csv`

I got this error: `slurmstepd-uri-cpu039: error: Detected 3 oom_kill events in StepId=40304713.batch. Some of the step tasks have been OOM Killed.` This says out of memory, maybe I'll split the 50 into 25 and 25...

```
executor >  local (80)
[-        ] NFC…DEX_BISMARK_BWAMETH:GUNZIP -
[f0/7c700f] NFC…acuta_HIv2.assembly.fasta) | 1 of 1 ✔
[-        ] NFC…HYLSEQ:METHYLSEQ:CAT_FASTQ -
[7b/2b31a3] NFC…YLSEQ:TRIMGALORE (HI_1427) | 50 of 50 ✔
[0b/b08831] NFC…RK:BISMARK_ALIGN (HI_1732) | 29 of 50, failed: 1
[-        ] NFC…ISMARK:BISMARK_DEDUPLICATE | 0 of 23
[-        ] NFC…EDUP_BISMARK:SAMTOOLS_SORT -
[-        ] NFC…DUP_BISMARK:SAMTOOLS_INDEX -
[-        ] NFC…SMARK_METHYLATIONEXTRACTOR -
[-        ] NFC…:BISMARK_COVERAGE2CYTOSINE -
[-        ] NFC…DUP_BISMARK:BISMARK_REPORT -
[-        ] NFC…UP_BISMARK:BISMARK_SUMMARY -
-[nf-core/methylseq] Pipeline completed with errors-
ERROR ~ Error executing process > 'NFCORE_METHYLSEQ:METHYLSEQ:FASTQ_ALIGN_DEDUP_BISMARK:BISMARK_ALIGN (HI_1709)'

Caused by:
  Process `NFCORE_METHYLSEQ:METHYLSEQ:FASTQ_ALIGN_DEDUP_BISMARK:BISMARK_ALIGN (HI_1709)` terminated with an error exit status (255)
```

**8-4-2025**: I downloaded the full samplesheet and split into csvs with 10 files each. Start fresh so I don't miss any files. I tried to run them all at once but the 1-10 got a memory error and the rest couldn't run at the same time. So now I'm doing 1-10 by itself with 600 GB. 

**8-18-2025**: I ran all 60 again with more GB and it finished 59/60 before time ran out. I'll re-do the missing sample 1709.

**8-25-2025**: changed GB To 400 and re-do 1709. FINALLY FINISHED, it had ~20X the data so this was why.

**9-2-2025**: There were hardly any SNPs so I changed the DP to 5 and will see what the output looks like.

**10-15-2025**: Replacing high thresholds with lower ones: 

```
## old
bcftools view -i 'FILTER="PASS" && QUAL>=30 && FORMAT/DP>=5 && FORMAT/DP<=150 && FORMAT/GQ>=20 && FORMAT/AF1>=0.3' "$i" -Oz -o "${out}/${filename}.filtered.vcf.gz"

## new 
bcftools view -i 'FILTER="PASS" && QUAL>=10 && FORMAT/DP>=3 && FORMAT/GQ>=10' "$i" -Oz -o "${out}/${filename}.filtered.vcf.gz"
```

**10-15-2025**: I'm lowering the quality thresholds and the max depth filter to see if this retains more. 59 total, went up to 15 quality threshold for bleaching pairs project. 

`unzip.sh`

```
#!/usr/bin/env bash
#SBATCH --export=NONE
#SBATCH --nodes=1 --ntasks-per-node=12
#SBATCH --partition=uri-cpu
#SBATCH --no-requeue
#SBATCH --mem=10GB
#SBATCH -t 120:00:00

cd /scratch3/workspace/emma_strand_uri_edu-shared/HoloInt_all_deduplicated/biscuit/filtered_vcfs

gunzip *merged.filtered.*.vcf.gz 
```

```
grep -v "^#" merged.filtered.53.vcf | wc -l ## 10,287,406
grep -v "^#" merged.filtered.47.vcf | wc -l ##  
grep -v "^#" merged.filtered.41.vcf | wc -l ##  
grep -v "^#" merged.filtered.35.vcf | wc -l ##  
```

Removing this code before filtering by trip and dip 

```

# Filter merged VCF to SNPs present in all samples (no missing genotypes)
bcftools view -g ^miss ${out}/merged.filtered.vcf.gz -Oz -o ${out}/merged.filtered.100pct.vcf.gz

bcftools view -i 'N_PASS(GT!="mis")>=53' ${out}/merged.filtered.vcf.gz -Oz -o ${out}/merged.filtered.53.vcf.gz

bcftools view -i 'N_PASS(GT!="mis")>=47' ${out}/merged.filtered.vcf.gz -Oz -o ${out}/merged.filtered.47.vcf.gz

bcftools view -i 'N_PASS(GT!="mis")>=41' ${out}/merged.filtered.vcf.gz -Oz -o ${out}/merged.filtered.41.vcf.gz

bcftools view -i 'N_PASS(GT!="mis")>=35' ${out}/merged.filtered.vcf.gz -Oz -o ${out}/merged.filtered.35.vcf.gz

## Create SNP.bed file from merged.filtered.100pct.vcf.gz
${biscuit_path}/biscuit vcf2bed -t snp ${out}/merged.filtered.100pct.vcf.gz > ${out}/merged.filtered.100pct.SNP.bed
bgzip ${out}/merged.filtered.100pct.SNP.bed
tabix -p bed ${out}/merged.filtered.100pct.SNP.bed.gz

## Filter merged.filtered.100pct.SNP.bed.gz to only C>T SNPs
zcat ${out}/merged.filtered.100pct.SNP.bed.gz | awk '($4=="C" && $5=="T")' > ${out}/merged.filtered.100pct.CTonly_SNP.bed
```

**10-21-2025**: Viewing ct SNPs prior to triploid or diploid specific filtering. Added diploid only and a filter to get SNPs in at least 10% of samples (n=5 minimum individuals to be called a SNP). 

`gunzip ct_snps.vcf`
`grep -v "^#" ct_snps.vcf | wc -l` 4,556,893 SNPs 

**10-22-2025**: I still had the file name as 70%, change to 10%: `common_70pct_ct_snps` to `common_10pct_ct_snps`. 682,915 CT SNPs to use. Now that I'll use the 10% filter, then I'll up the quality from script #3. Up'd those outputs to 20 minimum value to see how many SNPs come out (Were 10 before). 

```
emma_strand_uri_edu@login1:/scratch3/workspace/emma_strand_uri_edu-shared/HoloInt_all_deduplicated/biscuit/filtered_vcfs$ wc common_10pct_ct_snps.txt 
  682915  1365830 29873475 common_10pct_ct_snps.txt
```

With min 20 quality:  

`gunzip ct_snps.vcf`
`grep -v "^#" ct_snps.vcf | wc -l` 4,556,893 SNPs 

Re-do locations:

```
srun --pty bash 
module load conda/latest
conda activate /work/pi_hputnam_uri_edu/conda/envs/biscuit
out="/scratch3/workspace/emma_strand_uri_edu-shared/HoloInt_all_deduplicated/biscuit/filtered_vcfs"

bcftools query -f '%CHROM\t%POS\n' ${out}/ct_snps.vcf > ${out}/ct_snps.locations.txt

## creating 10% file 
bcftools view -i 'N_PASS(GT!="mis")>=6' ${out}/ct_snps.vcf -Oz -o ${out}/ct_snps.10p.vcf

bcftools query -f '%CHROM\t%POS\n' ${out}/ct_snps.10p.vcf > ${out}/ct_snps.10p.locations.txt

wc ct_snps.10p.locations.txt ## 4,445,809
wc ct_snps.locations.txt ## 4,556,893
```

Create list of the locations and now I can use that to filter my methylation matrix!! 


Creating a tar file from .vcf.gz 

`nano tar.sh` 

```
#!/usr/bin/env bash
#SBATCH --export=NONE
#SBATCH --nodes=1 --ntasks-per-node=48
#SBATCH --partition=uri-cpu
#SBATCH --no-requeue
#SBATCH --mem=50GB
#SBATCH -t 120:00:00

# Set the input and output directories
input_vcfs="/scratch3/workspace/emma_strand_uri_edu-shared/HoloInt_all_deduplicated/biscuit/filtered_vcfs"
input_bam="/scratch3/workspace/emma_strand_uri_edu-shared/HoloInt_all_deduplicated"
output_dir="/work/pi_hputnam_uri_edu/estrand/HoloInt_WGBS/"

# Create tar archive of all .vcf.gz files
cd "${input_vcfs}"
tar -cvf "${output_dir}/all_nonfiltered_vcfs.tar" *.vcf.gz

# Verify the contents of the tar file
tar -tvf "${output_dir}/all_nonfiltered_vcfs.tar"

# Print completion message
echo "Tar archive created successfully at: ${output_dir}/all_nonfiltered_vcfs.tar"

#### BAM files 
# Create tar archive of all .vcf.gz files
cd "${input_bam}"
tar -cvf "${output_dir}/all_dedup_sorted_bam.tar" *.bam

# Verify the contents of the tar file
tar -tvf "${output_dir}/all_dedup_sorted_bam.tar"

# Print completion message
echo "Tar archive created successfully at: ${output_dir}/all_dedup_sorted_bam.tar"

```
