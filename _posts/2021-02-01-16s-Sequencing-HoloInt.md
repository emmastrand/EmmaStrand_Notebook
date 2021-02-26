---
layout: post
title: 16s Sequencing Processing
date: '2021-02-01'
categories: Processing
tags: 16s, DNA
projects: Putnam Lab
---

# 16s Sequencing for HoloInt Project

Written by Emma Strand 20210225.

## Next Gen 16s Sequencing Primer Design

[URI GSC](https://web.uri.edu/gsc/next-generation-sequencing/) requires specific adapter sequences that are outlined below:  

Forward Primer with Adapter Overhang:

5’ **TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG‐[locus-specific sequence]**

Reverse Primer with Adapter Overhang:

5’ **GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG‐[locus-specific sequence]**

### 515F and 806RB for V4

[Apprill et al 2015](https://www.int-res.com/articles/ame_oa/a075p129.pdf):  
515F: 5’-**GTG CCA GCM GCC GCG GTA A**-3’    
806RB: 5’-**GGA CTA CNV GGG TWT CTA AT**-3’

We took the primer sequences from Apprill et al 2015, and added the URI GSC specific adapter sequences (all bolded above):  

| Primer       	| GSC Adapter Overhang               	| Sequence             	| Custom primer to be ordered (Adapter+Seq):             	|
|--------------	|------------------------------------	|----------------------	|--------------------------------------------------------	|
| 515F forward 	| TCGTCGGCAGCGTCAGATGTGTATAAGAGACAG  	| GTGCCAGCMGCCGCGGTAA  	| TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGGTGCCAGCMGCCGCGGTAA   	|
| 806RB reverse 	| GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG 	| GGACTACNVGGGTWTCTAAT 	| GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGGGACTACNVGGGTWTCTAAT 	|

## Lab Protocol

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
- 515F and 806R primers with appropriate adapter overhang


This protocol is based on resources from on Earth Microbiome, Apprill et al 2015, and URI GSC.

![workflow1](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/16s-workflow.png?raw=true)

In our lab, we will complete the first PCR step and then we pay URI GSC to complete the rest of the library prep and preparation for sequencing.

![workflow2](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/16s-workflow2.png?raw=true)

515F Forward and 806RB Reverse Amplicon size: ~390 bp.

**Steps:**

1. Check concentrations with [Qubit](https://emmastrand.github.io/EmmaStrand_Notebook/Qubit-Protocol/).  
2. Calculate volumes of DNA and water needed to dilute sample to 3.33 ng/μl concentration in 10 μl. 3.33 ng is the minimum input to be used for one reaction. In this protocol, samples will be run in triplicate with each reaction containing 3.33 ng for a sample total of 10 ng. Dilutions can be done in any volume, but we recommend 10 or 20 μl depending on your starting concentration.    

| Sample ID | DNA (ng_μl) | DNA for dilution (μl) | Water for Dilution (μl) |
|----------|-------------|-----------------------|-------------------------|
| Example       | Qubit value        | =33/Qubit value                  | 10 - DNA for dilution value                    |
| Coral 1      | 6.82        | 4.84                  | 5.16                    |

To calculate the DNA sample volume needed for the dilution in 10µl for example, use the following equation: V<sub>1</sub>M<sub>1</sub>=V<sub>2</sub>M<sub>2</sub>.   
V<sub>1</sub>(Qubit value)=(3.33 ng/μl)(10 μl)  
V<sub>1</sub>=33/Qubit value  
Finally, to calculate the volume of water needed, subtract the DNA volume required from 10 μl.

3. Aliquot the appropriate volume of ultra pure water needed for dilution (for Coral 1, 5.16 μl) into each appropriately labeled PCR strip tube or well in a 96-well plate. To maximize efficiency, copy the PCR plate setup from Step 11 and the example image. Column 1 in the PCR 96-well plate should be the same as column 1 in the dilution plate so that you can use the multi-channel pipette to add 3 uL in Step 8.      
4. Aliquot the appropriate volume of DNA sample needed for dilution (for Coral 1, 4.84 μl).  
> 10 ng is widely used as a general starting point, this is usually enough DNA to amplify your desired gene. If the sample is suspected to contain more inhibitors, decrease this starting value. If the sample is not amplifying, a troubleshooting option is to decrease and increase this value. Starting with 10 ng in one 100 μl well that is split into triplicate wells for the PCR steps, 3.33 ng of DNA is needed per reaction (3.33 ng in 33 uL per reaction). Standardize the DNA concentration of each sample prior to amplification.   

5. Make positive mixture control by adding 0.5 μl of each sample into its own well (if doing dilutions on plates) or tube (if doing dilutions in PCR strip tubes).  
6. Make master mix stock solution. Forward and reverse primers will come in 100 uM stock solutions, dilute this to 10 uM. Keep master mix stock solution on ice.    

| Master Mix                      	| uL 	| # of samples (X + X neg controls + X for error) 	| total needed (uL) 	|
|---------------------------------	|----	|-------------------------------------------------	|-------------------	|
| Phusion PCR master mix          	| 50 	| 1                                               	| 50                	|
| UltraPure water                 	| 46 	| 1                                               	| 46                	|
| 10uM working stock 515F primer  	| 2  	| 1                                               	| 2                 	|
| 10uM working stock 806RB primer 	| 2  	| 1                                               	| 2                 	|

> Amount of Ultrapure water is determined by  100 - (Phusion PCR master mix + F primer + R primer). Amount of primer can be increased or decreased as a part of troubleshooting.

7. Add 97 μl of master mix stock solution to each well.    
8. Add 3 μl of DNA sample (from the 10 μl dilution mix) to each well.  
9. Add 3 μl ultra pure water to one well per plate as a negative control.  
10. Add 3 μl of the positive mixture control to one well (total, not per plate) as a positive control.    
11. Set up each reaction in duplicate or triplicate for the PCR by pipette mixing and moving 33 μl of DNA/master mix solution into each neighboring empty well or PCR strip tube.  

>   See below image for an example of 96-well plate setup with 30 samples (four digit values) and 2 negative controls (Neg. Control). To run samples in triplicate, add DNA and master mix to columns 1, 4, 7, and 10. Then in Step 11 above and image below, move 33 uL of Sample 1254's reaction from B1 to B2 and 33 uL of reaction from B1 to B3. Use a multi-channel pipette to save time and energy.  

![palte-setup](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/96wellplate-setup.png?raw=true)

12. Spin down plate.  
13. Run the following PCR program (this cycle program is specific to 16s):  

PCR program (Apprill et al 2015):  

| Temperature 	| Time   	| Repeat 	|
|-------------	|--------	|--------	|
| 95 °C       	| 2 min  	| 1      	|
| 95 °C       	| 20 s   	| x27-35 	|
|  55 °C      	| 15s    	|        	|
| 72 °C       	| 5 min  	|        	|
| 72 °C       	| 10 min 	| 1      	|

14. Run 5 μl of each product on a 2% agarose gel using the following [Putnam Lab Gel Electrophoresis protocol](https://emmastrand.github.io/EmmaStrand_Notebook/Gel-Electrophoresis-Protocol/) to check for ~300 bp product.  
15. Pool products into PCR strip tubes (100 μl total) appropriately labeled with the sample ID. *Pooling occurs only after duplicate or triplicate samples (based on if you chose duplicates or triplicates above) have successfully amplified and confirmed on the gel.* These will be the PCR product stock. Store at -20&deg;C.   
16. Aliquot 45 μl of each product from the PCR product stock (in Step 11) into new PCR strip tubes appropriately labeled with the sample ID. These tubes will be delivered to the sequencing center. Store at -20&deg;C until delivering to the sequencing center.   

Example of [google spreadsheet](https://docs.google.com/spreadsheets/d/184gZr6-Bc48Q-48O8OhfnEsu5wRloLiekuJg3T_IzXw/edit?usp=sharing) for data processing, including master mix and dilution calculations, and 96-well PCR platemaps.

## Previous primer sets used

Rebecca Stevik originally tried 518F and 926R for 16s V4/V5 region but had trouble with the results. Link to [protocol google sheet](https://docs.google.com/spreadsheets/d/1nwWCbPFduX4a2K3Fc-qeALjZADdt0yuQTMVSW2n9SbU/edit?usp=sharing).  

Primers: ITS2, cp23S, and 16S with Nextera partial tails
Annealing temp: 57°

| Primer 	| Region   	| Sequence                                                                                                                                                         	|
|--------	|----------	|------------------------------------------------------------------------------------------------------------------------------------------------------------------	|
| 518F   	| 16S V4V5 	| TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGCCAGCAGCYGCGGTAAN                                                                                                               	|
| 926R   	| 16S V4V5 	| GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGCCGTCAATTCNTTTRAGT, GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGCCGTCAATTTCTTTGAGT, GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGCCGTCTATTCCTTTGANT 	|

## Sample processing

Link to sample processing [google sheet](https://docs.google.com/spreadsheets/d/184gZr6-Bc48Q-48O8OhfnEsu5wRloLiekuJg3T_IzXw/edit#gid=0).

**Dilution calculations**

| Plug_ID 	| Extraction Date 	| Species     	| Hard DNA (ng_ul) 	| DNA for dilution (ul) 	| Water for dilution (ul) 	| Notes         	|
|---------	|-----------------	|-------------	|------------------	|-----------------------	|-------------------------	|---------------	|
| 1037    	| 20190826        	| Montipora   	| 10.15            	| 6.50                  	| 13.50                   	|               	|
| 1041    	| 20190823        	| Pocillopora 	| 44               	| 1.50                  	| 18.50                   	|               	|
| 1043    	| 20190814        	| Pocillopora 	| 25.9             	| 2.55                  	| 17.45                   	|               	|
| 1047    	| 20190808        	| Pocillopora 	| 37.4             	| 1.76                  	| 18.24                   	|               	|
| 1050    	| 20190809        	| Pocillopora 	| 35.4             	| 1.86                  	| 18.14                   	| 2021-02-25 A8 	|
| 1051    	| 20190731        	| Pocillopora 	| 45.5             	| 1.45                  	| 18.55                   	|               	|
| 1058    	| 20190823        	| Montipora   	| 14.95            	| 4.41                  	| 15.59                   	|               	|
| 1059    	| 20190826        	| Pocillopora 	| 25.2             	| 2.62                  	| 17.38                   	|               	|
| 1060    	| 20190725        	| Pocillopora 	| 44.3             	| 1.49                  	| 18.51                   	|               	|
| 1074    	| 20190722        	| Montipora   	| 22.2             	| 2.97                  	| 17.03                   	|               	|
| 1076    	| 20190930        	| Montipora   	| 16.35            	| 4.04                  	| 15.96                   	|               	|
| 1078    	| 20191125        	| Montipora   	| 13.1             	| 5.04                  	| 14.96                   	|               	|
| 1082    	| 20190805        	| Montipora   	| 14               	| 4.71                  	| 15.29                   	|               	|
| 1083    	| 20191204        	| Montipora   	| 25.4             	| 2.60                  	| 17.40                   	| 2021-02-25 A3 	|
| 1090    	| 20190807        	| Pocillopora 	| 14               	| 4.71                  	| 15.29                   	|               	|
| 1095    	| 20190722        	| Montipora   	| 12.9             	| 5.12                  	| 14.88                   	|               	|
| 1101    	| 20190823        	| Montipora   	| 13.8             	| 4.78                  	| 15.22                   	|               	|
| 1103    	| 20190718        	| Pocillopora 	| 50.9             	| 1.30                  	| 18.70                   	|               	|
| 1108    	| 20191121        	| Montipora   	| 13.15            	| 5.02                  	| 14.98                   	|               	|
| 1114    	| 20190805        	| Montipora   	| 10.05            	| 6.57                  	| 13.43                   	|               	|
| 1120    	| 20191014        	| Montipora   	| 13.1             	| 5.04                  	| 14.96                   	|               	|
| 1121    	| 20191204        	| Montipora   	| 20.4             	| 3.24                  	| 16.76                   	|               	|
| 1124    	| 20191113        	| Montipora   	| 18.9             	| 3.49                  	| 16.51                   	|               	|
| 1126    	| 20190807        	| Montipora   	| 13.4             	| 4.93                  	| 15.07                   	|               	|
| 1128    	| 20190802        	| Montipora   	| 3.74             	| 17.65                 	| 2.35                    	|               	|
| 1131    	| 20190718        	| Pocillopora 	| 30.5             	| 2.16                  	| 17.84                   	|               	|
| 1138    	| 20190809        	| Pocillopora 	| 33.1             	| 1.99                  	| 18.01                   	|               	|
| 1140    	| 20191009        	| Montipora   	| 14.5             	| 4.55                  	| 15.45                   	|               	|
| 1141    	| 20190722        	| Pocillopora 	| 24.1             	| 2.74                  	| 17.26                   	|               	|
| 1145    	| 20190826        	| Montipora   	| 14.7             	| 4.49                  	| 15.51                   	|               	|
| 1147    	| 20191206        	| Pocillopora 	| 39.3             	| 1.68                  	| 18.32                   	|               	|
| 1148    	| 20190724        	| Montipora   	| 28               	| 2.36                  	| 17.64                   	|               	|
| 1154    	| 20191105        	| Montipora   	| 13.15            	| 5.02                  	| 14.98                   	| 2021-02-25 A4 	|
| 1159    	| 20190720        	| Pocillopora 	| 4.38             	| 15.07                 	| 4.93                    	|               	|
| 1164    	| 20190801        	| Montipora   	| 8.81             	| 7.49                  	| 12.51                   	|               	|
| 1168    	| 20190730        	| Pocillopora 	| 21.5             	| 3.07                  	| 16.93                   	|               	|
| 1169    	| 20191113        	| Montipora   	| 28.4             	| 2.32                  	| 17.68                   	|               	|
| 1178    	| 20190930        	| Montipora   	| 12.25            	| 5.39                  	| 14.61                   	|               	|
| 1184    	| 20190731        	| Pocillopora 	| 33.7             	| 1.96                  	| 18.04                   	|               	|
| 1196    	| 20190730        	| Montipora   	| 17.6             	| 3.75                  	| 16.25                   	|               	|
| 1204    	| 20191208        	| Montipora   	| 18.85            	| 3.50                  	| 16.50                   	|               	|
| 1205    	| 20190720        	| Pocillopora 	| 27.3             	| 2.42                  	| 17.58                   	|               	|
| 1207    	| 20190826        	| Pocillopora 	| 35.9             	| 1.84                  	| 18.16                   	|               	|
| 1212    	| 20191205        	| Montipora   	| 24.2             	| 2.73                  	| 17.27                   	|               	|
| 1218    	| 20190826        	| Montipora   	| 13.4             	| 4.93                  	| 15.07                   	|               	|
| 1219    	| 20190724        	| Pocillopora 	| 40.2             	| 1.64                  	| 18.36                   	|               	|
| 1220    	| 20190730        	| Pocillopora 	| 20.3             	| 3.25                  	| 16.75                   	|               	|
| 1221    	| 20191121        	| Montipora   	| 11.65            	| 5.67                  	| 14.33                   	|               	|
| 1223    	| 20190806        	| Montipora   	| 5.99             	| 11.02                 	| 8.98                    	|               	|
| 1225    	| 20190730        	| Pocillopora 	| 21.6             	| 3.06                  	| 16.94                   	|               	|
| 1227    	| 20190801        	| Pocillopora 	| 10.55            	| 6.26                  	| 13.74                   	|               	|
| 1229    	| 20191206        	| Montipora   	| 11.85            	| 5.57                  	| 14.43                   	|               	|
| 1235    	| 20190722        	| Montipora   	| 15.1             	| 4.37                  	| 15.63                   	|               	|
| 1237    	| 20190926        	| Montipora   	| 17.5             	| 3.77                  	| 16.23                   	|               	|
| 1238    	| 20190725        	| Pocillopora 	| 27.4             	| 2.41                  	| 17.59                   	|               	|
| 1239    	| 20190823        	| Pocillopora 	| 28.6             	| 2.31                  	| 17.69                   	|               	|
| 1246    	| 20190801        	| Montipora   	| 19.85            	| 3.32                  	| 16.68                   	|               	|
| 1248    	| 20191001        	| Montipora   	| 10.4             	| 6.35                  	| 13.65                   	|               	|
| 1250    	| 20190809        	| Montipora   	| 12.5             	| 5.28                  	| 14.72                   	|               	|
| 1254    	| 20190731        	| Pocillopora 	| 32.7             	| 2.02                  	| 17.98                   	|               	|
| 1260    	| 20190724        	| Montipora   	| 11.9             	| 5.55                  	| 14.45                   	|               	|
| 1269    	| 20191202        	| Montipora   	| 12.9             	| 5.12                  	| 14.88                   	|               	|
| 1270    	| 20191009        	| Montipora   	| 24.7             	| 2.67                  	| 17.33                   	|               	|
| 1274    	| 20911105        	| Montipora   	| 19.85            	| 3.32                  	| 16.68                   	|               	|
| 1277    	| 20191202        	| Montipora   	| 14.7             	| 4.49                  	| 15.51                   	|               	|
| 1278    	| 20190809        	| Montipora   	| 19.1             	| 3.46                  	| 16.54                   	|               	|
| 1281    	| 20190924        	| Pocillopora 	| 16.7             	| 3.95                  	| 16.05                   	|               	|
| 1289    	| 20191113        	| Montipora   	| 14.3             	| 4.62                  	| 15.38                   	|               	|
| 1296    	| 20190729        	| Pocillopora 	| 21.5             	| 3.07                  	| 16.93                   	|               	|
| 1302    	| 20191111        	| Pocillopora 	| 15.55            	| 4.24                  	| 15.76                   	|               	|
| 1303    	| 20190726        	| Pocillopora 	| 18.85            	| 3.50                  	| 16.50                   	|               	|
| 1306    	| 20190725        	| Montipora   	| 31.7             	| 2.08                  	| 17.92                   	|               	|
| 1315    	| 20191204        	| Montipora   	| 23.8             	| 2.77                  	| 17.23                   	|               	|
| 1317    	| 20190814        	| Montipora   	| 12.15            	| 5.43                  	| 14.57                   	|               	|
| 1321    	| 20191209        	| Montipora   	| 16.85            	| 3.92                  	| 16.08                   	| 2021-02-25 A1 	|
| 1323    	| 20190807        	| Montipora   	| 10.75            	| 6.14                  	| 13.86                   	|               	|
| 1328    	| 20190826        	| Montipora   	| 13.7             	| 4.82                  	| 15.18                   	|               	|
| 1329    	| 20191204        	| Pocillopora 	| 48.1             	| 1.37                  	| 18.63                   	|               	|
| 1330    	| 20190801        	| Pocillopora 	| 16.8             	| 3.93                  	| 16.07                   	|               	|
| 1331    	| 20190725        	| Montipora   	| 10.8             	| 6.11                  	| 13.89                   	|               	|
| 1332    	| 20191205        	| Montipora   	| 22.2             	| 2.97                  	| 17.03                   	|               	|
| 1343    	| 20190814        	| Pocillopora 	| 11.7             	| 5.64                  	| 14.36                   	|               	|
| 1345    	| 20190731        	| Montipora   	| 23.5             	| 2.81                  	| 17.19                   	|               	|
| 1415    	| 20190815        	| Pocillopora 	| 36.4             	| 1.81                  	| 18.19                   	|               	|
| 1416    	| 20191009        	| Pocillopora 	| 7.1              	| 9.30                  	| 10.70                   	|               	|
| 1418    	| 20190720        	| Pocillopora 	| 31.2             	| 2.12                  	| 17.88                   	|               	|
| 1420    	| 20190722        	| Montipora   	| 20.9             	| 3.16                  	| 16.84                   	|               	|
| 1427    	| 20190807        	| Pocillopora 	| 29.7             	| 2.22                  	| 17.78                   	|               	|
| 1436    	| 20190731        	| Montipora   	| 9.3              	| 7.10                  	| 12.90                   	|               	|
| 1445    	| 20190826        	| Pocillopora 	| 26.1             	| 2.53                  	| 17.47                   	|               	|
| 1449    	| 20190905        	| Montipora   	| 22.2             	| 2.97                  	| 17.03                   	|               	|
| 1451    	| 20190720        	| Pocillopora 	| 39.5             	| 1.67                  	| 18.33                   	|               	|
| 1452    	| 20191009        	| Montipora   	| 22.8             	| 2.89                  	| 17.11                   	|               	|
| 1455    	| 20191202        	| Montipora   	| 12.45            	| 5.30                  	| 14.70                   	|               	|
| 1459    	| 20190722        	| Pocillopora 	| 50               	| 1.32                  	| 18.68                   	|               	|
| 1466    	| 20190731        	| Pocillopora 	| 32.8             	| 2.01                  	| 17.99                   	|               	|
| 1467    	| 20191210        	| Montipora   	| 12.75            	| 5.18                  	| 14.82                   	|               	|
| 1468    	| 20191121        	| Pocillopora 	| 15.95            	| 4.14                  	| 15.86                   	|               	|
| 1471    	| 20190718        	| Pocillopora 	| 41.2             	| 1.60                  	| 18.40                   	|               	|
| 1478    	| 20190725        	| Montipora   	| 36               	| 1.83                  	| 18.17                   	|               	|
| 1481    	| 20191205        	| Montipora   	| 19.65            	| 3.36                  	| 16.64                   	|               	|
| 1486    	| 20190720        	| Pocillopora 	| 37.2             	| 1.77                  	| 18.23                   	|               	|
| 1487    	| 20190807        	| Pocillopora 	| 36.1             	| 1.83                  	| 18.17                   	|               	|
| 1496    	| 20190801        	| Montipora   	| 8.89             	| 7.42                  	| 12.58                   	|               	|
| 1499    	| 20190808        	| Montipora   	| 14.35            	| 4.60                  	| 15.40                   	|               	|
| 1536    	| 20190725        	| Pocillopora 	| 58.2             	| 1.13                  	| 18.87                   	|               	|
| 1542    	| 20190815        	| Pocillopora 	| 15.35            	| 4.30                  	| 15.70                   	|               	|
| 1544    	| 20190806        	| Montipora   	| 15.55            	| 4.24                  	| 15.76                   	|               	|
| 1548    	| 20190904        	| Montipora   	| 16.9             	| 3.91                  	| 16.09                   	|               	|
| 1559    	| 20190725        	| Pocillopora 	| 35.4             	| 1.86                  	| 18.14                   	|               	|
| 1561    	| 20190730        	| Montipora   	| 15.95            	| 4.14                  	| 15.86                   	|               	|
| 1562    	| 20190926        	| Montipora   	| 18.35            	| 3.60                  	| 16.40                   	|               	|
| 1563    	| 20190905        	| Pocillopora 	| 24               	| 2.75                  	| 17.25                   	|               	|
| 1571    	| 20191121        	| Pocillopora 	| 25.7             	| 2.57                  	| 17.43                   	|               	|
| 1579    	| 20190826        	| Montipora   	| 16.45            	| 4.01                  	| 15.99                   	|               	|
| 1580    	| 20190718        	| Montipora   	| 15.8             	| 4.18                  	| 15.82                   	|               	|
| 1581    	| 20190826        	| Pocillopora 	| 37.2             	| 1.77                  	| 18.23                   	| 2021-02-25 A5 	|
| 1582    	| 20190926        	| Pocillopora 	| 20.9             	| 3.16                  	| 16.84                   	|               	|
| 1583    	| 20191121        	| Montipora   	| 12               	| 5.50                  	| 14.50                   	|               	|
| 1588    	| 20191206        	| Montipora   	| 14.3             	| 4.62                  	| 15.38                   	|               	|
| 1594    	| 20190720        	| Pocillopora 	| 16.1             	| 4.10                  	| 15.90                   	|               	|
| 1595    	| 20190808        	| Pocillopora 	| 57.6             	| 1.15                  	| 18.85                   	|               	|
| 1596    	| 20191009        	| Pocillopora 	| 13.1             	| 5.04                  	| 14.96                   	|               	|
| 1600    	| 20190718        	| Montipora   	| 26.6             	| 2.48                  	| 17.52                   	|               	|
| 1604    	| 20191209        	| Montipora   	| 30.5             	| 2.16                  	| 17.84                   	|               	|
| 1609    	| 20191208        	| Montipora   	| 12.45            	| 5.30                  	| 14.70                   	|               	|
| 1610    	| 20191125        	| Montipora   	| 11.05            	| 5.97                  	| 14.03                   	|               	|
| 1611    	| 20190806        	| Montipora   	| 5.64             	| 11.70                 	| 8.30                    	|               	|
| 1617    	| 20190801        	| Pocillopora 	| 29.9             	| 2.21                  	| 17.79                   	|               	|
| 1628    	| 20191113        	| Montipora   	| 26.2             	| 2.52                  	| 17.48                   	| 2021-02-25 A7 	|
| 1631    	| 20190718        	| Montipora   	| 20.2             	| 3.27                  	| 16.73                   	|               	|
| 1632    	| 20191009        	| Montipora   	| 13.7             	| 4.82                  	| 15.18                   	|               	|
| 1637    	| 20190805        	| Pocillopora 	| 49.6             	| 1.33                  	| 18.67                   	|               	|
| 1641    	| 20190720        	| Pocillopora 	| 26.9             	| 2.45                  	| 17.55                   	|               	|
| 1642    	| 20190903        	| Pocillopora 	| 37.3             	| 1.77                  	| 18.23                   	|               	|
| 1644    	| 20190718        	| Montipora   	| 34.1             	| 1.94                  	| 18.06                   	|               	|
| 1645    	| 20191209        	| Montipora   	| 20.5             	| 3.22                  	| 16.78                   	|               	|
| 1647    	| 20190926        	| Pocillopora 	| 59.3             	| 1.11                  	| 18.89                   	|               	|
| 1651    	| 20190924        	| Montipora   	| 27               	| 2.44                  	| 17.56                   	|               	|
| 1652    	| 20190826        	| Montipora   	| 11.85            	| 5.57                  	| 14.43                   	|               	|
| 1653    	| 20190826        	| Pocillopora 	| 31.9             	| 2.07                  	| 17.93                   	|               	|
| 1676    	| 20190718        	| Pocillopora 	| 23.5             	| 2.81                  	| 17.19                   	|               	|
| 1689    	| 20191206        	| Montipora   	| 20.4             	| 3.24                  	| 16.76                   	|               	|
| 1694    	| 20190905        	| Montipora   	| 14.55            	| 4.54                  	| 15.46                   	|               	|
| 1696    	| 20190718        	| Pocillopora 	| 23.9             	| 2.76                  	| 17.24                   	|               	|
| 1701    	| 20190826        	| Pocillopora 	| 34.2             	| 1.93                  	| 18.07                   	| 2021-02-25 A2 	|
| 1705    	| 20190801        	| Montipora   	| 11.85            	| 5.57                  	| 14.43                   	|               	|
| 1706    	| 20190826        	| Montipora   	| 10.45            	| 6.32                  	| 13.68                   	|               	|
| 1707    	| 20190905        	| Pocillopora 	| 35.4             	| 1.86                  	| 18.14                   	|               	|
| 1709    	| 20191121        	| Pocillopora 	| 20               	| 3.30                  	| 16.70                   	|               	|
| 1721    	| 20190805        	| Pocillopora 	| 19.35            	| 3.41                  	| 16.59                   	|               	|
| 1722    	| 20191202        	| Montipora   	| 18.4             	| 3.59                  	| 16.41                   	|               	|
| 1728    	| 20190806        	| Pocillopora 	| 48.1             	| 1.37                  	| 18.63                   	|               	|
| 1729    	| 20191105        	| Montipora   	| 19.95            	| 3.31                  	| 16.69                   	|               	|
| 1732    	| 20190724        	| Pocillopora 	| 42.6             	| 1.55                  	| 18.45                   	|               	|
| 1744    	| 20190807        	| Pocillopora 	| 21.8             	| 3.03                  	| 16.97                   	|               	|
| 1751    	| 20190722        	| Montipora   	| 18.2             	| 3.63                  	| 16.37                   	|               	|
| 1754    	| 20190718        	| Montipora   	| 17.05            	| 3.87                  	| 16.13                   	|               	|
| 1755    	| 20190801        	| Pocillopora 	| 12               	| 5.50                  	| 14.50                   	|               	|
| 1757    	| 20190731        	| Pocillopora 	| 31.4             	| 2.10                  	| 17.90                   	|               	|
| 1762    	| 20191121        	| Pocillopora 	| 18.85            	| 3.50                  	| 16.50                   	|               	|
| 1765    	| 20190725        	| Pocillopora 	| 50.5             	| 1.31                  	| 18.69                   	|               	|
| 1767    	| 20190823        	| Pocillopora 	| 52.1             	| 1.27                  	| 18.73                   	|               	|
| 1775    	| 20190718        	| Pocillopora 	| 37.2             	| 1.77                  	| 18.23                   	|               	|
| 1776    	| 20190731        	| Montipora   	| 10.45            	| 6.32                  	| 13.68                   	|               	|
| 1777    	| 20190930        	| Pocillopora 	| 39.2             	| 1.68                  	| 18.32                   	|               	|
| 1779    	| 20190729        	| Montipora   	| 16.9             	| 3.91                  	| 16.09                   	|               	|
| 1820    	| 20190815        	| Pocillopora 	| 21.4             	| 3.08                  	| 16.92                   	|               	|
| 1826    	| 20190806        	| Montipora   	| 19               	| 3.47                  	| 16.53                   	|               	|
| 1997    	| 20190905        	| Montipora   	| 11.2             	| 5.89                  	| 14.11                   	|               	|
| 2000    	| 20190730        	| Montipora   	| 19               	| 3.47                  	| 16.53                   	|               	|
| 2002    	| 20190826        	| Pocillopora 	| 26.5             	| 2.49                  	| 17.51                   	|               	|
| 2005    	| 20190718        	| Pocillopora 	| 30.3             	| 2.18                  	| 17.82                   	|               	|
| 2007    	| 20191105        	| Montipora   	| 12.2             	| 5.41                  	| 14.59                   	|               	|
| 2009    	| 20191111        	| Montipora   	| 30.6             	| 2.16                  	| 17.84                   	|               	|
| 2012    	| 20190730        	| Pocillopora 	| 36.1             	| 1.83                  	| 18.17                   	|               	|
| 2016    	| 20191125        	| Montipora   	| 15.95            	| 4.14                  	| 15.86                   	|               	|
| 2021    	| 20191204        	| Montipora   	| 13.75            	| 4.80                  	| 15.20                   	|               	|
| 2026    	| 20190718        	| Pocillopora 	| 14.85            	| 4.44                  	| 15.56                   	|               	|
| 2064    	| 20190730        	| Pocillopora 	| 29.5             	| 2.24                  	| 17.76                   	|               	|
| 2067    	| 20191209        	| Montipora   	| 13               	| 5.08                  	| 14.92                   	|               	|
| 2068    	| 20190808        	| Montipora   	| 11.15            	| 5.92                  	| 14.08                   	|               	|
| 2072    	| 20190814        	| Pocillopora 	| 20.2             	| 3.27                  	| 16.73                   	|               	|
| 2081    	| 20190815        	| Montipora   	| 10.4             	| 6.35                  	| 13.65                   	|               	|
| 2087    	| 20190826        	| Pocillopora 	| 35.3             	| 1.87                  	| 18.13                   	|               	|
| 2153    	| 20191210        	| Montipora   	| 21               	| 3.14                  	| 16.86                   	|               	|
| 2183    	| 20190718        	| Montipora   	| 11.6             	| 5.69                  	| 14.31                   	|               	|
| 2185    	| 20191009        	| Pocillopora 	| 15.9             	| 4.15                  	| 15.85                   	|               	|
| 2188    	| 20191001        	| Montipora   	| 13.4             	| 4.93                  	| 15.07                   	|               	|
| 2190    	| 20191009        	| Montipora   	| 20.4             	| 3.24                  	| 16.76                   	|               	|
| 2195    	| 20191121        	| Pocillopora 	| 30               	| 2.20                  	| 17.80                   	|               	|
| 2197    	| 20190729        	| Pocillopora 	| 25.4             	| 2.60                  	| 17.40                   	|               	|
| 2202    	| 20190724        	| Pocillopora 	| 50.8             	| 1.30                  	| 18.70                   	|               	|
| 2204    	| 20190807        	| Montipora   	| 11.45            	| 5.76                  	| 14.24                   	|               	|
| 2210    	| 20190826        	| Pocillopora 	| 21.4             	| 3.08                  	| 16.92                   	|               	|
| 2212    	| 20190903        	| Pocillopora 	| 19.3             	| 3.42                  	| 16.58                   	|               	|
| 2300    	| 20190731        	| Pocillopora 	| 33.3             	| 1.98                  	| 18.02                   	|               	|
| 2302    	| 20191001        	| Montipora   	| 11.95            	| 5.52                  	| 14.48                   	|               	|
| 2304    	| 20190722        	| Pocillopora 	| 12.75            	| 5.18                  	| 14.82                   	|               	|
| 2305    	| 20190724        	| Pocillopora 	| 83               	| 0.80                  	| 19.20                   	|               	|
| 2306    	| 20190926        	| Pocillopora 	| 53.8             	| 1.23                  	| 18.77                   	|               	|
| 2357    	| 20190718        	| Pocillopora 	| 61.8             	| 1.07                  	| 18.93                   	|               	|
| 2363    	| 20190720        	| Pocillopora 	| 40.2             	| 1.64                  	| 18.36                   	|               	|
| 2380    	| 20191204        	| Montipora   	| 22.4             	| 2.95                  	| 17.05                   	|               	|
| 2386    	| 20190718        	| Montipora   	| 36.1             	| 1.83                  	| 18.17                   	|               	|
| 2402    	| 20190826        	| Montipora   	| 18.7             	| 3.53                  	| 16.47                   	|               	|
| 2403    	| 20191208        	| Montipora   	| 20.8             	| 3.17                  	| 16.83                   	|               	|
| 2409    	| 20190808        	| Pocillopora 	| 55.7             	| 1.18                  	| 18.82                   	|               	|
| 2410    	| 20191204        	| Montipora   	| 18.2             	| 3.63                  	| 16.37                   	|               	|
| 2412    	| 20190731        	| Montipora   	| 15.15            	| 4.36                  	| 15.64                   	|               	|
| 2413    	| 20190809        	| Pocillopora 	| 36.9             	| 1.79                  	| 18.21                   	|               	|
| 2414    	| 20190807        	| Pocillopora 	| 48               	| 1.38                  	| 18.63                   	|               	|
| 2419    	| 20190826        	| Montipora   	| 15.15            	| 4.36                  	| 15.64                   	|               	|
| 2511    	| 20191206        	| Montipora   	| 16.1             	| 4.10                  	| 15.90                   	|               	|
| 2513    	| 20190722        	| Pocillopora 	| 12.55            	| 5.26                  	| 14.74                   	|               	|
| 2518    	| 20190801        	| Montipora   	| 9.3              	| 7.10                  	| 12.90                   	|               	|
| 2527    	| 20190805        	| Pocillopora 	| 61.2             	| 1.08                  	| 18.92                   	|               	|
| 2534    	| 20191208        	| Pocillopora 	| 48.7             	| 1.36                  	| 18.64                   	|               	|
| 2550    	| 20190724        	| Pocillopora 	| 60.4             	| 1.09                  	| 18.91                   	|               	|
| 2554    	| 20190720        	| Montipora   	| 31.2             	| 2.12                  	| 17.88                   	|               	|
| 2555    	| 20191111        	| Montipora   	| 19.85            	| 3.32                  	| 16.68                   	|               	|
| 2561    	| 20190724        	| Montipora   	| 16.9             	| 3.91                  	| 16.09                   	|               	|
| 2564    	| 20190726        	| Pocillopora 	| 57.5             	| 1.15                  	| 18.85                   	|               	|
| 2668    	| 20191001        	| Pocillopora 	| 31.1             	| 2.12                  	| 17.88                   	|               	|
| 2731    	| 20191105        	| Montipora   	| 24.9             	| 2.65                  	| 17.35                   	|               	|
| 2733    	| 20191113        	| Pocillopora 	| 32.8             	| 2.01                  	| 17.99                   	|               	|
| 2734    	| 20190815        	| Montipora   	| 7.37             	| 8.96                  	| 11.04                   	|               	|
| 2735    	| 20191111        	| Montipora   	| 16.3             	| 4.05                  	| 15.95                   	|               	|
| 2736    	| 20191105        	| Montipora   	| 11.25            	| 5.87                  	| 14.13                   	|               	|
| 2737    	| 20191125        	| Montipora   	| 12.05            	| 5.48                  	| 14.52                   	|               	|
| 2743    	| 20190724        	| Pocillopora 	| 101              	| 0.65                  	| 19.35                   	| 2021-02-25 A6 	|
| 2750    	| 20190905        	| Pocillopora 	| 45.8             	| 1.44                  	| 18.56                   	|               	|
| 2753    	| 20191205        	| Montipora   	| 17.9             	| 3.69                  	| 16.31                   	|               	|
| 2756    	| 20191009        	| Montipora   	| 10.2             	| 6.47                  	| 13.53                   	|               	|
| 2860    	| 20190807        	| Montipora   	| 17.75            	| 3.72                  	| 16.28                   	|               	|
| 2861    	| 20190730        	| Pocillopora 	| 25.3             	| 2.61                  	| 17.39                   	|               	|
| 2862    	| 20190724        	| Montipora   	| 24               	| 2.75                  	| 17.25                   	|               	|
| 2866    	| 20190801        	| Montipora   	| 10.8             	| 6.11                  	| 13.89                   	|               	|
| 2870    	| 20190801        	| Pocillopora 	| 36               	| 1.83                  	| 18.17                   	|               	|
| 2873    	| 20190730        	| Pocillopora 	| 44.2             	| 1.49                  	| 18.51                   	|               	|
| 2875    	| 20190806        	| Montipora   	| 11.35            	| 5.81                  	| 14.19                   	|               	|
| 2877    	| 20190731        	| Pocillopora 	| 59.1             	| 1.12                  	| 18.88                   	|               	|
| 2878    	| 20190807        	| Pocillopora 	| 48.7             	| 1.36                  	| 18.64                   	|               	|
| 2879    	| 20190930        	| Pocillopora 	| 33.5             	| 1.97                  	| 18.03                   	|               	|
| 2977    	| 20190815        	| Pocillopora 	| 14.75            	| 4.47                  	| 15.53                   	|               	|
| 2979    	| 20190722        	| Pocillopora 	| 32.2             	| 2.05                  	| 17.95                   	|               	|
| 2986    	| 20191210        	| Montipora   	| 10.35            	| 6.38                  	| 13.62                   	|               	|
| 2990    	| 20191210        	| Montipora   	| 15.1             	| 4.37                  	| 15.63                   	|               	|
| 2993    	| 20190725        	| Pocillopora 	| 48.4             	| 1.36                  	| 18.64                   	|               	|
| 2995    	| 20190729        	| Montipora   	| 8.99             	| 7.34                  	| 12.66                   	|               	|
| 2999    	| 20190801        	| Pocillopora 	| 44               	| 1.50                  	| 18.50                   	|               	|
| 1169    	| 20191113        	| Pocillopora 	| 28.4             	| 2.32                  	| 17.68                   	|               	|

**Dilution plates**

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

**PCR plates**

Plate 1 - 20210225

| Master Mix                      	| uL 	| # of samples (8 + 0.5 for error) 	| total needed (uL) 	|
|---------------------------------	|----	|-------------------------------------------------	|-------------------	|
| Phusion PCR master mix          	| 50 	| 8.5                                             	| 425               	|
| UltraPure water                 	| 43 	| 8.5                                             	| 365.5             	|
| 10uM working stock 515F primer  	| 2  	| 8.5                                             	| 17                	|
| 10uM working stock 806RB primer 	| 2  	| 8.5                                             	| 17                	|

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

**Results**

20210225 gel image - 33 uL reactions pooled back together and run on gel. Run gel on triplicates next time to make sure no PCR artifact.    

![gel](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/20210225-gel-16s.jpg?raw=true)

Two bands - one at ~300-350 bp (bottom band) and one at ~750 bp. The expected band size is 300-350 bp. What is the band at ~750 bp? This could be:  
- **Non specific targets; aka targeting more than our desired product**     
- Single vs. double strand products  
- Heterozygosity at particular locus   
- Not likely primer dimer b/c 300-350 bp is desired length and primer dimer is usually closer to 100 bp    
- Mixed DNA sample - could this be picking up something in the coral or symbiont?  

Next steps: I can try to increase the annealing temperature. Apprill et al had 55C but Rebecca had tried 57C before. I can take 3-4 samples from above do a PCR gradient - run one at 57; one at 58; one at 59 to see if there is a difference. Make sure to include negative control next time to exclude contamination!!

Alternatively, I could up the volume of primer used.I don't want to change the number of cycles yet because the bands are so clear.
