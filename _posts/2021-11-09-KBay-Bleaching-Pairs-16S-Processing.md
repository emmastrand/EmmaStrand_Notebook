---
layout: post
title: KBay Bleaching Pairs 16S Processing
date: '2021-11-09'
categories: Processing
tags: 16S, DNA, KBay
projects: KBay
---

# KBay Bleaching Pairs 16S Processing

Processing with Ariana and Kevin's samples. Spreadsheet for sample names and plate maps found [here](https://docs.google.com/spreadsheets/d/1hFIY0g74x_yjGrz7F8n_IFccVfC5TheEPZtd7_je3uI/edit#gid=1693868430).

Putnam Lab 16S protocol found [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-02-01-16s-Sequencing-HoloInt.md).  

## Trial run

Master mix calculations:

|                	| (ul) 	| # of rxns 	| (ul) to add 	|
|----------------	|------	|-----------	|-------------	|
| Phusion MM     	| 12.5 	| 43.5      	| 543.75      	|
| 806RB primer   	| 0.5  	| 43.5      	| 21.75       	|
| 515F primer    	| 0.5  	| 43.5      	| 21.75       	|
| Ultra pure H2O 	| 10.5 	| 43.5      	| 456.75      	|

Platemap (plate 1)

|   	| 1      	| 2      	| 3      	| 4      	| 5      	| 6      	| 7     	| 8     	| 9     	| 10    	| 11    	| 12    	|
|---	|--------	|--------	|--------	|--------	|--------	|--------	|-------	|-------	|-------	|-------	|-------	|-------	|
| A 	| KW-10  	| KW-10  	| KW-10  	| KW-11  	| KW-11  	| KW-11  	| KW-12 	| KW-12 	| KW-12 	| KW-13 	| KW-13 	| KW-13 	|
| B 	| AH-2   	| AH-2   	| AH-2   	| AH-3   	| AH-3   	| AH-3   	| AH-4  	| AH-4  	| AH-4  	| AH-5  	| AH-5  	| AH-5  	|
| C 	| ES-2   	| ES-2   	| ES-2   	| ES-4   	| ES-4   	| ES-4   	| ES-6  	| ES-6  	| ES-6  	| ES-16 	| ES-16 	| ES-16 	|
| D 	| POS(+) 	| POS(+) 	| POS(+) 	| NEG(-) 	| NEG(-) 	| NEG(-) 	|       	|       	|       	|       	|       	|       	|

Positive control: *M. capitata* sample from Holobiont Integration M2410 from well B1 from dilution plate 2.  
Negative control: Ultrapure water

![gelimage](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/KBay%2016S/trial-run-gel.jpg?raw=true)

Initially we were worried about the difference in band size between KW and AH/ES samples (KW appears to be closer to 400 bp and AH/ES bands seem to be closer to 300 bp long). This could be because AH and ES samples are picking up more of the 18S and mitochondria regions than the 16S regions. However, the positive control was a sample that we have sequenced previously and in the gel image above it looks like the *M. capitata* ES samples.

### Positive control M2410 sequencing details

M2410 = HPW060 (Sequencing ID with URI GSC)

Denoising stats: M2410 was the 57th lowest # of reads after filtering out non-chimeric out of 262 samples.

| Plug ID                	| Sequencing ID 	| Input    	| Filtered 	| % of input passed filtered 	| Denoised 	| Merged   	| % of input merged 	| Non-chimeric 	| % of input non-chimeric 	|
|------------------------	|---------------	|----------	|----------	|----------------------------	|----------	|----------	|-------------------	|--------------	|-------------------------	|
| M2410                  	| HPW060        	| 31027    	| 22804    	| 73.5                       	| 22472    	| 20306    	| 65.45             	| 19673        	| 63.41                   	|
| Average of all samples 	|               	| 40776.97 	| 29593.68 	| 72.49211                   	| 29411.86 	| 27954.59 	| 67.92323          	| 27939.43     	| 67.88873                	|

Next steps could be to try a short run with more of the samples from Holobiont Integration - because I only did one of my pervious ones, I don't know if the faint band is truly reflective of the below avaerage denoising statistics above.  
