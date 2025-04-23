---
layout: post
title: Transfering data from Andromeda during clean-out
date: '2025-04-18'
categories: Processing
tags: Andromeda, OSF, data-transfer
projects: Data management
---

## Andromeda clean out 

The week of 4-14-2025, I cleaned out my folder on Andromeda `/data/putnamlab/estrand/`. I got rid of intermediate files that I don't need but need to transfer some files to OSF and some to Unity for further analyses. 

### HoloINT WGBS

Raw data = `/data/putnamlab/KITT/hputnam/20211008_HoloInt_WGBS`. This should be zipped and moved to Andromeda until the paper is published. 

#### Andromeda to OSF

`HoloInt_WGBS` will go to this OSF page: [https://osf.io/ghsv8/](https://osf.io/ghsv8/). [OSF has a client](https://github.com/osfclient/osfclient) that was downloaded to Andromeda. 

```
interactive

cd HoloInt_WGBS 

module load osfclient

## set username and OSF information
osf init
## Provide a username for the config file [current username:  ]:
emma_strand@uri.edu

## Provide a project for the config file [current project:  ]:
ghsv8

## list projects
osf ls 

## prompted to input password for the OSF project -- success! connected the ploidy OSF 
```

Transfer test file

```
osf -p ghsv8 -u emma_strand@uri.edu upload multiqc_report.html methylseq_output/multiqc_report.html
## this worked! now transfering larger files.

```

Transfer important files. I'm only transferring the files that are key intermediate steps that take the longest which is the alignment and two subsequent steps. This paper will be in review soon and hopefully we won't need to take these files back through a pipeline. 

```
osf -p ghsv8 -u emma_strand@uri.edu upload WGBS_methylseq_HoloInt_genomev2_multiqc_report.html methylseq_output/WGBS_methylseq_HoloInt_genomev2_multiqc_report.html

osf -p ghsv8 -u emma_strand@uri.edu upload bismark_summary_report.html methylseq_output/bismark_summary_report.html

osf -p ghsv8 -u emma_strand@uri.edu upload bismark_summary_report.txt methylseq_output/bismark_summary_report.txt
```

The biggest files I want to transfer are the tab gene files. Everything else is intermediate and I can redo on Unity if absolutely needed based on a peer review.

```
cd /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/tab_files

# Upload using wildcard (requires existing methylseq_output/ folder on OSF)
for file in *_gene; do
  osf -p ghsv8 -u emma_strand@uri.edu upload "$file" "methylseq_output/$file"
done
### this worked for 5 files but then stopped.. maybe I'm running out of OSF space..
### these should be zipped before transferring

zip -r tab_files.zip ./*

## Now upload repo zipped instead of individual files
osf -p ghsv8 -u emma_strand@uri.edu upload tab_files.zip methylseq_output/tab_files.zip
```

Also transferring the .cov files 

```
cd /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2
ls *.cov
## each sample has 2 files: 1047.CpG_report.merged_CpG_evidence.cov and 1047_sorted.cov 
## ill save both 

zip -r cov_files.zip ./*.cov

osf -p ghsv8 -u emma_strand@uri.edu upload cov_files.zip methylseq_output/cov_files.zip
## this didn't work because OSF has a 5 GB storage limit
## this would be the best intermediate to save other than the tab files..
## raw data is already on NCBI 
mv cov_files.zip Strand_HoloInt_WGBS_cov_files.zip

zip -r script_files.zip scripts/*
osf -p ghsv8 -u emma_strand@uri.edu upload script_files.zip script_files.zip
```

#### Andromeda to Unity 

`Strand_HoloInt_WGBS_cov_files.zip` and the raw data in a tar folder but permission denied. **Need Hollie to do this**

```
cd /data/putnamlab/KITT/hputnam/20211008_HoloInt_WGBS

tar -czvf Strand_HoloInt_WGBS_rawdata.tar.gz ./*gz 
```

### BleachingPairs WGBS 

Raw data = 

Switching OSF project to bleaching pairs 

```
cd /data/putnamlab/estrand/BleachingPairs_WGBS

### switch the OSF project
osf init
emma_strand@uri.edu
p9txk

cd /data/putnamlab/estrand/BleachingPairs_WGBS/scripts
zip -r script_files.zip scripts/*

osf -p p9txk -u emma_strand@uri.edu upload script_files.zip script_files.zip

tar -czvf Strand_BleachingPairs_WGBS_bed.tar.gz ./*5x_enrichment.bed
tar -czvf Strand_BleachingPairs_WGBS_tab.tar.gz ./*5x_sorted.tab

## transfer those files to OSF 
module load osfclient
osf -p p9txk -u emma_strand@uri.edu upload Strand_BleachingPairs_WGBS_bed.tar.gz Strand_BleachingPairs_WGBS_bed.tar.gz
osf -p p9txk -u emma_strand@uri.edu upload Strand_BleachingPairs_WGBS_tab.tar.gz Strand_BleachingPairs_WGBS_tab.tar.gz
```

### Bleaching Pairs 16S Testing 

```
cd /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V4_515F/raw_data

tar -czvf Strand_BleachingPairs_16STesting_V4_515F_rawdata.tar.gz ./*gz
osf -p p9txk -u emma_strand@uri.edu upload Strand_BleachingPairs_16STesting_V4_515F_rawdata.tar.gz Strand_BleachingPairs_16STesting_V4_515F_rawdata.tar.gz

cd /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_341F/raw_data

tar -czvf Strand_BleachingPairs_16STesting_V3V4_341F_rawdata.tar.gz ./*gz
osf -p p9txk -u emma_strand@uri.edu upload Strand_BleachingPairs_16STesting_V3V4_341F_rawdata.tar.gz Strand_BleachingPairs_16STesting_V3V4_341F_rawdata.tar.gz

cd /data/putnamlab/estrand/Test_V3V4_16S/sample_sets/V3V4_338F/raw_data
tar -czvf Strand_BleachingPairs_16STesting_V3V4_338F_rawdata.tar.gz ./*gz
osf -p p9txk -u emma_strand@uri.edu upload Strand_BleachingPairs_16STesting_V3V4_338F_rawdata.tar.gz Strand_BleachingPairs_16STesting_V3V4_338F_rawdata.tar.gz
```

### Bleaching Pairs 16S Data 

```
cd /data/putnamlab/estrand/BleachingPairs_16S/Mothur

tar -czvf Strand_BleachingPairs_16S_rawdata.tar.gz ./*gz

osf -p p9txk -u emma_strand@uri.edu upload Strand_BleachingPairs_16S_rawdata.tar.gz Strand_BleachingPairs_16S_rawdata.tar.gz

```

### Bleaching Pairs RNASeq 

This is already on NCBI and counts files are on github so no OSF need. 

### Point Judith MBDBS 

My folder is all temporary working data but I want to re-do this analysis anyway. Just make sure raw transfer is done. 

What we do need on Unity that I will ask Jill to transfer:  
- `/data/putnamlab/shared/PointJudithData_Rebecca`  (16S data raw data + analysis)  
- `/data/putnamlab/shared/Oyst_Nut_RNA` (RNAseq processing)    
- `/data/putnamlab/KITT/hputnam/20200119_Oyst_Nut/MBDBS` (Methylation MBDBS raw data) - this is already on NCBI   
- `/data/putnamlab/KITT/hputnam/20200119_Oyst_Nut/DB` AND `/data/putnamlab/KITT/hputnam/20200119_Oyst_Nut/NS` (RNAseq raw data) - this is already on NCBI    

These are already on Unity! Hooray. I will have Jill transfer the Rebecca working folder. 

### Kevin data 

I made file lists of the folders he has raw data for. These will need to go to NCBI 

```
scp emma_strand@ssh3:/data/putnamlab/estrand/*.txt .

```