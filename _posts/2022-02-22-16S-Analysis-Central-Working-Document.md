---
layout: post
title: 16S Analysis Central Working Document
date: '2022-02-22'
categories: Analysis
tags: 16S, Holobiont Integration, KBay, bioinformatics
projects: Putnam Lab
---

# 16S Analysis Central Document

This will be my working document to connect all the datasets and different analysis pipelines together. I'm working with 2 datasets: Holobiont Integration and KBay Bleaching Pairs, and working through 2 different programs: QIIME2 and Mothur for the 16S analysis pipeline.

### Question drives the experimental design, methods, analysis, and writing

**Holobiont Integration**

Github repo link: [here](https://github.com/hputnam/Acclim_Dynamics).

How does the microbial community shift in:  
- Chronic increased temperature and increased pCO2 conditions? How does experimental stimuli impact those communities? How long does a stressor have to be present to see that shift?  
- Recovery periods after a stress is alleviated? As the fragments are returning to baseline pigmentation and health status, does the community return to reflect timepoint 1? Or is this altered moving forward?  
- Does temperature or pCO2 cause a greater shift in microbial community?  
- Are there ambient, seasonal changes in microbial community through the fall season?


**KBay Bleaching Pairs**

Github repo link: [here](https://github.com/hputnam/HI_Bleaching_Timeseries).

- How does the microbial community shift during seasonal changes (July vs. December)?  
- How does the microbial community shift pre- and post- bleaching event (July vs. December)? This may be hard to distinguish from the above question of seasonality..   
- Is there a particular community that is associated with 'stronger' phenotypes?  

With just 16S data, questions RE how big of a shift and how confident we can be in that shift change might be hard to answer.. a.k.a. all we have is relative abundance. **We need to be careful interpreting this. With this type of data, we cannot confidently say genus Y decreased by X% over time because time point's data is only relative to itself.**

### Resources on 16S amplicon sequencing

These are likely private google slides and document. Contact emma_strand@uri.edu for more information on this if you do not have access.

- [Ariana's Mothur workshop notes](https://docs.google.com/document/d/1orXQezT3Nm8xJfQsy1T6ZreaJlkSr-BXA1LofRo607Y/edit)  
- [16S meeting notes](https://docs.google.com/document/d/1jlrpn4QEftbP6p4Iy_IYxkRekqylhrDXz3zRjgjrd5g/edit#)  
- [Putnam Lab meeting presentation - Huffmyer, Strand, Wong](https://docs.google.com/presentation/d/19-wLW03_1FUUyLwciXDedRmFAq9PBtnCKQwSyJ6r0Ao/edit). Mothur vs. QIIME2 and 16S background.  
- [Emma Strand journal club presentation](https://docs.google.com/presentation/d/1-70Sv9-zIuDA7Zuw5qgZkNrrE05sEOwVpWh2TjDysgo/edit) on papers with 16S data and 16S background.  

### Lab work / Pre-bioinformatic processing

The laboratory work for both projects was done the same. Laboratory notebook post for [Holobiont Integration processing](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-02-01-16s-Sequencing-HoloInt.md#sample-processing), laboratory notebook post for [KBay Bleaching Pairs processing](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-11-09-KBay-Bleaching-Pairs-16S-Processing.md). KBay Bleaching Pairs samples were processed in conjunction with K. Wong and A. Huffmyer samples (all sequenced together and I did the lab work for both).

[Putnam Lab working 16S laboratory protocol](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-02-01-16s-Sequencing-HoloInt.md).

515F and 806RB primers from [Apprill et al 2015](https://www.int-res.com/articles/ame_oa/a075p129.pdf), plus adapter overhang for sequencing on an Illumina MiSe at URI GSC.  
- This should result in a fragment that is XX basepairs long.  
- These are 2x300 reads  


### Bioinformatic processing

Multiqc reports:  
- [Holobiont Integration](https://github.com/hputnam/Acclim_Dynamics/blob/master/16S_seq/ES-run/16S_raw_qc_multiqc_report_ES.html)    
- [KBay Bleaching Pairs](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/data/16S/BleachedPairs_16S_raw_qc_multiqc_report.html)

[KBay QIIME2 pipeline](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-01-07-KBay-Pairs-16S-Analysis-Pipeline.md)  
[KBay Mothur pipeline](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-01-24-KBay-Bleached-Pairs-16S-Analysis-Mothur.md)   
[Holobiont Integration QIIME2 pipeline](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-06-21-16s-Analysis-Pipeline.md)   
[Holobiont Integration Mothur pipeline](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-02-17-Holobiont-Integration-16S-Mothur-Pipeline.md#holobiont-integration-16s-mothur-pipeline)  

**General issues to work through:**  
- Unclassified general bacteria showing up just for *M. capitata*  
- Low number of reads that are unique and aligning, therefore low subsample groups  
- Pipeline decision: Mothur or QIIME2?


### Things to do differently next time

1. Sequence a negative control sample: this will help in determining how many reads per sample you need to overcome noise in sequencing. Can ask do we see the same taxa in our negative control as our samples? This can help determine if there are taxa that we might want to take out.       
2. V4 primers may be too broad to capture what we want to with coral tissue work. Look into sequencing V3/V4 regions. We could use human microbiome project V3-4 primers - exclude Archea and Eukarya, are longer primers, and amplify less of the short fragment microsat/mitochondrial sequences.
