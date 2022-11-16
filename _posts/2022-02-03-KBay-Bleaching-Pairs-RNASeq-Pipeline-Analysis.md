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

`align.sh`: 

```
#!/bin/bash
#SBATCH -t 60:00:00
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

## <a name="assemble"></a> **Assemble aligned reads and quantify transcripts**

`StringTie` is a fast and highly efficient assembler of RNA-Seq alignments into potential transcripts.

1. Reference-guided assembly with novel transcript discovery
2. Merge output GTF files and assess the assembly performance
3. Compilation of GTF-files into gene and transcript count matrices

`assemble.sh`: 

```
#!/bin/bash
#SBATCH -t 60:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
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

## <a name="genecount"></a> **Create gene counts matrix**

The StringTie program includes a script, prepDE.py that compiles your assembly files into gene and transcript count matrices. This script requires as input the list of sample names and their full file paths, sample_list.txt. This file will live in StringTie program directory.

Copy this file: `cp /data/putnamlab/ashuffmyer/pairs-rnaseq/prepDE.py .`

`genecount.sh`: 

```
#!/bin/bash
#SBATCH -t 60:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_RNASeq/output/                
#SBATCH --error=../"%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output=../"%x_output.%j" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function (specific need to my computer)
module load StringTie/2.1.4-GCC-9.3.0
module load Python/2.7.15-foss-2018b

# Assess the performance of the assembly
gffcompare -r /data/putnamlab/estrand/Montipora_capitata_HIv3.genes.gff3 -o merged stringtie_merged.gtf

echo "GFFcompare complete, Starting gene count matrix assembly..." $(date)

# Make gtf list text file

for filename in *.bam.gtf; do echo $filename $PWD/$filename; done > listGTF.txt

# Compile the gene count matrix

python prepDE.py -g KB_gene_count_matrix.csv -i listGTF.txt
echo "Gene count matrix compiled." $(date)
```

**Copy that output to local computer**

```
scp emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/BleachingPairs_RNASeq/output/KB_gene_count_matrix.csv /Users/emmastrand/MyProjects/HI_Bleaching_Timeseries/Dec-July-2019-analysis/output/RNASeq/KB_gene_count_matrix.csv
```