---
layout: post
title: ITS2 Sequencing Protocol
date: '2020-01-31'
categories: Protocols
tags: ITS2
projects: Putnam Lab
---

# Putnam Lab ITS2 Sequencing Protocol

Prerequisites:  
- Snap-frozen or well-preserved tissue samples  
- DNA extracted from tissue samples ([Putnam Lab Zymo Duet RNA DNA Extraction Protocol](https://emmastrand.github.io/EmmaStrand_Notebook/Zymo-Duet-RNA-DNA-Extraction-Protocol/))  
- Quantity and quality of DNA checked (Quality: [Gel Electrophoresis](https://emmastrand.github.io/EmmaStrand_Notebook/Gel-Electrophoresis-Protocol/) and Quantity: [Qubit](https://emmastrand.github.io/EmmaStrand_Notebook/Qubit-Protocol/))  

Resources:  
- PCR and Gel Electrophoresis Descriptions and Troubleshooting: [Strand 2017](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/protocols/PCR_GEL_SPEC.pdf)  
- Khan Academy: [PCR Explained](https://www.khanacademy.org/science/biology/biotech-dna-technology/dna-sequencing-pcr-electrophoresis/a/polymerase-chain-reaction-pcr)  
- Internal Transcribed Spacer 2 (ITS2) is a region of ribosomal DNA: [Universal DNA Barcode](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2948509/)  
- DNA Barcoding Explained: [International Barcode of Life](https://ibol.org/about/dna-barcoding/), [Barcoding 101](https://dnabarcoding101.org/lab/)

Materials:  
- Primers: ITS2  

| Gene | PrimerName   | Sequence (5'-3')             | SequenceWithPartialIlluminaTail (5'-3')                        |
|------|--------------|------------------------------|----------------------------------------------------------------|
| ITS2 | ITSintfor2   | GAATTGCAGAACTCCGTG           | TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGGAATTGCAGAACTCCGTG            |
| ITS2 | ITS2_Reverse | GGGATCCATATGCTTAAGTTCAGCGGGT | GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGGGGATCCATATGCTTAAGTTCAGCGGGT |

Citation: LaJeunesse TC, Trench RK (2000) Biogeography of two species of Symbiodinium (Freudenthal) inhabiting the intertidal sea anemone Anthopleura elegantissima (Brandt). Biol Bull 199: 126−134.

- Phusion HiFi Mastermix (Thermo Scientific F531S): https://www.fishersci.com/shop/products/phusion-high-fidelity-pcr-master-mixes/f531s  
- Ultra-pure water
- 96-well plates, centrifuge, pipettes and filter tips, thermocycler

Protocol:  
10 ng of DNA is the bare minimum required for ITS2 sequencing using this protocol.  

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

| Component            | Per Rxn            | FINAL CONC | ITS2 |
|----------------------|--------------------|------------|------|
| 2X Phusion Mastermix | 50 μl               | 1X         | 1750 |
| F primer (10uM)      | 2 μl                | 0.4uM      | 70   |
| R primer (10uM)      | 2 μl                | 0.4uM      | 70   |
| H2O                  | Up to 100 μl (45 μl) |            | 1645 |  

6. Add 97 μl of master mix stock solution to each well.  
7. Add 3 μl of DNA sample (from the 10 μl dilution mix) to each well.
8. Add 10 μl ultra pure water to one well per plate as a negative control.
9. Add 0.5 μl of each sample into one well as a mixture control.  
10. Aliquot 100 μl reaction into 3 wells to run reaction in triplicate PCR (33 μl each).  
11. Spin down plate.  
12. Run the following PCR program (this cycle program is specific to ITS2):  

| Cycles | Time   | Temp |
|--------|--------|------|
| 1      | 3 min  | 95°  |
| 35     | 30 sec | 95°  |
|        | 30 sec | 52°  |
|        | 30 sec | 72°  |
| 1      | 2 min  | 72°  |
| 1      | ∞ min  | 4°   |

13. Pool products into PCR strip tubes (100 μl total) appropriately labeled with the sample ID. These will be the PCR product stock. Store at -20&deg;C.     
14. Run 5 μl of each product on a 2% agarose gel using the following [Putnam Lab Gel Electrophoresis protocol](https://emmastrand.github.io/EmmaStrand_Notebook/Gel-Electrophoresis-Protocol/) to check for ~300 bp product.  
15. Aliquot 45 μl of each product from the PCR product stock (in Step 11) into new PCR strip tubes appropriately labeled with the sample ID. These tubes will be delivered to the sequencing center. Store at -20&deg;C until delivering to the sequencing center.     
