---
layout: post
title: SNP Calling with RNASeq data
date: '2023-03-06'
categories: Processing
tags: SNP, RNASeq
projects: KBay Bleaching Pairs
---

# SNP Calling with RNASeq Data 

Goal: Call SNPs for my Bleaching Pairs project using RNASeq data. I originally tried EpiDiverse to call SNPs with my WGBS data but am continuing to troubleshoot that pipeline ([link here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2023-02-06-EpiDiverse-Bleaching-Pairs-Analysis.md)). 

References: 
- Palumbi lab workshop: https://github.com/UCcongenomics/Conservation-Gene-Expression/blob/master/UCGenomics-SNPcalling-Palumbilab_final%20(1).pdf; https://github.com/bethsheets/SNPcalling_tutorial   
- Federica's pipeline: https://github.com/fscucchia/Pastreoides_development_depth/tree/main/SNPs (Federica referenced Tim's)  
- Tim's pipeline: https://github.com/TimothyStephens/Kaneohe_Bay_coral_2018_PopGen 

Data path = `/data/putnamlab/estrand/BleachingPairs_RNASeq/SNP`.

All analysis done on URI's HPC system Andromeda. 

### Input

`/data/putnamlab/estrand/BleachingPairs_RNASeq/processed/trimmed.*.fastq.gz`. Both R1 and R2 

## 0. Installing Programs 

1. GATK (https://gatk.broadinstitute.org/hc/en-us/articles/360036194592-Getting-started-with-GATK4). Version already downloaded on Andromeda: `GATK/4.3.0.0-GCCcore-11.2.0-Java-11`. 
2. rgsam (https://github.com/djhshih/rgsam). I asked Kevin Bryan to download `rgsam/0.2.1-foss-2022a`.    
3. PLINK (https://www.cog-genomics.org/plink2). Version already downloaded on Andromeda: `PLINK/2.00a2.3_x86_64`. 


## 1. FastqToSam, collect RG, and MergeBamAlignment

### 1a. FastqToSam

https://gatk.broadinstitute.org/hc/en-us/articles/360037057412-FastqToSam-Picard-.  
Purpose: Converts a FASTQ file to an unaligned BAM or SAM file.    
Input: One FASTQ file name for single-end or two for pair-end sequencing input data. These files might be in gzip compressed format (when file name is ending with ".gz").     
Output: A single unaligned BAM or SAM file. By default, the records are sorted by query (read) name.   

`FastqToSam.sh`: 

Mine took ~7.5 minutes per sample (x40) = 300 minutes. 

```
#!/bin/sh
#SBATCH -t 200:00:00
#SBATCH --export=NONE
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_RNASeq/SNP  
#SBATCH --error=output_messages/"%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output=output_messages/"%x_output.%j" #once your job is completed, any final job report comments will be put in this file

# load modules needed (specific need for my computer)
source /usr/share/Modules/init/sh # load the module function
# Load modules needed 
module load GATK/4.3.0.0-GCCcore-11.2.0-Java-11

# Data path to filtered reads 
path="/data/putnamlab/estrand/BleachingPairs_RNASeq/processed"

# Create a list for every file that ends with R1__001.fastq.gz in that folder 
array1=($(ls $path/*_R1_001.fastq.gz))

# A for loop that says for every file that ends with R1 and R2 
for i in ${array1[@]}; do
        gatk FastqToSam \
				--FASTQ ${i} \
                --FASTQ2 $(echo ${i}|sed s/_R1/_R2/) \
                --OUTPUT ${i}.FastqToSam.unmapped.bam \
                --SAMPLE_NAME ${i}; touch ${i}.FastqToSam.done
done
```

#### Tips 

The sed argument 's/_R1.fastq//' has 3 parts. Each is separated by /.
- s means substitution
- _R1.fastq is something to be substituted
- The next is actually empty, i.e., substitute _R1.fastq with nothing

### 1b. collect RG

I moved all the unmapped bam files produced above into a new directory within my SNPs folder. 
 
Purpose: *fill in*     
Input: `${i}.FastqToSam.unmapped.bam` from the previous script     
Output: `${i}.rg.bam` ; edited bam file 

`collectRG_rgsam.sh`: 

```
#!/bin/sh
#SBATCH -t 200:00:00
#SBATCH --export=NONE
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_RNASeq/SNP  
#SBATCH --error=output_messages/"%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output=output_messages/"%x_output.%j" #once your job is completed, any final job report comments will be put in this file

# load modules needed (specific need for my computer)
source /usr/share/Modules/init/sh # load the module function

# Load modules needed 
module load SAMtools/1.16.1-GCC-11.3.0
module load rgsam/0.2.1-foss-2022a

# Data path to unmapped bam files reads 
path="/data/putnamlab/estrand/BleachingPairs_RNASeq/SNP"

# Create a list for every file that ends with FastqToSam.unmapped.bam in that folder 
array1=($(ls $path/unmapped_bam/*FastqToSam.unmapped.bam))

# A for loop that says for every file that ends with R1 and R2 
for i in ${array1[@]}; do
    samtools view ${i} | rgsam collect -s ${i} -o ${i}.rg.txt
    samtools view -h ${i} | 
        rgsam tag -r ${i}.rg.txt |
        samtools view -b - > ${i}.rg.bam
done

```

#### Tips 

https://github.com/djhshih/rgsam 

`rgsam` commands:
  - collect: collect read-group information from SAM or FASTQ file
  - split: plit SAM or FASTQ file based on read-group
  - tag: tag reads in SAM file with read-group field
  - qnames: list supported read name formats
  - version: print version

Note that we use the `-h` flag of samtools view to ensure that other header data are preserved (any existing @RG will be replaced)

#### Troubleshooting 

I ran into several errors with versions of modules. `rgsam/0.2.1-foss-2022a` needs to be pairs with GCC-11.3.0 so Kevin Bryan downloaded `SAMtools/1.16.1-GCC-11.3.0` and that seemed to work. 

```
GCCcore/11.3.0(24):ERROR:150: Module 'GCCcore/11.3.0' conflicts with the currently loaded module(s) 'GCCcore/11.2.0'
GCCcore/11.3.0(24):ERROR:102: Tcl command execution failed: conflict GCCcore
```

### 1c. Prepare your reference file

*below content from [F.Scucchia page](https://github.com/fscucchia/Pastreoides_development_depth/tree/main/SNPs)* 

The GATK uses two files to access and safety check access to the reference files: a .dict dictionary of the contig names and sizes, and a .fai fasta index file to allow efficient random access to the reference bases. You have to generate these files in order to be able to use a fasta file as reference.

**Step 1**: CreateSequenceDictionary.jar from Picard to create a .dict file from a fasta file. This produces a SAM-style header file describing the contents of the fasta file.

**Step 2**: faidx command in samtools to prepare the fasta index file. This file describes byte offsets in the fasta file for each contig, allowing to compute exactly where a particular reference base at contig:pos is in the fasta file. This produces a text file with one record per line for each of the fasta contigs. Each record is of the: contig, size, location, basesPerLine, bytesPerLine.

I have already have Step 2 done from a previous project: `/data/putnamlab/estrand/Montipora_capitata_HIv3.assembly.fasta.fai`. The command to run to create a file like this is: `samtools faidx $R` with $R as the path to reference file.

`prep_ref.sh`: 

Takes under 5 minutes. 

```
#!/bin/sh
#SBATCH -t 200:00:00
#SBATCH --export=NONE
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_RNASeq/SNP  
#SBATCH --error=output_messages/"%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output=output_messages/"%x_output.%j" #once your job is completed, any final job report comments will be put in this file

# load modules needed (specific need for my computer)
source /usr/share/Modules/init/sh # load the module function
# Load modules needed 
module load GATK/4.3.0.0-GCCcore-11.2.0-Java-11

R="/data/putnamlab/estrand/Montipora_capitata_HIv3.assembly.fasta"

# Step 1 described in notebook post 
gatk CreateSequenceDictionary -REFERENCE $R -OUTPUT ${R%*.*}.dict
```

Output: `Montipora_capitata_HIv3.assembly.dict`.

### 1c. Merge unalinged bam file

Purpose: Merge unalinged bam file (now with read group info) with aligned bam file (read group info from unalinged bam is transfered to aligned bam)       
Input: `${i}.FastqToSam.unmapped.bam.rg.bam` from the previous script (edited merged bam file)  
Output: `${i}.MergeBamAlignment.merged.bam` ; edited merged bam file 

`MergeBamAlignment.sh`:

```
#!/bin/sh
#SBATCH -t 200:00:00
#SBATCH --export=NONE
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_RNASeq/SNP  
#SBATCH --error=output_messages/"%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output=output_messages/"%x_output.%j" #once your job is completed, any final job report comments will be put in this file

# load modules needed (specific need for my computer)
source /usr/share/Modules/init/sh # load the module function
module load GATK/4.3.0.0-GCCcore-11.2.0-Java-11 

F="/data/putnamlab/estrand/BleachingPairs_RNASeq/SNP/unmapped_bam"
G="/data/putnamlab/estrand/Montipora_capitata_HIv3.assembly.fasta"
A="/data/putnamlab/estrand/BleachingPairs_RNASeq/output"

array1=($(ls $F/*unmapped.bam.rg.bam))
for i in ${array1[@]}; do
    gatk MergeBamAlignment --REFERENCE_SEQUENCE $G \
    --UNMAPPED_BAM ${i} \
    --ALIGNED_BAM $A/*.bam \ 
    --OUTPUT ${i}.MergeBamAlignment.merged.bam \
    --INCLUDE_SECONDARY_ALIGNMENTS false \
    --VALIDATION_STRINGENCY SILENT \ 
    touch ${i}.MergeBamAlignment.done
done 
```

#### Rename the output files to get rid of several bam.bam.bam extentions

```


```