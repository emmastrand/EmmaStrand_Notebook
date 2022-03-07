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

## Question drives the experimental design, methods, analysis, and writing

### Holobiont Integration

Github repo link: [here](https://github.com/hputnam/Acclim_Dynamics).

How does the microbial community shift in:  
- Chronic increased temperature and increased pCO2 conditions? How does experimental stimuli impact those communities? How long does a stressor have to be present to see that shift?  
- Recovery periods after a stress is alleviated? As the fragments are returning to baseline pigmentation and health status, does the community return to reflect timepoint 1? Or is this altered moving forward?  
- Does temperature or pCO2 cause a greater shift in microbial community?  
- Are there ambient, seasonal changes in microbial community through the fall season?


### KBay Bleaching Pairs

Github repo link: [here](https://github.com/hputnam/HI_Bleaching_Timeseries).

- How does the microbial community shift during seasonal changes (July vs. December)?  
- How does the microbial community shift pre- and post- bleaching event (July vs. December)? This may be hard to distinguish from the above question of seasonality..   
- Is there a particular community that is associated with 'stronger' phenotypes?  

With just 16S data, questions RE how big of a shift and how confident we can be in that shift change might be hard to answer.. a.k.a. all we have is relative abundance. **We need to be careful interpreting this. With this type of data, we cannot confidently say genus Y decreased by X% over time because time point's data is only relative to itself.**

### Point Judith Oyster Gut V6, V4V5 project links

- [github repo - Cvir_Nut_Int](https://github.com/hputnam/Cvir_Nut_Int)  
- [V4V5 QIIME2 pipeline](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-03-02-Point-Judith-Oyster-Gut-16S-V4V5-Analysis.md)   
- [V6 QIIME2 pipeline](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-03-07-Point-Judith-Oyster-Gut-16S-V6-Analysis.md)

## Resources on 16S amplicon sequencing

These are likely private google slides and document. Contact emma_strand@uri.edu for more information on this if you do not have access.

- [Ariana's Mothur workshop notes](https://docs.google.com/document/d/1orXQezT3Nm8xJfQsy1T6ZreaJlkSr-BXA1LofRo607Y/edit)  
- [16S meeting notes](https://docs.google.com/document/d/1jlrpn4QEftbP6p4Iy_IYxkRekqylhrDXz3zRjgjrd5g/edit#)  
- [Putnam Lab meeting presentation - Huffmyer, Strand, Wong](https://docs.google.com/presentation/d/19-wLW03_1FUUyLwciXDedRmFAq9PBtnCKQwSyJ6r0Ao/edit). Mothur vs. QIIME2 and 16S background.  
- [Emma Strand journal club presentation](https://docs.google.com/presentation/d/1-70Sv9-zIuDA7Zuw5qgZkNrrE05sEOwVpWh2TjDysgo/edit) on papers with 16S data and 16S background.  
- Mothur home website: https://mothur.org/

## Lab work / Pre-bioinformatic processing

The laboratory work for both projects was done the same. Laboratory notebook post for [Holobiont Integration processing](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-02-01-16s-Sequencing-HoloInt.md#sample-processing), laboratory notebook post for [KBay Bleaching Pairs processing](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-11-09-KBay-Bleaching-Pairs-16S-Processing.md). KBay Bleaching Pairs samples were processed in conjunction with K. Wong and A. Huffmyer samples (all sequenced together and I did the lab work for both).

[Putnam Lab working 16S laboratory protocol](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-02-01-16s-Sequencing-HoloInt.md).

515F and 806RB primers from [Apprill et al 2015](https://www.int-res.com/articles/ame_oa/a075p129.pdf), plus adapter overhang for sequencing on an Illumina MiSe at URI GSC.  
- This should result in a fragment that is 253 basepairs long average.    
- These are 2x300 reads -- clarify this.. why is it not 2x250 bp sequencing?

End product from sequencing: 2 files for each sequence that has already been demultiplexed and adapters removed by URI GSC.   
- Quality and error in F and R reads   
- Read 1 error rate goes up the further down the fragment you go  
- Read 2 error rate starts a little higher due to fragment flipping and then increases as you go  
- If you have a shorter fragment, then you have coverage of all with the ability to correct the error to be more confident; if you have a longer fragment you might have areas that you can’t correct for error


## Bioinformatic processing

Multiqc reports:  
- [Holobiont Integration](https://github.com/hputnam/Acclim_Dynamics/blob/master/16S_seq/ES-run/16S_raw_qc_multiqc_report_ES.html)    
- [KBay Bleaching Pairs](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/data/16S/BleachedPairs_16S_raw_qc_multiqc_report.html)

For V4, we would expect about 250 nt as the minimum length of sequences. Use minlength=250.  
Reference database: Silva has high diversity and high alignment quality and is manually curated: Newest version is 138.1.  

[KBay QIIME2 pipeline](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-01-07-KBay-Pairs-16S-Analysis-Pipeline.md)  
[KBay Mothur pipeline](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-01-24-KBay-Bleached-Pairs-16S-Analysis-Mothur.md)   
[Holobiont Integration QIIME2 pipeline](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-06-21-16s-Analysis-Pipeline.md)   
[Holobiont Integration Mothur pipeline](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-02-17-Holobiont-Integration-16S-Mothur-Pipeline.md#holobiont-integration-16s-mothur-pipeline)  

**General issues to work through:**  
- Unclassified general bacteria showing up just for *M. capitata*  
- Low number of reads that are unique and aligning, therefore low subsample groups for KBay project   
- Pipeline decision: Mothur or QIIME2?  
- OTU vs. ASV decision - make note in each notebook post above RE what pipeline is using OTU vs ASV  
- Look into what the biases are for the primer that we used for our data (V4 vs. V3/4)

### Current progress / issues - as monday early afternoon Mar 7 2022

Holobiont Integration Mothur: running from contigs.sh - update these steps and run again   
Holobiont Integration QIIME2: Finished. Waiting decision on reseq.

KBay QIIME2: I'm losing most of my sequencing at the input step.. could this be the same error as Mothur above? See note below KBay Mothur.  
KBay Mothur: running from contigs.sh again - updated steps and run again. Low # of contigs from the very beginning... **sequencing issue?**

PJ Oyster V6: running qiime2 pipeline - fastqc and import step.


#### Mothur Threshold Decisions

Change these values based on the project and sequencing run details.

1. **contigs.sh:** trimoverlap=TRUE vs. trimoverlap=FALSE. Use TRUE when sequenced 2x300 bp and use FALSE when 2x250 bp sequencing.  
2. **screen.sh:** A.) maxambig=0. Setting this to 0 will take out any sequences with an ambigous call ("N"). B.) maxlength=350. This takes out any sequences over 350 bp long. C.) minlength=200. This takes out any sequences that are below 200 bp long.  
3. **unique.sh**: This script does not have any threshold values to change.    
4. **silva_ref.sh**: A.) start=11894 and end=25319 is the region of interest (V4 region). B.) keepdots=F. Silva database uses periods as placeholders and we don't need these so setting to false removes them.  
5. **align.sh**: This script does not have any threshold values to change.    
6. **screen2.sh**: A.) start=1968 and end=11550. This is our alignment window (1968-11550bp) and we don't want any sequences that are outside of that. This removes anything that starts after start and ends before end. B.) maxhomop=8. This removes anything that has repeats greater than the threshold - e.g., 8 A's in a row = polymer 8. Here we will removes polymers >8 because we are confident these are likely not "real".  
7. **filter.sh**: A.) vertical=T. This aligns vertically. B.) trump=. This aligns the sequences accounting for periods in the reference.  
8. **precluster.sh**: diffs=1. The rational behind this step assumes that the most abundant sequences are the most trustworthy and likely do not have sequencing errors. Pre-clustering then looks at the relationship between abundant and rare sequences - rare sequences that are "close" (e.g., 1 nt difference) to highly abundant sequences are likely due to sequencing error. This step will pool sequences and look at the maximum differences between sequences within this group to form ASV groupings.  
9. **chimera.sh**: dereplicate=T. Uses dereplicate method: In this method, we are again using the assumption that the highest abundance sequences are most trustworthy. This program looks for chimeras by comparing each sequences to the next highest abundance sequences to determine if a sequence is a chimera of the more abundance sequences.  
10. **classify.sh**: taxon=Chloroplast-Mitochondria-unknown-Archaea-Eukaryota. Identified taxon will be removed in this step.
11. **cluster.sh**: A.) cutoff=0.03 in cluster function. =3% difference. This equates to sequences with 97% similarity are grouped together. B.) taxlevel=3 and splitmethod=classify. XXXX  

These settings and thresholds will be the same between Holobiont Integration and KBay Bleaching Pairs because all lab work (DNA extractions, primer design, PCR, sequencing) was all done the same.

#### QIIME2 Threshold Decisions

1. **qiime tools import**: A.) ``--type 'SampleData[PairedEndSequencesWithQuality]'`` and B.) ``--input-format PairedEndFastqManifestPhred33V2``. See [Importing Data](https://docs.qiime2.org/2022.2/tutorials/importing/) information to select the correct type for your sequencing.  
2. **qiime dada2 denoise**: A.) `--p-trunc-len-f` and `--p-trunc-len-r`: These are cut-off values based on decreased quality seen in multiqc report. B.) `p-trim-left-f` and `p-trim-left-r` are cut-offs based on how long your primers are.  
3. **qiime feature-classifier**: A.) the classifier B.) the database chosen. See [Data Resources from QIIME2](https://docs.qiime2.org/2021.11/data-resources/) for pre-trained classifiers and suggestions.  
4. **qiime taxa filter-table**: `--p-exclude "Unassigned","Chloroplast","Eukaryota"`. Chose the taxa to filter out using `--p-mode contains`.  
5. **qiime diversity core-metrics-phylogenetic**: `--p-sampling-depth 5570`. you need to choose your subsampling depth based on either the number of sequences you have in your lowest sample or the lowest cut-off you are willing to have (1,000 is really the minimum in our field. 1,500-3,000 is more ideal).  
6. **qiime diversity alpha-rarefaction**: `--p-max-depth 5570`. See note above.

These are the decisions we include in our pipeline. See QIIME2 documentation for further options and defaults in each step of the pipeline.

### Things to do differently next time

1. Sequence a negative control sample: this will help in determining how many reads per sample you need to overcome noise in sequencing. Can ask do we see the same taxa in our negative control as our samples? This can help determine if there are taxa that we might want to take out.       
2. V4 primers may be too broad to capture what we want to with coral tissue work. Look into sequencing V3/V4 regions. We could use human microbiome project V3-4 primers - exclude Archea and Eukarya, are longer primers, and amplify less of the short fragment microsat/mitochondrial sequences. Craig recommended the Human Microbiome Project V3V4 region primers (a recent paper from their lab is here https://www.nature.com/articles/s41522-021-00252-1).   
3. Think about creating a mock community in lab (can also buy from Zymo) to act as a control too. This can give error rate and sequencing performance.  
4. Think about running consistent sampling (taking the same sample and sequencing multiple times). This could be more important if there is a large project with multiple sequence runs.    
