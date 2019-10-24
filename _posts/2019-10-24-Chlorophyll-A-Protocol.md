---
layout: post
title: Chlorophyll-A Protocol
date: '2019-10-24'
categories: Protocols
tags: chlorophylla, physiology
projects: Putnam Lab
---

# Putnam Lab Chlorophyll-A Concentration Protocol

Goal: To determine the concentration of Chlorophyll-A in adult coral tissue homogenate samples.  

Protocol written for *Montipora capitata* and *Pocillopora acuta* adult coral samples from the Holobiont Integration 2018 project. Modified from [Wall et al 2018](https://link.springer.com/content/pdf/10.1007%2Fs00227-018-3317-z.pdf).  

**Sample Preparation**
1. Thaw homogenate aliquot labeled with the coral ID and "chlorophyll-a".  
2. Vortex to re-suspend the symbiont cell pellet.  
3. Label a new microcentrifuge tube with the coral ID, total protein assay date, and "Chl-A". *If aliquot tube already contains exactly 500 μL of tissue sample, no need to make a new microcentrifuge tube.*  
4. Pipette 500 μL of the adult coral tissue sample into the new labeled 1.5 mL microcentrifuge tube.

**Measuring Chlorophyll-A Concentration**  
1. Centrifuge the 500 μL aliquot of adult homogenate at 13,000 rpm for 3 minutes to separate the host and Symbiodiniaceae cells.  
2. Remove the supernatant and discard.  
3. Add 1 mL of 100% acetone to the 1.5 mL microcentrifuge tube.  
4. Place in the dark at 4&deg;C for 36 hours.  
5. Measure this extracted chlorophyll-a pigment on the spectrophotometer at 630, 663, and 750 nm on a 96-well quartz plate.

**Calculating Chlorophyll-A Concentration**  

Chlorophyll-A concentrations are calculated from the equations in [Jeffrey and Humphrey 1975](https://reader.elsevier.com/reader/sd/pii/S0015379617307783?token=0937035D38C07F29ADF00F1F2A21F20F221219B1CC11A444A4F84D16B98EC3A6AD941D191BA2135A68C98BA62A0B69FE).  
R code for this analysis can be found at [K. Wong's Github](https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_kevinhwong1_Thermal-5FTransplant-5F2017-2D2018_blob_master_scripts_ChlorophyllA.R&d=DwMFaQ&c=dWz0sRZOjEnYSN4E4J0dug&r=hzX7Pj5Cn4ufjLQbICvWcOqlrencJyNZMIrmCT00z_o&m=Hpn_SeiBeA7gle40eXLMx3-j3YSrgRHCsOsZ3E5cSGA&s=q5PUrza32gdiEvIa0nI8pMvjeaMw9LFkIDujTh_tGPw&e=).
