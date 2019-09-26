---
layout: post
title: TapeStation Protocol
date: '2019-05-31'
categories: Protocols
tags: TapeStation, RNA
projects: Putnam Lab
---

# TapeStation Protocol

Based on Putnam Lab TapeStation Protocol written by M. Schedl: [TapeStation](https://meschedl.github.io/MESPutnam_Open_Lab_Notebook/RNA-TapeStation-Protocol/)

Agilent [Tape Station 4200](https://www.agilent.com/en/promotions/agilent-4200-tapestation-system?gclid=EAIaIQobChMI_tykoMrw4AIVFI7ICh2S3AZFEAAYASAAEgIqEPD_BwE&gclsrc=aw.ds)  
[Link to Agilent 4200 TapeStation System](https://www.agilent.com/cs/library/technicaloverviews/public/5991-6616EN.pdf)
TapeStation Ladder: [Agilent RNA screentape ladder](https://www.agilent.com/en/product/automated-electrophoresis/tapestation-systems/tapestation-rna-screentape-reagents/rna-screentape-analysis-228268)  
TapeStation buffer and tape: [Agilent RNA assays](https://www.agilent.com/cs/library/datasheets/public/5991-7785EN_4200_TapeStation.pdf)  

Lab Armor chill bucket and beads: [The Lab Depot](https://www.labdepotinc.com/articles/lab-armor-chill-bucket.html)

### Setup

1. Take RNA Tape and buffer out of fridge 30 minutes beforehand to allow it to equilibrate to room temperature  
2. Take bead bucket out of the -20&deg;C and put in the RNA ladder (kept in -20&deg;C) and your RNA sample aliquot tubes (kept in -80&deg;C)  
3. Turn on TapeStation, laptop, and Thermocycler

### Steps

4. Take out appropriate number of Tape Station strip tubes and tube caps (located F drawer 11)  
5. Vortex and spin down buffer, ladder, and samples  
6. Add 5µl RNA buffer each to the number of tubes needed + 1. The first tube is always the ladder  
7. Add 1µl RNA ladder to the first tube  
8. Add 1µl of each sample to each sample tube  
9. Put on tube caps and vortex for 1 minute in IKA vortexer  
10. Spin down tubes  
11. Turn on Thermocyler and log into JONP. Put tube strip(s) in Thermocyler and balance for the lid. Run program **rna denature**  
12. Spin down tubes  
13. Open TapeStation Controller program and make sure connection to Eve is good  
14. Put in tape and check expiration date  
15. Take off tube caps and place tubes in Eve with the ladder in position A1  
16. Name tube positions in TapeStation Controller program  
17. Start and relax!  

### After

18. The TapeStation Analysis software should open by itself  
19. View the traces with the Electropherogram option  
20. File -> Create Report  

**Thermocyler "rna denature" program:**  
1. 3 minutes at 72 &deg;C  
2. 2 minutes at 4 &deg;C  
3. Hold at 4 &deg;C
