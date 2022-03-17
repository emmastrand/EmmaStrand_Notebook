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
- Based on week 1, we can probably do 3 runs tuesday - thursday depending on our sharing schedule. Mondays we can do 3-4 runs (4 if starting at 8 am go through 5 pm).  

Daily log for notes about each step: [google document link](https://docs.google.com/document/d/18YpBWMWWOQzft9wPQUlEfvq7ivTyKiauDOLJ_f2qbC4/edit). Path is 201906_Post_Award > URI_Titrations > "E5 January, March, September, and November 2020 Instantaneous Calcification Samples Notes".

Contents:  
- [**Issues/Questions to Address**](#Issues)   
- [**Weekly Schedule**](#Week)    
- [**September 2020, 51 samples to complete**](#Sept)   
- [**January 2020, 146 samples to complete**](#Jan)   
- [**November 2020, 145 samples to complete**](#Nov)   
- [**Equipment locations**](#Equip)   
- [**Waste**](#Waste)   

Remaining as of 2022-03-17 end of day:  
- September 2020: Done (see note in issues RE initials and blanks)  
- January 2020: 66/146 samples. Projected to be done with January time point by March 23, 2022.   
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
- Initial1_20200915_10  
- BK-1_20200912_2  
- JUNK 1
- CRM 1  

### CRM Information

March 3, 2022 - current:    
- Batch 180 Salinity: 33.623  
- Batch 180 TA value: 2224.47

## <a name="Issues"></a> **Issues/Questions to Address**

### Open Issues

*Issue*: Timepoint 3 - September 2020; 2020-09-12 Run 3: Initial measurements from 2020-09-09 are in 3_initial_TA_samples.csv but no initial measurements for runs after that. If there are 2 data points for "Initial 1" - do we distinguish which one to use?  
*Resolution*: Ariana and Emma are currently chatting about the best way to go about this.

*Issue*: We are currently copy and pasting into `Timepoint#_TA_Data` in urol timeseries repo.  
*Resolution*: Emma is ~halfway through creating this script for TP3: stopped at the initial measurements issue above.  

*Issue*: 50 mL falcon tubes for some samples for January 2020 and November 2020 time points instead of larger bottles.  
*Resolution*: Hollie says it doesn't matter we can run these at whatever mass we can get - run this by Ariana and Danielle in meeting. Will add a column to keep track of which samples were in a 50 mL and we can see if there is a batch effect. For these samples, we will need to calculate salinity prior to measuring mass and putting samples in rondolino.  

*Issue*: 20200314 - ACR 246 and Initial 2 may be mixed up in the rondolino (mass and salinities are correct, just position in titrator). Almost positive I fixed it but double check TA values at the end to make sure these make sense.  
*Resolution*: Emma will need to do this after run data has been pushed to github.

*Issue*: Do we use chamber temperature, salinity, and pH? Check with Hollie and Nyssa.     
*Resolution*: Ariana and Emma are currently chatting about the best way to go about this. Look at calc as a function of temp for a sanity check?

*Issue*: TP1 - January surface area is 30 for every chamber.  
*Resolution*: pull in real surface area for this.

*Issue*: TA protocol is missing details, links, etc.  
*Resolution*: Emma edit this as we process samples.

*Issue*: Salinity readings at CSUN vs URI (36 range vs 40 psu range..). Test batch effect. Calibrated with 50 mS/cm solution and then the probe was reading at ~55 when measuring the same solution post-calibration. Calibrated to two point 12.9 mS/cm and 1413 uS/cm and the probe was reading 36-37 psu range. Closer to what was run at CSUN.  
*Resolution*: We might need to re-measure psu of previous samples done at URI.

### Closed Issues

*Issue*: All September bottles have been processed but there are several blank and initials that we do not have accounted for. Cross reference again with those bottles done at CSUN and in-field notes.  
*Resolution*: Ariana and Emma are currently chatting about the best way to go about this. Some bottles spilled in transport but we don't think these are them. Turns out my code wasn't pulling all the California bottles done. The only missing samples from September are and Initial1_20200909_1 and POR-240_20200913_5. There are 2 Initial1_20200912_3 bottles/TA values (one bottle at URI but two TA values - one done at URI and one done in CA).

*Issue*: Sample notation was not consistent for the first couple of rounds.  
*Resolution*: Changed initial notation format on 0303 in the E5 timeseries folder and changed to all correct format on the titrator computer.

*Issue*: volumes missing from delta TA sheet.  
*Resolution*: https://drive.google.com/drive/u/0/folders/1Z7Gxiqo8QbnP4AMpgxmgq0wDNJ-qWmBW. extract volumes here and put in delta TA.

## <a name="Missing"></a> **Missing and Duplicate Data**

**TP1 January 2020**

**TP2 March 2020**

**TP3 September 2020**

- The only missing samples from September are and Initial1_20200909_1 and POR-240_20200913_5.  
- There are 2 Initial1_20200912_3 bottles/TA values (one bottle at URI but two TA values - one done at URI and one done in CA).  
- Initial environmental measurements (temp, pH, salinity) missing run 3 and on.  

**TP4 November 2020**

## <a name="Week"></a> **Weekly Schedule**

Emma will sign the Putnam lab up for the appropriate time slots at the beginning of the week on the [PPP team up calendar](https://teamup.com/c/h2sumb/ppp-and-thornber-labs).

**Week of 3/7 - 3/11**

|                	| Monday 3/7 	| Tuesday 3/8                                         	| Wednesday 3/9                                                  	| Thursday 3/10                                                                  	| Friday 3/11 	|
|----------------	|------------	|-----------------------------------------------------	|----------------------------------------------------------------	|--------------------------------------------------------------------------------	|-------------	|
| Personnel      	|            	| Emma starts (~9 am); Kristen finishes (12:15-3:15p) 	| Kristen starts (~9a-1p); Emma finishes (whenever Run2 is done) 	| Emma starts (~9 am-12p); Megan ends (12:15p - end)                             	| Amy         	|
| E5 sample runs 	| 0          	| 2                                                   	| 2                                                              	| 2                                                                              	| 0           	|
| Notes          	|            	|                                                     	| 2 E5 runs; 1 blue tank run                                     	| Emma does pH cal, CRM run, 1 E5 round; Megan (Puritz lab) runs 1-2 sample runs 	| Puritz Lab  	|

| # of runs 	| Samples done this week 	|
|-----------	|------------------------	|
| 6         	| 48                     	|

**Week of 3/14 - 3/18**

|                	| Monday 3/14                            	| Tuesday 3/15 	| Wednesday 3/16 	| Tuesday 3/1  	| Friday 3/18      	|
|----------------	|----------------------------------------	|--------------	|----------------	|--------------	|------------------	|
| Personnel      	| Emma and Pierrick together all day     	| Puritz Lab   	| Power out - no one   	| Emma and Kristen 	| Pierrick all day 	|
| E5 sample runs 	| 3                                      	| 0            	| 0              	| 4            	| 2                	|
| Notes          	| Kristen out M-W for spring break 	|              	|                	|              	|                  	|

*Projected:*

| # of runs 	| Samples done this week 	|
|-----------	|------------------------	|
| 9        	| 72                     	|


## <a name="Sept"></a> **September 2020, 51 samples to complete**

#### 20220303 Kristen and Emma (1 run = 8 samples)

CRM error: -0.11796%

| SampleID                 	| TA         	| Mass   	| Salinity 	|
|--------------------------	|------------	|--------	|----------	|
| JUNK 1                   	| 2535.93082 	| 59.733 	| 35       	|
| INITIAL1_20200912_3 	| 2337.25626 	| 60.379 	| 40.34    	|
| INITIAL2_20200912_3 	| 2348.79131 	| 60.446 	| 40.41    	|
| ACR-343_20200912_3   	| 2333.80991 	| 60.081 	| 40.35    	|
| POR-340_20200912_3   	| 2218.77808 	| 59.626 	| 40.16    	|
| POR-362_20200912_3   	| 2265.81267 	| 60.031 	| 40.29    	|
| POR-381_20200912_3   	| 2145.78802 	| 59.934 	| 40.3     	|
| POR-387_20200912_3   	| 2295.43894 	| 60.478 	| 40.35    	|
| POR-373_20200912_3   	| 2286.19554 	| 60.173 	| 40.26    	|

#### 20220308 Kristen and Emma (2 runs = 16 samples)

CRM error: -0.16%

Run 1:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2538.00404 	| 59.725 	| 35       	|
| POR-338_20200909_2  	| 2286.2164  	| 60.178 	| 40.61    	|
| Initial1_20200909_2 	| 2331.52126 	| 60.177 	| 40.34    	|
| POR-383_20200909_2  	| 2258.89333 	| 60.472 	| 40.18    	|
| POR-354_20200912_3  	| 2267.02905 	| 59.979 	| 39.94    	|
| POR-353_20200909_1  	| 2303.53562 	| 59.46  	| 39.94    	|
| POR-341_20200909_2  	| 2221.63388 	| 59.672 	| 40.38    	|
| BK-2_20200909_2     	| 2314.59019 	| 59.823 	| 39.87    	|
| POC-391_20200912_3  	| 2319.23502 	| 60.119 	| 39.73    	|

Run 2:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2537.4245  	| 60.207 	| 35       	|
| Initial2_20200909_2 	| 2349.06732 	| 59.741 	| 40.49    	|
| POC-359_20200909_1  	| 2335.40506 	| 59.578 	| 40.52    	|
| POC-369_20200909_2  	| 2286.28668 	| 60.163 	| 40.5     	|
| POC-378_20200909_2  	| 2264.71636 	| 59.926 	| 40.63    	|
| POC-395_20200909_2  	| 2315.40556 	| 59.611 	| 40.63    	|
| POR-349_20200909_2  	| 2259.5831  	| 60.468 	| 40.66    	|
| POR-355_20200909_2  	| 2269.82513 	| 59.525 	| 40.59    	|
| POR-384_20200909_2  	| 2277.95517 	| 60.238 	| 40.7     	|


#### 20220309 Kristen and Emma (2 runs = 16 samples; 3 runs total for the day (1 blue tank run))

First E5 sample run was for September 2020 and the 2nd run was for January 2020 time point.

Run 1:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2486.92729 	| 60.388 	| 35       	|
| BK1_20200909_1      	| 2344.78601 	| 60.492 	| 40.7     	|
| Initial2_20200909_1 	| 2346.26208 	| 60.095 	| 40.71    	|
| POC-358_20200909_1  	| 2300.88123 	| 60.436 	| 40.74    	|
| POC-372_20200909_1  	| 2299.23341 	| 60.256 	| 40.77    	|
| POC-386_20200909_1  	| 2266.33998 	| 60.454 	| 40.84    	|
| POR-357_20200909_1  	| 2293.5182  	| 59.981 	| 40.75    	|
| POC-365_20200909_1  	| 2228.51312 	| 60.359 	| 40.84    	|
| POC-367_20200909_1  	| 2246.40924 	| 60.109 	| 40.98    	|

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/E5%20Calcification%20Processing/Titrations-September2020-processing.jpg?raw=true)

## <a name="Jan"></a> **January 2020, 146 samples to complete**

#### 20220309 Kristen and Emma (2 runs = 16 samples; 3 runs total for the day (1 blue tank run))

First E5 sample run was for September 2020 and the 2nd run was for January 2020 time point.

Run 2:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2483.8335  	| 60.305 	| 35       	|
| INITIAL2_20200107_8 	| 2360.47591 	| 59.997 	| 40.96    	|
| POR-381_20200107_8  	| 2306.57443 	| 59.691 	| 40.99    	|
| ACR-364_20200107_8  	| 2341.16235 	| 60.528 	| 40.86    	|
| POC-373_20200107_8  	| 2274.75422 	| 60.144 	| 40.72    	|
| POC-394_20200107_8  	| 2349.66741 	| 60.258 	| 40.3     	|
| ACR-363_20200107_8  	| 2326.21349 	| 59.786 	| 40.96    	|
| POR-357_20200107_8  	| 2320.55603 	| 60.547 	| 40.81    	|
| INITIAL1_20200107_8 	| 2354.24313 	| 59.783 	| 40.59    	|

#### 20220310 Emma (2 runs = 16 samples)

Run 1:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2489.40784 	| 58.13  	| 35       	|
| POC-391_20200107_8  	| 2323.87908 	| 59.986 	| 41.93    	|
| POC-254_20200104_1  	| 2336.21906 	| 60.298 	| 41.14    	|
| Initial1_20200104_1 	| 2355.49784 	| 59.705 	| 41.32    	|
| BK-8_20200107_8     	| 2366.69776 	| 60.216 	| 41.8     	|
| Initial2_20200104_1 	| 2350.25702 	| 60.648 	| 41.76    	|
| Initial2_20200108_9 	| 2343.9948  	| 59.581 	| 41.58    	|
| Initial1_20200108_9 	| 2308.83694 	| 59.802 	| 41.48    	|
| ACR-368_20200107_8  	| 2330.2108  	| 60.478 	| 41.49    	|

Run 2:

| SampleID           	| TA         	| Mass   	| Salinity 	|
|--------------------	|------------	|--------	|----------	|
| JUNK 1             	| 2484.84902 	| 59.981 	| 35       	|
| ACR-267_20200104_2 	| 2315.30616 	| 59.511 	| 41.47    	|
| ACR-228_20200104_2 	| 2345.61169 	| 60.255 	| 41.27    	|
| POC-219_20200102_1 	| 2321.50614 	| 60.75  	| 41.38    	|
| POR-214_20200104_1 	| 2340.83917 	| 59.614 	| 40.93    	|
| ACR-256_20200104_2 	| 2308.17129 	| 59.637 	| 41.42    	|
| POC-239_20200104_1 	| 2332.69129 	| 60.495 	| 40.93    	|
| POR-242_20200104_1 	| 2305.38159 	| 59.97  	| 40.31    	|
| POR-262_20200104_1 	| 2204.22422 	| 60.699 	| 40.48    	|

#### 20200314 Emma and Pierrick (3 runs = 24 samples)

-0.13% CRM error

Run 1:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2275.1106  	| 59.205 	| 35       	|
| Initial2_20200105_3 	| 2286.70311 	| 59.923 	| 41.15    	|
| BK-3_20200105_3     	| 2355.50141 	| 60.611 	| 42.33    	|
| POC-238_20200105_3  	| 2333.09919 	| 60.404 	| 40.61    	|
| ACR-234_20200105_3  	| 2272.03283 	| 59.905 	| 40.82    	|
| Initial1_20200104_2 	| 2334.63197 	| 59.795 	| 40.12    	|
| ACR-229_20200105_3  	| 2257.26957 	| 59.706 	| 41.24    	|
| POC-255_20200104_2  	| 2292.36053 	| 59.436 	| 38.42    	|
| POC-201_20200104_2  	| 2333.90785 	| 59.729 	| 41.52    	|

Run 2:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2274.50372 	| 60.696 	| 35       	|
| POC-205_20200105_4  	| 2338.22994 	| 59.888 	| 41.54    	|
| ACR-246_20200105_4  	| 2265.14352 	| 60.031 	| 41.17    	|
| POC-222_20200106_5  	| 2319.27203 	| 60.956 	| 41.33    	|
| Initial2_20200105_4 	| 2314.01441 	| 59.993 	| 41.62    	|
| Initial1_20200105_4 	| 2356.00739 	| 59.188 	| 41.53    	|
| POC-200_20200105_3  	| 2332.13855 	| 60.718 	| 41.42    	|
| POC-371_20200106_6  	| 2329.36386 	| 60.349 	| 41.2     	|
| POR-209_20200105_3  	| 2259.74708 	| 60.426 	| 40.63    	|

Run 3:

| SampleID           	| TA         	| Mass   	| Salinity 	|
|--------------------	|------------	|--------	|----------	|
| JUNK 1             	| 2269.71589 	| 59.584 	| 35       	|
| POC-378_20200107_7 	| 2300.71112 	| 60.28  	| 41.55    	|
| POR-383_20200107_7 	| 2287.35238 	| 60.604 	| 41.3     	|
| POC-358_20200107_7 	| 2320.07917 	| 60.561 	| 41.55    	|
| ACR-393_20200106_6 	| 2333.50884 	| 60.059 	| 41.41    	|
| ACR-379_20200107_7 	| 2330.53561 	| 59.726 	| 41.62    	|
| POR-260_20200106_5 	| 2176.26568 	| 60.658 	| 41.55    	|
| POC-395_20200106_6 	| 2308.54744 	| 59.312 	| 41.63    	|
| BK-4_20200105_4    	| 2354.1675  	| 59.679 	| 41.82    	|

#### 20200317 Emma and Kristen (4 runs)

-0.06% error for CRMs

Run 1:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2109.01085 	| 58.53  	| 35       	|
| Initial2_20200104_2 	| 2323.45155 	| 61.219 	| 37.31    	|
| POR-221_20200104_1  	| 2279.88571 	| 60.32  	| 36.8     	|
| POR-236_20200104_2  	| 2304.69755 	| 59.684 	| 36.82    	|
| POR-235_20200104_2  	| 2330.78335 	| 60.356 	| 37.65    	|
| ACR-247_20200104_1  	| 2331.74976 	| 61.125 	| 37.4     	|
| BK-1_20200104_1     	| 2356.03458 	| 60.851 	| 37.64    	|
| ACR-244_20200104_2  	| 2312.64306 	| 59.306 	| 37.53    	|
| ACR-243_20200104_1  	| 2313.96408 	| 60.283 	| 37.83    	|

Run 2:

| SampleID           	| TA         	| Mass   	| Salinity 	|
|--------------------	|------------	|--------	|----------	|
| JUNK 1             	| 2110.499   	| 60.101 	| 35       	|
| BK-6_20200106_6    	| 2340.47914 	| 60.051 	| 37.87    	|
| POC-217_20200105_3 	| 2328.82375 	| 60.027 	| 37.89    	|
| ACR-225_20200106_5 	| 2295.83706 	| 59.846 	| 37.9     	|
| ACR-231_20200105_4 	| 2302.29988 	| 60.24  	| 37.97    	|
| ACR-237_20200106_5 	| 2301.59754 	| 60.308 	| 37.95    	|
| ACR-350_20200106_6 	| 2324.14255 	| 59.888 	| 37.91    	|
| POR-240_20200105_4 	| 2320.5666  	| 60.421 	| 37.97    	|
| POR-353_20200106_6 	| 2248.87862 	| 59.829 	| 37.96    	|

Run 3:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2108.20792 	| 60.346 	| 35       	|
| Initial1_20200106_6 	| 2342.93012 	| 60.118 	| 37.87    	|
| Initial1_20200107_7 	| 2359.76202 	| 60.018 	| 37.89    	|
| Initial2_20200106_6 	| 2328.58517 	| 59.684 	| 37.91    	|
| Initial2_20200107_7 	| 2358.01268 	| 60.039 	| 37.94    	|
| POR-340_20200107_7  	| 2298.74556 	| 59.68  	| 37.98    	|
| POR-355_20200106_6  	| 2292.79806 	| 60.093 	| 37.96    	|
| POR-384_20200107_7  	| 2246.51929 	| 60.055 	| 37.96    	|
| ACR-343_20200107_7  	| 2309.90034 	| 60.242 	| 38       	|

Run 4:

| SampleID             	| TA         	| Mass   	| Salinity 	|
|----------------------	|------------	|--------	|----------	|
| JUNK 1               	| 2106.20673 	| 60.064 	| 35       	|
| Initial1_20200106_5 	| 2289.58405 	| 59.751 	| 37.55    	|
| BK-7_20200107_7      	| 2356.63365 	| 59.634 	| 37.54    	|
| POC-369_20200107_7   	| 2322.27535 	| 60.072 	| 37.56    	|
| POC-377_20200106_6   	| 2280.25736 	| 59.803 	| 37.65    	|
| ACR-265_20200105_4   	| 2328.93355 	| 60.273 	| 37.7     	|
| ACR-345_20200107_7   	| 2329.65971 	| 60.455 	| 37.89    	|
| POR-224_20200105_4   	| 2320.6102  	| 60.135 	| 37.93    	|
| POR-362_20200106_6   	| 2274.03636 	| 60.256 	| 37.94    	|

## <a name="Nov"></a> **November 2020, 145 samples to complete**

## <a name="Equip"></a> **Equipment locations**

Lab inventory link google sheet: [here](https://docs.google.com/spreadsheets/d/1_0Qe9gYnuqSAA0Lr24fjMHW3b2HDtKML87l29piD6uM/edit#gid=0).

More 10 mL serological pipettes live on BS11.

BS10: titrator supplies, buffers, pH    
BS11: ziplock bags and plastic containers, 10 mL serological pipette tips

Junk seawater can be taken from a blue tank downstairs in the aquarium room.

The serological pipette holder lives in the third drawer down on the same bench as the waste (just the left side if you are looking at the bench).

## <a name="Waste"></a> **Waste**

*See titration protocol for full waste details.*

Serological pipette tips are broken in half and placed in the solids bin. Kim wipes are also placed in this bin.  
Samples post-run are placed in the liquids container.  
