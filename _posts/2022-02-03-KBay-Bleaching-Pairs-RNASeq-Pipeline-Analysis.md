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

## <a name="details"></a> **KBay Bleaching Pairs project details **

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

**Functional Annotation** 

- Erin Chille Functional Annotation: https://github.com/echille/Mcapitata_Developmental_Gene_Expression_Timeseries/blob/master/0-BLAST-GO-KO/2020-10-08-M-capitata-functional-annotation-pipeline.md  
- Jill Ashey Functional Annotation: https://github.com/JillAshey/FunctionalAnnotation/blob/main/FunctionalAnnotation_Worflow.md  
- Kevin Wong Functional Annotation: https://github.com/hputnam/Past_Genome/blob/master/genome_annotation_pipeline.md#functional-annotation-1
- Danielle Becker-Polinski Functional Annotation: https://github.com/daniellembecker/DanielleBecker_Lab_Notebook/blob/master/_posts/2021-12-08-Molecular-Underpinnings-Functional-Annotation-Pipeline.md#overview

**RNASeq** 

- Erin Chille RNAseq pipeline: https://github.com/echille/Mcapitata_Developmental_Gene_Expression_Timeseries/blob/master/1-QC-Align-Assemble/mcap_rnaseq_analysis.md  
- Jill Ashey RNAseq pipeline: https://github.com/JillAshey/SedimentStress/blob/master/Bioinf/RNASeq_pipeline_HI.md  

## Function Annotation pipeline 

See here for *M. capitata* genome version 3 functional annotation: https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-11-02-M.capitata-Genome-v3-Functional-Annotation.md. 

## <a name="Setting_up"></a> **Setting Up Andromeda**

Sym link raw files to `raw_data` folder within `/BleachingPairs_RNASeq`. 

