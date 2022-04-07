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
- [**Sequencing test run 1**](#Seq1)   

## <a name="Primers"></a> **Primers**

| Primer        	| GSC Adapter Overhang               	| Primer Sequence      	| Sequence to be ordered: Adapter   + Primer Sequence    	|
|---------------	|------------------------------------	|----------------------	|--------------------------------------------------------	|
| 338F forward  	| TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG  	| ACTCCTACGGGAGGCAGCA  	| TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGACTCCTACGGGAGGCAGCA   	|
| 806RB reverse 	| GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG 	| GGACTACNVGGGTWTCTAAT 	| GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGGGACTACNVGGGTWTCTAAT 	|

[338F order sheet from IDT](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/Lab-protocols/16S_primers/338F_16S_IDT.pdf); [806RB order sheet from IDT](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/Lab-protocols/16S_primers/806RB_16S_IDT.pdf).

We received a concentrate of primer and needed to resuspend the 338F primer. Resuspending concenrate to 100 uM = started with 82.6 nM so IDT sheet said to add 826 uL to create 100 uM. Our stock will be 100 uM and then I diluted a portion to 10 uM for use in PCR protocol.

V3/V4 amplicon size: 380–400 bp + 50-60 bp for primer & adapter overhang (410-460 bp)

**Dilutions to make 10 uM primer** 	

C1 x V1 = C2 x V2
100 uM * X = 10 uM * 200 uL
X = 2,000 / 100
X = 20 uL

200 uL of 10 uM primer = 	20 uL 200 uM 	+ 180 uL Ultra Pure water

## <a name="Annealtemp"></a> **Annealing Temperature Test**

### 20220321 Trial 1

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

#### GeneRuler 1kb plus DNA LAdder on 2% gel: 100V, 400amp, 1 hour

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/16S_v3v4/gel1.jpg?raw=true)

#### GeneRuler 100 bp DNA Ladder on 2% gel: 75V, 400amp, 1 hour

Ladder, 10 original not diluted, 3 bright band diluted to see if there are 2 bands or just one strong band

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/16S_v3v4/20220323-gel2.jpg?raw=true)

https://www.thermofisher.com/us/en/home/brands/thermo-scientific/molecular-biology/molecular-biology-learning-center/molecular-biology-resource-library/spotlight-articles/8-DNA-ladder-tips.html

Next steps: PCR at 57C (and maybe 58?) with same samples - original DNA then dilute to 4 ng/uL then PCR and gel again. No dye in ladder and 2% gel like last time.

### 20220404 Trial 2

Same samples as above but re-diluted from original DNA and did duplicates instead of triplicates to save materials. Ran at 57C and 58C to make sure we have the correct annealing temperature. Dilution: in 20 uL dilution volume -- 4 ng/uL*20uL reaction / Qubit value = 80/Qubit value.

| Strip tube   # 	| Plug ID                 	| Species       	| Life stage         	| Project          	| Original DNA tube        	| DNA concentration (ng/uL) 	| DNA for dilution (uL) 	| Ultrapure H20 for dilution (uL) 	| Notes                                    	|
|----------------	|-------------------------	|---------------	|--------------------	|------------------	|--------------------------	|---------------------------	|-----------------------	|---------------------------------	|------------------------------------------	|
| 1              	| 2878                    	| P. acuta      	| Adult              	| HoloInt          	| 20190807 Ext ID 319, 320 	| 48.7                      	| 1.64                  	| 18.36                           	| Hard DNA boxes                           	|
| 2              	| 2513                    	| P. acuta      	| Adult              	| HoloInt          	| 20190722 Ext ID 65, 66   	| 12.55                     	| 6.37                  	| 13.63                           	| Hard DNA boxes                           	|
| 3              	| ES-17 (M-212 12-4-2019) 	| M. capitata   	| Adult              	| KBay             	| 20210225 Ext ID 17       	| 32.9                      	| 2.43                  	| 17.57                           	| KBay DNA box                             	|
| 4              	| ES-16 (M-217 12-4-2019) 	| M. capitata   	| Adult              	| KBay             	| 20210225 Ext ID 16       	| 36.5                      	| 2.19                  	| 17.81                           	| KBay DNA box                             	|
| 5              	| AH-9 D1 (TP1)           	| M. capitata   	| Eggs               	| A. Huffmyer      	|                          	| too low                   	| #VALUE!               	| #VALUE!                         	| pull 3 uL straight from Kevin's dilution 	|
| 6              	| AH-10 D2 (TP1)          	| M. capitata   	| Eggs               	| A. Huffmyer      	|                          	| too low                   	| #VALUE!               	| #VALUE!                         	| pull 3 uL straight from Kevin's dilution 	|
| 7              	| AH-2 (Plug_10 48 hps)   	| M. capitata   	| Settled recruits   	| A. Huffmyer      	|                          	|        31.4               	| 2.55                  	| 17.45                           	|                                          	|
| 8              	| AH-3 (Plug_4 48 hps)    	| M. capitata   	| Settled recruits   	| A. Huffmyer      	|                          	| 51                        	| 1.57                  	| 18.43                           	|                                          	|
| 9              	| KW-10 (R37-A1)          	| P. asteroides 	| Adult              	| KW_PJB           	| Vial #10                 	| 10.2                      	| 7.84                  	| 12.16                           	| Porites july bleaching DNA extracts      	|
| 10             	| NA                      	| NA            	| NA                 	| Negative control 	| NA                       	| NA                        	| NA                    	| NA                              	| NA                                       	|

| Master   Mix Calculations 	|      	|               	|     	|
|---------------------------	|------	|---------------	|-----	|
|                           	| uL   	| N (20*2*1.05) 	| uL  	|
| Phusion MM                	| 12.5 	| 42            	| 525 	|
| F primer                  	| 0.5  	| 42            	| 21  	|
| R primer                  	| 0.5  	| 42            	| 21  	|
| Water                     	| 10.5 	| 42            	| 441 	|

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/16S_v3v4/20220404-16Sv3v4-trial2.jpg?raw=true)

#### GeneRuler 100 bp DNA Ladder on 2% gel: 75V, 400amp, 1 hour

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/16S_v3v4/gel-trial2.jpg?raw=true)

### 20220406 Trial 3

Trial1 = 12 ng DNA input total in that gel band (done in triplicates)  
Trial2 = 8 ng DNA input total in that gel band (done in duplicates)  
Trial3 - varying DNA input to see if we can get a band to appear in those that don't have one  

Done in triplicates

4 ng/uL already made from Trial 2 - use those  
in 20 uL dilution volume -- 8 ng/uL*20uL reaction / Qubit value = 160/Qubit value							

|    	| SampleID            	| Input concentration 	| Original DNA tube        	| Notes         	| DNA concentration (ng/uL) 	| DNA for dilution (uL) 	| Ultrapure H20 for dilution (uL) 	|
|----	|---------------------	|---------------------	|--------------------------	|---------------	|---------------------------	|-----------------------	|---------------------------------	|
| 1  	| P.acuta 2513 adult  	| 4 ng/uL             	| 20190722 Ext ID 65, 66   	| Bright band   	| 12.55                     	| 6.37                  	| 13.63                           	|
| 2  	| P. ast KW-10        	| 4 ng/uL             	| Vial #10                 	| Bright band   	| 10.2                      	| 7.84                  	| 12.16                           	|
| 3  	| M. cap Plug10       	| 4 ng/uL             	| Labeled plug 10          	| Faint/No band 	| 31.4                      	| 2.55                  	| 17.45                           	|
| 4  	| P. acuta 2878 adult 	| 4 ng/uL             	| 20190807 Ext ID 319, 320 	| Faint/No band 	| 48.7                      	| 1.64                  	| 18.36                           	|
| 5  	| M. cap M-217        	| 4 ng/uL             	| 20210225 Ext ID 16       	| No band       	| 36.5                      	| 2.19                  	| 17.81                           	|
| 6  	| M. cap M-212        	| 4 ng/uL             	| 20210225 Ext ID 17       	| No band       	| 32.9                      	| 2.43                  	| 17.57                           	|
| 7  	| P.acuta 2513 adult  	| 8 ng/uL             	| 20190722 Ext ID 65, 66   	| Bright band   	| 12.55                     	| 12.75                 	| 7.25                            	|
| 8  	| P. ast KW-10        	| 8 ng/uL             	| Vial #10                 	| Bright band   	| 10.2                      	| 15.69                 	| 4.31                            	|
| 9  	| M. cap Plug10       	| 8 ng/uL             	| Labeled plug 10          	| Faint/No band 	| 31.4                      	| 5.10                  	| 14.90                           	|
| 10 	| P. acuta 2878 adult 	| 8 ng/uL             	| 20190807 Ext ID 319, 320 	| Faint/No band 	| 48.7                      	| 3.29                  	| 16.71                           	|
| 11 	| M. cap M-217        	| 8 ng/uL             	| 20210225 Ext ID 16       	| No band       	| 36.5                      	| 4.38                  	| 15.62                           	|
| 12 	| M. cap M-212        	| 8 ng/uL             	| 20210225 Ext ID 17       	| No band       	| 32.9                      	| 4.86                  	| 15.14                           	|

| Master   Mix Calculations 	|      	|               	|       	|
|---------------------------	|------	|---------------	|-------	|
|                           	| uL   	| N (12*3*1.05) 	| uL    	|
| Phusion MM                	| 12.5 	| 37.8          	| 472.5 	|
| F primer                  	| 0.5  	| 37.8          	| 18.9  	|
| R primer                  	| 0.5  	| 37.8          	| 18.9  	|
| Water                     	| 10.5 	| 37.8          	| 396.9 	|

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/16S_v3v4/trial3-20220406.jpg?raw=true)

#### GeneRuler 100 bp DNA Ladder on 2% gel: 75V, 400amp, 1 hour

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/16S_v3v4/gel-trial3.jpg?raw=true)

## Notes

Based on other papers that use 338F and 806R, we have a lot of room to bump up the ng concentrations. Other papers are in the range of 50-100 ng input per sample.

338F and 806R:   
Pocillopora - [Qin et al 2022](https://www.mdpi.com/2076-2607/10/2/207)  
Favites and Acropora - [Meenatchi et al 2020](https://reader.elsevier.com/reader/sd/pii/S0944501319313126?token=B416D94747CAD990D64F1B01261C8AE459983B43ABA076CC711CFF993BBEF149FCC8B017D6492BCE6657861E2DBC6DC4&originRegion=us-east-1&originCreation=20220406211052)  
Pocillopora - [Yang et al 2020](https://academic.oup.com/femsec/article/97/1/fiaa215/5924451#221111253)

341F and 802R:
Phanerochaete and Galaxea - [Cai et al 2018](https://link.springer.com/article/10.1007/s00253-018-8909-5#Sec2)

341F and 785R:  
Porites spp. - [O'Brien et al 2018](https://www.frontiersin.org/articles/10.3389/fmicb.2018.02621/full#h3)

341F and 806R: Nelson's lab at Hawaii for M. capitata

**Adult M. capitata might not work with the 338F primer?**

## <a name="Seq1"></a> **Sequencing test run 1**

Samples to send:

![]()

| SampleID 	| Strip tube # to Janet 	| Original strip tube # 	| SampleID         	| Lifestage       	| Species            	| DNA input             	| Date PCR run 	| Trial # 	| Band information 	| Replicate # (uL total after gel) 	| uL leftover after  	|
|----------	|-----------------------	|-----------------------	|------------------	|-----------------	|--------------------	|-----------------------	|--------------	|---------	|------------------	|----------------------------------	|--------------------	|
| ELS001   	| 1                     	| 7                     	| 2513             	| Adult           	| Pocillopora acuta  	| 8 ng/uL (24 ng total) 	| 20220406     	| 3       	| strong           	| 3 (70 uL)                        	| 45 uL              	|
| ELS002   	| 2                     	| 8                     	| KW-10            	| Adult           	| Porites asteroides 	| 8 ng/uL (24 ng total) 	| 20220406     	| 3       	| strong           	| 3 (70 uL)                        	| 45 uL              	|
| ELS003   	| 3                     	| 9                     	| Plug10           	| Settled recruit 	| Montipora capitata 	| 8 ng/uL (24 ng total) 	| 20220406     	| 3       	| strong           	| 3 (70 uL)                        	| 45 uL              	|
| ELS004   	| 4                     	| 10                    	| 2878             	| Adult           	| Pocillopora acuta  	| 4 ng/uL (12 ng total) 	| 20220321     	| 1       	| faint            	| 3 (70 uL)                        	| 45 uL              	|
| ELS005   	| 5                     	| 11                    	| M-217            	| Adult           	| Montipora capitata 	| 8 ng/uL (24 ng total) 	| 20220406     	| 3       	| none             	| 3 (70 uL)                        	| 45 uL              	|
| ELS006   	| 6                     	| 12                    	| M-212            	| Adult           	| Montipora capitata 	| 8 ng/uL (24 ng total) 	| 20220406     	| 3       	| none             	| 3 (70 uL)                        	| 45 uL              	|
| ELS007   	| 7                     	| (-)                   	| Negative control 	| NA              	| NA                 	| NA                    	| 20220406     	| 3       	| none             	| 3 (70 uL)                        	| 45 uL              	|
| ELS008   	| 8                     	| 5                     	| D1               	| Eggs            	| Montipora capitata 	| **too low**           	| 20220404     	| 2       	| faint            	| 2 (45 uL)                        	| 20 uL              	|

Along with Kevin's if he needs to send any.
