---
layout: post
title: Andromeda Clean-Up
date: '2022-11-11'
categories: Processing
tags: Andromeda
projects: Putnam Lab
---


# Andromeda Clean Up Fall 2022

### 16S_E5

I deleted the raw files becasue these also exist in my github lab notebook. These are trial 16S files from the E5 team and I believe also exist at Shedd with Ross. The lab work was not done or sequenced at URI. 

### Acc_dy

This appears to be some fasta file.. with protein codes? Where did this come from? Deleted it. Possibly from protein expression from Erin M?

### BleachingPairs_16S

Raw data files are on NCBI for this project. 

### BleachingPairs_ITS2

Raw data was deleted b/c this exists on NCBI and data analysis is complete.

### BleachingPairs_RNASeq

Data analysis is still in progress so I did not change anything here. There is no raw data here. 

### BleachingPairs_WGBS

cd `BleachingPairs_methylseq/`. this is the old genome v2 version so I can delete the biggest folders: 
- bismark_deduplicated
- reference_genome

I ended up deleting the whole folder to just leave the v3 version. 

`raw_data` is all sym links. 

The rest I will leave until all analysis is done. 

### HoloInt_16s

I went to delete the `HoloInt_16s/raw-data` folder because there are on NCBI but I got this question: `rm: remove write-protected regular file ‘raw-data/HPW061_S56_L001_R1_001.fastq.gz’?` so I exited out of this for now... 

### HoloInt_ITS2

No raw data here. This is all on NCBI 

### HoloInt_WGBS

I am out of the testing trial phase and using genome v2 version so I can delete the biggest files and whole folders. 

cd `HoloInt_methylseq`, `HoloInt_methylseq2`, `HoloInt_methylseq3`, and `HoloInt_methylseq_final`, . this is the old genome v2 version so I can delete the biggest folders: 
- bismark_deduplicated
- reference_genome

### Old Genome files 

I removed: 
- Montipora_capitata_HIv2.assembly.fasta
- Montipora_capitata_HIv2.genes.gff3
- Pocillopora_acuta_HIv1.assembly.fasta

Where does this live outside of my folders? /data/putnamlab/estrand/PointJudithData_16S/QIIME2_v4v5/gut_v4v5/00_RAW_gz

### PointJudithData_16S

We are only using V6 region so I am deleting the analysis I did for V3V4. 

rm -r QIIME2_v4v5

### PointJudithData_MBDBS

This is still in progress so nothing to delete here. 

### SymPortal 

I deleted this folder b/c I can redownload this for a future analysis using script I already have. 

### Test_V3V4_16S 

This is the only spot for this raw data so I didn't delete any of it. 

### work 

This didn't have anything important in it.. I think this was a product of a methylseq run in the wrong directory? Deleted. 
