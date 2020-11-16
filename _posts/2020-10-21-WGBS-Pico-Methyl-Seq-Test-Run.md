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

Both trials done in 2 days - day 1 ends with the bisulfite conversion step, left in the 4C fridge for less than 20 hours and then started again the next day. This could probably be done in 1 day in the future now that I have done this protocol multiple times. 

### Trial 1: 20201015 and 20201026
DNA input: 1 ng. Dilutions done by taking 2 uL of DNA + (1-Qubit value)x2 10 uM Tris HCl.  

BR DNA Standard 1: 200.79  
BR DNA Standard 2: 22,255.60

| Coral_ID 	| Species               	| Qubit (ng/uL) 	| Gel Pass? 	| DNA for dilution (ul) 	| 10 mM Tris for dilution (ul) 	| Qubit (ng/uL) post PMS 	| TapeStation pass? 	| Notes                                                                          	|
|----------	|-----------------------	|---------------	|-----------	|-----------------------	|------------------------------	|------------------------	|-------------------	|--------------------------------------------------------------------------------	|
| P7       	| Pocillopora meandrina 	| 75.6          	| Not good  	| 2                     	| 149.2                        	| Too low                	| Peaks visible     	| Hawaii - Eva extracted this with HMW kit and sent it in the recent dry shipper 	|
| P3       	| Porites lutea         	| 136.5         	| Not good  	| 2                     	| 271                          	| Too low                	| Peaks visible     	| Hawaii - Eva extracted this with HMW kit and sent it in the recent dry shipper 	|
| P1       	| Porites astreoides    	| 8.27          	| Great     	| 2                     	| 14.54                        	| 2.08                   	| Peaks visible     	| genome coral - Maggie extracted this with HMW kit                              	|

| Date     	| Sample       	| i5 index # 	| i7 index # 	|
|----------	|--------------	|------------	|------------	|
| 20201025 	| P1 - Past    	| 1          	| 1          	|
| 20201025 	| P3 - P lutea 	| 2          	| 2          	|
| 20201025 	| P7 - Poc mea 	| 3          	| 3          	|


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
*The above calculation should be 0.63 uL and 0.99 uL, unclear if that was a written mistake or a mistake made during the protocol. This mix could have been far too diluted for the protocol, leading to less enzymatic activity and smaller output.**

1st Amplification Master Mix (AMM)  
39.38 uL Library Amp Mix (2X) (12.5 uL * 3.15 samples = 39.375)  
3.15 uL Library Amp Primers (10 uM) (1 uL * 3.15 samples = 3.15)  

20201026 Trial 1 [TapeStation Report](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/TapeStation/2020-10-26%20-%2017.00.48%20(1).pdf)

![tape1](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/20201026_P1.png?raw=true)

![tape2](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/20201026_P3.png?raw=true)

![tape3](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/20201026_P7.png?raw=true)


### Trial 2: 20201110 and 20201111  
DNA input: 10 ng. 10 ng/uL calculations done by 100/Qubit value uL DNA for dilution and 10-DNA value for 10 uM Tris HCl volume.

BR DNA Standard 1: 180.28  
BR DNA Standard 2: 19,255.88

| Coral_ID 	| Species               	| Qubit (ng/uL) 	| Gel Pass? 	| DNA needed (uL)                                    	| 10 mM Tris HCl (uL) 	| Qubit (ng/uL) post PMS 	| TapeStation pass? 	| Notes                                             	|
|----------	|-----------------------	|---------------	|-----------	|----------------------------------------------------	|---------------------	|------------------------	|-------------------	|---------------------------------------------------	|
| P3       	| Pocillopora meandrina 	| 54.75         	| Good      	| 1.83                                               	| 8.17                	| 3.81                   	| Peaks visible     	| Maggie extracted HMW from 20201109                	|
| P1       	| Porites astreoides    	| 8.27          	| Good      	| Too low to dilute; just take 1 uL of original tube 	|                     	| Too low                	| Peaks visible     	| genome coral - Maggie extracted this with HMW kit 	|
| 2860     	| Montipora capitata    	| 43.5          	| Good      	| 2.30                                               	| 7.70                	| 2.58                   	| Peaks visible     	| Emma extracted - Holo Int                         	|
| 2878     	| Pocillopora acuta     	| 48.1          	| Fair      	| 2.08                                               	| 7.92                	| 3.81                   	| Peaks visible     	| Emma extracted - Holo Int                         	|

**Index Key**  

| Date     	| Sample       	| i5 index # 	| i7 index # 	|
|----------	|--------------	|------------	|------------	|
| 20201110 	| P1 - P ast   	| 3          	| 3          	|
| 20201110 	| P3 - Poc mea 	| 4          	| 4          	|
| 20201110 	| 2860 Mcap        	| 1          	| 1          	|
| 20201110 	| 2878 Pacuta        	| 2          	| 2          	|

I started my samples at 1 and 2 in case this trial worked and I could start the rest of my samples at 3.

**Mix Calculations**   

Amplification with Prep-Amp Primers  
4 samples + 0.2 (for 5% error) = 4.2

Priming Master Mix (PMM):  
8.4 uL of 5X PrepAmp Buffer (2 uL * 4.2 samples = 8.4)  
4.2 uL 40 uM PrepAmp Primer (1 uL * 4.2 samples = 4.2)

PrepAmp Master Mix (PAMM):  
4.2 uL of 5X PrepAmp Buffer (1 uL * 4.2 samples = 4.2)  
15.75 uL PrepAmp Pre Mix (3.75 uL * 4.2 samples = 15.75)  
1.26 uL PrepAmp Polymerase (0.3 uL * 4.2 = 1.26)

"Diluted" PrepAmp Polymerase mix  
1.26 uL PrepAmp Polymerase (0.3 uL * 4.2 samples = 1.26)  
0.84 uL DNA Elution Buffer (0.2 uL * 4.2 = 0.84)

1st Amplification Master Mix (AMM)  
52.5 uL Library Amp Mix (2X) (12.5 uL * 4.2 samples = 52.5)  
4.2 uL Library Amp Primers (10 uM) (1 uL * 4.2 samples = 4.2)

20201111 Trial 2 [TapeStation Report](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/TapeStation/2020-11-11%20-%2015.08.59.pdf)

![tape1](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/20201111_P1.png?raw=true)

![tape2](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/20201111_P3.png?raw=true)

![tape3](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/20201111_2860.png?raw=true)

![tape4](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/20201111_2878.png?raw=true)

*The concentrations are much higher on the TapeStation than Qubit values. Which one do we trust more? The output of WGBS PMS is only 15 uL max, and I used 3 uL for tapestation and qubit (prepped qubit twice). I'm hesitant to use more to re-qubit unless we have to.*
