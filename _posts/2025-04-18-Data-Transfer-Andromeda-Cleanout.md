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

Transfer important files

```
osf -p ghsv8 -u emma_strand@uri.edu upload WGBS_methylseq_HoloInt_genomev2_multiqc_report.html methylseq_output/WGBS_methylseq_HoloInt_genomev2_multiqc_report.html


```


