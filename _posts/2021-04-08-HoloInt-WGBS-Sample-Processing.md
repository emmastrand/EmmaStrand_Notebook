---
layout: post
title: HoloInt WGBS Sample Processing
date: '2021-04-08'
categories: Processing
tags: DNA, WGBS
projects: Holobiont Integration
---

# Holobiont Integration WGBS Sample Processing

Test runs were completed prior to sample processing: see notebook post [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2020-10-21-WGBS-Pico-Methyl-Seq-Test-Run.md).    
Maggie's notebook posts for processing Danielle Becker's samples is [here](https://github.com/meschedl/MESPutnam_Open_Lab_Notebook/blob/master/_posts/2020-09-24-Danielle-WGBS.md) (as another point of reference).    
Putnam Lab WGBS Pico Methyl Seq Library Prep Protocol found [here](https://github.com/meschedl/MESPutnam_Open_Lab_Notebook/blob/master/_posts/2020-09-18-WGBS-PMS-protocol.md).  
Dennis's WGBS test runs (10 pg - 100 ng input) found [here](https://github.com/dconetta/DAC_Putnam_Lab_Notebook/blob/master/_posts/2019-08-15-PMS-Input-Conc-Tests.md).  
Zymo Pico Methyl Seq Library Prep Kit [link](https://www.zymoresearch.com/products/pico-methyl-seq-library-prep-kit).

### Pico Methylation Prep
I'm running my samples with a 10 ng input. I dilute my samples to 5 ng/uL so that I can take 2 uL of DNA and 18 uL Tris HCl for the bisulfite conversion step.   

Link to my google spreadsheet for sample processing [here](https://docs.google.com/spreadsheets/d/1lWT0KRO5x9RFflYMF9Jnk5lsGCo0k3_A98ZsyKd4kks/edit#gid=978992575) (if you don't already have access, you may request it via a google email address). This includes 5 ng/uL dilution calculations, dilution platemaps, amplification step calculations, indices information, and post-PMS protocol quantification.

For Holobiont Integration, we are processing 5 timepoints: 30 hour, 2 weeks, 4 weeks, 8 weeks, and 12 weeks (n=60).

**Notes**  
- P. acuta 2878 has already been sequenced from this project for the methylation methods comparison paper so we won't need to do this one again.  
- I started with n=3 and n=4 during trial runs but worked my way up to n=8 and n=10 at a time for this protocol. My maximum will probably be 16 samples at a time.  
- These samples will be sequenced with K. Wong and my 2nd chapter Hawaii Bleaching Pairs project. This will span across 4 lanes, each project taking up its own lane and HoloInt using 2 lanes.  
- HoloInt indices: #1-60  
- I give every sample a Pico # which is the number of the pico methylation prep I have done. There are going to be some samples that need to be re-done and for ease of labeling tubes, I will refer to each sample by their Pico # instead of the Plug ID. This will make it easier to set aside the desired tubes for sequencing rather than going by Plug ID and date of PMS protocol.

### Post Pico Methylation Protocol Quantification

As of 2021-04-06: 12/60 are done.

2021-03-31 Qubit: DNA BR Standard 1 = 173.28; Standard 2 = 19,833.04  
2021-04-06 Qubit: DNA BR Standard 1 = 179.54; Standard 2 = 19,252.29

| Plug_ID 	| Pico # 	| PMS_Date 	| DNA 1 	| DNA 2 	| Qubit (ng/uL) 	| Tapestation pass? 	| Final Pico Prep? 	| Notes                               	|
|---------	|--------	|----------	|-------	|-------	|---------------	|-------------------	|------------------	|-------------------------------------	|
| 1296    	| 1      	| 20210331 	| 23.2  	| 23    	| 23.1          	| Yes               	| Yes              	|                                     	|
| 2197    	| 2      	| 20210331 	| 20.4  	| 20.4  	| 20.4          	| Yes               	| Yes              	|                                     	|
| 1225    	| 3      	| 20210331 	| 13.3  	| 13.2  	| 13.25         	| Yes               	| Yes              	|                                     	|
| 1728    	| 4      	| 20210331 	| 9.38  	| 9.34  	| 9.36          	| Yes               	| No               	| Wrong 1728 original extraction tube 	|
| 2413    	| 5      	| 20210331 	| 21.2  	| 21.2  	| 21.2          	| Yes               	| Yes              	|                                     	|
| 1445    	| 6      	| 20210331 	| 17    	| 16.9  	| 16.95         	| Yes               	| Yes              	|                                     	|
| 1707    	| 7      	| 20210331 	| 2.78  	| 2.78  	| 2.78          	| No                	| No               	|                                     	|
| 2212    	| 8      	| 20210331 	| 5.96  	| 5.92  	| 5.94          	| No                	| No               	|                                     	|
| 2550    	| 9      	| 20210406 	| 7.98  	| 7.96  	| 7.97          	| ~1000?            	| Maybe            	| Double check with Maggie            	|
| 2861    	| 10     	| 20210406 	| **    	| **    	| #VALUE!       	| NA                	| No               	| DNA too low                         	|
| 2877    	| 11     	| 20210406 	| 22.2  	| 22.2  	| 22.2          	| Yes               	| Yes              	|                                     	|
| 1732    	| 12     	| 20210406 	| 18.6  	| 18.5  	| 18.55         	| Yes               	| Yes              	|                                     	|
| 1329    	| 13     	| 20210406 	| 22.8  	| 22.6  	| 22.7          	| Yes               	| Yes              	|                                     	|
| 1563    	| 14     	| 20210406 	| 24    	| 24    	| 24            	| Yes               	| Yes              	|                                     	|
| 1103    	| 15     	| 20210406 	| **    	| **    	| #VALUE!       	| NA                	| No               	| DNA too low                         	|
| 1728    	| 16     	| 20210406 	| 19.4  	| 19.3  	| 19.35         	| Yes               	| Yes              	|                                     	|
| 2012    	| 17     	| 20210406 	| 23.8  	| 23.8  	| 23.8          	| Yes               	| Yes              	|                                     	|
| 1051    	| 18     	| 20210406 	| 18.3  	| 18.3  	| 18.3          	| Yes               	| Yes              	|                                     	| |

Use the index #s: 4, 7, 8, 10, and 15 for the next ones.


Example of acceptable tapestation result:  

![goodtape](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/WGBS-good-tapestation.png?raw=true)

Example of one I would re-do:  

![badtape](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/WGBS-bad-tapestation.png?raw=true)

Pico #1-3 tapestation [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/TapeStation/2021-04-01%20-%2015.23.20.pdf).  
Pico #4-8 tapestation [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/TapeStation/2021-04-01%20-%2015.49.25.pdf).  
Pico #9-18 tapestation [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/TapeStation/2021-04-06%20-%2015.16.45.pdf)  
