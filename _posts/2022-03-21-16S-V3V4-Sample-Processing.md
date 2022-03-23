---
layout: post
title: 16S V3V4 Sample Processing
date: '2022-03-21'
categories: Processing
tags: 16S
projects: Putnam Lab
---

# Sample Processing for 16S V3V4 primers

16S PCR Protocol [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-02-01-16s-Sequencing-HoloInt.md).    
Excel processing sheet [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/Lab-work/V3V4_16S_March2020.xlsx). I'm using excel and github instead of google sheets so that my processing sheets are version controlled.

Contents:  
- [**Primers**](#primers)   
- [**Annealing Temperature Test**](#Annealtemp)   

## <a name="Primers"></a> **Primers**

| Primer        	| GSC Adapter Overhang               	| Primer Sequence      	| Sequence to be ordered: Adapter   + Primer Sequence    	|
|---------------	|------------------------------------	|----------------------	|--------------------------------------------------------	|
| 388F forward  	| TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG  	| ACTCCTACGGGAGGCAGCA  	| TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGACTCCTACGGGAGGCAGCA   	|
| 806RB reverse 	| GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG 	| GGACTACNVGGGTWTCTAAT 	| GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGGGACTACNVGGGTWTCTAAT 	|

[388F order sheet from IDT](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/Lab-protocols/16S_primers/388F_16S_IDT.pdf); [806RB order sheet from IDT](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/Lab-protocols/16S_primers/806RB_16S_IDT.pdf).

We received a concentrate of primer and needed to resuspend the 388F primer. Resuspending concenrate to 100 uM = started with 82.6 nM so IDT sheet said to add 826 uL to create 100 uM. Our stock will be 100 uM and then I diluted a portion to 10 uM for use in PCR protocol.

V3/V4 amplicon size: 380–400 bp + 50-60 bp for primer & adapter overhang (410-460 bp)

**Dilutions to make 10 uM primer** 	

C1 x V1 = C2 x V2
100 uM * X = 10 uM * 200 uL
X = 2,000 / 100
X = 20 uL

200 uL of 10 uM primer = 	20 uL 200 uM 	+ 180 uL Ultra Pure water

## <a name="Annealtemp"></a> **Annealing Temperature Test**

2 Pacuta, 2 Mcap adults, 2 eggs, 2 settled recruits and 1 negative control and 1 positive control (Kevin's). We're using Kevin's as a positive control because in our V4 region sequencing, his samples had low host amplification compared to mine and Ariana's. In this test, if all the bands are the same size (Kevin, mine and Ariana's) then either all of them amplified the same targets (either all microbiome or all host - goal is the microbiome).

| Strip tube   # 	| Plug ID               	| Species       	| Life stage         	| Project          	| Dilution plate                        	| Well 	| Concentration 	| Notes                               	|
|----------------	|-----------------------	|---------------	|--------------------	|------------------	|---------------------------------------	|------	|---------------	|-------------------------------------	|
| 1              	| 2878                  	| P. acuta      	| Adult              	| HoloInt          	|        DILUTIONS   PLATE 2 - 5 TP RUN 	| A11  	| 4 ng/uL       	|                                     	|
| 2              	| 2513                  	| P. acuta      	| Adult              	| HoloInt          	|        DILUTIONS   PLATE 2 - 5 TP RUN 	| B3   	| 4 ng/uL       	| 2513 for 55C/56C; 1184 (B4) for 57C 	|
| 3              	| ES-17 (M-212)         	| M. capitata   	| Adult              	| KBay             	| SAMPLE # PLATE 1                      	| A12  	| 4 ng/uL       	| ES-17 for 55C/56C; ES-18 for 57C    	|
| 4              	| ES-16 (M-217)         	| M. capitata   	| Adult              	| KBay             	| SAMPLE # PLATE 1                      	| H11  	| 4 ng/uL       	|                                     	|
| 5              	| AH-9 D1 (TP1)         	| M. capitata   	| Eggs               	| A. Huffmyer      	| SAMPLE # PLATE 1                      	| E7   	| 4 ng/uL       	|                                     	|
| 6              	| AH-10 D2 (TP1)        	| M. capitata   	| Eggs               	| A. Huffmyer      	| SAMPLE # PLATE 1                      	| F7   	| 4 ng/uL       	|                                     	|
| 7              	| AH-2 (Plug_10 48 hps) 	| M. capitata   	| Settled recruits   	| A. Huffmyer      	| SAMPLE # PLATE 1                      	| F6   	| 4 ng/uL       	|                                     	|
| 8              	| AH-3 (Plug_4 48 hps)  	| M. capitata   	| Settled recruits   	| A. Huffmyer      	| SAMPLE # PLATE 1                      	| G7   	| 4 ng/uL       	|                                     	|
| 9              	| KW-10 (R37-A1)        	| P. asteroides 	| Adult              	| KW_PJB           	| SAMPLE # PLATE 1                      	| A1   	| 4 ng/uL       	|                                     	|
| 10             	| NA                    	| NA            	| NA                 	| Negative control 	| NA                                    	| NA   	| NA            	|                                     	|

| Master   Mix Calculations 	|      	|               	|         	|
|---------------------------	|------	|---------------	|---------	|
|                           	| uL   	| N (30*3*1.05) 	| uL      	|
| Phusion MM                	| 12.5 	| 94.5          	| 1181.25 	|
| F primer                  	| 0.5  	| 94.5          	| 47.25   	|
| R primer                  	| 0.5  	| 94.5          	| 47.25   	|
| Water                     	| 10.5 	| 94.5          	| 992.25  	|

| Trial # 	| Temperature  	| n= 	|
|---------	|--------------	|----	|
| 1       	| 55C       	| 10 	|
| 2       	| 56C           	| 10 	|
| 3       	| 57C           	| 10 	|

~1 hour and 30 minutes for PCR program

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/16S_v3v4/16S_v3v4_trials.jpg?raw=true)

### GeneRuler 1kb plus DNA LAdder on 2% gel: 100V, 400amp, 1 hour

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/16S_v3v4/gel1.jpg?raw=true)

### GeneRuler 100 bp DNA Ladder on 2% gel: 75V, 400amp, 1 hour

Ladder, 10 original not diluted, 3 bright band diluted to see if there are 2 bands or just one strong band

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/16S_v3v4/20220323-gel2.jpg?raw=true)
