---
layout: post
title: 16s Sequencing HoloInt
date: '2021-02-01'
categories: Processing
tags: 16s, DNA
projects: Holobiont Integration
---

# Next Gen 16s Sequencing

Link to [Acclimatization Dynamics repo](https://github.com/hputnam/Acclim_Dynamics).  

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

Now we want to try 515F and 806R for the V4 region. Below information from [Earth Microbiome](https://earthmicrobiome.org/protocols-and-standards/16s/) and Apprill et al 2015.

515F forward primer, barcoded  
Field descriptions (space-delimited):

5′ Illumina adapter  
Golay barcode  
Forward primer pad  
Forward primer linker  
Forward primer (515F)  

AATGATACGGCGACCACCGAGATCTACACGCT XXXXXXXXXXXX TATGGTAATT GT **GTGYCAGCMGCCGCGGTAA**

806R reverse primer  
Field descriptions (space-delimited):

Reverse complement of 3′ Illumina adapter  
Reverse primer pad  
Reverse primer linker  
Reverse primer (806R)  

CAAGCAGAAGACGGCATACGAGAT AGTCAGCCAG CC **GGACTACNVGGGTWTCTAAT**

We took the primer sequences (bolded above) from Earth Microbiome (and based on Apprill et al 2015), and added the URI GSC specific adapter sequences:  

| Primer       	| GSC Adapter Overhang               	| Sequence             	| Custom primer to be ordered (Adapter+Seq):             	|
|--------------	|------------------------------------	|----------------------	|--------------------------------------------------------	|
| 515F forward 	| TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG  	| GTGYCAGCMGCCGCGGTAA  	| TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGGTGYCAGCMGCCGCGGTAA   	|
| 806R reverse 	| GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG 	| GGACTACNVGGGTWTCTAAT 	| GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGGGACTACNVGGGTWTCTAAT 	|
