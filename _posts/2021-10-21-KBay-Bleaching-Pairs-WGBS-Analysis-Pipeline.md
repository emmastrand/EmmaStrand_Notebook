---
layout: post
title: KBay Bleaching Pairs WGBS Analysis Pipeline
date: '2021-10-21'
categories: Processing
tags: DNA, methylation, WGBS
projects: KBay Bleaching Pairs
---

# KBAY WGBS Methylation Analysis Pipeline

Raw data folder path: /data/putnamlab/KITT/hputnam/20211008_BleachingPairs_WGBS    
Processed data folder path: /data/putnamlab/estrand/BleachingPairs_WGBS  

References:  
- Wong and Strand WGBS pipeline info: https://github.com/Putnam-Lab/Lab_Management/blob/master/Bioinformatics_%26_Coding/Workflows/Methylation_QC.md  
- Wong Past pipeline: https://github.com/kevinhwong1/Thermal_Transplant_Molecular/blob/main/scripts/Past_WGBS_Workflow.md   
- Wong methylseq trimming tests pipeline: https://kevinhwong1.github.io/KevinHWong_Notebook/Methylseq-trimming-test-to-remove-m-bias/

#### Download genome file from Rutgers

http://cyanophora.rutgers.edu/montipora/ and upload to andromeda.

Contents:  
- [**Setting Up Andromeda**](#Setting_up)  
- [**Initial fastqc on files**](#fastqc)    
- [**Initial Multiqc Report**](#multiqc)    
- [**NF-core: Methylseq**](#Test)  
- [**Bismark Multiqc Report**](#bismark_multiqc)  
- [**Merge Strands**](#merge_strands)  


## <a name="Setting_up"></a> **Setting Up Andromeda**

#### Make a new directory for output files

```
$ mkdir BleachingPairs_WGBS
$ mkdir fastqc_results
$ mkdir scripts
```

#### Download genome file from Rutgers

http://cyanophora.rutgers.edu/montipora/

### Creating a test run folder

Creating a test set folder in case I need to run different iterations of the methylseq script.

```
$ mkdir test_set
$ cp /data/putnamlab/KITT/hputnam/20211008_BleachingPairs_WGBS/16_S138_L003_R{1,2}_001.fastq.gz /data/putnamlab/estrand/BleachingPairs_WGBS/test_set
$ cp /data/putnamlab/KITT/hputnam/20211008_BleachingPairs_WGBS/17_S134_L003_R{1,2}_001.fastq.gz /data/putnamlab/estrand/BleachingPairs_WGBS/test_set
$ cp /data/putnamlab/KITT/hputnam/20211008_BleachingPairs_WGBS/18_S154_L003_R{1,2}_001.fastq.gz /data/putnamlab/estrand/BleachingPairs_WGBS/test_set
$ cp /data/putnamlab/KITT/hputnam/20211008_BleachingPairs_WGBS/21_S119_L003_R{1,2}_001.fastq.gz /data/putnamlab/estrand/BleachingPairs_WGBS/test_set
$ cp /data/putnamlab/KITT/hputnam/20211008_BleachingPairs_WGBS/22_S120_L003_R{1,2}_001.fastq.gz /data/putnamlab/estrand/BleachingPairs_WGBS/test_set
```

## <a name="fastqc"></a> **Initial fastqc on files**

`fastqc.sh`. This took 14 hours for 40 files. Maybe I would do this only on a subset next time.

```
#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_WGBS                
#SBATCH --error="script_error_fastqc" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_fastqc" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

cd /data/putnamlab/estrand/BleachingPairs_WGBS

module load FastQC/0.11.9-Java-11
module load MultiQC/1.9-intel-2020a-Python-3.8.2

for file in /data/putnamlab/KITT/hputnam/20211008_BleachingPairs_WGBS/*fastq.gz
do
fastqc $file --outdir /data/putnamlab/estrand/BleachingPairs_WGBS/fastqc_results         
done

multiqc --interactive fastqc_results
```

The first time I ran this I didn't have the right output path for multiqc because I did 'cd' to the wrong folder. This has been fixed in the script above and I ran the multiqc function

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/BleachingPairs_WGBS/multiqc_report.html /Users/emmastrand/MyProjects/HI_Bleaching_Timeseries/Dec-July-2019-analysis/output/WGBS/initial_multiqc_report.html
```

## <a name="multiqc"></a> **Initial MultiQC Report**

[Full initial multiqc report](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/Dec-July-2019-analysis/output/WGBS/initial_multiqc_report.html)

**All samples have sequences of a single length (151bp).**

| **Sample Name**     | **% Dups** | **% GC** | **M Seqs** |
|---------------------|------------|----------|------------|
| 16_S138_L003_R1_001 |  20.5%     |  25%     |  74.5      |
| 16_S138_L003_R2_001 |  19.6%     |  26%     |  74.5      |
| 17_S134_L003_R1_001 |  18.6%     |  25%     |  65.0      |
| 17_S134_L003_R2_001 |  17.1%     |  25%     |  65.0      |
| 18_S154_L003_R1_001 |  18.6%     |  25%     |  72.9      |
| 18_S154_L003_R2_001 |  19.1%     |  25%     |  72.9      |
| 21_S119_L003_R1_001 |  21.1%     |  25%     |  74.7      |
| 21_S119_L003_R2_001 |  20.6%     |  25%     |  74.7      |
| 22_S120_L003_R1_001 |  17.3%     |  24%     |  55.0      |
| 22_S120_L003_R2_001 |  16.6%     |  24%     |  55.0      |
| 23_S141_L003_R1_001 |  24.3%     |  23%     |  69.3      |
| 23_S141_L003_R2_001 |  23.8%     |  24%     |  69.3      |
| 24_S147_L003_R1_001 |  15.4%     |  24%     |  48.4      |
| 24_S147_L003_R2_001 |  15.7%     |  25%     |  48.4      |
| 25_S148_L003_R1_001 |  21.6%     |  25%     |  137.5     |
| 25_S148_L003_R2_001 |  21.0%     |  25%     |  137.5     |
| 26_S121_L003_R1_001 |  15.5%     |  25%     |  48.8      |
| 26_S121_L003_R2_001 |  15.1%     |  25%     |  48.8      |
| 28_S122_L003_R1_001 |  20.3%     |  25%     |  93.6      |
| 28_S122_L003_R2_001 |  19.6%     |  25%     |  93.6      |
| 29_S153_L003_R1_001 |  25.0%     |  24%     |  105.4     |
| 29_S153_L003_R2_001 |  24.4%     |  24%     |  105.4     |
| 2_S128_L003_R1_001  |  21.9%     |  24%     |  77.3      |
| 2_S128_L003_R2_001  |  21.2%     |  24%     |  77.3      |
| 30_S124_L003_R1_001 |  18.9%     |  24%     |  68.3      |
| 30_S124_L003_R2_001 |  18.1%     |  24%     |  68.3      |
| 31_S127_L003_R1_001 |  13.1%     |  25%     |  21.8      |
| 31_S127_L003_R2_001 |  13.0%     |  25%     |  21.8      |
| 32_S130_L003_R1_001 |  21.7%     |  23%     |  72.7      |
| 32_S130_L003_R2_001 |  21.1%     |  23%     |  72.7      |
| 33_S142_L003_R1_001 |  16.3%     |  24%     |  53.0      |
| 33_S142_L003_R2_001 |  15.7%     |  24%     |  53.0      |
| 34_S136_L003_R1_001 |  16.0%     |  24%     |  60.1      |
| 34_S136_L003_R2_001 |  15.2%     |  24%     |  60.1      |
| 35_S137_L003_R1_001 |  22.6%     |  24%     |  84.9      |
| 35_S137_L003_R2_001 |  21.6%     |  24%     |  84.9      |
| 37_S140_L003_R1_001 |  18.1%     |  24%     |  64.7      |
| 37_S140_L003_R2_001 |  17.1%     |  24%     |  64.7      |
| 38_S129_L003_R1_001 |  14.8%     |  23%     |  49.9      |
| 38_S129_L003_R2_001 |  14.7%     |  23%     |  49.9      |
| 39_S145_L003_R1_001 |  19.6%     |  24%     |  75.3      |
| 39_S145_L003_R2_001 |  19.2%     |  24%     |  75.3      |
| 40_S135_L003_R1_001 |  21.5%     |  25%     |  82.4      |
| 40_S135_L003_R2_001 |  20.8%     |  25%     |  82.4      |
| 41_S151_L003_R1_001 |  19.1%     |  26%     |  70.8      |
| 41_S151_L003_R2_001 |  19.3%     |  26%     |  70.8      |
| 42_S131_L003_R1_001 |  24.0%     |  26%     |  88.6      |
| 42_S131_L003_R2_001 |  23.6%     |  26%     |  88.6      |
| 43_S143_L003_R1_001 |  20.6%     |  24%     |  90.6      |
| 43_S143_L003_R2_001 |  20.1%     |  25%     |  90.6      |
| 44_S125_L003_R1_001 |  19.5%     |  25%     |  68.2      |
| 44_S125_L003_R2_001 |  18.9%     |  25%     |  68.2      |
| 45_S156_L003_R1_001 |  16.7%     |  25%     |  68.5      |
| 45_S156_L003_R2_001 |  16.8%     |  25%     |  68.5      |
| 46_S133_L003_R1_001 |  17.6%     |  25%     |  62.2      |
| 46_S133_L003_R2_001 |  17.2%     |  25%     |  62.2      |
| 47_S155_L003_R1_001 |  17.9%     |  25%     |  75.5      |
| 47_S155_L003_R2_001 |  17.5%     |  25%     |  75.5      |
| 4_S146_L003_R1_001  |  21.7%     |  25%     |  104.3     |
| 4_S146_L003_R2_001  |  21.4%     |  25%     |  104.3     |
| 50_S139_L003_R1_001 |  21.9%     |  24%     |  89.8      |
| 50_S139_L003_R2_001 |  21.1%     |  24%     |  89.8      |
| 51_S126_L003_R1_001 |  18.1%     |  26%     |  61.0      |
| 51_S126_L003_R2_001 |  17.6%     |  26%     |  61.0      |
| 52_S150_L003_R1_001 |  19.1%     |  25%     |  62.5      |
| 52_S150_L003_R2_001 |  19.4%     |  26%     |  62.5      |
| 54_S144_L003_R1_001 |  17.7%     |  24%     |  82.3      |
| 54_S144_L003_R2_001 |  17.4%     |  24%     |  82.3      |
| 55_S123_L003_R1_001 |  20.8%     |  26%     |  100.2     |
| 55_S123_L003_R2_001 |  20.1%     |  26%     |  100.2     |
| 56_S149_L003_R1_001 |  15.1%     |  24%     |  50.3      |
| 56_S149_L003_R2_001 |  14.9%     |  24%     |  50.3      |
| 57_S152_L003_R1_001 |  18.8%     |  24%     |  84.3      |
| 57_S152_L003_R2_001 |  18.5%     |  24%     |  84.3      |
| 58_S157_L003_R1_001 |  21.3%     |  25%     |  60.8      |
| 58_S157_L003_R2_001 |  21.2%     |  26%     |  60.8      |
| 59_S158_L003_R1_001 |  14.7%     |  24%     |  61.0      |
| 59_S158_L003_R2_001 |  14.8%     |  24%     |  61.0      |
| 6_S132_L003_R1_001  |  21.1%     |  24%     |  80.3      |
| 6_S132_L003_R2_001  |  20.4%     |  24%     |  80.3      |

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/seq%20counts.png?raw=true)

Sample 31 appears to have a very low # of reads. Might have to take this out later?

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/seq%20quality.png?raw=true)

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/per%20seq%20quality%20score.png?raw=true)

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/per%20base%20seq%20content.png?raw=true)

Based on the above, the %reads appear to stabilized ~15 bp.

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/per%20seq%20GC%20content.png?raw=true)

This peak has a normal distribution (good, what we're looking for) but is shifted to a peak ~20-25... This is usually higher? Red flag?  
Is this shifted because methylation changes unmethylated Cytosine to Thymine and therefore a smaller amount of GC content? Especially in an invertebrate that only has 20% methylation.. This is actually a green flag then?

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/per%20base%20N%20content.png?raw=true)

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/seq%20duplication.png?raw=true)

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/overrepresented%20seq.png?raw=true)

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/adapter%20content.png?raw=true)

This throws a red flag for me... That seems like a lot of adapter content in places it is not usually?  
Does bisulfite conversion cause a higher # of T's (mostly unmethylated in a WGBS set) that could look like adapters?

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/status%20checks.png?raw=true)

## <a name="Test"></a> **NF-core: Methylseq**

**Goal**: Reduce M-bias but keep as much of the sequence as possible. The first iteration of my methylseq script output looked good

Nextflow version 21.03.0 requires an -input command.  
The --name output needs to be different every time you run this script.  

### BleachingPairs_methylseq (1) script

```
nano BleachingPairs_methylseq.sh
```

```
#!/bin/bash
#SBATCH --job-name="methylseq"
#SBATCH -t 120:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=100GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_WGBS
#SBATCH -p putnamlab
#SBATCH --cpus-per-task=3

# load modules needed
source /usr/share/Modules/init/sh # load the module function
module load Nextflow/21.03.0

# run nextflow methylseq

nextflow run nf-core/methylseq -profile singularity \
--aligner bismark \
--igenomes_ignore \
--fasta /data/putnamlab/estrand/Montipora_capitata_HIv2.assembly.fasta \
--save_reference \
--input '/data/putnamlab/KITT/hputnam/20211008_BleachingPairs_WGBS/*_R{1,2}_001.fastq.gz' \
--clip_r1 10 \
--clip_r2 10 \
--three_prime_clip_r1 10 --three_prime_clip_r2 10 \
--non_directional \
--cytosine_report \
--relax_mismatches \
--unmapped \
--outdir /data/putnamlab/estrand/BleachingPairs_WGBS \
-name WGBS_methylseq_BleachingPairs3
```

Ran first and then moved all output to BleachingPairs_methylseq directory folder.

## <a name="bismark_multiqc"></a> **Bismark Multiqc Report**

 Comparing statistics for the methylseq summary output in this post: https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/Dec-July-2019-analysis/scripts/methylseq_statistics.md. It does not appear that extraction or pico methyl seq date affected these statistics. I'm good to move on to the following scripts for DMG analysis.

 Versions of all packages that bismark uses are in [bismark multiqc report output](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/Dec-July-2019-analysis/output/WGBS/BleachingPairs_methylseq_multiqc_report.html).

 **Based on the below stats, it looks like the methylseq script (BleachingPairs_methylseq - 1) worked well and there is not an m-bias issue to worry about.**

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/bismark%20multiqc%20report/methylseq1/alignment%20rates.png?raw=true)

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/bismark%20multiqc%20report/methylseq1/deduplication.png?raw=true)

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/bismark%20multiqc%20report/methylseq1/strand%20alignment.png?raw=true)

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/bismark%20multiqc%20report/methylseq1/cytosine%20methylation.png?raw=true)

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/bismark%20multiqc%20report/methylseq1/R1%20m%20bias.png?raw=true)

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/bismark%20multiqc%20report/methylseq1/R2%20m%20bias.png?raw=true)

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/bismark%20multiqc%20report/methylseq1/coverage%20quality.png?raw=true)

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/bismark%20multiqc%20report/methylseq1/genome%20coverage.png?raw=true)

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/bismark%20multiqc%20report/methylseq1/insert%20size%20histogram.png?raw=true)

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/bismark%20multiqc%20report/methylseq1/GC%20content%20distribution.png?raw=true)

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/bismark%20multiqc%20report/methylseq1/complexity%20curve.png?raw=true)

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/bismark%20multiqc%20report/methylseq1/read%20filtering.png?raw=true)

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%20WGBS%20Multiqc%20Report/bismark%20multiqc%20report/methylseq1/trimmed%20seq%20length.png?raw=true)


## <a name="merge_strands"></a> **Merge Strands**

See more detailed information on these steps, what the script is doing, and what the flags mean here:  
- https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-10-21-HoloInt-WGBS-Analysis-Pipeline.md#-merge-strands 
- https://github.com/Putnam-Lab/Lab_Management/blob/master/Bioinformatics_%26_Coding/Workflows/Methylation_QC.md#-merge-strands 

File path: `/data/putnamlab/estrand/BleachingPairs_WGBS/BleachingPairs_methylseq/bismark_methylation_calls/methylation_coverage/*deduplicated.bismark.cov.gz`. 

Input: `*deduplicated.bismark.cov.gz`.  
Output: `*merged_CpG_evidence.cov`.

Make a new directory for this output: `mkdir merged_cov`. 

`merge_strands.sh` (named cov_to_cyto in other lab members' pipelines): 

```
#!/bin/bash
#SBATCH --job-name="merge"
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=500GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov #### this should be your new output directory so all the outputs ends up here
#SBATCH --cpus-per-task=3
#SBATCH --error="script_error_merge" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_merge" #once your job is completed, any final job report comments will be put in this file

# load modules needed (specific need for my computer)
source /usr/share/Modules/init/sh # load the module function

# load modules needed

module load Bismark/0.20.1-foss-2018b

# run coverage2cytosine merge of strands
# change paths below 
# change file names below (_L003_*)
# there can't be any spaces after the \

find /data/putnamlab/estrand/BleachingPairs_WGBS/BleachingPairs_methylseq/bismark_methylation_calls/methylation_coverage/*deduplicated.bismark.cov.gz \
 | xargs basename -s _L003_R1_001_val_1_bismark_bt2_pe.deduplicated.bismark.cov.gz \
 | xargs -I{} coverage2cytosine \
 --genome_folder /data/putnamlab/estrand/BleachingPairs_WGBS/BleachingPairs_methylseq/reference_genome/BismarkIndex \
 -o {} \
 --merge_CpG \
 --zero_based \
/data/putnamlab/estrand/BleachingPairs_WGBS/BleachingPairs_methylseq/bismark_methylation_calls/methylation_coverage/{}_L003_R1_001_val_1_bismark_bt2_pe.deduplicated.bismark.cov.gz
```