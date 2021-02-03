---
layout: post
title: 16s Sequencing Protocol
date: '2021-02-01'
categories: Protocol
tags: 16s, DNA
projects: Putnam Lab
---

# 16s Sequencing



## Next Gen 16s Sequencing Primer Design

Rebecca Stevik originally tried 518F and 926R for 16s V4/V5 region but had trouble with the results. Link to [protocol google sheet](https://docs.google.com/spreadsheets/d/1nwWCbPFduX4a2K3Fc-qeALjZADdt0yuQTMVSW2n9SbU/edit?usp=sharing).  

Primers: ITS2, cp23S, and 16S with Nextera partial tails
Annealing temp: 57°

| Primer 	| Region   	| Sequence                                                                                                                                                         	|
|--------	|----------	|------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| 518F   	| 16S V4V5 	| TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGCCAGCAGCYGCGGTAAN                                                                                                               	|
| 926R   	| 16S V4V5 	| GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGCCGTCAATTCNTTTRAGT, GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGCCGTCAATTTCTTTGAGT, GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGCCGTCTATTCCTTTGANT 	|


[URI GSC](https://web.uri.edu/gsc/next-generation-sequencing/) requires specific adapter sequences that are outlined below:  

Forward Primer with Adapter Overhang:

5’ **TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG‐[locus-specific sequence]**

Reverse Primer with Adapter Overhang:

5’ **GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG‐[locus-specific sequence]**

### 515F and 806R for V4

Now we want to try 515F and 806R for the V4 region. Below information from [Earth Microbiome](https://earthmicrobiome.org/protocols-and-standards/16s/).

Earth Microbiome:  

515F forward primer, barcoded  
Field descriptions (space-delimited):

5′ Illumina adapter  
Golay barcode  
Forward primer pad  
Forward primer linker  
Forward primer (515F)  

AATGATACGGCGACCACCGAGATCTACACGCT XXXXXXXXXXXX TATGGTAATT GT GTGYCAGCMGCCGCGGTAA

806R reverse primer  
Field descriptions (space-delimited):

Reverse complement of 3′ Illumina adapter  
Reverse primer pad  
Reverse primer linker  
Reverse primer (806R)  

CAAGCAGAAGACGGCATACGAGAT AGTCAGCCAG CC GGACTACNVGGGTWTCTAAT

[Apprill et al 2015](https://www.int-res.com/articles/ame_oa/a075p129.pdf):  
515F: 5’-**GTG CCA GCM GCC GCG GTA A**-3’    
806R: 5’-**GGA CTA CNV GGG TWT CTA AT**-3’

We took the primer sequences from Apprill et al 2015, and added the URI GSC specific adapter sequences (all bolded above):  

| Primer       	| GSC Adapter Overhang               	| Sequence             	| Custom primer to be ordered (Adapter+Seq):             	|
|--------------	|------------------------------------	|----------------------	|--------------------------------------------------------	|
| 515F forward 	| TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG  	| GTGCCAGCMGCCGCGGTAA  	| TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGGTGCCAGCMGCCGCGGTAA   	|
| 806RB reverse 	| GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG 	| GGACTACNVGGGTWTCTAAT 	| GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGGGACTACNVGGGTWTCTAAT 	|

## Lab Protocol

Based on Earth Microbiome, Apprill et al 2015, and URI GSC (figure below).

![workflow1](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/16s-workflow.png?raw=true)

In our lab, we will complete the first PCR step and then we pay URI GSC to complete the rest of the library prep and preparation for sequencing. 

![workflow2]()

515F Forward and 806RB Reverse Amplicon size: ~390 bp.

PCR program:  

| Temperature 	| Time, 96-well 	| Time, 384-well 	| Repeat 	|
|-------------	|---------------	|----------------	|--------	|
| 94 °C       	| 3 min         	| 3 min          	|        	|
| 94 °C       	| 45 s          	| 60 s           	| x35    	|
| 50 °C       	| 60 s          	| 60 s           	| x35    	|
| 72 °C       	| 90 s          	| 105 s          	| x35    	|
| 72 °C       	| 10 min        	| 10 min         	|        	|
| 4 °C        	| hold          	| hold           	|        	|
