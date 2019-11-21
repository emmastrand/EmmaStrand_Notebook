---
layout: post
title: 16s, ITS2, 23s PCR Protocol Testing
date: '2019-11-20'
categories: Processing
tags: 16s, 23s, ITS2, DNA, coral
projects: Holobiont Integration
---

**20191119 R.S., E.S.**

Protocol testing for 16s, ITS2, and 23s amplicon sequencing.

Primers: ITS2, cp23S, and 16S with Nextera partial tails  

| Primer       |            |                                                                                                                                                                  | Annealing Temp |
|--------------|------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------|
| ITSintfor2   | ITS2       | TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGGAATTGCAGAACTCCGTG                                                                                                              | 52°            |
| ITS2_Reverse | ITS2       | GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGGGGATCCATATGCTTAAGTTCAGCGGGT                                                                                                   | 52°            |
| 24 F         | cp23S-rDNA | TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGGGTAGCAAATTTCCTTGTCG                                                                                                            | 55°            |
| 454 R        | cp23S-rDNA | GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGCTTGTATCGCTTTGTTCACC                                                                                                           | 55°            |
| 518F         | 16S V4V5   | TCGTCGGCAGCGTCAGATGTGTATAAGAGACAGCCAGCAGCYGCGGTAAN                                                                                                               | 57°            |
| 926R         | 16S V4V5   | GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGCCGTCAATTCNTTTRAGT, GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGCCGTCAATTTCTTTGAGT, GTCTCGTGGGCTCGGAGATGTGTATAAGAGACAGCCGTCTATTCCTTTGANT | 57°            |

Phusion HiFi Mastermix (Thermo Scientific™ F531S): https://www.fishersci.com/shop/products/phusion-high-fidelity-pcr-master-mixes/f531s  

Protocol:  
1. Check concentration with [Qubit](https://emmastrand.github.io/EmmaStrand_Notebook/Qubit-Protocol/).  
2. Dilute DNA to 100ng in 10ul (10ng/ul).

| SampleID | CoralCode | Conc (ng/ul) | DNA for 10ng/ul dilution (ul) | Water for dilution (ul) | Amount to add for 10ng | Water to add | Amount for mix |
|----------|-----------|--------------|-------------------------------|-------------------------|------------------------|--------------|----------------|
| H1       | 1637H     | 49.6         | 2.02                          | 7.98                    | 1.00                   | 47.00        | 0.167          |
| H2       | 1060H     | 44.3         | 2.26                          | 7.74                    | 1.00                   | 47.00        | 0.167          |
| H3       | 1041H     | 44           | 2.27                          | 7.73                    | 1.00                   | 47.00        | 0.167          |
| H4       | 1651H     | 27           | 3.70                          | 6.30                    | 1.00                   | 47.00        | 0.167          |
| H5       | 1600H     | 26.6         | 3.76                          | 6.24                    | 1.00                   | 47.00        | 0.167          |
| H6       | 1196H     | 17.6         | 5.68                          | 4.32                    | 1.00                   | 47.00        | 0.167          |
| HM       | MixH      | 10           |                               |                         | 1.00                   | 47.00        |                |
| S1       | 1637S     | 86.6         | 1.15                          | 8.85                    | 1.00                   | 47.00        | 0.167          |
| S2       | 1060S     | 71.8         | 1.39                          | 8.61                    | 1.00                   | 47.00        | 0.167          |
| S3       | 1041S     | 62.4         | 1.60                          | 8.40                    | 1.00                   | 47.00        | 0.167          |
| S4       | 1651S     | 24.5         | 4.08                          | 5.92                    | 1.00                   | 47.00        | 0.167          |
| S5       | 1600S     | 38.4         | 2.60                          | 7.40                    | 1.00                   | 47.00        | 0.167          |
| S6       | 1196S     | 25.6         | 3.91                          | 6.09                    | 1.00                   | 47.00        | 0.167          |
| SM       | MixS      | 10           |                               |                         | 1.00                   | 47.00        |                |   

3. Make stock solution per gene.  

| For 18 reactions (ul) |             |      |       |                     |
|-----------------------|-------------|------|-------|---------------------|
| Component             | Per Rxn     | ITS2 | cp23S | 16S                 |
| 2X Phusion Mastermix  | 50ul        | 900  | 900   | 900                 |
| F primer (10uM)       | 3-4ul       | 72   | 72    | 54 (use mixed pool) |
| R primer (10uM)       | 3-4ul       | 72   | 72    |                     |
| H2O                   | Up to 100ul | 738  | 738   | 828                 |

4. Add 99uL of stock solution to each well. Add 1ul of DNA to each well per gene.  
5. Aliquot 100ul reaction into 3 wells to run reaction in triplicate PCR (33ul each).  

| ITS2   |        | cp23S |        | 16S  |        |      |
|--------|--------|-------|--------|------|--------|------|
| Cycles | Time   | Temp  | Time   | Temp | Time   | Temp |
| 1      | 3 min  | 95°   | 3 min  | 95°  | 3 min  | 98°  |
| 35     | 30 sec | 95°   | 30 sec | 95°  | 30 sec | 94°  |
|        | 30 sec | 52°   | 30 sec | 55°  | 45 sec | 57°  |
|        | 30 sec | 72°   | 30 sec | 72°  | 1 min  | 72°  |
| 1      | 5 min  | 72°   | 5 min  | 72°  | 5 min  | 72°  |
| 1      | ∞ min  | 4°    | ∞ min  | 4°   | ∞ min  | 4°   |

6. Pool products into strip tubes (100ul total).  
7. Run 5ul of each product on a 2% agarose gel to check for ~300bp product.  

[Gel Electrophoresis Protocol](https://emmastrand.github.io/EmmaStrand_Notebook/Gel-Electrophoresis-Protocol/)

![20191119 Gel]()


Order of test tubes, gel electrophoresis, and PCR plates:  

| Dilution Strip tubes: |    |    |    |    |    |    |    |        |
|-----------------------|----|----|----|----|----|----|----|--------|
| 1                     | H1 | H2 | H3 | H4 | H5 | H6 | HM | NegCon |
| 2                     | S1 | S2 | S3 | S4 | S5 | S6 | SM | NegCon |  

| ITS2 |     |     |     |     |     | cp23S |     |     |     |     |     |     |
|------|-----|-----|-----|-----|-----|-------|-----|-----|-----|-----|-----|-----|
|      | 1   | 2   | 3   | 4   | 5   | 6     | 7   | 8   | 9   | 10  | 11  | 12  |
| A    | H1  | H1  | H1  | S1  | S1  | S1    | H1  | H1  | H1  | S1  | S1  | S1  |
| B    | H2  | H2  | H2  | S2  | S2  | S2    | H2  | H2  | H2  | S2  | S2  | S2  |
| C    | H3  | H3  | H3  | S3  | S3  | S3    | H3  | H3  | H3  | S3  | S3  | S3  |
| D    | H4  | H4  | H4  | S4  | S4  | S4    | H4  | H4  | H4  | S4  | S4  | S4  |
| E    | H5  | H5  | H5  | S5  | S5  | S5    | H5  | H5  | H5  | S5  | S5  | S5  |
| F    | H6  | H6  | H6  | S6  | S6  | S6    | H6  | H6  | H6  | S6  | S6  | S6  |
| G    | HM  | HM  | HM  | SM  | SM  | SM    | HM  | HM  | HM  | SM  | SM  | SM  |
| H    | NEG | NEG | NEG | NEG | NEG | NEG   | NEG | NEG | NEG | NEG | NEG | NEG |  

| V4V5 16S |     |     |     |     |     |     |
|----------|-----|-----|-----|-----|-----|-----|
|          | 13  | 14  | 15  | 16  | 17  | 18  |
| A        | H1  | H1  | H1  | S1  | S1  | S1  |
| B        | H2  | H2  | H2  | S2  | S2  | S2  |
| C        | H3  | H3  | H3  | S3  | S3  | S3  |
| D        | H4  | H4  | H4  | S4  | S4  | S4  |
| E        | H5  | H5  | H5  | S5  | S5  | S5  |
| F        | H6  | H6  | H6  | S6  | S6  | S6  |
| G        | HM  | HM  | HM  | SM  | SM  | SM  |
| H        | NEG | NEG | NEG | NEG | NEG | NEG |  

| PCR product strip tubes: |          |          |          |          |          |          |          |           |
|--------------------------|----------|----------|----------|----------|----------|----------|----------|-----------|
| 1                        | H1-ITS2  | H2-ITS2  | H3-ITS2  | H4-ITS2  | H5-ITS2  | H6-ITS2  | HM-ITS2  | NEG-ITS2  |
| 3                        | S1-ITS2  | S2-ITS2  | S3-ITS2  | S4-ITS2  | S5-ITS2  | S6-ITS2  | SM-ITS2  | NEG-ITS2  |
| 7                        | H1-cp23S | H2-cp23S | H3-cp23S | H4-cp23S | H5-cp23S | H6-cp23S | HM-cp23S | NEG-cp23S |
| 10                       | S1-cp23S | S2-cp23S | S3-cp23S | S4-cp23S | S5-cp23S | S6-cp23S | SM-cp23S | NEG-cp23S |
| 13                       | H1-16S   | H2-16S   | H3-16S   | H4-16S   | H5-16S   | H6-16S   | HM-16S   | NEG-16S   |
| 16                       | S1-16S   | S2-16S   | S3-16S   | S4-16S   | S5-16S   | S6-16S   | SM-16S   | NEG-16S   |  

| Strip tubes submitted to Janet: |          |          |          |          |          |          |          |          |
|---------------------------------|----------|----------|----------|----------|----------|----------|----------|----------|
| 1                               | H1-ITS2  | H2-ITS2  | H3-ITS2  | H4-ITS2  | H5-ITS2  | H6-ITS2  | HM-ITS2  | S1-ITS2  |
| 2                               | S2-ITS2  | S3-ITS2  | S4-ITS2  | S5-ITS2  | S6-ITS2  | SM-ITS2  | H1-cp23S | H2-cp23S |
| 3                               | H3-cp23S | H4-cp23S | H5-cp23S | H6-cp23S | HM-cp23S | S1-cp23S | S2-cp23S | S3-cp23S |
| 4                               | S4-cp23S | S5-cp23S | S6-cp23S | SM-cp23S | H1-16S   | H2-16S   | H3-16S   | H4-16S   |
| 5                               | H5-16S   | H6-16S   | HM-16S   | S1-16S   | S2-16S   | S3-16S   | S4-16S   | S5-16S   |
| 6                               | S6-16S   | SM-16S   |          |          |          |          |          |          |  

Gel map:  

| Ladder | H1-ITS2  | H2-ITS2  | H3-ITS2  | H4-ITS2  | H5-ITS2  | H6-ITS2  | HM-ITS2  | NEG-ITS2  | S1-ITS2 | S2-ITS2 | S3-ITS2 | S4-ITS2 | S5-ITS2 | S6-ITS2 | SM-ITS2 | NEG-ITS2 | H1-cp23S | H2-cp23S | H3-cp23S | H4-cp23S | H5-cp23S | H6-cp23S | HM-cp23S | NEG-cp23S |
|--------|----------|----------|----------|----------|----------|----------|----------|-----------|---------|---------|---------|---------|---------|---------|---------|----------|----------|----------|----------|----------|----------|----------|----------|-----------|
|        |          |          |          |          |          |          |          |           |         |         |         |         |         |         |         |          |          |          |          |          |          |          |          |           |
| Ladder | S1-cp23S | S2-cp23S | S3-cp23S | S4-cp23S | S5-cp23S | S6-cp23S | SM-cp23S | NEG-cp23S | H1-16S  | H2-16S  | H3-16S  | H4-16S  | H5-16S  | H6-16S  | HM-16S  | NEG-16S  | S1-16S   | S2-16S   | S3-16S   | S4-16S   | S5-16S   | S6-16S   | SM-16S   | NEG-16S   |

Final Amplicon samples:  

| SampleNumber | SampleID | CoralCode | CoralType | AmpliconGene | ProductLength |
|--------------|----------|-----------|-----------|--------------|---------------|
| 1            | H1       | 1637H     | Hard      | ITS2         | 350           |
| 2            | H2       | 1060H     | Hard      | ITS2         | 350           |
| 3            | H3       | 1041H     | Hard      | ITS2         | 350           |
| 4            | H4       | 1651H     | Hard      | ITS2         | 350           |
| 5            | H5       | 1600H     | Hard      | ITS2         | 350           |
| 6            | H6       | 1196H     | Hard      | ITS2         | 350           |
| 7            | HM       | MixH      | Hard      | ITS2         | 350           |
| 8            | S1       | 1637S     | Soft      | ITS2         | 350           |
| 9            | S2       | 1060S     | Soft      | ITS2         | 350           |
| 10           | S3       | 1041S     | Soft      | ITS2         | 350           |
| 11           | S4       | 1651S     | Soft      | ITS2         | 350           |
| 12           | S5       | 1600S     | Soft      | ITS2         | 350           |
| 13           | S6       | 1196S     | Soft      | ITS2         | 350           |
| 14           | SM       | MixS      | Soft      | ITS2         | 350           |
| 15           | H1       | 1637H     | Hard      | cp23S        | 350           |
| 16           | H2       | 1060H     | Hard      | cp23S        | 350           |
| 17           | H3       | 1041H     | Hard      | cp23S        | 350           |
| 18           | H4       | 1651H     | Hard      | cp23S        | 350           |
| 19           | H5       | 1600H     | Hard      | cp23S        | 350           |
| 20           | H6       | 1196H     | Hard      | cp23S        | 350           |
| 21           | HM       | MixH      | Hard      | cp23S        | 350           |
| 22           | S1       | 1637S     | Soft      | cp23S        | 350           |
| 23           | S2       | 1060S     | Soft      | cp23S        | 350           |
| 24           | S3       | 1041S     | Soft      | cp23S        | 350           |
| 25           | S4       | 1651S     | Soft      | cp23S        | 350           |
| 26           | S5       | 1600S     | Soft      | cp23S        | 350           |
| 27           | S6       | 1196S     | Soft      | cp23S        | 350           |
| 28           | SM       | MixS      | Soft      | cp23S        | 350           |
| 29           | H1       | 1637H     | Hard      | 16S          | 400           |
| 30           | H2       | 1060H     | Hard      | 16S          | 400           |
| 31           | H3       | 1041H     | Hard      | 16S          | 400           |
| 32           | H4       | 1651H     | Hard      | 16S          | 400           |
| 33           | H5       | 1600H     | Hard      | 16S          | 400           |
| 34           | H6       | 1196H     | Hard      | 16S          | 400           |
| 35           | HM       | MixH      | Hard      | 16S          | 400           |
| 36           | S1       | 1637S     | Soft      | 16S          | 400           |
| 37           | S2       | 1060S     | Soft      | 16S          | 400           |
| 38           | S3       | 1041S     | Soft      | 16S          | 400           |
| 39           | S4       | 1651S     | Soft      | 16S          | 400           |
| 40           | S5       | 1600S     | Soft      | 16S          | 400           |
| 41           | S6       | 1196S     | Soft      | 16S          | 400           |
| 42           | SM       | MixS      | Soft      | 16S          | 400           |
