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
2. Calculate volumes of DNA and water needed to dilute sample to 3.33 ng/μl concentration in 10 μl.  

| Sample ID | DNA (ng_μl) | DNA for dilution (μl) | Water for Dilution (μl) |
|----------|-------------|-----------------------|-------------------------|
| Example       | Qubit value        | =33/Qubit value                  | 10 - DNA for dilution value                    |
| Coral 1      | 6.82        | 4.84                  | 5.16                    |

3. Aliquot the appropriate volume of ultra pure water needed for dilution (for Coral 1, 5.16 μl) into each appropriately labeled PCR strip tube.  
4. Aliquot the appropriate volume of DNA sample needed for dilution (for Coral 1, 4.84 μl).  
> 10 ng is widely used as a general starting point, this is usually enough DNA to amplify your desired gene. If the sample is suspected to contain more inhibitors, decrease this starting value. If the sample is not amplifying, a troubleshooting option is to increase this value. Starting with 10 ng for 100 μl reaction that is split into triplicate wells in the PCR steps, 3.33 ng of DNA is needed per reaction. A 10 μl dilution step is used to standardize DNA samples. To calculate the DNA sample volume needed for the dilution, use the following equation: V<sub>1</sub>M<sub>1</sub>=V<sub>2</sub>M<sub>2</sub>.   
V<sub>1</sub>(Qubit value)=(3.33 ng/μl)(10 μl)  
V<sub>1</sub>=33/Qubit value  
Finally, to calculate the volume of water needed, subtract the DNA volume required from 10 μl.

5. Make master mix stock solution. Forward and reverse primers will come in 100 uM stock solutions, dilute this to 10 uM. Keep master mix stock solution on ice.    

| Master Mix                      	| uL 	| # of samples (X + X neg controls + X for error) 	| total needed (uL) 	|
|---------------------------------	|----	|-------------------------------------------------	|-------------------	|
| Phusion PCR master mix          	| 50 	| 1                                               	| 50                	|
| UltraPure water                 	| 43 	| 1                                               	| 43                	|
| 10uM working stock 515F primer  	| 2  	| 1                                               	| 2                 	|
| 10uM working stock 806RB primer 	| 2  	| 1                                               	| 2                 	|

> Amount of Ultrapure water is determined by  100 - (Phusion PCR master mix + F primer + R primer). Amount of primer can be increased or decreased as a part of troubleshooting.

6. Add 97 μl of master mix stock solution to each well.  
7. Add 3 μl of DNA sample (from the 10 μl dilution mix) to each well.
8. Add 10 μl ultra pure water to one well per plate as a negative control.
9. Add 0.5 μl of each sample into one well as a mixture control.  
10. Aliquot 100 μl reaction into 3 wells to run reaction in triplicate PCR (33 μl each).  
11. Spin down plate.  
12. Run the following PCR program (this cycle program is specific to 16s):  

PCR program (Apprill et al 2015):  

| Temperature 	| Time   	| Repeat 	|
|-------------	|--------	|--------	|
| 95 °C       	| 2 min  	| 1      	|
| 95 °C       	| 20 s   	| x27-35 	|
|  55 °C      	| 15s    	|        	|
| 72 °C       	| 5 min  	|        	|
| 72 °C       	| 10 min 	| 1      	|
   
13. Run 5 μl of each product on a 2% agarose gel using the following [Putnam Lab Gel Electrophoresis protocol](https://emmastrand.github.io/EmmaStrand_Notebook/Gel-Electrophoresis-Protocol/) to check for ~390 bp product. You need to have successful triplicate samples prior to pooling
14. Pool replicate products for those that were successfully amplified into PCR strip tubes (100 μl total) appropriately labeled with the original sample ID and the word pool. These will be the PCR product stock. Store at -20&deg;C.  
15. Aliquot 45 μl of each product from the PCR product stock (in Step 11) into new PCR strip tubes appropriately labeled with the sample ID. These tubes will be delivered to the sequencing center to complete the library prep and sequencing. Store at -20&deg;C until delivering to the sequencing center.

Example of [google spreadsheet](https://docs.google.com/spreadsheets/d/184gZr6-Bc48Q-48O8OhfnEsu5wRloLiekuJg3T_IzXw/edit?usp=sharing) for data processing, including master mix and dilution calculations, and 96-well PCR platemaps.
