---
layout: post
title: WGBS Pico Methyl Seq Test Run
date: '2020-10-21'
categories: Processing
tags: DNA, methylation, WGBS, Pico
projects: Holobiont Integration
---

# WGBS Pico Methylation Protocol Trials

[Putnam Lab WGBS Protocol](https://meschedl.github.io/MESPutnam_Open_Lab_Notebook/WGBS-PMS-protocol/)  

[Google spreadsheet with all WGBS raw data from E.Strand](https://docs.google.com/spreadsheets/d/1lWT0KRO5x9RFflYMF9Jnk5lsGCo0k3_A98ZsyKd4kks/edit#gid=978992575)

As 20201112, two test runs have been done for WGBS PMS protocol to optimize sample input for five species of coral: *P. lutea, M. capitata, P. acuta, P. meandrina, P. asterodies*.  

**20201015 and 20201026**  
DNA input: 1 ng

| Coral_ID 	| Species               	| Qubit (ng/uL) 	| Gel Pass? 	| DNA for dilution (ul) 	| 10 mM Tris for dilution (ul) 	| Qubit (ng/uL) post PMS 	| TapeStation pass? 	| Notes                                                                          	|
|----------	|-----------------------	|---------------	|-----------	|-----------------------	|------------------------------	|------------------------	|-------------------	|--------------------------------------------------------------------------------	|
| P7       	| Pocillopora meandrina 	| 75.6          	| Not good  	| 2                     	| 149.2                        	| Too low                	| Peaks visible     	| Hawaii - Eva extracted this with HMW kit and sent it in the recent dry shipper 	|
| P3       	| Porites lutea         	| 136.5         	| Not good  	| 2                     	| 271                          	| Too low                	| Peaks visible     	| Hawaii - Eva extracted this with HMW kit and sent it in the recent dry shipper 	|
| P1       	| Porites astreoides    	| 8.27          	| Great     	| 2                     	| 14.54                        	| 2.08                   	| Peaks visible     	| genome coral - Maggie extracted this with HMW kit                              	|

Calculations for mixes:  

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

1st Amplification Master Mix (AMM)
39.38 uL Library Amp Mix (2X) (12.5 uL * 3.15 samples = 39.375)
3.15 uL Library Amp Primers (10 uM) (1 uL * 3.15 samples = 3.15)
