---
layout: post
title: WGBS Pico Methyl Seq Test Run
date: '2020-10-21'
categories: Processing
tags: DNA, methylation, WGBS, Pico
projects: Holobiont Integration
---

# WGBS Pico Methylation Protocol Test Run

[Maggie protocol](https://meschedl.github.io/MESPutnam_Open_Lab_Notebook/WGBS-PMS-protocol/)  

[Google spreadsheet with this test run info](https://docs.google.com/spreadsheets/d/1lWT0KRO5x9RFflYMF9Jnk5lsGCo0k3_A98ZsyKd4kks/edit#gid=978992575)

Outline of lab plan for Emma and Kevin-

**Day 1:**  
Gel and qubit at the same time as dilutions to avoid an extra freeze thaw step.  
1. Make gel and let harden while doing the following steps  
2. Qubit 3 samples for ng_uL value  
3. Load the gel with 3 samples and let run while doing the following steps. This way the original DNA tubes won't be sitting on ice the whole time gel runs, they can be back in the freezer).  

Time ~20-30 minutes

| Coral_ID 	| Species               	| Qubit (ng/uL) 	| Gel Pass? 	| DNA for dilution (ul) 	| 10 mM Tris for dilution (ul) 	| Gel Image Link 	| Notes                                                                          	|
|----------	|-----------------------	|---------------	|-----------	|-----------------------	|------------------------------	|----------------	|--------------------------------------------------------------------------------	|
|          	| Pocillopora meandrina 	|               	|           	| 2                     	| =(Qubit-1)*2                 	|                	| Hawaii - Eva extracted this with HMW kit and sent it in the recent dry shipper 	|
|          	| Porites lutea         	|               	|           	| 2                     	| =(Qubit-1)*2                 	|                	| Hawaii - Eva extracted this with HMW kit and sent it in the recent dry shipper 	|
|          	| Porites astreoides    	|               	|           	| 2                     	| =(Qubit-1)*2                 	|                	| genome coral - Maggie extracted this with HMW kit                              	|

4. Dilutions to 1 ng/uL (see equation in the 10mM Tris column above). [Maggie dilutions video](https://www.youtube.com/watch?v=byipduTsFmc&list=PLI8mZMNHcIVq9DFCOPksLhcch8UbJj4Pq&index=1)

Time ~5 minutes

5. Bisulfite conversion with PCR. [Maggie Bisulfite conversion video](https://www.youtube.com/watch?v=4ar8d5NeSks&list=PLI8mZMNHcIVq9DFCOPksLhcch8UbJj4Pq&index=2)  

Time ~ 5-10 minutes prep; PCR run ~ 62 minutes

**Day 2**

Times are probably overestimated conservatively, there are only 3 samples in the test so it shouldn't take too long to pipette into 3 tubes.

6. Post Conversion column clean-up ~40 minutes.  
7. Amplification with PreAmp Primers. Prep ~10 minutes; thermocycler programs ~20-25 minutes.

Amplification with Prep-Amp Primers
3 samples + 0.15 (for 5% error) = 3.15

Priming Master Mix (PMM):
6.3 uL of 5X PrepAmp Buffer (2 uL * 3.15 samples = 6.3)
3.15 uL 40 uM PrepAmp Primer (1 uL * 3.15 samples = 3.15)

PrepAmp Master Mix (PAMM):
3.15 uL of 5X PrepAmp Buffer (1 uL * 3.15 samples = 3.15)
11.81 uL PrepAmp Pre Mix (3.75 uL * 3.15 samples = 11.81)
0.95 uL PrepAmp Polymerase (0.3 uL * 3.15 = 0.95)

"Diluted" PrepAmp Polymerase mix
0.9 uL PrepAmp Polymerase (0.3 uL * 3 samples = 0.9)
6.3 uL DNA Elution Buffer (0.2 uL * 3.15 = 6.3)

8. DNA Clean and Concentrator Cleanup (DCC) ~15 minutes.  
9. 1st Amplification Prep ~10 minutes; PCR 35 minutes.  
10. DNA Clean and Concentrator Cleanup (DCC) ~20 minutes.  
11. 2nd Amplification Prep Prep ~10 minutes; PCR ~50 minutes?  

Ask Maggie where the primer index prep spreadsheet is?  

12. 1X Bead Clean-Up ~45 minutes.

**Day 3**
1. BR DNA Qubit Assay  
2. D5000 TapeStation
