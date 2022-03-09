---
layout: post
title: E5 Timepoint 1, 2, 3, and 4 Instantaneous Calcification Sample Processing (Samples Collected in 2020)
date: '2022-03-03'
categories: Processing
tags: titration, instanteous calcification, TA, E5
projects: E5
---

# Processing the E5 January, March, September, and November 2020 Instantaneous Calcification Samples

Original protocol post from D. Becker: [here](https://github.com/daniellembecker/DanielleBecker_Lab_Notebook/blob/master/_posts/2021-02-18-E5-January-March-September-November-Calcification-Samples.md).

Putnam Lab Titration protcol [here](https://github.com/Putnam-Lab/Lab_Management/blob/master/Lab_Resources/Equipment_Protocols/Titrator_Protocols/Titrator_Protocol.md).

Emma, Pierrick, and Kristen are working together to process the remaining E5 samples on the titrator.

General Schedule: *not final, check the weekly schedule section to see how we are working with the Puritz Lab that week.*  

|           	| **Monday** 	| **Tuesday**                    	| **Wednesday**                               	| **Thursday**                   	| **Friday** 	|
|-----------	|-------------	|--------------------------------	|---------------------------------------------	|--------------------------------	|------------	|
| Personnel 	| Pierrick    	| Emma starts (~9 am); Kristen finishes (12:15-3:15p)  	| Kristen starts (~9a-1p); Emma finishes (whenever Run2 is done)               	| Emma starts (~10 am); Kristen finishes (12:15-4:15p)  	| Pierrick   	|
| E5 sample Runs      	| 1           	| 2                              	| 1                                           	| 2                              	| 1          	|
| Notes     	|             	|                                	| Tanks downstairs = Run1; E5 samples = Run2  	|                                	|            	|

Kristen, Pierrick, and Emma will do the physical titrations according to the schedule above. Emma will do all steps in [Titration Data Entry Process](https://github.com/daniellembecker/DanielleBecker_Lab_Notebook/blob/master/_posts/2021-02-18-E5-January-March-September-November-Calcification-Samples.md#titration-data-entry-process) and analyze data after Kristen and Pierrick push to github.

Goal: ~6-7 runs a week (8 samples each x 7 = 56 samples a week). We'll start with this and see how that schedule works for everyone's time and energy. Then adjust from there if needed.

Daily log for notes about each step: [google document link](https://docs.google.com/document/d/18YpBWMWWOQzft9wPQUlEfvq7ivTyKiauDOLJ_f2qbC4/edit). Path is 201906_Post_Award > URI_Titrations > "E5 January, March, September, and November 2020 Instantaneous Calcification Samples Notes".

Contents:  
- [**Issues/Questions to Address**](#Issues)   
- [**Weekly Schedule**](#Week)    
- [**September 2020, 51 samples to complete**](#Sept)   
- [**January 2020, 146 samples to complete**](#Jan)   
- [**November 2020, 145 samples to complete**](#Nov)   
- [**Equipment locations**](#Equip)   
- [**Waste**](#Waste)   

Remaining as of 2022-03-08:  
- September 2020: 27/51 samples  
- January 2020: 146/146 samples  
- November 2020: 145/145 samples

We'll do time points separately and do initials and blanks in the same titration run.  
The #s for samples left to-do are generated from the # of bottles left in the bin for September 2020. This does not account for samples already run so that number will likely be less.

### Folders and file formats for this project

Path on desktop computer: Data > E5_Titrations > E5_2020_Calcification_Samples.

Each day make a new folder with the date YEAR-MONTH-DAY (i.e. 20220303).  

Each CRM and sample run will have their own mass file instead of overriding the previous one.  
Before running the R script, rename these files:
- rename the LabX output file to match this format: 20220308_Run1_PutnamTitrations_PutnamLab (If CRM run, replace Run1 with "CRM")    
- Mass files should reflect this format: Mass_CRM_20220308 (If a sample run, replace CRM with "Run #")  

After running the R script, rename these files:  
- rename the TA Output file to match this format: TA_Output_20220308_Run1_PutnamTitrations_PutnamLab (If CRM run, replace Run1 with "CRM")  

### Notation for sample ID

Match this example sample ID format:   
- Colony-ID_DATE_RUN#   
- ACR-225_20200914_7    
- INITIAL-1_20200915_10  
- BK-1_20200912_2

### CRM Information

Batch 180 Salinity: 33.623  
Batch 180 TA value: 2224.47

## <a name="Issues"></a> **Issues/Questions to Address**

Timepoint 3 - September 2020; 2020-09-12 Run 3: Initial measurements from 2020-09-09 are in 3_initial_TA_samples.csv but no initial measurements for runs after that. If there are 2 data points for "Initial 1" - do we distinguish which one to use? Ariana and I are currently chatting about the best way to go about this.

We are currently copy and pasting into `Timepoint#_TA_Data` in urol timeseries repo. Can we pull values into R and cat the dfs together? I'm nervous for manual entry. Will touch base with Ariana about this in meeting 3/7.

## <a name="Week"></a> **Weekly Schedule**

**Week of 3/7 - 3/11**

|                	| Monday 3/7 	| Tuesday 3/8                                         	| Wednesday 3/9                                                  	| Thursday 3/10                                                                  	| Friday 3/11 	|
|----------------	|------------	|-----------------------------------------------------	|----------------------------------------------------------------	|--------------------------------------------------------------------------------	|-------------	|
| Personnel      	|            	| Emma starts (~9 am); Kristen finishes (12:15-3:15p) 	| Kristen starts (~9a-1p); Emma finishes (whenever Run2 is done) 	| Emma starts (~9 am-12p); Megan ends (12:15p - end)                             	| Amy         	|
| E5 sample runs 	| 0          	| 2                                                   	| 1                                                              	| 1                                                                              	| 0           	|
| Notes          	|            	|                                                     	| Tanks downstairs = Run1; E5 samples = Run2                     	| Emma does pH cal, CRM run, 1 E5 round; Megan (Puritz lab) runs 1-2 sample runs 	| Puritz Lab  	|


## <a name="Sept"></a> **September 2020, 51 samples to complete**

#### 20220303 Kristen and Emma (1 run = 8 samples)

CRM error: -0.11796%

| SampleID                 	| TA         	| Mass   	| Salinity 	|
|--------------------------	|------------	|--------	|----------	|
| JUNK 1                   	| 2535.93082 	| 59.733 	| 35       	|
| INITIAL_1_20200912_RUN_3 	| 2337.25626 	| 60.379 	| 40.34    	|
| INITIAL_2_20200912_RUN_3 	| 2348.79131 	| 60.446 	| 40.41    	|
| ACR_343_20200912_RUN_3   	| 2333.80991 	| 60.081 	| 40.35    	|
| POR_340_20200912_RUN_3   	| 2218.77808 	| 59.626 	| 40.16    	|
| POR_362_20200912_RUN_3   	| 2265.81267 	| 60.031 	| 40.29    	|
| POR_381_20200912_RUN_3   	| 2145.78802 	| 59.934 	| 40.3     	|
| POR_387_20200912_RUN_3   	| 2295.43894 	| 60.478 	| 40.35    	|
| POR_373_20200912_RUN_3   	| 2286.19554 	| 60.173 	| 40.26    	|

*These sample IDs will need to be changed on the laptop next to the titrator. Otherwise each push will override that file changed on my computer.*

#### 20220308 Kristen and Emma (2 runs = 16 samples)

#### 20220309 Kristen and Emma (2 runs = 8 samples for E5; 8 samples for blue tanks)

## <a name="Jan"></a> **January 2020, 146 samples to complete**

## <a name="Nov"></a> **November 2020, 145 samples to complete**

## <a name="Equip"></a> **Equipment locations**

Lab inventory link google sheet: [here](https://docs.google.com/spreadsheets/d/1_0Qe9gYnuqSAA0Lr24fjMHW3b2HDtKML87l29piD6uM/edit#gid=0).

More 10 mL serological pipettes live on BS11.

BS10: titrator supplies, buffers, pH    
BS11: ziplock bags and plasftic containers, 10 mL serological pipette tips

Junk seawater can be taken from a blue tank downstairs in the aquarium room.

The serological pipette holder lives in the third drawer down on the same bench as the waste (just the left side if you are looking at the bench).

## <a name="Waste"></a> **Waste**

*See titration protocol for full waste details.*

Serological pipette tips are broken in half and placed in the solids bin. Kim wipes are also placed in this bin.  
Samples post-run are placed in the liquids container.  
