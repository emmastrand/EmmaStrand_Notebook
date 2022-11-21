---
layout: post
title: CpG OE Analysis for DNA Methylation
date: '2022-11-19'
categories: Analysis
tags: CpGOE, DNA methylation
projects: KBay Bleaching Pairs, Holobiont Integration
---

# Historical DNA Methylation Analysis: CpG O/E

Background on CpG O/E: 
- [Dimond et al 2016](https://onlinelibrary.wiley.com/doi/pdf/10.1111/mec.13414?casa_token=J5-ThKmLEYsAAAAA:y5x-yut6DwxurmYAVWRa-xDoybiwM-9pzEloQ3gbADjz6zc5v4HPaNALEK29LropHhwIWjBmNANRQg)
- [Dixon et al 2014](https://bmcgenomics.biomedcentral.com/track/pdf/10.1186/1471-2164-15-1109)
- [Putnam et al 2016](https://onlinelibrary.wiley.com/doi/pdf/10.1111/eva.12408).

### Download M.capitata and P.acuta 

```
wget http://cyanophora.rutgers.edu/montipora/Montipora_capitata_HIv3.assembly.fasta.gz
wget http://cyanophora.rutgers.edu/Pocillopora_acuta/Pocillopora_acuta_HIv2.assembly.fasta.gz 
```

## 1. Functional annotation of Mcap and Pacuta 

- Emma Strand Mcap v3 functional annotation: https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-11-02-M.capitata-Genome-v3-Functional-Annotation.md
- Emma Strand Pacuta v2 functional annotation: https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-11-17-Pocillopora-acuta-v2-Functional-Genome-Annotation.md

Also annotated from Rutgers site:  

### P. acuta

```
wget http://cyanophora.rutgers.edu/Pocillopora_acuta/Pocillopora_acuta_HIv2.genes.Conserved_Domain_Search_results.txt.gz 
```

## 2. CpG Ratio 

Based on scripts and pipeline instructions from:
- [Dimond et al 2016](https://onlinelibrary.wiley.com/doi/pdf/10.1111/mec.13414?casa_token=J5-ThKmLEYsAAAAA:y5x-yut6DwxurmYAVWRa-xDoybiwM-9pzEloQ3gbADjz6zc5v4HPaNALEK29LropHhwIWjBmNANRQg).  
- Jay Dimond workflow: https://github.com/jldimond/Coral-CpG 



