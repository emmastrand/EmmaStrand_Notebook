---
layout: post
title: KBay Bleaching Pairs RNASeq Pipeline Analysis
date: '2022-02-03'
categories: Analysis
tags: RNA, pipeline, bioinformatics
projects: KBay
---

# KBay Bleaching Pairs RNASeq Pipeline Analysis

Contents:  
- [**Project Details**](#details) 
- [**Setting Up Andromeda**](#Setting_up)  
- [**FastQC**](#fastqc)  
- [**Trim Reads**](#trim)  
- [**Align Trimmed Reads to Reference Genome**](#align) 
- [**Assemble aligned reads and quantify transcripts**](#assemble) 
- [**Create Gene Counts Matrix**](#genecounts) 


## <a name="details"></a> KBay Bleaching Pairs project details

Project github: [HI_Bleaching_Pairs](https://github.com/hputnam/HI_Bleaching_Timeseries)  
Molecular laboratory work spreadsheet: [excel doc](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/data/Molecular-labwork.xlsx)  

40 adult coral biopsies of *M. capitata* used for molecular analysis from July 2019 and December 2019 time points. Laboratory work for this project found [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-11-09-KBay-Bleaching-Pairs-16S-Processing.md).

Raw data path: ../../data/putnamlab/KITT/hputnam/20220203_BleachedPairs_RNASeq    
Sym linked files in my working directory: ../../data/putnamlab/estrand/BleachingPairs_RNASeq 

Script to download raw data found [here in github repo](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/data/RNASeq/pairs_rnaseq_download.md).

A. Huffmyer first-pass analysis of these files: /data/putnamlab/ashuffmyer/pairs-rnaseq (done with Version 2 of genome)

*M. capitata* genome database: http://cyanophora.rutgers.edu/montipora/. I will use version 3 for this analysis. 

### References:  

For detailed explanations of each step, refer to the below pipelines. 

**RNASeq** 

- Erin Chille RNAseq pipeline: https://github.com/echille/Mcapitata_Developmental_Gene_Expression_Timeseries/blob/master/1-QC-Align-Assemble/mcap_rnaseq_analysis.md  
- Jill Ashey RNAseq pipeline: https://github.com/JillAshey/SedimentStress/blob/master/Bioinf/RNASeq_pipeline_HI.md  
- Danielle Becker pipeline: https://github.com/daniellembecker/DanielleBecker_Lab_Notebook/blob/master/_posts/2021-04-14-Molecular-Underpinnings-RNAseq-Workflow.md 

**TagSeq** 
- Kevin Wong pipeline: https://github.com/kevinhwong1/Porites_Rim_Bleaching_2019/blob/master/scripts/TagSeq/TagSeq_Analysis_HPC.md

## Function Annotation pipeline 

See here for *M. capitata* genome version 3 functional annotation: https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-11-02-M.capitata-Genome-v3-Functional-Annotation.md. 

## <a name="Setting_up"></a> **Setting Up Andromeda**

Sym link raw files (from HP path above) to `raw_data` folder within `/BleachingPairs_RNASeq`. 

Make a new directory for `scripts`, `fastqc_results`

## <a name="fastqc"></a> **FastQC**

`fastqc.sh`: 

```
#!/bin/bash
#SBATCH -t 100:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_RNASeq                
#SBATCH --error="script_error_fastqc" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_fastqc" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function (specifc to my computer)

module load FastQC/0.11.9-Java-11
module load MultiQC/1.9-intel-2020a-Python-3.8.2

for file in /data/putnamlab/KITT/hputnam/20220203_BleachedPairs_RNASeq/*fastq.gz
do
fastqc $file --outdir /data/putnamlab/estrand/BleachingPairs_RNASeq/fastqc_results/         
done

multiqc --interactive /data/putnamlab/estrand/BleachingPairs_RNASeq/fastqc_results -o /data/putnamlab/estrand/BleachingPairs_RNASeq/multiqc_results
```

Outside of Andromeda: 

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/BleachingPairs_RNASeq/multiqc_results/multiqc_report.html /Users/emmastrand/MyProjects/HI_Bleaching_Timeseries/Dec-July-2019-analysis/output/RNASeq/initial_multiqc_report.html
```

### fastqc results 

All samples have sequences of a single length (101bp).

![](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/Dec-July-2019-analysis/output/RNASeq/seq-quality.png?raw=true)

![](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/Dec-July-2019-analysis/output/RNASeq/seq-counts.png?raw=true)

![](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/Dec-July-2019-analysis/output/RNASeq/perseq-quality.png?raw=true)

![](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/Dec-July-2019-analysis/output/RNASeq/perseq-GC-content.png?raw=true)

![](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/Dec-July-2019-analysis/output/RNASeq/seq-dup.png?raw=true)

![](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/Dec-July-2019-analysis/output/RNASeq/adapter-content.png?raw=true)

## <a name="trim"></a> **Trimming Reads**

I use the program `fastp`, but there are others like `Trimmomatic`.  
- More info on Trimmomatic from [Data Carpentry](https://datacarpentry.org/wrangling-genomics/03-trimming/index.html).  
- More info on fastp https://manpages.debian.org/testing/fastp/fastp.1.en.html 

`fastp_multiqc.sh`:

Fill in the trimming parameters based on the initial multiqc report.

```
#!/bin/bash
#SBATCH -t 100:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_RNASeq/raw_data                
#SBATCH --error=../"%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output=../"%x_output.%j" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function (specific to my computer)

# Load modules needed 
module load fastp/0.19.7-foss-2018b
module load FastQC/0.11.8-Java-1.8
module load MultiQC/1.9-intel-2020a-Python-3.8.2

# Make an array (list) of sequences to trim
# Needs to be in directory above (raw data directory)
array1=($(ls *.fastq.gz))

# fastp and fastqc loop 
for i in ${array1[@]}; do
    fastp --in1 ${i} \
        --in2 $(echo ${i}|sed s/_R1/_R2/)\
        --out1 /data/putnamlab/estrand/BleachingPairs_RNASeq/processed/trimmed.${i} \
        --out2 /data/putnamlab/estrand/BleachingPairs_RNASeq/processed/trimmed.$(echo ${i}|sed s/_R1/_R2/) \
        --qualified_quality_phred 20 \
        --unqualified_percent_limit 10 \
        --length_required 100 \
        --detect_adapter_for_pe \
        --cut_right cut_right_window_size 5 cut_right_mean_quality 20
    fastqc /data/putnamlab/estrand/BleachingPairs_RNASeq/processed/trimmed.${i}
done

echo "Read trimming of adapters complete." $(date)

# Quality Assessment of Trimmed Reads
cd /data/putnamlab/estrand/BleachingPairs_RNASeq/processed/ #The following command will be run in the /clean directory

# Compile MultiQC report from FastQC files 
multiqc --interactive ./  

echo "Cleaned MultiQC report generated." $(date)
```

**Exporting this report (outside of Andromeda)**

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/BleachingPairs_RNASeq/processed/multiqc_report.html /Users/emmastrand/MyProjects/HI_Bleaching_Timeseries/Dec-July-2019-analysis/output/RNASeq/processed_multiqc_report.html
```

### Processed Multiqc report 

#### 80 samples had less than 1% of reads made up of overrepresented sequences

#### No samples found with any adapter contamination > 0.1%

![](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/Dec-July-2019-analysis/output/RNASeq/processed%20multiqc/seq%20counts.png?raw=true)

![](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/Dec-July-2019-analysis/output/RNASeq/processed%20multiqc/seq%20quality.png?raw=true)

![](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/Dec-July-2019-analysis/output/RNASeq/processed%20multiqc/per%20seq%20quality.png?raw=true)

![](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/Dec-July-2019-analysis/output/RNASeq/processed%20multiqc/per%20base%20n%20content.png?raw=true)

![](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/Dec-July-2019-analysis/output/RNASeq/processed%20multiqc/per%20seq%20GC%20content.png?raw=true)

![](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/Dec-July-2019-analysis/output/RNASeq/processed%20multiqc/seq%20duplication.png?raw=true)

![](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/Dec-July-2019-analysis/output/RNASeq/processed%20multiqc/seq%20length%20dist.png?raw=true)

## <a name="align"></a> **Align Trimmed Reads to Reference Genome**

I use the program `HISAT2`, but other pipelines use `STAR`.  

1. Index the reference genome
2. Alignment of clean reads to the reference genome

### Reference genome information 

I'm using the newest version of the Mcap genome: 

`wget http://cyanophora.rutgers.edu/montipora/Montipora_capitata_HIv3.assembly.fasta.gz`. gunzip this file 
`wget http://cyanophora.rutgers.edu/montipora/Montipora_capitata_HIv3.genes.gff3.gz`. gunzip this file

path: `/data/putnamlab/estrand/Montipora_capitata_HIv3.assembly.fasta`  
path: `/data/putnamlab/estrand/Montipora_capitata_HIv3.genes.gff3` 

Creating the reference genome part takes ~5-10 minutes.  
Running the hisat2 and samtools parts took under 4 days (the align.sh script at the end of this doc took 2 weeks..) 

`align2.sh`: 

```
#!/bin/bash
#SBATCH -t 500:00:00
#SBATCH --export=NONE
#SBATCH --nodes=1 --ntasks-per-node=15
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_RNASeq/output2/                
#SBATCH --error=../"%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output=../"%x_output.%j" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function (specific need to my computer)

# load modules needed
module load HISAT2/2.2.1-gompi-2021b
module load SAMtools/1.15.1-GCC-11.2.0

# Index the reference genome 
hisat2-build -f /data/putnamlab/estrand/Montipora_capitata_HIv3.assembly.fasta ./Mcap_ref
echo "Reference genome indexed. Starting alignment" $(date)

# Alignment of clean reads to the reference genome
array=($(ls /data/putnamlab/estrand/BleachingPairs_RNASeq/processed/*_R1_001.fastq.gz))

for i in ${array[@]}; do
    hisat2 -p 8 --rna-strandness RF --dta -q -x Mcap_ref -1 ${i} -2 $(echo ${i}|sed s/_R1/_R2/) -S ${i}.sam
    samtools sort -@ 8 -o ${i}.bam ${i}.sam
    	echo "${i} bam-ified!"
    rm ${i}.sam
done
```

**OUTPUT SHOULD BE BOTH R1 AND R2 IN ONE SAM FILE!!** 


## <a name="assemble"></a> **Assemble aligned reads and quantify transcripts**

`StringTie` is a fast and highly efficient assembler of RNA-Seq alignments into potential transcripts.

1. Reference-guided assembly with novel transcript discovery
2. Merge output GTF files and assess the assembly performance
3. Compilation of GTF-files into gene and transcript count matrices

### GFF File Fix 

My original counts matrix output with names like `STRG.6173` instead of the gene name. 

Ariana had a solution to this outlined here: https://github.com/Putnam-Lab/Lab_Management/issues/51

### Upload new GFF file 

```
scp /Users/emmastrand/MyProjects/HI_Bleaching_Timeseries/Dec-July-2019-analysis/Montipora_capitata_HIv3.genes_fixed.gff3.gz emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/
```

### Ended up using assemble2.sh below (b/c of a formatting issue in my original gff)

`assemble2.sh`: 

```
#!/bin/bash
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --export=NONE
#SBATCH --mem=128GB
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_RNASeq/output2/                
#SBATCH --error=../"%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output=../"%x_output.%j" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function (specific need to my computer)
module load StringTie/2.1.4-GCC-9.3.0

# Assemble and estimate reads
# array 1 ls is every file that ends with .bam in the output2 folder specified above 
array1=($(ls *.bam))

for i in ${array1[@]}; do
    stringtie -p 8 -e -B -G /data/putnamlab/estrand/Montipora_capitata_HIv3.genes_fixed.gff3 -o /data/putnamlab/estrand/BleachingPairs_RNASeq/output2/${i}.gtf /data/putnamlab/estrand/BleachingPairs_RNASeq/output2/${i}
done

# Merge stringTie gtf results

ls *gtf > mergelist.txt
cat mergelist.txt

stringtie --merge -p 8 -G /data/putnamlab/estrand/Montipora_capitata_HIv3.genes_fixed.gff3 -o stringtie_merged.gtf mergelist.txt

echo "Stringtie merge complete" $(date)
```

`head mergelist.txt`:

```

```

`head stringtie_merged.gtf`:

```

```



## <a name="genecount"></a> **Create gene counts matrix**

The StringTie program includes a script, prepDE.py that compiles your assembly files into gene and transcript count matrices. This script requires as input the list of sample names and their full file paths, sample_list.txt. This file will live in StringTie program directory.

Copy this file: `cp /data/putnamlab/ashuffmyer/pairs-rnaseq/prepDE.py .`

### Ended up using genecount2.sh b/c of a formatting issue above 

`genecount2.sh`: 

```
#!/bin/bash
#SBATCH -t 60:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=128GB
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_RNASeq/output/                
#SBATCH --error=../"%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output=../"%x_output.%j" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function (specific need to my computer)
module load StringTie/2.1.4-GCC-9.3.0
module load Python/2.7.15-foss-2018b
module load GffCompare/0.12.1-GCCcore-8.3.0

# Assess the performance of the assembly
gffcompare -r /data/putnamlab/estrand/Montipora_capitata_HIv3.genes_fixed.gff3 -o merged stringtie_merged.gtf

echo "GFFcompare complete, Starting gene count matrix assembly..." $(date)

# Make gtf list text file

for filename in *.bam.gtf; do echo $filename $PWD/$filename; done > listGTF.txt

# Compile the gene count matrix

python ../scripts/prepDE.py -g ../KB_gene_count_matrix.csv -i listGTF.txt
echo "Gene count matrix compiled." $(date)
```

`head output/listGTF.txt` : 

```
16_S121_L003_R1_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/16_S121_L003_R1_001.bam.gtf
16_S121_L003_R2_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/16_S121_L003_R2_001.bam.gtf
17_S122_L003_R1_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/17_S122_L003_R1_001.bam.gtf
17_S122_L003_R2_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/17_S122_L003_R2_001.bam.gtf
21_S123_L003_R1_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/21_S123_L003_R1_001.bam.gtf
21_S123_L003_R2_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/21_S123_L003_R2_001.bam.gtf
22_S124_L003_R1_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/22_S124_L003_R1_001.bam.gtf
22_S124_L003_R2_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/22_S124_L003_R2_001.bam.gtf
23_S125_L003_R1_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/23_S125_L003_R1_001.bam.gtf
23_S125_L003_R2_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/23_S125_L003_R2_001.bam.gtf
```

`head -5 KB_gene_count_matrix.csv`:

```
gene_id,16_S121_L003_R1_001.bam.gtf,16_S121_L003_R2_001.bam.gtf,17_S122_L003_R1_001.bam.gtf,17_S122_L003_R2_001.bam.gtf,21_S123_L003_R1_001.bam.gtf,21_S123_L003_R2_001.bam.gtf,22_S124_L003_R1_001.bam.gtf,22_S124_L003_R2_001.bam.gtf,23_S125_L003_R1_001.bam.gtf,23_S125_L003_R2_001.bam.gtf,24_S126_L003_R1_001.bam.gtf,24_S126_L003_R2_001.bam.gtf,25_S127_L003_R1_001.bam.gtf,25_S127_L003_R2_001.bam.gtf,26_S128_L003_R1_001.bam.gtf,26_S128_L003_R2_001.bam.gtf,28_S129_L003_R1_001.bam.gtf,28_S129_L003_R2_001.bam.gtf,29_S130_L003_R1_001.bam.gtf,29_S130_L003_R2_001.bam.gtf,2_S118_L003_R1_001.bam.gtf,2_S118_L003_R2_001.bam.gtf,30_S131_L003_R1_001.bam.gtf,30_S131_L003_R2_001.bam.gtf,31_S132_L003_R1_001.bam.gtf,31_S132_L003_R2_001.bam.gtf,33_S133_L003_R1_001.bam.gtf,33_S133_L003_R2_001.bam.gtf,37_S134_L003_R1_001.bam.gtf,37_S134_L003_R2_001.bam.gtf,39_S135_L003_R1_001.bam.gtf,39_S135_L003_R2_001.bam.gtf,42_S136_L003_R1_001.bam.gtf,42_S136_L003_R2_001.bam.gtf,43_S137_L003_R1_001.bam.gtf,43_S137_L003_R2_001.bam.gtf,45_S138_L003_R1_001.bam.gtf,45_S138_L003_R2_001.bam.gtf,46_S139_L003_R1_001.bam.gtf,46_S139_L003_R2_001.bam.gtf,47_S140_L003_R1_001.bam.gtf,47_S140_L003_R2_001.bam.gtf,4_S119_L003_R1_001.bam.gtf,4_S119_L003_R2_001.bam.gtf,50_S141_L003_R1_001.bam.gtf,50_S141_L003_R2_001.bam.gtf,51_S142_L003_R1_001.bam.gtf,51_S142_L003_R2_001.bam.gtf,52_S143_L003_R1_001.bam.gtf,52_S143_L003_R2_001.bam.gtf,54_S144_L003_R1_001.bam.gtf,54_S144_L003_R2_001.bam.gtf,55_S145_L003_R1_001.bam.gtf,55_S145_L003_R2_001.bam.gtf,56_S146_L003_R1_001.bam.gtf,56_S146_L003_R2_001.bam.gtf,57_S147_L003_R1_001.bam.gtf,57_S147_L003_R2_001.bam.gtf,59_S148_L003_R1_001.bam.gtf,59_S148_L003_R2_001.bam.gtf,60_S149_L003_R1_001.bam.gtf,60_S149_L003_R2_001.bam.gtf,61_S150_L003_R1_001.bam.gtf,61_S150_L003_R2_001.bam.gtf,62_S151_L003_R1_001.bam.gtf,62_S151_L003_R2_001.bam.gtf,63_S152_L003_R1_001.bam.gtf,63_S152_L003_R2_001.bam.gtf,64_S153_L003_R1_001.bam.gtf,64_S153_L003_R2_001.bam.gtf,65_S154_L003_R1_001.bam.gtf,65_S154_L003_R2_001.bam.gtf,66_S155_L003_R1_001.bam.gtf,66_S155_L003_R2_001.bam.gtf,67_S156_L003_R1_001.bam.gtf,67_S156_L003_R2_001.bam.gtf,68_S157_L003_R1_001.bam.gtf,68_S157_L003_R2_001.bam.gtf,6_S120_L003_R1_001.bam.gtf,6_S120_L003_R2_001.bam.gtf
Montipora_capitata_HIv3___RNAseq.g42319.t1,1,2,0,11,0,3,6,15,3,7,0,7,0,0,0,7,0,10,0,1,0,4,0,9,0,11,0,11,0,8,0,8,0,4,0,0,0,2,0,4,0,12,0,0,0,1,0,17,0,4,0,3,0,0,0,12,0,3,1,2,0,4,0,11,0,7,0,6,0,5,0,14,2,16,0,0,0,9,0,2
Montipora_capitata_HIv3___TS.g49315.t1b,42,24,0,0,13,9,115,53,24,16,2,0,130,68,22,14,255,117,191,109,0,0,70,34,113,60,3,4,0,0,6,0,56,24,74,39,306,136,65,35,0,0,178,90,29,16,242,126,9,4,15,10,139,71,3,7,160,84,48,23,114,50,0,0,0,8,27,16,85,40,18,13,88,47,153,82,105,52,116,58
Montipora_capitata_HIv3___TS.g49315.t1a,325,178,13,0,104,60,1239,668,669,373,24,18,619,343,56,34,1441,790,1052,594,0,0,576,328,825,437,0,0,0,0,19,0,44,26,752,416,1816,1021,1276,707,0,0,1018,574,71,47,2005,1099,0,0,79,41,1047,560,0,0,1082,599,29,17,1140,639,0,0,22,0,729,408,1666,954,96,65,1287,742,905,538,2351,1376,1874,1043
Montipora_capitata_HIv3___RNAseq.g19176.t1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,5,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
```

This seems to have fixed the issue with gene naming. 

### copy gene counts matrix to computer (again)

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/BleachingPairs_RNASeq/KB_gene_count_matrix.csv /Users/emmastrand/MyProjects/HI_Bleaching_Timeseries/Dec-July-2019-analysis/output/RNASeq/KB_gene_count_matrix.csv
```


`genecount.sh`: 

```
#!/bin/bash
#SBATCH -t 60:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=128GB
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_RNASeq/output/                
#SBATCH --error=../"%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output=../"%x_output.%j" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function (specific need to my computer)
module load StringTie/2.1.4-GCC-9.3.0
module load Python/2.7.15-foss-2018b
module load GffCompare/0.12.1-GCCcore-8.3.0

# Assess the performance of the assembly
gffcompare -r /data/putnamlab/estrand/Montipora_capitata_HIv3.genes.gff3 -o merged stringtie_merged.gtf

echo "GFFcompare complete, Starting gene count matrix assembly..." $(date)

# Make gtf list text file

for filename in *.bam.gtf; do echo $filename $PWD/$filename; done > listGTF.txt

# Compile the gene count matrix

python ../scripts/prepDE.py -g ../KB_gene_count_matrix.csv -i listGTF.txt
echo "Gene count matrix compiled." $(date)
```

`head output/listGTF.txt` : 

```
16_S121_L003_R1_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/16_S121_L003_R1_001.bam.gtf
16_S121_L003_R2_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/16_S121_L003_R2_001.bam.gtf
17_S122_L003_R1_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/17_S122_L003_R1_001.bam.gtf
17_S122_L003_R2_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/17_S122_L003_R2_001.bam.gtf
21_S123_L003_R1_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/21_S123_L003_R1_001.bam.gtf
21_S123_L003_R2_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/21_S123_L003_R2_001.bam.gtf
22_S124_L003_R1_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/22_S124_L003_R1_001.bam.gtf
22_S124_L003_R2_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/22_S124_L003_R2_001.bam.gtf
23_S125_L003_R1_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/23_S125_L003_R1_001.bam.gtf
23_S125_L003_R2_001.bam.gtf /glfs/brick01/gv0/putnamlab/estrand/BleachingPairs_RNASeq/output/23_S125_L003_R2_001.bam.gtf
```

less `less genecount.sh_error.201740`: 

```
GCCcore/8.3.0(24):ERROR:150: Module 'GCCcore/8.3.0' conflicts with the currently loaded module(s) 'GCCcore/9.3.0'
GCCcore/8.3.0(24):ERROR:102: Tcl command execution failed: conflict GCCcore

  54384 reference transcripts loaded.
  2 duplicate reference transcripts discarded.
  54384 query transfrags loaded.
```

`head -5 KB_gene_count_matrix.csv`:

```
gene_id,16_S121_L003_R1_001.bam.gtf,16_S121_L003_R2_001.bam.gtf,17_S122_L003_R1_001.bam.gtf,17_S122_L003_R2_001.bam.gtf,21_S123_L003_R1_001.bam.gtf,21_S123_L003_R2_001.bam.gtf,22_S124_L003_R1_001.bam.gtf,22_S124_L003_R2_001.bam.gtf,23_S125_L003_R1_001.bam.gtf,23_S125_L003_R2_001.bam.gtf,24_S126_L003_R1_001.bam.gtf,24_S126_L003_R2_001.bam.gtf,25_S127_L003_R1_001.bam.gtf,25_S127_L003_R2_001.bam.gtf,26_S128_L003_R1_001.bam.gtf,26_S128_L003_R2_001.bam.gtf,28_S129_L003_R1_001.bam.gtf,28_S129_L003_R2_001.bam.gtf,29_S130_L003_R1_001.bam.gtf,29_S130_L003_R2_001.bam.gtf,2_S118_L003_R1_001.bam.gtf,2_S118_L003_R2_001.bam.gtf,30_S131_L003_R1_001.bam.gtf,30_S131_L003_R2_001.bam.gtf,31_S132_L003_R1_001.bam.gtf,31_S132_L003_R2_001.bam.gtf,33_S133_L003_R1_001.bam.gtf,33_S133_L003_R2_001.bam.gtf,37_S134_L003_R1_001.bam.gtf,37_S134_L003_R2_001.bam.gtf,39_S135_L003_R1_001.bam.gtf,39_S135_L003_R2_001.bam.gtf,42_S136_L003_R1_001.bam.gtf,42_S136_L003_R2_001.bam.gtf,43_S137_L003_R1_001.bam.gtf,43_S137_L003_R2_001.bam.gtf,45_S138_L003_R1_001.bam.gtf,45_S138_L003_R2_001.bam.gtf,46_S139_L003_R1_001.bam.gtf,46_S139_L003_R2_001.bam.gtf,47_S140_L003_R1_001.bam.gtf,47_S140_L003_R2_001.bam.gtf,4_S119_L003_R1_001.bam.gtf,4_S119_L003_R2_001.bam.gtf,50_S141_L003_R1_001.bam.gtf,50_S141_L003_R2_001.bam.gtf,51_S142_L003_R1_001.bam.gtf,51_S142_L003_R2_001.bam.gtf,52_S143_L003_R1_001.bam.gtf,52_S143_L003_R2_001.bam.gtf,54_S144_L003_R1_001.bam.gtf,54_S144_L003_R2_001.bam.gtf,55_S145_L003_R1_001.bam.gtf,55_S145_L003_R2_001.bam.gtf,56_S146_L003_R1_001.bam.gtf,56_S146_L003_R2_001.bam.gtf,57_S147_L003_R1_001.bam.gtf,57_S147_L003_R2_001.bam.gtf,59_S148_L003_R1_001.bam.gtf,59_S148_L003_R2_001.bam.gtf,60_S149_L003_R1_001.bam.gtf,60_S149_L003_R2_001.bam.gtf,61_S150_L003_R1_001.bam.gtf,61_S150_L003_R2_001.bam.gtf,62_S151_L003_R1_001.bam.gtf,62_S151_L003_R2_001.bam.gtf,63_S152_L003_R1_001.bam.gtf,63_S152_L003_R2_001.bam.gtf,64_S153_L003_R1_001.bam.gtf,64_S153_L003_R2_001.bam.gtf,65_S154_L003_R1_001.bam.gtf,65_S154_L003_R2_001.bam.gtf,66_S155_L003_R1_001.bam.gtf,66_S155_L003_R2_001.bam.gtf,67_S156_L003_R1_001.bam.gtf,67_S156_L003_R2_001.bam.gtf,68_S157_L003_R1_001.bam.gtf,68_S157_L003_R2_001.bam.gtf,6_S120_L003_R1_001.bam.gtf,6_S120_L003_R2_001.bam.gtf
Montipora_capitata_HIv3___RNAseq.g19176.t1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,5,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
Montipora_capitata_HIv3___RNAseq.g42173.t1,0,0,0,6,6,11,6,13,0,3,0,1,6,0,0,10,2,3,3,7,4,82,0,0,2,1,1,0,3,3,0,6,2,5,1,6,2,5,4,4,6,2,0,4,0,7,2,0,2,0,0,3,3,5,2,5,3,5,3,7,4,4,1,0,4,52,0,5,2,4,2,0,6,8,3,11,2,7,0,4
Montipora_capitata_HIv3___RNAseq.g13553.t1,0,0,0,0,0,0,1,1,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,2,0,0,0,0,0,0,10,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,6,0,0,0,0,0,0,0,0,0,2,0,2,0,0,1,2,0,0,0,0,0,0,0,0,0,1
STRG.6173,396,227,1108,635,799,461,924,535,554,312,1959,1154,931,549,2016,1178,1126,663,1014,604,874,516,1169,689,1574,931,1471,867,1542,912,1525,908,1370,815,1739,1011,716,428,826,488,716,415,1109,651,866,519,2429,1434,1124,664,804,487,1575,957,1524,936,1585,934,822,488,1219,720,1646,973,1169,716,1282,764,1598,972,1915,1165,1465,877,1331,799,915,556,1016,590
```

Column with gene ID contains both gene names from reference genome and IDs from this pipeline (e.g. STRG.6173). Those from this pipeline seem to have the highest counts.. What does this mean?  **see troubleshooting section below** 

**Copy that output to local computer**

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/BleachingPairs_RNASeq/KB_gene_count_matrix.csv /Users/emmastrand/MyProjects/HI_Bleaching_Timeseries/Dec-July-2019-analysis/output/RNASeq/KB_gene_count_matrix.csv
```

## Previous versions of scripts

This took two weeks.. seems long but all worked. **Later I found out that the below `align.sh` actually produced a bam file for both R1 and R2. ah!** 

`align.sh`: 

```
#!/bin/bash
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_RNASeq/output/                
#SBATCH --error=../"%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output=../"%x_output.%j" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function (specific need to my computer)

# load modules needed
module load HISAT2/2.2.1-foss-2019b
module load SAMtools/1.9-foss-2018b

# Index the reference genome 
hisat2-build -f /data/putnamlab/estrand/Montipora_capitata_HIv3.assembly.fasta ./Mcap_ref
echo "Reference genome indexed. Starting alignment" $(date)

# Alignment of clean reads to the reference genome
array=($(ls /data/putnamlab/estrand/BleachingPairs_RNASeq/processed/*.fastq.gz))

for i in ${array[@]}; do
    sample_name=`echo $i| awk -F [.] '{print $2}'`
    hisat2 -p 8 --rna-strandness RF --dta -q -x Mcap_ref -1 ${i} -2 $(echo ${i}|sed s/_R1/_R2/) -S ${sample_name}.sam
    samtools sort -@ 8 -o ${sample_name}.bam ${sample_name}.sam
    	echo "${i} bam-ified!"
    rm ${sample_name}.sam
done
```


`assemble.sh`: 

```
#!/bin/bash
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=128GB
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_RNASeq/output/                
#SBATCH --error=../"%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output=../"%x_output.%j" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function (specific need to my computer)
module load StringTie/2.1.4-GCC-9.3.0
module load gffcompare/0.11.5-foss-2018b

# Assemble and estimate reads

array1=($(ls *.bam))

for i in ${array1[@]}; do
    sample_name=`echo $i| awk -F [_] '{print $1"_"$2"_"$3}'`
    stringtie -p 8 -e -B -G /data/putnamlab/estrand/Montipora_capitata_HIv3.genes.gff3 -o /data/putnamlab/estrand/BleachingPairs_RNASeq/output/${i}.gtf /data/putnamlab/estrand/BleachingPairs_RNASeq/output/${i}
done

# Merge stringTie gtf results

ls *gtf > mergelist.txt
cat mergelist.txt

stringtie --merge -p 8 -G /data/putnamlab/estrand/Montipora_capitata_HIv3.genes.gff3 -o stringtie_merged.gtf mergelist.txt

echo "Stringtie merge complete" $(date)
```