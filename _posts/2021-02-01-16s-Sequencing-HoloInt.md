---
layout: post
title: 16s Sequencing Processing
date: '2021-02-01'
categories: Processing
tags: 16s, DNA
projects: Putnam Lab
---

# 16s Sequencing for HoloInt Project

Written by Emma Strand 20210315.

## Next Gen 16s Sequencing Primer Design

[URI GSC](https://web.uri.edu/gsc/next-generation-sequencing/) requires specific adapter sequences that are outlined below:  

Forward Primer with Adapter Overhang:

5’ **TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG‐[locus-specific sequence]**

Reverse Primer with Adapter Overhang:

5’ **GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG‐[locus-specific sequence]**

### 515F and 806RB for V4 region

[Apprill et al 2015](https://www.int-res.com/articles/ame_oa/a075p129.pdf):  
515F: 5’-**GTG CCA GCM GCC GCG GTA A**-3’    
806RB: 5’-**GGA CTA CNV GGG TWT CTA AT**-3’

We took the primer sequences from Apprill et al 2015, and added the URI GSC specific adapter sequences (all bolded above):  

| Primer       	| GSC Adapter Overhang               	| Sequence             	| Custom primer to be ordered (Adapter+Seq):             	|
|--------------	|------------------------------------	|----------------------	|--------------------------------------------------------	|
| 515F forward 	| TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG  	| GTGCCAGCMGCCGCGGTAA  	| TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGGTGCCAGCMGCCGCGGTAA   	|
| 806RB reverse 	| GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG 	| GGACTACNVGGGTWTCTAAT 	| GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGGGACTACNVGGGTWTCTAAT 	|

## **WORKING** Lab Protocol

Prerequisites:  
- Snap-frozen or well-preserved tissue samples  
- DNA extracted from tissue samples ([Putnam Lab Zymo Duet RNA DNA Extraction Protocol](https://emmastrand.github.io/EmmaStrand_Notebook/Zymo-Duet-RNA-DNA-Extraction-Protocol/))  
- Quantity and quality of DNA checked (Quality: [Gel Electrophoresis](https://emmastrand.github.io/EmmaStrand_Notebook/Gel-Electrophoresis-Protocol/) and Quantity: [Qubit](https://emmastrand.github.io/EmmaStrand_Notebook/Qubit-Protocol/))  

Resources:  
- PCR and Gel Electrophoresis Descriptions and Troubleshooting: [Strand 2017](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/protocols/PCR_GEL_SPEC.pdf)  
- Khan Academy: [PCR Explained](https://www.khanacademy.org/science/biology/biotech-dna-technology/dna-sequencing-pcr-electrophoresis/a/polymerase-chain-reaction-pcr)  
- [16s Library Prep Guide](https://support.illumina.com/documents/documentation/chemistry_documentation/16s/16s-metagenomic-library-prep-guide-15044223-b.pdf)
- DNA Barcoding Explained: [International Barcode of Life](https://ibol.org/about/dna-barcoding/), [Barcoding 101](https://dnabarcoding101.org/lab/)

Materials:  
- Phusion HiFi Mastermix (Thermo Scientific F531S): https://www.fishersci.com/shop/products/phusion-high-fidelity-pcr-master-mixes/f531s  
- Ultra-pure water
- 96-well plates, centrifuge, pipettes and filter tips, thermocycler  
- 515F and 806RB primers with appropriate adapter overhang  
- Zymoclean Gel DNA recovery kit: [protocol](https://files.zymoresearch.com/protocols/_d4001t_d4001_d4002_d4007_d4008_zymoclean_gel_dna_recovery_kit.pdf) and product [link](https://www.zymoresearch.com/products/zymoclean-gel-dna-recovery-kit?variant=32298390224978)  
- Gel cutting pipette tips 


This protocol is based on resources from on Earth Microbiome, Apprill et al 2015, and URI GSC.

![workflow1](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/16s-workflow.png?raw=true)

In our lab, we will complete the first PCR step and then we pay URI GSC to complete the rest of the library prep and preparation for sequencing.

![workflow2](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/16s-workflow2.png?raw=true)

515F Forward and 806RB Reverse Amplicon size: ~390 bp.

**Steps:**

1. Check concentrations with [Qubit](https://emmastrand.github.io/EmmaStrand_Notebook/Qubit-Protocol/).  
2. Calculate volumes of DNA and water needed to dilute sample to 4 ng/μl concentration in 20 μl. 4 ng is the minimum input to be used for one reaction. In this protocol, samples will be run in triplicate with each reaction containing 4 ng for a sample total of 12 ng. Dilutions can be done in any volume, but we recommend 10 or 20 μl depending on your starting concentration.    

| Sample ID | DNA (ng_μl) | DNA for dilution (μl) | Water for Dilution (μl) |
|----------|-------------|-----------------------|-------------------------|
| Example       | Qubit value        | =40/Qubit value                  | 10 - DNA for dilution value                    |
| Coral 1      | 37.4        | 1.07                  | 8.93                    |

To calculate the DNA sample volume needed for the dilution in 10µl for example, use the following equation: V<sub>1</sub>M<sub>1</sub>=V<sub>2</sub>M<sub>2</sub>.   
V<sub>1</sub>(Qubit value)=(4 ng/μl)(10 μl)  
V<sub>1</sub>=40/Qubit value  
Finally, to calculate the volume of water needed, subtract the DNA volume required from 10 μl.

3. Aliquot the appropriate volume of ultra pure water needed for dilution (for Coral 1, 8.93 μl) into each appropriately labeled PCR strip tube or well in a 96-well plate. To maximize efficiency, copy the PCR plate setup from Step 11 and the example image. Column 1 in the PCR 96-well plate should be the same as column 1 in the dilution plate so that you can use the multi-channel pipette to add 3 uL in Step 8.      
4. Aliquot the appropriate volume of DNA sample needed for dilution (for Coral 1, 1.07 μl).  
> 10 ng is widely used as a general starting point, this is usually enough DNA to amplify your desired gene. If the sample is suspected to contain more inhibitors, decrease this starting value. If the sample is not amplifying, a troubleshooting option is to decrease and increase this value. Starting with 10 ng in one 100 μl well that is split into triplicate wells for the PCR steps, 3.33 ng of DNA is needed per reaction (3.33 ng in 33 uL per reaction). Standardize the DNA concentration of each sample prior to amplification.   

5. Make positive mixture control by adding 0.5 μl of each sample into its own well (if doing dilutions on plates) or tube (if doing dilutions in PCR strip tubes).  
6. Make master mix stock solution. Forward and reverse primers will come in 100 uM stock solutions, dilute this to 10 uM. Keep master mix stock solution on ice.  
7. Multiply the below values by the number of samples (x # number of replicates) plus negative controls and buffer room for error (i.e. (8 samples x 3 replicates) + 1 negative control + 0.5 for error = 25.5 reactions). The amount you include for error will depend on your comfortability and experience level with pipetting.        

Master Mix calculations (per reaction):  

|      25µl RXN       	|    24 uL MM + 1 uL DNA        	|   	|  	|
|------------	|------------	|------------------	|-------------	|
|   Reagent  	| Final Conc 	| Final Conc Units 	| Volume µl   	|
| Phusion MM 	| 1          	| X                	| 12.5        	|
|  F primer  	| 10     	| uM              	| 0.5         	|
|  R primer  	| 10     	| uM              	| 0.5         	|
|    Water   	|            	|                  	| 10.5        	|
|     DNA    	| 3.33        	| ng/µl            	| 1           	|
|            	|            	|                  	| 25 uL total	|

> Amount of Ultrapure water is determined by  24 - (Phusion PCR master mix + F primer + R primer). Amount of primer can be increased or decreased as a part of troubleshooting.

8. Add 72 μl of master mix stock solution to each well.    
9. Add 3 μl of DNA sample (from the 3.33 ng/μl dilution mix) to each well. This will total 10 ng.  
10. Add 3 μl ultra pure water to one well per plate as a negative control.  
11. Add 3 μl of the positive mixture control to one well (total, not per plate) as a positive control.    
12. Set up each reaction in duplicate or triplicate for the PCR by pipette mixing and moving 24 μl of DNA/master mix solution into each neighboring empty well or PCR strip tube.  

>   See below image for an example of 96-well plate setup with 30 samples (four digit values) and 2 negative controls (Neg. Control). To run samples in triplicate, add DNA and master mix to columns 1, 4, 7, and 10. Then in Step 11 above and image below, move 33 uL of Sample 1254's reaction from B1 to B2 and 33 uL of reaction from B1 to B3. Use a multi-channel pipette to save time and energy.  

![plate-setup](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/96wellplate-setup.png?raw=true)

13. Spin down plate.  
14. Run the following PCR program (this cycle program is specific to 16s):  

PCR program:  

| Temperature 	| Time   	| Repeat 	|
|-------------	|--------	|--------	|
| 95 °C       	| 2 min  	| 1      	|
| 95 °C       	| 20 s   	| x27-35 	|
|  57 °C      	| 15s    	|        	|
| 72 °C       	| 5 min  	|        	|
| 72 °C       	| 10 min 	| 1      	|

15. Triplicate Gel: Run 5 μl of each product (3 per sample because the PCR was done in triplicate) on a 1% agarose gel for 45 minutes using the following [Putnam Lab Gel Electrophoresis protocol](https://emmastrand.github.io/EmmaStrand_Notebook/Gel-Electrophoresis-Protocol/) to check for ~390 bp product.  
16. Pool products into PCR strip tubes (75 μl total) appropriately labeled with the sample ID. *Pooling occurs only after duplicate or triplicate samples (based on if you chose duplicates or triplicates above) have successfully amplified and confirmed on the gel.* These will be the PCR product stock. Store at -20&deg;C.  
17. Single Gel: Run 5 μl of each pooled sample on a 1% agarose gel for 60-75 minutes. The goal is to separate the mitochondrial V4 region band and the 16s V4 region band really well to be able to physically cut out of the gel.  
18. Excise the desired gel band from the agarose gel with 1 mm x 4 mm gel band pipette tips and transferred to a 1.5 mL microcentrifuge tube.    
19.  Add 3 volumes of Agarose Dissolving Buffer (ADB) to each volume of agarose excised from the gel (e.g. for 100 µl (mg) of agarose gel slice add 300 µl of ADB). For this project: add ____ µl.
20. Incubate at 37-55 &deg;C for 5-10 minutes until the gel slice is completely dissolved.   
21. Transfer the melted agarose solution to a Zymo-Spin™ Column in a Collection Tube.  
22. Centrifuge for 60 seconds at 16,000 rcf. Discard the flow-through.  
23. Add 200 µl of DNA Wash Buffer to the column and centrifuge for 30 seconds. Discard the flow-through.   
24. Repeat the above wash step.   
25. Add 50 µl 10 uM Tris HCl directly to the column matrix.  
26. Place column into a 1.5 ml tube and centrifuge for 30 seconds at 16,000 rcf to elute DNA.  
27. Run 5 μl of each sample on a 1% agarose gel for 60 minutes. The goal is to see a single band instead of two (one mitochondrial and one bacterial).  
28. Aliquot 45 μl of each product from the PCR product stock (in Step 11) into new PCR strip tubes appropriately labeled with the sample ID. These tubes will be delivered to the sequencing center. Store at -20&deg;C until delivering to the sequencing center.   

Example of [google spreadsheet](https://docs.google.com/spreadsheets/d/184gZr6-Bc48Q-48O8OhfnEsu5wRloLiekuJg3T_IzXw/edit?usp=sharing) for data processing, including master mix and dilution calculations, and 96-well PCR platemaps.


## Sample processing

Link to sample processing [google sheet](https://docs.google.com/spreadsheets/d/184gZr6-Bc48Q-48O8OhfnEsu5wRloLiekuJg3T_IzXw/edit#gid=0).

We will only be doing five timepoints: 30 hour, 2 week, 4 week, 8 week, and 12 week to match the metabolomics, DNA methylation, and gene expression data.

### Dilution calculations

**From trials: 3.33 ng/uL**  

| Plug_ID 	| Extraction Date 	| Species     	| Hard DNA (ng_ul) 	| DNA for dilution (ul) 	| Water for dilution (ul) 	| Notes         	|
|---------	|-----------------	|-------------	|------------------	|-----------------------	|-------------------------	|---------------	|
| 1050    	| 20190809        	| Pocillopora 	| 35.4             	| 1.86                  	| 18.14                   	| 2021-02-25 A8 	|
| 1083    	| 20191204        	| Montipora   	| 25.4             	| 2.60                  	| 17.40                   	| 2021-02-25 A3 	|
| 1154    	| 20191105        	| Montipora   	| 13.15            	| 5.02                  	| 14.98                   	| 2021-02-25 A4 	|
| 1321    	| 20191209        	| Montipora   	| 16.85            	| 3.92                  	| 16.08                   	| 2021-02-25 A1 	|
| 1581    	| 20190826        	| Pocillopora 	| 37.2             	| 1.77                  	| 18.23                   	| 2021-02-25 A5 	|
| 1628    	| 20191113        	| Montipora   	| 26.2             	| 2.52                  	| 17.48                   	| 2021-02-25 A7 	|
| 1701    	| 20190826        	| Pocillopora 	| 34.2             	| 1.93                  	| 18.07                   	| 2021-02-25 A2 	|
| 2743    	| 20190724        	| Pocillopora 	| 101              	| 0.65                  	| 19.35                   	| 2021-02-25 A6 	|

**From 5 timepoint processing: 4 ng/uL**

| Plug_ID 	| Extraction Date 	| Extraction ID 	| Species   	| Hard DNA ng_ul 	| DNA (uL) 	| Ultrapure Water  (uL) 	| Notes 	|
|---------	|-----------------	|---------------	|-----------	|----------------	|----------	|-----------------------	|-------	|
| 1047    	| 20190808        	| 325, 326      	| Pacuta    	| 37.4           	| 2.14     	| 17.86                 	| ✓     	|
| 1051    	| 20190731        	| 209, 210      	| Pacuta    	| 45.5           	| 1.76     	| 18.24                 	| ✓     	|
| 1058    	| 20190823        	| 371, 372      	| Mcapitata 	| 14.95          	| 5.35     	| 14.65                 	| ✓     	|
| 1059    	| 20190826        	| 413, 414      	| Pacuta    	| 25.2           	| 3.17     	| 16.83                 	| ✓     	|
| 1074    	| 20190722        	| 93, 94        	| Mcapitata 	| 22.2           	| 3.60     	| 16.40                 	| ✓     	|
| 1076    	| 20190930        	| 479, 480      	| Mcapitata 	| 16.35          	| 4.89     	| 15.11                 	| ✓     	|
| 1082    	| 20190805        	| 279, 280      	| Mcapitata 	| 14             	| 5.71     	| 14.29                 	| ✓     	|
| 1083    	| 20191204        	| 629, 630      	| Mcapitata 	| 25.4           	| 3.15     	| 16.85                 	| ✓     	|
| 1090    	| 20190807        	| 313, 314      	| Pacuta    	| 14             	| 5.71     	| 14.29                 	| ✓     	|
| 1095    	| 20190722        	| 77, 78        	| Mcapitata 	| 12.9           	| 6.20     	| 13.80                 	| ✓     	|
| 1103    	| 20190718        	| 25, 26        	| Pacuta    	| 50.9           	| 1.57     	| 18.43                 	| ✓     	|
| 1126    	| 20190807        	| 305, 306      	| Mcapitata 	| 13.4           	| 5.97     	| 14.03                 	| ✓     	|
| 1147    	| 20191206        	| 659, 660      	| Pacuta    	| 39.3           	| 2.04     	| 17.96                 	| ✓     	|
| 1159    	| 20190720        	| 37, 38        	| Pacuta    	| 4.38           	| 18.26    	| 1.74                  	| ✓     	|
| 1168    	| 20190730        	| 171, 172      	| Pacuta    	| 21.5           	| 3.72     	| 16.28                 	| ✓     	|
| 1178    	| 20190930        	| 477, 478      	| Mcapitata 	| 12.25          	| 6.53     	| 13.47                 	| ✓     	|
| 1184    	| 20190731        	| 183, 184      	| Pacuta    	| 33.7           	| 2.37     	| 17.63                 	| ✓     	|
| 1196    	| 20190730        	| 157, 158      	| Mcapitata 	| 17.6           	| 4.55     	| 15.45                 	| ✓     	|
| 1204    	| 20191208        	| 665, 666      	| Mcapitata 	| 18.85          	| 4.24     	| 15.76                 	| ✓     	|
| 1205    	| 20190720        	| 45, 46        	| Pacuta    	| 27.3           	| 2.93     	| 17.07                 	| ✓     	|
| 1223    	| 20190806        	| 297, 298      	| Mcapitata 	| 5.99           	| 13.36    	| 6.64                  	| ✓     	|
| 1225    	| 20190730        	| 159, 160      	| Pacuta    	| 21.6           	| 3.70     	| 16.30                 	| ✓     	|
| 1229    	| 20191206        	| 661, 662      	| Mcapitata 	| 11.85          	| 6.75     	| 13.25                 	| ✓     	|
| 1235    	| 20190722        	| 67, 68        	| Mcapitata 	| 15.1           	| 5.30     	| 14.70                 	| ✓     	|
| 1237    	| 20190926        	| 471, 472      	| Mcapitata 	| 17.5           	| 4.57     	| 15.43                 	| ✓     	|
| 1238    	| 20190725        	| 125, 126      	| Pacuta    	| 27.4           	| 2.92     	| 17.08                 	| ✓     	|
| 1246    	| 20190801        	| 253, 254      	| Mcapitata 	| 19.85          	| 4.03     	| 15.97                 	| ✓     	|
| 1248    	| 20191001        	| 493, 494      	| Mcapitata 	| 10.4           	| 7.69     	| 12.31                 	| ✓     	|
| 1250    	| 20190809        	| 337, 338      	| Mcapitata 	| 12.5           	| 6.40     	| 13.60                 	| ✓     	|
| 1260    	| 20190724        	| 107, 108      	| Mcapitata 	| 11.9           	| 6.72     	| 13.28                 	| ✓     	|
| 1270    	| 20191009        	| 501, 502      	| Mcapitata 	| 24.7           	| 3.24     	| 16.76                 	| ✓     	|
| 1278    	| 20190809        	| 339, 340      	| Mcapitata 	| 19.1           	| 4.19     	| 15.81                 	| ✓     	|
| 1281    	| 20190924        	| 457, 458      	| Pacuta    	| 16.7           	| 4.79     	| 15.21                 	| ✓     	|
| 1296    	| 20190729        	| 147, 148      	| Pacuta    	| 21.5           	| 3.72     	| 16.28                 	| ✓     	|
| 1303    	| 20190726        	| 143, 144      	| Pacuta    	| 18.85          	| 4.24     	| 15.76                 	| ✓     	|
| 1315    	| 20191204        	| 625, 626      	| Mcapitata 	| 23.8           	| 3.36     	| 16.64                 	| ✓     	|
| 1321    	| 20191209        	| 677, 678      	| Mcapitata 	| 16.85          	| 4.75     	| 15.25                 	| ✓     	|
| 1329    	| 20191204        	| 641, 642      	| Pacuta    	| 48.1           	| 1.66     	| 18.34                 	| ✓     	|
| 1332    	| 20191205        	| 645, 646      	| Mcapitata 	| 22.2           	| 3.60     	| 16.40                 	| ✓     	|
| 1345    	| 20190731        	| 187, 188      	| Mcapitata 	| 23.5           	| 3.40     	| 16.60                 	| ✓     	|
| 1415    	| 20190815        	| 359, 360      	| Pacuta    	| 36.4           	| 2.20     	| 17.80                 	| ✓     	|
| 1416    	| 20191009        	| 497, 498      	| Pacuta    	| 7.1            	| 11.27    	| 8.73                  	| ✓     	|
| 1427    	| 20190807        	| 311, 312      	| Pacuta    	| 29.7           	| 2.69     	| 17.31                 	| ✓     	|
| 1436    	| 20190731        	| 205, 206      	| Mcapitata 	| 9.3            	| 8.60     	| 11.40                 	| ✓     	|
| 1445    	| 20190826        	| 375, 376      	| Pacuta    	| 26.1           	| 3.07     	| 16.93                 	| ✓     	|
| 1449    	| 20190905        	| 441, 442      	| Mcapitata 	| 22.2           	| 3.60     	| 16.40                 	| ✓     	|
| 1455    	| 20191202        	| 609, 610      	| Mcapitata 	| 12.45          	| 6.43     	| 13.57                 	| ✓     	|
| 1459    	| 20190722        	| 53, 54        	| Pacuta    	| 54.6           	| 1.47     	| 18.53                 	| ✓     	|
| 1478    	| 20190725        	| 133, 134      	| Mcapitata 	| 36             	| 2.22     	| 17.78                 	| ✓     	|
| 1487    	| 20190807        	| 317, 318      	| Pacuta    	| 36.1           	| 2.22     	| 17.78                 	| ✓     	|
| 1499    	| 20190808        	| 329, 330      	| Mcapitata 	| 14.35          	| 5.57     	| 14.43                 	| ✓     	|
| 1536    	| 20190725        	| 121, 122      	| Pacuta    	| 58.2           	| 1.37     	| 18.63                 	| ✓     	|
| 1559    	| 20190725        	| 129, 130      	| Pacuta    	| 35.4           	| 2.26     	| 17.74                 	| ✓     	|
| 1561    	| 20190730        	| 173, 174      	| Mcapitata 	| 15.95          	| 5.02     	| 14.98                 	| ✓     	|
| 1562    	| 20190926        	| 467, 468      	| Mcapitata 	| 18.35          	| 4.36     	| 15.64                 	| ✓     	|
| 1563    	| 20190905        	| 447, 448      	| Pacuta    	| 24             	| 3.33     	| 16.67                 	| ✓     	|
| 1571    	| 20191121        	| 581, 582      	| Pacuta    	| 25.7           	| 3.11     	| 16.89                 	| ✓     	|
| 1582    	| 20190926        	| 473, 474      	| Pacuta    	| 20.9           	| 3.83     	| 16.17                 	| ✓     	|
| 1583    	| 20191121        	| 593, 594      	| Mcapitata 	| 12             	| 6.67     	| 13.33                 	| ✓     	|
| 1596    	| 20191009        	| 503, 504      	| Pacuta    	| 13.1           	| 6.11     	| 13.89                 	| ✓     	|
| 1610    	| 20191125        	| 599, 600      	| Mcapitata 	| 11.05          	| 7.24     	| 12.76                 	| ✓     	|
| 1631    	| 20190718        	| 21, 22        	| Mcapitata 	| 20.2           	| 3.96     	| 16.04                 	| ✓     	|
| 1641    	| 20190720        	| 39, 40        	| Pacuta    	| 26.9           	| 2.97     	| 17.03                 	| ✓     	|
| 1644    	| 20190718        	| 17, 18        	| Mcapitata 	| 34.1           	| 2.35     	| 17.65                 	| ✓     	|
| 1645    	| 20191209        	| 681, 682      	| Mcapitata 	| 20.5           	| 3.90     	| 16.10                 	| ✓     	|
| 1647    	| 20190926        	| 469, 470      	| Pacuta    	| 59.3           	| 1.35     	| 18.65                 	| ✓     	|
| 1689    	| 20191206        	| 663, 664      	| Mcapitata 	| 20.4           	| 3.92     	| 16.08                 	| ✓     	|
| 1694    	| 20190905        	| 451, 452      	| Mcapitata 	| 14.55          	| 5.50     	| 14.50                 	| ✓     	|
| 1706    	| 20190826        	| 409, 410      	| Mcapitata 	| 10.45          	| 7.66     	| 12.34                 	| ✓     	|
| 1707    	| 20190905        	| 445, 446      	| Pacuta    	| 35.4           	| 2.26     	| 17.74                 	| ✓     	|
| 1709    	| 20191121        	| 591, 592      	| Pacuta    	| 20             	| 4.00     	| 16.00                 	| ✓     	|
| 1722    	| 20191202        	| 607, 608      	| Mcapitata 	| 18.4           	| 4.35     	| 15.65                 	| ✓     	|
| 1728    	| 20190806        	| 293, 294      	| Pacuta    	| 48.1           	| 1.66     	| 18.34                 	| ✓     	|
| 1732    	| 20190724        	| 111, 112      	| Pacuta    	| 42.6           	| 1.88     	| 18.12                 	| ✓     	|
| 1754    	| 20190718        	| 1, 2          	| Mcapitata 	| 17.05          	| 4.69     	| 15.31                 	| ✓     	|
| 1755    	| 20190801        	| 251, 252      	| Pacuta    	| 12             	| 6.67     	| 13.33                 	| ✓     	|
| 1757    	| 20190731        	| 197, 198      	| Pacuta    	| 31.4           	| 2.55     	| 17.45                 	| ✓     	|
| 1765    	| 20190725        	| 119, 120      	| Pacuta    	| 50.5           	| 1.58     	| 18.42                 	| ✓     	|
| 1776    	| 20190731        	| 211, 212      	| Mcapitata 	| 10.45          	| 7.66     	| 12.34                 	| ✓     	|
| 1777    	| 20190930        	| 481, 482      	| Pacuta    	| 39.2           	| 2.04     	| 17.96                 	| ✓     	|
| 1779    	| 20190729        	| 153, 154      	| Mcapitata 	| 16.9           	| 4.73     	| 15.27                 	| ✓     	|
| 1820    	| 20190815        	| 353, 354      	| Pacuta    	| 21.4           	| 3.74     	| 16.26                 	| ✓     	|
| 1997    	| 20190905        	| 453, 454      	| Mcapitata 	| 11.2           	| 7.14     	| 12.86                 	| ✓     	|
| 2012    	| 20190730        	| 203, 204      	| Pacuta    	| 36.1           	| 2.22     	| 17.78                 	| ✓     	|
| 2064    	| 20190730        	| 167, 168      	| Pacuta    	| 29.5           	| 2.71     	| 17.29                 	| ✓     	|
| 2067    	| 20191209        	| 683, 684      	| Mcapitata 	| 13             	| 6.15     	| 13.85                 	| ✓     	|
| 2072    	| 20190814        	| 343, 344      	| Pacuta    	| 20.2           	| 3.96     	| 16.04                 	| ✓     	|
| 2087    	| 20190826        	| 415, 416      	| Pacuta    	| 35.3           	| 2.27     	| 17.73                 	| ✓     	|
| 2185    	| 20191009        	| 499, 500      	| Pacuta    	| 15.9           	| 5.03     	| 14.97                 	| ✓     	|
| 2188    	| 20191001        	| 487, 488      	| Mcapitata 	| 13.4           	| 5.97     	| 14.03                 	| ✓     	|
| 2197    	| 20190729        	| 151, 152      	| Pacuta    	| 25.4           	| 3.15     	| 16.85                 	| ✓     	|
| 2212    	| 20190903        	| 449, 450      	| Pacuta    	| 19.3           	| 4.15     	| 15.85                 	| ✓     	|
| 2300    	| 20190731        	| 181, 182      	| Pacuta    	| 33.3           	| 2.40     	| 17.60                 	| ✓     	|
| 2302    	| 20191001        	| 491, 492      	| Mcapitata 	| 11.95          	| 6.69     	| 13.31                 	| ✓     	|
| 2304    	| 20190722        	| 81, 82        	| Pacuta    	| 12.75          	| 6.27     	| 13.73                 	| ✓     	|
| 2306    	| 20190926        	| 465, 466      	| Pacuta    	| 53.8           	| 1.49     	| 18.51                 	| ✓     	|
| 2380    	| 20191204        	| 633, 634      	| Mcapitata 	| 22.4           	| 3.57     	| 16.43                 	| ✓     	|
| 2386    	| 20190718        	| 7, 8          	| Mcapitata 	| 36.1           	| 2.22     	| 17.78                 	| ✓     	|
| 2409    	| 20190808        	| 323, 324      	| Pacuta    	| 55.7           	| 1.44     	| 18.56                 	| ✓     	|
| 2410    	| 20191204        	| 635, 636      	| Mcapitata 	| 18.2           	| 4.40     	| 15.60                 	| ✓     	|
| 2413    	| 20190809        	| 333, 334      	| Pacuta    	| 36.9           	| 2.17     	| 17.83                 	| ✓     	|
| 2419    	| 20190826        	| 377, 378      	| Mcapitata 	| 15.15          	| 5.28     	| 14.72                 	| ✓     	|
| 2511    	| 20191206        	| 657, 658      	| Mcapitata 	| 16.1           	| 4.97     	| 15.03                 	| ✓     	|
| 2513    	| 20190722        	| 65, 66        	| Pacuta    	| 12.55          	| 6.37     	| 13.63                 	| ✓     	|
| 2550    	| 20190724        	| 117, 118      	| Pacuta    	| 60.4           	| 1.32     	| 18.68                 	| ✓     	|
| 2554    	| 20190720        	| 41, 42        	| Mcapitata 	| 31.2           	| 2.56     	| 17.44                 	| ✓     	|
| 2564    	| 20190726        	| 139, 140      	| Pacuta    	| 57.5           	| 1.39     	| 18.61                 	| ✓     	|
| 2668    	| 20191001        	| 489, 490      	| Pacuta    	| 31.1           	| 2.57     	| 17.43                 	| ✓     	|
| 2735    	| 20191111        	| 553, 554      	| Mcapitata 	| 16.3           	| 4.91     	| 15.09                 	| ✓     	|
| 2737    	| 20191125        	| 595, 596      	| Mcapitata 	| 12.05          	| 6.64     	| 13.36                 	| ✓     	|
| 2753    	| 20191205        	| 649, 650      	| Mcapitata 	| 17.9           	| 4.47     	| 15.53                 	| ✓     	|
| 2756    	| 20191009        	| 495, 496      	| Mcapitata 	| 10.2           	| 7.84     	| 12.16                 	| ✓     	|
| 2860    	| 20190807        	| 303, 304      	| Mcapitata 	| 17.75          	| 4.51     	| 15.49                 	| ✓     	|
| 2861    	| 20190730        	| 161, 162      	| Pacuta    	| 25.3           	| 3.16     	| 16.84                 	| ✓     	|
| 2875    	| 20190806        	| 301, 302      	| Mcapitata 	| 11.35          	| 7.05     	| 12.95                 	| ✓     	|
| 2877    	| 20190731        	| 213, 214      	| Pacuta    	| 59.1           	| 1.35     	| 18.65                 	| ✓     	|
| 2878    	| 20190807        	| 319, 320      	| Pacuta    	| 48.7           	| 1.64     	| 18.36                 	| ✓     	|
| 2879    	| 20190930        	| 483, 484      	| Pacuta    	| 33.5           	| 2.39     	| 17.61                 	| ✓     	|
| 2986    	| 20191210        	| 687, 688      	| Mcapitata 	| 10.35          	| 7.73     	| 12.27                 	| ✓     	|

### Dilution plates

**From trials:**    

3.33 ng/uL dilutions to get 10 ng total for 3 reactions in PCR plates.  

Plate 1 - started 20210225

|   	| 1    	| 2    	| 3    	| 4    	| 5    	| 6    	| 7    	| 8    	| 9 	| 10 	| 11 	| 12 	|
|---	|------	|------	|------	|------	|------	|------	|------	|------	|---	|----	|----	|----	|
| A 	| 1321 	| 1701 	| 1083 	| 1154 	| 1581 	| 2743 	| 1628 	| 1050 	|   	|    	|    	|    	|
| B 	|      	|      	|      	|      	|      	|      	|      	|      	|   	|    	|    	|    	|
| C 	|      	|      	|      	|      	|      	|      	|      	|      	|   	|    	|    	|    	|
| D 	|      	|      	|      	|      	|      	|      	|      	|      	|   	|    	|    	|    	|
| E 	|      	|      	|      	|      	|      	|      	|      	|      	|   	|    	|    	|    	|
| F 	|      	|      	|      	|      	|      	|      	|      	|      	|   	|    	|    	|    	|
| G 	|      	|      	|      	|      	|      	|      	|      	|      	|   	|    	|    	|    	|
| H 	|      	|      	|      	|      	|      	|      	|      	|      	|   	|    	|    	|    	|

**From 5 timepoint processing:**

Plate 2 - 20210317

|   	| 1        	| 2    	| 3    	| 4        	| 5        	| 6    	| 7    	| 8        	| 9        	| 10   	| 11   	| 12       	|
|---	|----------	|------	|------	|----------	|----------	|------	|------	|----------	|----------	|------	|------	|----------	|
| A 	| NEGATIVE 	| 1641 	| 1563 	| 2185     	| NEGATIVE 	| 1246 	| 1436 	| 1455     	| NEGATIVE 	| 1610 	| 2878 	| 1260     	|
| B 	| 2410     	| 1074 	| 2513 	| 1184     	| 2197     	| 1196 	| 1722 	| 1281     	| 2067     	| 2304 	| 1689 	| 1777     	|
| C 	| 1147     	| 1205 	| 1779 	| 1415     	| 1820     	| 1296 	| 2064 	| 2188     	| 1159     	| 1229 	| 2550 	| 1051     	|
| D 	| 1095     	| 1303 	| 1332 	| 1168     	| 1103     	| 2735 	| 1755 	| 1728     	| 1571     	| 1445 	| 2668 	| 1536     	|
| E 	| 1694     	| 1647 	| 2413 	| 2879     	| 1645     	| 2380 	| 1315 	| 1427     	| 2737     	| 1765 	| 1248 	| 1237     	|
| F 	| 2986     	| 1058 	| 1059 	| 2753     	| 1076     	| 1707 	| 1270 	| 1321     	| 1487     	| 1449 	| 2756 	| 2511     	|
| G 	| 1204     	| 2877 	| 2386 	| 1278     	| 1126     	| 1416 	| 2409 	| 2564     	| 1223     	| 1732 	| 1047 	| 1250     	|
| H 	| 2861     	| 1225 	| 1582 	| NEGATIVE 	| 2306     	| 1083 	| 1082 	| NEGATIVE 	| 2875     	| 1178 	| 2072 	| NEGATIVE 	|

Plate 3 - 20210317

|   	| 1        	| 2    	| 3    	| 4        	| 5 	| 6 	| 7 	| 8 	| 9 	| 10 	| 11 	| 12 	|
|---	|----------	|------	|------	|----------	|---	|---	|---	|---	|---	|----	|----	|----	|
| A 	| NEGATIVE 	| 1596 	| 1329 	| 1090     	|   	|   	|   	|   	|   	|    	|    	|    	|
| B 	| 1562     	| 2212 	| 1345 	| 1583     	|   	|   	|   	|   	|   	|    	|    	|    	|
| C 	| 1559     	| 1776 	| 1757 	| 1709     	|   	|   	|   	|   	|   	|    	|    	|    	|
| D 	| 1561     	| 2419 	| 2554 	| 2087     	|   	|   	|   	|   	|   	|    	|    	|    	|
| E 	| 2302     	| 1238 	| 1235 	| 1706     	|   	|   	|   	|   	|   	|    	|    	|    	|
| F 	| 1631     	| 1997 	| 1478 	| 1459     	|   	|   	|   	|   	|   	|    	|    	|    	|
| G 	| 2012     	| 2860 	| 2300 	| NA       	|   	|   	|   	|   	|   	|    	|    	|    	|
| H 	| 1644     	| 1499 	| 1754 	| NEGATIVE 	|   	|   	|   	|   	|   	|    	|    	|    	|

### PCR Plates

**From trials:**

Plate 1

|   	| 1    	| 2    	| 3    	| 4    	| 5    	| 6    	| 7    	| 8    	|
|---	|------	|------	|------	|------	|------	|------	|------	|------	|
| A 	| 1321 	| 1701 	| 1083 	| 1154 	| 1581 	| 2743 	| 1628 	| 1050 	|
| B 	| 1321 	| 1701 	| 1083 	| 1154 	| 1581 	| 2743 	| 1628 	| 1050 	|
| C 	| 1321 	| 1701 	| 1083 	| 1154 	| 1581 	| 2743 	| 1628 	| 1050 	|

**From 5 timepoint processing 20210317:**

Plate 2

|   	| 1        	| 2        	| 3        	| 4    	| 5    	| 6    	| 7    	| 8    	| 9    	| 10       	| 11       	| 12       	|
|---	|----------	|----------	|----------	|------	|------	|------	|------	|------	|------	|----------	|----------	|----------	|
| A 	| NEGATIVE 	| NEGATIVE 	| NEGATIVE 	| 1641 	| 1641 	| 1641 	| 1563 	| 1563 	| 1563 	| 2185     	| 2185     	| 2185     	|
| B 	| 2410     	| 2410     	| 2410     	| 1074 	| 1074 	| 1074 	| 2513 	| 2513 	| 2513 	| 1184     	| 1184     	| 1184     	|
| C 	| 1147     	| 1147     	| 1147     	| 1205 	| 1205 	| 1205 	| 1779 	| 1779 	| 1779 	| 1415     	| 1415     	| 1415     	|
| D 	| 1095     	| 1095     	| 1095     	| 1303 	| 1303 	| 1303 	| 1332 	| 1332 	| 1332 	| 1168     	| 1168     	| 1168     	|
| E 	| 1694     	| 1694     	| 1694     	| 1647 	| 1647 	| 1647 	| 2413 	| 2413 	| 2413 	| 2879     	| 2879     	| 2879     	|
| F 	| 2986     	| 2986     	| 2986     	| 1058 	| 1058 	| 1058 	| 1059 	| 1059 	| 1059 	| 2753     	| 2753     	| 2753     	|
| G 	| 1204     	| 1204     	| 1204     	| 2877 	| 2877 	| 2877 	| 2386 	| 2386 	| 2386 	| 1278     	| 1278     	| 1278     	|
| H 	| 2861     	| 2861     	| 2861     	| 1225 	| 1225 	| 1225 	| 1582 	| 1582 	| 1582 	| NEGATIVE 	| NEGATIVE 	| NEGATIVE 	|

Plate 3

|   	| 1        	| 2        	| 3        	| 4    	| 5    	| 6    	| 7    	| 8    	| 9    	| 10       	| 11       	| 12       	|
|---	|----------	|----------	|----------	|------	|------	|------	|------	|------	|------	|----------	|----------	|----------	|
| A 	| NEGATIVE 	| NEGATIVE 	| NEGATIVE 	| 1246 	| 1246 	| 1246 	| 1436 	| 1436 	| 1436 	| 1455     	| 1455     	| 1455     	|
| B 	| 2197     	| 2197     	| 2197     	| 1196 	| 1196 	| 1196 	| 1722 	| 1722 	| 1722 	| 1281     	| 1281     	| 1281     	|
| C 	| 1820     	| 1820     	| 1820     	| 1296 	| 1296 	| 1296 	| 2064 	| 2064 	| 2064 	| 2188     	| 2188     	| 2188     	|
| D 	| 1103     	| 1103     	| 1103     	| 2735 	| 2735 	| 2735 	| 1755 	| 1755 	| 1755 	| 1728     	| 1728     	| 1728     	|
| E 	| 1645     	| 1645     	| 1645     	| 2380 	| 2380 	| 2380 	| 1315 	| 1315 	| 1315 	| 1427     	| 1427     	| 1427     	|
| F 	| 1076     	| 1076     	| 1076     	| 1707 	| 1707 	| 1707 	| 1270 	| 1270 	| 1270 	| 1321     	| 1321     	| 1321     	|
| G 	| 1126     	| 1126     	| 1126     	| 1416 	| 1416 	| 1416 	| 2409 	| 2409 	| 2409 	| 2564     	| 2564     	| 2564     	|
| H 	| 2306     	| 2306     	| 2306     	| 1083 	| 1083 	| 1083 	| 1082 	| 1082 	| 1082 	| NEGATIVE 	| NEGATIVE 	| NEGATIVE 	|

Plate 4

|   	| 1        	| 2        	| 3        	| 4    	| 5    	| 6    	| 7    	| 8    	| 9    	| 10       	| 11       	| 12       	|
|---	|----------	|----------	|----------	|------	|------	|------	|------	|------	|------	|----------	|----------	|----------	|
| A 	| NEGATIVE 	| NEGATIVE 	| NEGATIVE 	| 1610 	| 1610 	| 1610 	| 2878 	| 2878 	| 2878 	| 1260     	| 1260     	| 1260     	|
| B 	| 2067     	| 2067     	| 2067     	| 2304 	| 2304 	| 2304 	| 1689 	| 1689 	| 1689 	| 1777     	| 1777     	| 1777     	|
| C 	| 1159     	| 1159     	| 1159     	| 1229 	| 1229 	| 1229 	| 2550 	| 2550 	| 2550 	| 1051     	| 1051     	| 1051     	|
| D 	| 1571     	| 1571     	| 1571     	| 1445 	| 1445 	| 1445 	| 2668 	| 2668 	| 2668 	| 1536     	| 1536     	| 1536     	|
| E 	| 2737     	| 2737     	| 2737     	| 1765 	| 1765 	| 1765 	| 1248 	| 1248 	| 1248 	| 1237     	| 1237     	| 1237     	|
| F 	| 1487     	| 1487     	| 1487     	| 1449 	| 1449 	| 1449 	| 2756 	| 2756 	| 2756 	| 2511     	| 2511     	| 2511     	|
| G 	| 1223     	| 1223     	| 1223     	| 1732 	| 1732 	| 1732 	| 1047 	| 1047 	| 1047 	| 1250     	| 1250     	| 1250     	|
| H 	| 2875     	| 2875     	| 2875     	| 1178 	| 1178 	| 1178 	| 2072 	| 2072 	| 2072 	| NEGATIVE 	| NEGATIVE 	| NEGATIVE 	|

Plate 5

|   	| 1        	| 2        	| 3        	| 4    	| 5    	| 6    	| 7    	| 8    	| 9    	| 10       	| 11       	| 12       	|
|---	|----------	|----------	|----------	|------	|------	|------	|------	|------	|------	|----------	|----------	|----------	|
| A 	| NEGATIVE 	| NEGATIVE 	| NEGATIVE 	| 1596 	| 1596 	| 1596 	| 1329 	| 1329 	| 1329 	| 1090     	| 1090     	| 1090     	|
| B 	| 1562     	| 1562     	| 1562     	| 2212 	| 2212 	| 2212 	| 1345 	| 1345 	| 1345 	| 1583     	| 1583     	| 1583     	|
| C 	| 1559     	| 1559     	| 1559     	| 1776 	| 1776 	| 1776 	| 1757 	| 1757 	| 1757 	| 1709     	| 1709     	| 1709     	|
| D 	| 1561     	| 1561     	| 1561     	| 2419 	| 2419 	| 2419 	| 2554 	| 2554 	| 2554 	| 2087     	| 2087     	| 2087     	|
| E 	| 2302     	| 2302     	| 2302     	| 1238 	| 1238 	| 1238 	| 1235 	| 1235 	| 1235 	| 1706     	| 1706     	| 1706     	|
| F 	| 1631     	| 1631     	| 1631     	| 1997 	| 1997 	| 1997 	| 1478 	| 1478 	| 1478 	| 1459     	| 1459     	| 1459     	|
| G 	| 2012     	| 2012     	| 2012     	| 2860 	| 2860 	| 2860 	| 2300 	| 2300 	| 2300 	| NA       	| NA       	| NA       	|
| H 	| 1644     	| 1644     	| 1644     	| 1499 	| 1499 	| 1499 	| 1754 	| 1754 	| 1754 	| NEGATIVE 	| NEGATIVE 	| NEGATIVE 	|

### Post-PCR Gel in Triplicate

Each sample will have 3 gel wells (one per replicate).

### Post-Pooling Gel prior to extraction

Each sample will have 1 gel well (replicates pooled).

### Post-Gel Band Extraction Gel  

### Prep for GSC


## Troubleshooting "trials"

### 20210225 Trial Run 1

Plate 1 - 20210225

| Master Mix                      	| uL 	| # of samples (8 + 0.5 for error) 	| total needed (uL) 	|
|---------------------------------	|----	|-------------------------------------------------	|-------------------	|
| Phusion PCR master mix          	| 50 	| 8.5                                             	| 425               	|
| UltraPure water                 	| 46 	| 8.5                                             	| 391             	|
| 10uM working stock 515F primer  	| 2  	| 8.5                                             	| 17                	|
| 10uM working stock 806RB primer 	| 2  	| 8.5                                             	| 17                	|

*The above H2O volume should have been 43 uL to equal 97 uL total not 100 uL.*

|   	| 1    	| 2    	| 3    	| 4    	| 5    	| 6    	| 7    	| 8    	| 9 	| 10 	| 11 	| 12 	|
|---	|------	|------	|------	|------	|------	|------	|------	|------	|---	|----	|----	|----	|
| A 	| 1321 	| 1701 	| 1083 	| 1154 	| 1581 	| 2743 	| 1628 	| 1050 	|   	|    	|    	|    	|
| B 	| 1321 	| 1701 	| 1083 	| 1154 	| 1581 	| 2743 	| 1628 	| 1050 	|   	|    	|    	|    	|
| C 	| 1321 	| 1701 	| 1083 	| 1154 	| 1581 	| 2743 	| 1628 	| 1050 	|   	|    	|    	|    	|
| D 	|      	|      	|      	|      	|      	|      	|      	|      	|   	|    	|    	|    	|
| E 	|      	|      	|      	|      	|      	|      	|      	|      	|   	|    	|    	|    	|
| F 	|      	|      	|      	|      	|      	|      	|      	|      	|   	|    	|    	|    	|
| G 	|      	|      	|      	|      	|      	|      	|      	|      	|   	|    	|    	|    	|
| H 	|      	|      	|      	|      	|      	|      	|      	|      	|   	|    	|    	|    	|  

20210225 gel image - 33 uL reactions pooled back together and run on gel. Run gel on triplicates next time to make sure no PCR artifact.  

![gel](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/20210225-gel-ladder.png?raw=true)

Two bands - one at ~300-350 bp (top band) and one at ~75 bp. The expected band size is 300-350 bp. What is the band at ~75 bp? This could be:  
- **Non specific targets; aka targeting more than our desired product**     
- Single vs. double strand products  
- Heterozygosity at particular locus   
- Primer dimer? b/c 300-350 bp is desired length and primer dimer is usually closer to 100 bp    
- Mixed DNA sample - could this be picking up something in the coral or symbiont?  

Next steps: I can try to increase the annealing temperature. Apprill et al had 55C. I can take 3-4 samples from above do a PCR gradient - run one at 57; one at 58; one at 59 to see if there is a difference. Make sure to include negative control next time to exclude contamination!!

Alternatively, I could up the volume of primer used. I don't want to change the number of cycles yet because the bands are so clear.

### 20210302 Trial Run 2

I did a gradient of annealing temperatures (56, 57, and 58 C) and two volumes (2 and 3 uL) of primer to optimize those two portions of the protocol. Trial 1 was 55 C annealing temp and 2 uL primer.

The below program names need to edited to reflect the correct v-region.

There were 9 samples done in duplicate in 33 uL reactions (2 x 33 uL reactions) for each primer volume option. I needed a total of 18 reactions, so the master mix volume was calculated to be enough for 19.6 reactions (18 reactions + room for error). The ratios from above protocol were kept.  

| Strip Tube # 	| Annealing Temp 	| Primer added 	| Tube 1 	| Tube 2 	| Tube 3 	| Tube 4 	| Tube 5 	| Tube 6 	| Program Name  	| Thermocyler # 	|
|--------------	|----------------	|--------------	|--------	|--------	|--------	|--------	|--------	|--------	|---------------	|---------------	|
| 1            	| 56             	| 2 uL         	| 1321   	| 1701   	| 1083   	| 1321   	| 1701   	| 1083   	| 16s v4v5 a    	| 2             	|
| 2            	| 56             	| 3 uL         	| 1321   	| 1701   	| 1083   	| 1321   	| 1701   	| 1083   	| 16s v4v5 a    	| 2             	|
| 3            	| 57             	| 2 uL         	| 1154   	| 1581   	| 2743   	| 1154   	| 1581   	| 2743   	| 16s v4v5 b    	| 3             	|
| 4            	| 57             	| 3 uL         	| 1154   	| 1581   	| 2743   	| 1154   	| 1581   	| 2743   	| 16s v4v5 b    	| 3             	|
| 5            	| 58             	| 2 uL         	| 2743   	| 1628   	| 1050   	| 2743   	| 1628   	| 1050   	| 16s v4v5 c    	| 4             	|
| 6            	| 58             	| 3 uL         	| 2743   	| 1628   	| 1050   	| 2743   	| 1628   	| 1050   	| 16s v4v5 c    	| 4             	|

2 uL primer Master Mix calculation:  

| Master Mix                      	| uL 	| # of samples (X + X neg controls + X for error) 	| total needed (uL) 	|
|---------------------------------	|----	|-------------------------------------------------	|-------------------	|
| Phusion PCR master mix          	| 50 	| 6.5                                             	| 325               	|
| UltraPure water                 	| 46 	| 6.5                                             	| 299               	|
| 10uM working stock 515F primer  	| 2  	| 6.5                                             	| 13                	|
| 10uM working stock 806RB primer 	| 2  	| 6.5                                             	| 13                	|

*Come back to whether the above H2O volume should have been 41 uL to equal 97 uL total not 100 uL.*

3 uL primer Master Mix calculation:  

| Master Mix                      	| uL 	| # of samples (X + X neg controls + X for error) 	| total needed (uL) 	|
|---------------------------------	|----	|-------------------------------------------------	|-------------------	|
| Phusion PCR master mix          	| 50 	| 6.5                                             	| 325               	|
| UltraPure water                 	| 44 	| 6.5                                             	| 286               	|
| 10uM working stock 515F primer  	| 3  	| 6.5                                             	| 19.5              	|
| 10uM working stock 806RB primer 	| 3  	| 6.5                                             	| 19.5              	|

*Come back to whether the above H2O volume should have been 41 uL to equal 97 uL total not 100 uL.*

I made a new 806RB 10 uM diluted primer with 25 uL of 200 uM primer stock and 475 uL UP H2O. The original diluted primer was contaminated.

![gel-image](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/20210303-gel.jpg?raw=true)

The extra band gets brighter with more primer. It is hard to see the bottom bands on the ladder so next time I will do a longer gel run time (60 minutes instead of 45 minutes). We are now thinking this could actually be primer dimer at the bottom and our band on the top?

### 20210304 Trial Run 3

I did another gradient of temperatures based on the melting temperature (Tm) of the primers we designed in the first section of this post and primer concentration to see if we could get rid of the primer dimer. This was done in 25 uL instead of 33 uL reactions to save money on supplies.

Tm 515F = 73.4C; Tm 806RB = 68.8C  
Melting temperatures are specific to the primers we designed.

Best practices for PCR are to start 3-5C below the lowest melting temperature of the primer. This would be 63.8C so we started with 63C.

3 samples were placed in each strip tube (no duplicates or triplicates) with a negative control. The 10 uM stock was diluted to 1 uM stock (5 uL 10 uM and 45 uL UltraPure water) and the same volumes in the master mix calculations were used for each.

| Strip Tube # 	| Annealing Temp 	| Primer added 	| Tube 1 	| Tube 2 	| Tube 3 	| Tube 4           	| Program Name  	| Thermocyler # 	|
|--------------	|----------------	|--------------	|--------	|--------	|--------	|------------------	|---------------	|---------------	|
| 1            	| 63             	| 10 uM        	| 1321   	| 1321   	| 1701   	| Negative control 	| 16s v4v5 a    	| 1             	|
| 2            	| 63             	| 1 uM         	| 1701   	| 1083   	| 1154   	| Negative control 	| 16s v4v5 a    	| 1             	|
| 3            	| 60             	| 10 uM        	| 1581   	| 2743   	| 1628   	| Negative control 	| 16s v4v5 b    	| 2             	|
| 4            	| 60             	| 1 uM         	| 1581   	| 2743   	| 1628   	| Negative control 	| 16s v4v5 b    	| 2             	|
| 5            	| 57             	| 10 uM        	| 2743   	| 1628   	| 1050   	| Negative control 	| 16s v4v5 c    	| 3             	|
| 6            	| 57             	| 1 uM         	| 2743   	| 1628   	| 1050   	| Negative control 	| 16s v4v5 c    	| 3             	|

Master Mix calculations:  

|            	|            	|                  	| 25µl RXN    	|
|------------	|------------	|------------------	|-------------	|
|   Reagent  	| Final Conc 	| Final Conc Units 	| Volume µl   	|
| Phusion MM 	| 1          	| X                	| 12.5        	|
|  F primer  	| 10 or 1    	| uM              	| 0.5         	|
|  R primer  	| 10 or 1    	| uM              	| 0.5         	|
|     DNA    	| 3.3        	| ng/µl            	| 1           	|
|    Water   	|            	|                  	| 10.5        	|
|            	|            	|                  	| 25 uL total 	|

24 uL of Master Mix and 1 uL of DNA was added to each tube. 1 uL of Ultrapure water was used in the negative control instead of DNA.

57C with 10 uM primer seems to get good solid bands at ~350 bp and the bottom is primer dimer. My thought is we move forward with the above master mix ratios and cut the bands physically out of the gel.  
![gel](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/20210305-gel-16s.jpg?raw=true)

We decided to change the dilution concentration to 4 ng/uL instead of 3.33 ng/uL so that the total ng per sample across triplicates is 12 ng.
