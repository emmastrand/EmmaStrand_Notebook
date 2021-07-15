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

As of 2021-07-01: 38/60 are done. 22 left.

2021-03-31 Qubit: DNA BR Standard 1 = 173.28; Standard 2 = 19,833.04  
2021-04-06 Qubit: DNA BR Standard 1 = 179.54; Standard 2 = 19,252.29  
2021-05-24 Qubit: DNA BR Standard 1 = 194.96; Standard 2 = 21,282.28  
2021-06-09 Qubit: DNA BR Standard 1 = 192.07; Standard 2 = 20,942.30  
2021-06-10 Qubit: DNA BR Standard 1 = 179.67; Standard 2 = 19,385.82  
2021-06-14 Qubit: DNA BR Standard 1 = 190.50; Standard 2 = 20,152.88  
2021-07-01 Qubit: DNA BR Standard 1 = 193.88; Standard 2 = 20,559.34  

| Plug_ID 	| Pico # 	| Index # 	| PMS_Date 	| DNA 1 	| DNA 2 	| Qubit (ng/uL) 	| Bp size 	| Re-amp Qubit value (ng/uL) 	| Reamp Bp size 	| Tapestation pass? 	| Final Pico Prep? 	| Notes                                     	|
|---------	|--------	|---------	|----------	|-------	|-------	|---------------	|---------	|----------------------------	|---------------	|-------------------	|------------------	|-------------------------------------------	|
| 1296    	| 1      	| 1       	| 20210331 	| 23.2  	| 23    	| 23.1          	| 378     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 2197    	| 2      	| 2       	| 20210331 	| 20.4  	| 20.4  	| 20.4          	| 362     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1225    	| 3      	| 3       	| 20210331 	| 13.3  	| 13.2  	| 13.25         	| 338     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1728    	| 4      	| 4       	| 20210331 	| 9.38  	| 9.34  	| 9.36          	| NA      	| NA                         	| NA            	| Yes               	| No               	| Wrong 1728 original extraction tube       	|
| 2413    	| 5      	| 5       	| 20210331 	| 21.2  	| 21.2  	| 21.2          	| 387     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1445    	| 6      	| 6       	| 20210331 	| 17    	| 16.9  	| 16.95         	| 391     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1707    	| 7      	| 7       	| 20210331 	| 12.7  	| 12.6  	| 12.65         	| 349     	| NA                         	| NA            	| Yes               	| Yes              	| successfully reamped                      	|
| 2212    	| 8      	| 8       	| 20210331 	| 25    	| 24.8  	| 24.9          	| 433     	| NA                         	| NA            	| Yes               	| Yes              	| successfully reamped                      	|
| 2550    	| 9      	| 9       	| 20210406 	| 7.98  	| 7.96  	| 7.97          	| 569     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 2861    	| 10     	| 10      	| 20210406 	| **    	| **    	| #VALUE!       	| NA      	| NA                         	| NA            	| NA                	| No               	| failed reamp; redo                        	|
| 2877    	| 11     	| 11      	| 20210406 	| 22.2  	| 22.2  	| 22.2          	| 297     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1732    	| 12     	| 12      	| 20210406 	| 18.6  	| 18.5  	| 18.55         	| 286     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1329    	| 13     	| 13      	| 20210406 	| 22.8  	| 22.6  	| 22.7          	| 359     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1563    	| 14     	| 14      	| 20210406 	| 24    	| 24    	| 24            	| 315     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1103    	| 15     	| 15      	| 20210406 	| **    	| **    	| #VALUE!       	| NA      	| NA                         	| NA            	| NA                	| No               	| failed reamp; redo                        	|
| 1728    	| 16     	| 16      	| 20210406 	| 19.4  	| 19.3  	| 19.35         	| 387     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 2012    	| 17     	| 17      	| 20210406 	| 23.8  	| 23.8  	| 23.8          	| 353     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1051    	| 18     	| 18      	| 20210406 	| 18.3  	| 18.3  	| 18.3          	| 431     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1559    	| 19     	| 19      	| 20210524 	| 65.6  	| 65.4  	| 65.5          	| NA      	| NA                         	| NA            	| No                	| No               	| funky contamination? & KAPA               	|
| 2513    	| 20     	| 20      	| 20210524 	| **    	| **    	| #VALUE!       	| NA      	| NA                         	| NA            	| No                	| No               	| funky contamination? & KAPA               	|
| 1820    	| 21     	| 21      	| 20210524 	| 53.2  	| 53    	| 53.1          	| NA      	| NA                         	| NA            	| No                	| No               	| funky contamination? & KAPA               	|
| 1238    	| 22     	| 22      	| 20210524 	| 36.6  	| 36.4  	| 36.5          	| NA      	| NA                         	| NA            	| No                	| No               	| funky contamination? & KAPA               	|
| 2064    	| 23     	| 23      	| 20210524 	| 31.6  	| 31.6  	| 31.6          	| NA      	| NA                         	| NA            	| No                	| No               	| funky contamination? & KAPA               	|
| 1168    	| 24     	| 24      	| 20210524 	| 41.8  	| 41.8  	| 41.8          	| NA      	| NA                         	| NA            	| No                	| No               	| funky contamination? & KAPA               	|
| 1459    	| 25     	| 25      	| 20210524 	| 70.8  	| 70.6  	| 70.7          	| NA      	| NA                         	| NA            	| Yes               	| No               	| funky contamination? & KAPA               	|
| 1765    	| 26     	| 26      	| 20210524 	| 48.8  	| 48.6  	| 48.7          	| NA      	| NA                         	| NA            	| No                	| No               	| funky contamination? & KAPA               	|
| 1559    	| 27     	| 19      	| 20210609 	| 2.42  	| 2.38  	| 2.4           	| NA      	| 3.53                       	| 304           	| Maybe             	| No               	|                                           	|
| 2513    	| 28     	| 20      	| 20210609 	| 5.18  	| 5.14  	| 5.16          	| NA      	| 9.2                        	| 262           	| Maybe             	| Maybe            	| reamp value higher                        	|
| 1820    	| 29     	| 21      	| 20210609 	| 3.56  	| 3.56  	| 3.56          	| NA      	| 5.67                       	| 274           	| Maybe             	| No               	|                                           	|
| 1238    	| 30     	| 22      	| 20210609 	| 3.14  	| 3.14  	| 3.14          	| NA      	| 3.34                       	| 310           	| Maybe             	| No               	|                                           	|
| 2064    	| 31     	| 23      	| 20210609 	| 16.6  	| 16.6  	| 16.6          	| NA      	| 4.33                       	| 262           	| No                	| No               	| slightly double peak                      	|
| 1168    	| 32     	| 24      	| 20210609 	| 5.16  	| 5.12  	| 5.14          	| NA      	| 5.88                       	| 274           	| Maybe             	| No               	|                                           	|
| 1459    	| 33     	| 25      	| 20210609 	| 3.52  	| 3.5   	| 3.51          	| NA      	| 2.74                       	| 286           	| No                	| No               	|                                           	|
| 1765    	| 34     	| 26      	| 20210609 	| 2.8   	| 2.78  	| 2.79          	| NA      	| 2.53                       	| 264           	| No                	| No               	|                                           	|
| 2861    	| 35     	| 10      	| 20210609 	| 3.02  	| 3     	| 3.01          	| NA      	| 3.45                       	| 289           	| No                	| No               	|                                           	|
| 1103    	| 36     	| 15      	| 20210609 	| 2.7   	| 2.68  	| 2.69          	| NA      	| 3.12                       	| 274           	| No                	| No               	|                                           	|
| 2072    	| 37     	| 27      	| 20210609 	| 2.84  	| 2.8   	| 2.82          	| NA      	| 3.62                       	| 268           	| No                	| No               	|                                           	|
| 2304    	| 38     	| 28      	| 20210609 	| 2.18  	| 2.18  	| 2.18          	| NA      	| 2.56                       	| 315           	| No                	| No               	|                                           	|
| 1184    	| 39     	| 29      	| 20210609 	| 2.54  	| 2.52  	| 2.53          	| NA      	| 2.31                       	| 280           	| No                	| No               	|                                           	|
| 2185    	| 40     	| 30      	| 20210609 	| **    	| **    	| #VALUE!       	| NA      	| NA                         	| NA            	| No                	| No               	| redo                                      	|
| 2564    	| 41     	| 31      	| 20210609 	| 10.3  	| 10.2  	| 10.25         	| NA      	| 3.49                       	| 263           	| No                	| No               	|                                           	|
| 1757    	| 42     	| 32      	| 20210609 	| 2.22  	| 2.22  	| 2.22          	| NA      	| **                         	| 285           	| No                	| No               	|                                           	|
| 1416    	| 43     	| 33      	| 20210614 	| 8.6   	| 8.54  	| 8.57          	| 321     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1415    	| 44     	| 34      	| 20210614 	| 5.1   	| 5.08  	| 5.09          	| 364     	| NA                         	| NA            	| Yes               	| Yes              	| might be too low, what is min?            	|
| 1641    	| 45     	| 35      	| 20210614 	| 7.18  	| 7.12  	| 7.15          	| 343     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1536    	| 46     	| 36      	| 20210614 	| 14.7  	| 14.6  	| 14.65         	| 327     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1090    	| 47     	| 37      	| 20210614 	| 15.7  	| 15.7  	| 15.7          	| 329     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1303    	| 48     	| 38      	| 20210614 	| 6.86  	| 6.8   	| 6.83          	| 311     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1755    	| 49     	| 39      	| 20210614 	| 4.38  	| 4.34  	| 4.36          	| 327     	| NA                         	| NA            	| Yes               	| Maybe            	| re-amp? this didn't work for me last time 	|
| 1596    	| 50     	| 40      	| 20210614 	| 19.1  	| 19.1  	| 19.1          	| 341     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1281    	| 51     	| 41      	| 20210701 	| 7.12  	| 7.1   	| 7.11          	| 334     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1571    	| 52     	| 42      	| 20210701 	| 13.1  	| 13    	| 13.05         	| 316     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 2300    	| 53     	| 43      	| 20210701 	| 11.5  	| 11.5  	| 11.5          	| 311     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1427    	| 54     	| 44      	| 20210701 	| 8.72  	| 8.68  	| 8.7           	| 280     	| NA                         	| NA            	| Yes               	| Maybe            	| bp size too low?                          	|
| 1205    	| 55     	| 45      	| 20210701 	| 11.3  	| 11.2  	| 11.25         	| 312     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 2879    	| 56     	| 46      	| 20210701 	| 10.7  	| 10.6  	| 10.65         	| 305     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1709    	| 57     	| 47      	| 20210701 	| 13.7  	| 13.7  	| 13.7          	| 331     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|
| 1777    	| 58     	| 48      	| 20210701 	| 8.64  	| 8.6   	| 8.62          	| 309     	| NA                         	| NA            	| Yes               	| Yes              	|                                           	|

Use the index #s: 4 at the end.

Pico #19-26 done on 2021-05-24: KAPA hifi mix was used and funky contamination.. see [tapestation](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/TapeStation/2021-05-24%20-%2016.49.02.pdf). These were re-done in Pico #27-34.

Pico #27-42 were all low amplification. Re-amps were done on all except for Pico#40. Re-amps failed except for Pico#28.

Soft DNA E2 tubes missing for: 2409 (Ext ID 323, 324), 1047 (Ext ID 325, 326), 1059 (Ext ID 413, 414), and 2087 (Ext ID 415, 416).  
- Soft DNA E1 2409 = 531 ng/uL  
- Soft DNA E1 1047 = 931 ng/uL  
- Soft DNA E1 1059 = 208 ng/uL  
- Soft DNA E1 2087 = 524 ng/uL  

We could use the E1 tubes instead? Those qubit values seem way too high..   
We have the Hard DNA E2 tubes for all four samples. Those have been used for 16s and ITS2.

### Tapestation examples

Example of acceptable tapestation result:  

![goodtape](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/WGBS-good-tapestation.png?raw=true)

Example of one I would re-do:  

![badtape](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/WGBS-bad-tapestation.png?raw=true)

### D5000 Tapestation results

Pico #1-3 tapestation [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/TapeStation/2021-04-01%20-%2015.23.20.pdf).  
Pico #4-8 tapestation [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/TapeStation/2021-04-01%20-%2015.49.25.pdf).  
Pico #9-18 tapestation [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/TapeStation/2021-04-06%20-%2015.16.45.pdf).    
7 and 8 reamped tapestation [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/TapeStation/2021-05-26%20-%2011.24.21.pdf).  
Pico #19-26 tapestation [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/TapeStation/2021-05-24%20-%2016.49.02.pdf).  
Pico #27-42 TapeStation [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/TapeStation/2021-06-09%20-%2016.57.33.pdf).  
Re-amps for Pico #27-42 tapestation [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/TapeStation/2021-06-10%20-%2011.46.47.pdf).  
Pico #43-50 tapestation [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/TapeStation/2021-06-14%20-%2016.04.20.pdf)    
Pico #51-58 tapestation [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/TapeStation/2021-07-01%20-%2015.25.53.pdf)  
Pico #59-73 tapestation [here]()  
Pico #74,27,30,38,44,49 tapestation [here]()  

### Final D5000 Tapestation for all samples (60)

To view each image closer up, click on the image and this will open another tab with that image enlarged.

![test](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/HoloInt%20WGBS%20D5000/Screen%20Shot%202021-07-15%20at%2010.41.05%20AM.png?raw=true)
