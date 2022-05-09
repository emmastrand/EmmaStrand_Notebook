---
layout: post
title: E5 Timepoint 1, 2, 3, and 4 Instantaneous Calcification Sample Processing (Samples Collected in 2020)
date: '2022-03-03'
categories: Processing
tags: titration, instanteous calcification, TA, E5
projects: E5
---

# Processing the E5 January, March, September, and November 2020 Instantaneous Calcification Samples

Original E5 processing post from D. Becker and March sample processing included [here](https://github.com/daniellembecker/DanielleBecker_Lab_Notebook/blob/master/_posts/2021-02-18-E5-January-March-September-November-Calcification-Samples.md).

Putnam Lab Titration protocol [here](https://github.com/Putnam-Lab/Lab_Management/blob/master/Lab_Resources/Equipment_Protocols/Titrator_Protocols/Titrator_Protocol.md).

Kristen, Pierrick, and Emma will do the physical titrations according to the schedule above. Emma will do all steps in [Titration Data Entry Process](https://github.com/daniellembecker/DanielleBecker_Lab_Notebook/blob/master/_posts/2021-02-18-E5-January-March-September-November-Calcification-Samples.md#titration-data-entry-process) and analyze data after Kristen and Pierrick push to github.

The average # of runs per day was between 3-4 if the CRM and ph calibration were started first thing in the morning. Having multiple people to process was helpful to run a large # of runs per day (i.e. person 1 starts the run and person 2 switches the run over).

Daily log for notes about each step: [google document link](https://docs.google.com/document/d/18YpBWMWWOQzft9wPQUlEfvq7ivTyKiauDOLJ_f2qbC4/edit). Path is 201906_Post_Award > URI_Titrations > "E5 January, March, September, and November 2020 Instantaneous Calcification Samples Notes".

Contents:  
- [**Issues/Questions to Address**](#Issues)   
- [**Weekly Schedule**](#Week)    
- [**September 2020, 51 samples to complete**](#Sept)   
- [**January 2020, 146 samples to complete**](#Jan)   
- [**November 2020, 145 samples to complete**](#Nov)   
- [**Equipment locations**](#Equip)   
- [**Waste**](#Waste)   

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

### Acid information

March 3, 2022 - current: Batch A22

Switched bottle: 20220324 (From Batch A22 to new Batch A22 bottle no. 54)

### Salinity for 50 mL falcon tubes

Measure the salinity of the 50 mL falcon tubes prior to pouring the sample out into the titration cup. Thoroughly wipe the probe with a kim wipe in between samples and DI water so we don't introduce any new liquid into the sample. Pour the entire sample into the titration cup and place the used 50 mL falcon in the same bin we are putting the processed brown bottle samples (in the walk in 4C cold room).

On the sample sheet, please mark down if the sample came from a 50 mL tube in the last column (mark yes or no).

### Room temperature samples

Before starting the pH calibration, take samples out of the fridge so that they come down to room temperature by the time the run starts. We want to be measuring salinity and titration runs at room temperature.

## <a name="Issues"></a> **Issues/Questions to Address**

### Open Issues

*Issue*: Salinity readings at CSUN vs URI (36 range vs 40 psu range..). Test batch effect. Calibrated with 50 mS/cm solution and then the probe was reading at ~55 when measuring the same solution post-calibration. Calibrated to two point 12.9 mS/cm and 1413 uS/cm and the probe was reading 36-37 psu range. Closer to what was run at CSUN.  
*Resolution*: We got our salinity values down to ~38 when re-measuring but even at room temperature these are still our average values. I think this has to do with our calibration solution or our probe.. Samples from January TP1 with high salinity but was 50 mL falcon tube: POR-70. Salinity values at URI are 2 units higher b/c the probe was reading 2 units higher than it should be. Correct for this in our data but not CSUN's.   

1. Replace URI's salinity values with average salinity of CSUN (36.164)  
2. Replace with that run's "correct" salinity value (under 37) for Run 1, 2, and 3. This doesn't solve other timepoint's issue though.  

*Issue*: 50 mL empty falcon tube bottles once done are sitting in the completed bin.  
*Resolution*: Figure out the waste protocol for these bottles since they had mercuric chloride in them. Wait until processing is done to get rid of them. More of a reminder than an active issue.

*Issue*: In script, where does the umol.cm2.hr calc come from? (deltaTA/2)*(1.023)*((vol.L*1000)/surface.area.cm2)*(1/timediff)*(1/1000). And where does the 36 coefficient for normalizing TA come from?  
*Resolution*: Find the paper source and/or make a note of this in the script or in the paper.

### Salinity issue

1. Are there any samples that were done at both URI and CSUN?

TA.norm = TA * Salinity/36

**Initial 1 Run 3**  
CSUN:  
- TA: 2347.879  
- Salinity lab: 36.25  
- **TA.norm: 2364.184**

Putnam Lab:   
- TA: 2337.256  
- Salinity lab: 38.02  
- **TA.norm: 2468.402**

2. Are there any runs that have samples split between URI and CSUN?

Run 1 = 1 coral done at CSUN; the rest of the run done at URI
Run 2 = all URI  
Run 3 = 2 done at CSUN; the rest of the run done at URI

CSUN consistently below URI: ~36.35 psu and URI is ~37.5-38.5 psu.

Average for all CSUN samples = 36.164 psu  

Options:  
1. We could use average CSUN value for all samples.  
2. Some URI samples are in the 36 range and I'd like to keep those.. So if any URI value is above a threshold (37.5?) we could replace that value with the average CSUN value or -1.5 psu from that value.  
3. Would only work for September time point (bc the other 3 are only URI): Run 1 and 3 have CSUN values, we could replace URI salinity values with the CSUN salinity value for that run.  


**ALL TP**:
- effect of environment of chamber (Jan - none but no pH values, March - none, Sept- pH)
- blanks and initial variation - some blanks have very low volume value (that isn't realistic)   
- Differences in run #s  
- Salinity probe reading 2 units higher - correct for this in our data but not CSUN's

**January 2020 TP1**:   
- Run 1-4 initials and blanks are wonky, same with Run 8 and 9       
- POC-248, POR-83 titration "NOT OK" from LabX output. Values seem to be OK though.      
- Environmental data: pH of chamber missing  
- 2 blanks for Run 5 - 2 bottles run. I kept the first blank from deltaTA and that titration bottle (kept from 20200318 Run 2 not Run 1)  
- BK-2 lost water during volume measurement - 575 mL isn't correct so I replaced 575 with 610 mL b/c chamber 1 was used again in later run for a blank so that is the empty volume for that chamber.  
- ACR 224 is bonus coral that doesn't exist anywhere else

**March 2020 TP2**:
- Only 1 initial for Run 11  
- No mismatches in data df  
- Runs 10-13 were much higher

**September 2020 TP3**:  
- Blank 3 and Blank 4 are both from chamber 10 but have different volumes -- this shouldn't be the case  
- The only missing samples: Initial1_20200909_1 and POR-240_20200913_5.  
- There are 2 Initial1_20200912_3 bottles/TA values (one bottle at URI but two TA values - one done at URI and one done in CA). Could one of these be for Run 4 on the same day?   
- Initial environmental measurements (temp, pH, salinity) missing run 3 and on.  
- Run 4 missing both both initial bottles.  
- Run 1-3 high blanks and initial values

**November 2020 TP4**:
- Initial 2 from Run 2 taken out b/c way lower than expected


#### List for Danielle to bring back from Mo'orea Spring 2022

- September 2020: Run 4 BK-4  : DANIELLE FOUND
- September 2020: Run 4 Initial 1 and 2  
- September 2020: POR-240 Run 5 20200913  : DANIELLE FOUND


### Closed Issues

*Issue*: We are currently copy and pasting into `Timepoint#_TA_Data` in urol timeseries repo.  
*Resolution*: Emma created a new script for calc rates that pulls in raw files.  

*Issue*: Do we use chamber temperature, salinity, and pH? Check with Hollie and Nyssa.       
*Resolution*: In R script, we can look at TA as a function of these values to see if we need to correct for anything.  

*Issue*: All September bottles have been processed but there are several blank and initials that we do not have accounted for. Cross reference again with those bottles done at CSUN and in-field notes.  
*Resolution*: Ariana and Emma are currently chatting about the best way to go about this. Some bottles spilled in transport but we don't think these are them. Turns out my code wasn't pulling all the California bottles done. The only missing samples from September are and Initial1_20200909_1 and POR-240_20200913_5. There are 2 Initial1_20200912_3 bottles/TA values (one bottle at URI but two TA values - one done at URI and one done in CA).

*Issue*: Sample notation was not consistent for the first couple of rounds.  
*Resolution*: Changed initial notation format on 0303 in the E5 timeseries folder and changed to all correct format on the titrator computer.

*Issue*: volumes missing from delta TA sheet.  
*Resolution*: https://drive.google.com/drive/u/0/folders/1Z7Gxiqo8QbnP4AMpgxmgq0wDNJ-qWmBW. extract volumes here and put in delta TA.

*Issue*: Address variation in initials and blanks.  
*Resolution*: Cross comparison between initial 1 and 2, across days to see variation, and the same for the blanks. More of a reminder to do than an active issue (unless there is larger variation than expected).

*Issue*: TP1 - January surface area is 30 for every chamber.  
*Resolution*: pull in real surface area for this.

*Issue*: 50 mL falcon tubes for some samples for January 2020 and November 2020 time points instead of larger bottles.  
*Resolution*: Hollie says it doesn't matter we can run these at whatever mass we can get - run this by Ariana and Danielle in meeting. Will add a column to keep track of which samples were in a 50 mL and we can see if there is a batch effect. For these samples, we will need to calculate salinity prior to measuring mass and putting samples in rondolino.  

*Issue*: 20220314 titration run - ACR-246 and Initial 2 may be mixed up in the rondolino (mass and salinities are correct, just position in titrator). Almost positive I fixed it but double check TA values at the end to make sure these make sense.    
*Resolution*: Emma looked and samples were correct and fixed.


## <a name="Week"></a> **Weekly Schedule**

Emma will sign the Putnam lab up for the appropriate time slots at the beginning of the week on the [PPP team up calendar](https://teamup.com/c/h2sumb/ppp-and-thornber-labs). Titrations google sheet [schedule](https://docs.google.com/spreadsheets/d/1GTZB9j9tki10ST88y0ErgEItQN5vrMHNqjC2ykZzzsU/edit#gid=0).

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

|                	| Monday 3/14                        	| Tuesday 3/15 	| Wednesday 3/16     	| Tuesday 3/1      	| Friday 3/18            	|
|----------------	|------------------------------------	|--------------	|--------------------	|------------------	|------------------------	|
| Personnel      	| Emma and Pierrick together all day 	| Puritz Lab   	| No one - power out 	| Emma and Kristen 	| Pierrick, Emma, Hollie 	|
| E5 sample runs 	| 3                                  	| 0            	| 0                  	| 4                	| 3                      	|
| Notes          	| Kristen out M-W for spring break   	|              	|                    	|                  	|                        	|

| # of runs 	| Samples done this week 	|
|-----------	|------------------------	|
| 10        	| 80                     	|


**Week of 3/21 - 3/25**

|                	| Monday 3/21       	| Tuesday 3/22                                        	| Wednesday 3/23                                                 	| Thursday 3/24       	| Friday 3/25      	|
|----------------	|-------------------	|-----------------------------------------------------	|----------------------------------------------------------------	|---------------------	|------------------	|
| Personnel      	| Pierrick and Emma 	| Emma starts (~8 am); Kristen finishes (12:15-3:15p) 	| Kristen starts (~9a-1p); Emma finishes (whenever Run2 is done) 	| Puritz lab all day  	| Pierrick all day 	|
| E5 sample runs 	| 3                 	| 4                                                   	| 3                                                              	| 0                   	| 2                	|
| Notes          	|                   	|                                                     	|                                                                	|                     	|                  	|

| # of runs 	| Samples done this week 	|
|-----------	|------------------------	|
| 12        	| 96                     	|

**Week of 3/28 - 4/1**

|                	| Monday 3/28 	| Tuesday 3/29          	| Wednesday 3/30   	| Thursday 3/31     	| Friday 4/1         	|
|----------------	|-------------	|-----------------------	|------------------	|-------------------	|--------------------	|
| Personnel      	|             	| Kristen (12:15-3:15p) 	| Kristen (~9a-1p) 	| Kristen afternoon 	| Puritz lab all day 	|
| E5 sample runs 	| 0           	| 1                     	| 1                	| 1                 	| 0                  	|
| Notes          	|             	|                       	|                  	|                   	|                    	|

| # of runs 	| Samples done this week 	|
|-----------	|------------------------	|
| 3         	| 24                     	|

**Week of 4/4 - 4/8**

|                	| Monday 4/4 	| Tuesday 4/5      	| Wednesday 4/6 	| Thursday 4/7 	| Friday 4/8 	|
|----------------	|------------	|------------------	|---------------	|--------------	|------------	|
| Personnel      	| Emma       	| Emma and Kristen 	| Emma          	|      Emma    	| Puritz all day   	|
| E5 sample runs 	| 3          	| 3                	| 4             	|    3         	| 0          	|
| Notes          	|            	|                  	| Kristen out   	| Kristen out  	|            	|

*Projected:*

| # of runs 	| Samples done this week 	|
|-----------	|------------------------	|
| 13        	| 104                    	|


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

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/E5%20Calcification%20Processing/September-titrations.jpg?raw=true)

## <a name="Jan"></a> **January 2020, 146 samples to complete**

#### 20220309 Kristen and Emma (2 runs = 16 samples; 3 runs total for the day (1 blue tank run))

First E5 sample run was for September 2020 and the 2nd run was for January 2020 time point.

Run 2:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2483.8335  	| 60.305 	| 35       	|
| Initial2_20200107_8 	| 2360.47591 	| 59.997 	| 40.96    	|
| POR-381_20200107_8  	| 2306.57443 	| 59.691 	| 40.99    	|
| ACR-364_20200107_8  	| 2341.16235 	| 60.528 	| 40.86    	|
| POC-373_20200107_8  	| 2274.75422 	| 60.144 	| 40.72    	|
| POC-394_20200107_8  	| 2349.66741 	| 60.258 	| 40.3     	|
| ACR-363_20200107_8  	| 2326.21349 	| 59.786 	| 40.96    	|
| POR-357_20200107_8  	| 2320.55603 	| 60.547 	| 40.81    	|
| Initial1_20200107_8 	| 2354.24313 	| 59.783 	| 40.59    	|

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

#### 20200318 Emma and Pierrick and Hollie (3 runs)

Run 1:

| SampleID           	| TA         	| Mass   	| Salinity 	|
|--------------------	|------------	|--------	|----------	|
| JUNK 1             	| 2111.58105 	| 60.763 	| 35       	|
| POR-253_20200105_4 	| 2200.01988 	| 60.611 	| 37.16    	|
| POR-251_20200106_5 	| 2245.50642 	| 60.02  	| 37.14    	|
| POR-266_20200105_3 	| 2241.96263 	| 60.063 	| 37.21    	|
| POC-207_20200105_4 	| 2330.15529 	| 59.83  	| 37.17    	|
| POR-245_20200105_3 	| 2297.85524 	| 59.366 	| 37.18    	|
| ACR-258_20200105_3 	| 2329.42448 	| 60.03  	| 37.33    	|
| BK-5_20200106_5    	| 2323.33425 	| 60.164 	| 37.24    	|
| POC-259_20200105_3 	| 2274.74885 	| 60.668 	| 37.14    	|

Run 2:

| SampleID             	| TA         	| Mass   	| Salinity 	|
|----------------------	|------------	|--------	|----------	|
| JUNK 1               	| 2083.14922 	| 59.95  	| 35       	|
| Initial1_20200105_3  	| 2273.21421 	| 37.256 	| 35.6     	|
| POR-261_20200106_5   	| 2338.40199 	| 59.738 	| 37.61    	|
| BK-5_20200106_5      	| 2356.92038 	| 60.523 	| 37.46    	|
| BK-2_20200104_2      	| 2359.63364 	| 60.817 	| 37.51    	|
| ACR-389_20200106_6   	| 2332.09833 	| 59.824 	| 38.77    	|
| POC-248_20200104_2   	| 2125.46803 	| 29.433 	| 35.4     	|
| Initial2_20200106_5  	| 2195.53421 	| 27.034 	| 36.49    	|
| Initial2_20200111_14 	| 2341.65789 	| 49.902 	| 37.15    	|

POC-216 bottle label is actually POR-261.

Run 3:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| POR-387_20200108_9  	| 2305.25321 	| 51.915 	| 37.46    	|
| ACR-145_20200111_14 	| 2328.40214 	| 48.758 	| 37.49    	|
| ACR-165_20200111_14 	| 2292.71005 	| 51.182 	| 37.55    	|
| POC-55_20200111_14  	| 2324.54047 	| 48.309 	| 37.62    	|
| POC-53_20200111_14  	| 2331.14166 	| 50.319 	| 37.6     	|
| POR-73_20200111_14  	| 2347.30681 	| 49.319 	| 37.22    	|
| POR-82_20200111_14  	| 2290.74187 	| 52.039 	| 37.24    	|
| POC-57_20200111_14  	| 2397.20882 	| 43.858 	| 38.71    	|
| POC-372_20200108_9  	| 2318.10586 	| 51.839 	| 37.24    	|


#### 20200321 Emma and Pierrick (3 runs)

Run 1:

| SampleID             	| TA         	| Mass   	| Salinity 	|
|----------------------	|------------	|--------	|----------	|
| JUNK 1               	| 2118.57179 	| 45.928 	| 35       	|
| POC-45_20200111_15   	| 2331.34309 	| 49.453 	| 37.63    	|
| POR-74_20200111_14   	| 2226.30763 	| 49.906 	| 37.42    	|
| BK-14_20200111_14    	| 2341.3981  	| 51.681 	| 36.79    	|
| Initial1_20200111_14 	| 2337.796   	| 50.312 	| 37.71    	|
| ACR-185_20200111_14  	| 2287.78789 	| 51.132 	| 36.84    	|
| POC-50_20200111_15   	| 2325.35604 	| 50.158 	| 36.24    	|
| POC-68_20200111_15   	| 2323.62506 	| 49.396 	| 36.2     	|
| POR-83_20200111_15   	| 2242.81069 	| 50.659 	| 37.42    	|

Run 2:

| SampleID             	| TA         	| Mass   	| Salinity 	|
|----------------------	|------------	|--------	|----------	|
| JUNK 1               	| 2642.5321  	| 60.967 	| 35       	|
| POR-77_20200111_15   	| 2320.2919  	| 51.663 	| 37.72    	|
| ACR-175_20200111_15  	| 2326.74355 	| 48.851 	| 37.93    	|
| ACR-186_20200111_15  	| 2321.95558 	| 50.424 	| 37.75    	|
| BK-15_20200111_15    	| 2373.52763 	| 44.484 	| 37.71    	|
| POC-50_20200111_15   	| 2326.6607  	| 49.114 	| 37.5     	|
| ACR-173_20200111_15  	| 2340.83327 	| 45.174 	| 38.47    	|
| POR-72_20200111_15   	| 2262.39016 	| 49.13  	| 38.06    	|
| Initial1_20200111_15 	| 2343.90542 	| 50.253 	| 37.78    	|

Run 3:

| SampleID             	| TA         	| Mass   	| Salinity 	|
|----------------------	|------------	|--------	|----------	|
| JUNK 1               	| 2646.21995 	| 59.184 	| 35       	|
| NA                   	| 2333.77641 	| 47.405 	| 37.66    	|
| NA                   	| 2244.98889 	| 50.501 	| 37.95    	|
| NA                   	| 2328.34115 	| 50.149 	| 38.06    	|
| NA                   	| 2326.72068 	| 48.348 	| 38.74    	|
| NA                   	| 2314.87429 	| 50.193 	| 37.99    	|
| Initial2_20200111_15 	| 2347.33022 	| 51.522 	| 37.89    	|
| NA                   	| 2325.83054 	| 49.661 	| 38.07    	|
| NA                   	| 2263.24728 	| 48.634 	| 38.21    	|

See below note for NAs.

Duplicates done. These are taken out of the data files in the E5 folder for now but raw data lives in Titrator repo (not edited):  
- ACR-186 taken out of Run 3, kept in Run 2    
- POC-68 taken out of Run 3, kept in Run 1    
- POC-45 taken out of Run 3, kept in Run 1  
- ACR-173 taken out of Run 3, kept in Run 2  
- POR-83 taken out of Run 3, kept in Run 1       
- POR-77 taken out of Run 3, kept in Run 2  
- POR-72 taken out of Run 3, kept in Run 1  

#### 20200322 Emma and Kristen (4 runs)

CRM error: -0.05%

Run 1:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2650.48042 	| 44.108 	| 35       	|
| ACR-139_20200110_13 	| 2319.51332 	| 50.256 	| 37.17    	|
| POR-81_20200110_13  	| 2314.74675 	| 50.735 	| 37.34    	|
| ACR-187_20200110_13 	| 2292.28379 	| 51.731 	| 37.3     	|
| BK-13_20200110_13   	| 2342.83092 	| 50.645 	| 37.47    	|
| POR-79_20200110_13  	| 2258.19395 	| 51.79  	| 37.07    	|
| POR-71_20200110_13  	| 2314.3771  	| 50.08  	| 37.9     	|
| POC-52_20200110_13  	| 2310.9354  	| 49.71  	| 37.44    	|
| ACR-190_20200110_13 	| 2316.44093 	| 50.497 	| 37.64    	|

Run 2:

| SampleID             	| TA         	| Mass   	| Salinity 	|
|----------------------	|------------	|--------	|----------	|
| JUNK 1               	| 2647.59596 	| 55.731 	| 35       	|
| ACR-176_20200110_12  	| 2243.91882 	| 51.99  	| 36.98    	|
| POC-56_20200110_12   	| 2323.0274  	| 51.709 	| 37.21    	|
| POR-69_20200110_12   	| 2280.55526 	| 53.379 	| 37.18    	|
| POR-75_20200110_12   	| 2246.50921 	| 49.872 	| 37.2     	|
| Initial2_20200110_13 	| 2370.49297 	| 47.291 	| 37.73    	|
| Initial2_20200110_12 	| 2337.9261  	| 49.897 	| 37.47    	|
| POC-41_20200110_13   	| 2306.66837 	| 49.607 	| 37.28    	|
| POC-43_20200110_13   	| 2309.73417 	| 50.101 	| 37.4     	|

Run 3:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2645.13668 	| 59.69  	| 35       	|
| ACR-51_20200109_11  	| 2323.50066 	| 49.59  	| 37.84    	|
| ACR-140_20200110_12 	| 2295.45644 	| 50.685 	| 37.73    	|
| ACR-180_20200109_11 	| 2323.09432 	| 50.718 	| 38.2     	|
| ACR-193_20200110_12 	| 2288.35923 	| 51.965 	| 37.87    	|
| POC-47_20200110_12  	| 2293.71726 	| 52.933 	| 38.18    	|
| POC-48_20200110_12  	| 2292.89801 	| 51.152 	| 38.12    	|
| BK-12_20200110_12   	| 2332.94472 	| 51.275 	| 38.06    	|
| POR-78_20200110_12  	| 2245.37962 	| 52.171 	| 38.14    	|

Run 4:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2643.79377 	| 59.707 	| 35       	|
| POR-70_20200109_11  	| 2342.65017 	| 47.102 	| 41.18    	|
| POR-76_20200109_11  	| 2314.69552 	| 51.649 	| 37.55    	|
| POR-80_20200109_11  	| 2339.53291 	| 48.432 	| 37.83    	|
| ACR-150_20200109_11 	| 2293.27016 	| 46.331 	| 37.93    	|
| ACR-396_20200108_9  	| 2298.18117 	| 54.322 	| 37.22    	|
| BK-11_20200109_11   	| 2338.51884 	| 49.935 	| 37.6     	|
| POC-42_20200109_11  	| 2319.72446 	| 48.979 	| 37.82    	|
| POC-44_20200109_11  	| 2387.20571 	| 48.055 	| 38.71    	|

#### 20200323 Emma and Kristen (3 E5 runs; 4 runs total with 1 blue tank run)

0.13% CRM error

Run 1:

| SampleID             	| TA         	| Mass   	| Salinity 	|
|----------------------	|------------	|--------	|----------	|
| JUNK 1               	| 2994.82376 	| 60.459 	| 35       	|
| Initial2_20200109_11 	| 2347.68385 	| 50.295 	| 37.23    	|
| POC-40_20200109_11   	| 2336.42257 	| 48.12  	| 37.75    	|
| POC-346_20200108_9   	| 2311.97058 	| 45.69  	| 37.33    	|
| POC-366_20200108_9   	| 2305.23846 	| 51.215 	| 37.3     	|
| ACR-390_20200108_9   	| 2313.38028 	| 52.575 	| 37.38    	|
| POR-338_20200108_10  	| 2264.61331 	| 50.293 	| 37.65    	|
| POR-349_20200108_10  	| 2313.13904 	| 50.982 	| 37.91    	|
| POR-354_20200108_9   	| 2289.3542  	| 51.392 	| 37.96    	|

Run 2:

| SampleID             	| TA         	| Mass   	| Salinity 	|
|----------------------	|------------	|--------	|----------	|
| JUNK 1               	| 2973.47483 	| 59.946 	| 35       	|
| Initial2_20200108_10 	| 2342.27335 	| 51.074 	| 37.41    	|
| POR-365_20200108_10  	| 2317.11089 	| 50.306 	| 37.66    	|
| POR-367_20200108_10  	| 2324.75939 	| 50.397 	| 37.55    	|
| BK-10_20200108_10    	| 2345.53728 	| 50.996 	| 38.03    	|
| ACR-351_20200108_10  	| 2306.23493 	| 48.197 	| 37.32    	|
| ACR-374_20200108_10  	| 2308.43032 	| 50.484 	| 37.65    	|
| POC-375_20200108_10  	| 2320.45236 	| 50.271 	| 37.57    	|
| POC-386_20200108_10  	| 2343.08793 	| 49.01  	| 37.94    	|

Run 3:

| SampleID             	| TA         	| Mass   	| Salinity 	|
|----------------------	|------------	|--------	|----------	|
| JUNK 1               	| 3002.88929 	| 44.216 	| 35       	|
| Initial1_20200110_12 	| 2343.18073 	| 53.353 	| 37.01    	|
| Initial1_20200110_13 	| 2344.21063 	| 51.878 	| 37.27    	|
| Initial1_20200108_10 	| 2347.6633  	| 49.497 	| 37.25    	|
| Initial1_20200109_11 	| 2337.01936 	| 49.022 	| 37.28    	|
| BK-9_20200108_9      	| 2343.82123 	| 50.195 	| 37.64    	|
| POC-359_20200108_9   	| 2329.67509 	| 50.059 	| 37.62    	|
| POR-341_20200107_8   	| 2334.40555 	| 56.833 	| 38.21    	|

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/E5%20Calcification%20Processing/january1.jpg?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/E5%20Calcification%20Processing/january2.jpg?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/E5%20Calcification%20Processing/january3.jpg?raw=true)
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/E5%20Calcification%20Processing/january4.jpg?raw=true)

## <a name="Nov"></a> **November 2020, 145 samples to complete**

#### 20220325

Run 1:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2459.52806 	| 59.85  	| 35       	|
| Initial2_20201103_3 	| 2328.08088 	| 59.597 	| 38.46    	|
| Initial1_20201102_2 	| 2344.52274 	| 59.003 	| 38.38    	|
| Initial1_20201102_1 	| 2283.39532 	| 60.133 	| 38.65    	|
| BK-3_20201103_3     	| 2327.75499 	| 59.192 	| 38.46    	|
| POC-248_20201103_3  	| 2284.3558  	| 60.599 	| 38.38    	|
| Initial1_20201105_8 	| 2347.90306 	| 60.791 	| 38.5     	|
| POR-209_20201102_1  	| 2285.07298 	| 59.812 	| 38.64    	|
| ACR-241_20201103_4  	| 2305.81769 	| 59.832 	| 38.51    	|

Run 2:

| SampleID           	| TA         	| Mass   	| Salinity 	|
|--------------------	|------------	|--------	|----------	|
| JUNK 1             	| 2459.19918 	| 59.523 	| 35       	|
| ACR-398_20201104_6 	| 2330.44006 	| 60.171 	| 38.15    	|
| POR-242_20201103_3 	| 2308.52711 	| 59.267 	| 38.19    	|
| POC-371_20201104_6 	| 2322.18042 	| 60.5   	| 38.26    	|
| POC-255_20201103_4 	| 2333.55238 	| 60.396 	| 38.44    	|
| POC-373_20201104_6 	| 2312.65502 	| 60.412 	| 38.46    	|
| ACR-267_20201103_4 	| 2207.2942  	| 59.97  	| 38.47    	|
| POC-207_20201102_1 	| 2324.88341 	| 60.167 	| 38.34    	|
| BK-1_20201102_1    	| 2348.63579 	| 60.244 	| 38.44    	|

#### 20220329

Run 1:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2470.81103 	| 59.913 	| 35       	|
| Initial1_20201105_7 	| 2375.6211  	| 59.944 	| 38.74    	|
| POR-362_20201105_7  	| 2241.1036  	| 59.764 	| 38.51    	|
| POC-386_20201105_7  	| 2316.37118 	| 59.829 	| 38.5     	|
| ACR-244_20201102_1  	| 2278.36467 	| 60.471 	| 38.31    	|
| POR-383_20201105_8  	| 2317.13254 	| 59.813 	| 38.47    	|
| ACR-237_20201102_1  	| 2158.40301 	| 60.309 	| 38.53    	|
| ACR-229_20201103_3  	| 2288.22038 	| 60.121 	| 38.51    	|
| Initial1_20201103_4 	| 2350.70154 	| 59.984 	| 38.65    	|

#### 20220330

Run1:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 1556.04272 	| 59.872 	| 35       	|
| POR_224_20201102_2  	| 1982.24103 	| 59.795 	| 38.53    	|
| Initial2_20201102_2 	| 2070.523   	| 60.014 	| 38.55    	|
| ACR-225_20201103_3  	| 2272.05144 	| 59.752 	| 38.64    	|
| POR-221_20201103_3  	| 2233.26146 	| 60.259 	| 38.76    	|
| POC-259_20201103_4  	| 2135.60169 	| 60.289 	| 38.67    	|
| ACR-389_20201104_6  	| 2340.14637 	| 59.756 	| 38.73    	|
| POC-372_20201104_6  	| 2226.12092 	| 60.127 	| 38.66    	|
| POC-366_20201104_5  	| 2042.30818 	| 60.216 	| 38.73    	|

#### 20220331

Run 1:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2685.99576 	| 59.669 	| 35       	|
| Initial1_20201103_3 	| 2357.93901 	| 59.627 	| 38.53    	|
| POC-238_20201102_2  	| 2257.75923 	| 60.284 	| 38.64    	|
| POR-260_20201102_2  	| 2274.71246 	| 60.457 	| 38.72    	|
| POR-214_20201102_1  	| 2200.7441  	| 59.989 	| 38.69    	|
| ACR-210_20201102_2  	| 2286.12298 	| 60.5   	| 38.62    	|
| POC-219_20201102_2  	| 2271.37031 	| 60.178 	| 38.71    	|
| POR-216_20201102_1  	| 2277.59854 	| 59.841 	| 38.71    	|
| ACR-213_20201102_2  	| 2296.61666 	| 59.943 	| 38.79    	|

#### 20220404

Run 1:

| SampleID           	| TA         	| Mass   	| Salinity 	|
|--------------------	|------------	|--------	|----------	|
| JUNK 1             	| 2215.25079 	| 42.063 	| 35       	|
| POC-346_20201105_8 	| 2296.8305  	| 51.609 	| 39.03    	|
| POR-365_20201104_6 	| 2260.39111 	| 54.976 	| 39.29    	|
| POR-340_20201104_5 	| 2279.67102 	| 59.552 	| 39.18    	|
| POC-358_20201104_5 	| 2328.00067 	| 57.809 	| 39.28    	|
| ACR-220_20201103_3 	| 2253.65176 	| 57.133 	| 39.19    	|
| POC-369_20201104_5 	| 2332.31998 	| 59.956 	| 39.26    	|
| POC-254_20201103_3 	| 2302.67953 	| 58.129 	| 39.32    	|
| ACR-343_20201104_5 	| 2156.2942  	| 57.035 	| 39.3     	|

Run 2:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2449.07902 	| 53.995 	| 35       	|
| ACR-256_20201103_4  	| 2324.42984 	| 54.088 	| 39.19    	|
| Initial2_20201104_6 	| 2351.01021 	| 56.516 	| 39.21    	|
| POC-359_20201104_5  	| 2299.02915 	| 53.227 	| 39.43    	|
| POR-349_20201104_6  	| 2313.73717 	| 55.566 	| 39.17    	|
| POR-341_20201104_5  	| 2227.52434 	| 53.448 	| 39.33    	|
| POR-353_20201104_6  	| 2189.43197 	| 59.455 	| 39.26    	|
| BK-6_20201104_6     	| 2312.03214 	| 56.003 	| 39.29    	|
| ACR-368_20201104_5  	| 2279.81497 	| 57.319 	| 39.35    	|

Run 3:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2446.89246 	| 59.876 	| 35       	|
| POR-251_20201103_4  	| 2293.29224 	| 59.387 	| 39.29    	|
| Initial1_20201104_6 	| 2342.07398 	| 59.896 	| 39.22    	|
| POR-262_20201103_4  	| 2266.24457 	| 60.434 	| 39.26    	|
| Initial1_20201104_5 	| 2343.47258 	| 60.971 	| 39.27    	|
| POR-338_20201104_5  	| 2288.88806 	| 60.698 	| 39.16    	|
| POR-245_20201103_3  	| 2261.05437 	| 60.193 	| 39.18    	|
| POR-354_20201104_6  	| 2296.80522 	| 59.555 	| 39.08    	|
| BK-5_20201104_5     	| 2347.686   	| 60.532 	| 39.23    	|

#### 20220405

Run 1:

| SampleID             	| TA         	| Mass   	| Salinity 	|
|----------------------	|------------	|--------	|----------	|
| JUNK 1               	| 2455.19823 	| 55.633 	| 35       	|
| Initial2_20201106_9  	| 2319.0847  	| 52.456 	| 38.24    	|
| Initial2_20201106_10 	| 2302.00178 	| 52.931 	| 38.14    	|
| POR-73_20201106_10   	| 2264.46342 	| 52.683 	| 38.64    	|
| POC-40_20201106_9    	| 2278.31715 	| 53.372 	| 38.11    	|
| ACR-145_20201106_9   	| 2277.65617 	| 54.957 	| 38.2     	|
| POR-70_20201106_9    	| 2575.80824 	| 46.026 	| 45.87    	|
| POR-74_20201106_10   	| 2173.01456 	| 52.571 	| 38.24    	|
| BK-10_20201106_10    	| 2312.12355 	| 53.495 	| 38.5     	|

Run 2:

| SampleID             	| TA         	| Mass   	| Salinity 	|
|----------------------	|------------	|--------	|----------	|
| JUNK 1               	| 2459.29679 	| 59.988 	| 35       	|
| POC-47_20201106_10   	| 2375.5343  	| 51.096 	| 41.06    	|
| POR-72_20201106_10   	| 2243.16768 	| 52.797 	| 39.62    	|
| ACR-175_20201106_10  	| 2299.00502 	| 53.497 	| 39.09    	|
| POC-44_20201106_10   	| 2312.11909 	| 53.392 	| 39.45    	|
| POC-43_20201106_9    	| 2279.50746 	| 53.086 	| 39.33    	|
| POR-69_20201106_9    	| 2214.73618 	| 55.09  	| 39.22    	|
| POR-71_20201106_9    	| 2294.02013 	| 52.441 	| 40.5     	|
| Initial1_20201106_10 	| 2313.52694 	| 52.299 	| 39.07    	|

Run 3:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2454.84057 	| 59.813 	| 35       	|
| ACR-150_20201106_9  	| 2390.2876  	| 51.01  	| 40.86    	|
| BK-8_20201105_8     	| 2312.99331 	| 53.103 	| 39.46    	|
| ACR-176_20201106_10 	| 2273.41324 	| 53.903 	| 39.22    	|
| Initial1_20201106_9 	| 2312.1421  	| 51.567 	| 39.18    	|
| ACR-173_20201106_10 	| 2293.94975 	| 54.57  	| 39.2     	|
| POC-45_20201106_10  	| 2281.9282  	| 53.781 	| 39.3     	|
| ACR-139_20201106_9  	| 2406.96171 	| 51.684 	| 41.24    	|
| BK-9_20201106_9     	| 2309.69362 	| 53.303 	| 39.21    	|

#### 20220406

Run 1:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2453.36554 	| 51.4   	| 35       	|
| POR-357_20201105_7  	| 2287.31341 	| 56.134 	| 39.5     	|
| POC-391_20201105_8  	| 2315.54577 	| 56.953 	| 39.25    	|
| POC-375_20201105_7  	| 2318.89853 	| 58.838 	| 38.89    	|
| Initial2_20201105_7 	| 2345.46256 	| 54.44  	| 39.03    	|
| POC-394_20201105_8  	| 2314.7015  	| 55.353 	| 38.91    	|
| POC-377_20201105_7  	| 2317.55119 	| 54.729 	| 38.91    	|
| POC-378_20201105_7  	| 2247.99033 	| 56.844 	| 38.71    	|
| ACR-234_20201102_1  	| 2233.43928 	| 54.75  	| 38.98    	|

Run 2:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2454.79681 	| 53.023 	| 35       	|
| POC-42_20201106_9   	| 2279.72266 	| 52.572 	| 39.39    	|
| POR-240_20201102_2  	| 2304.73126 	| 55.106 	| 39.54    	|
| Initial2_20201105_8 	| 2340.89755 	| 57.739 	| 39.49    	|
| Initial2_20201102_1 	| 2303.27971 	| 61     	| 39.47    	|
| ACR-390_20201105_7  	| 2307.28893 	| 59.167 	| 39.46    	|
| BK-2_20201102_2     	| 2255.41764 	| 57.563 	| 39.25    	|
| POR-384_20201105_8  	| 2290.54093 	| 56.42  	| 39.28    	|
| POC-395_20201105_8  	| 2324.36352 	| 56.254 	| 39.17    	|

Run 3:

| SampleID           	| TA         	| Mass   	| Salinity 	|
|--------------------	|------------	|--------	|----------	|
| JUNK 1             	| 4095.35382 	| 24.748 	| 35       	|
| ACR-218_20201102_2 	| 2194.16801 	| 55.877 	| 39.66    	|
| POC-205_20201102_1 	| 2280.55671 	| 54.129 	| 39.67    	|
| POC-222_20201102_2 	| 2314.33751 	| 56.28  	| 39.5     	|
| ACR-393_20201105_8 	| 2328.77103 	| 53.989 	| 39.65    	|
| POR-367_20201105_7 	| 2268.30316 	| 59.917 	| 39.2     	|
| POC-200_20201102_1 	| 2309.16733 	| 56.301 	| 39.63    	|
| POR-381_20201105_8 	| 2190.69777 	| 60.546 	| 39.37    	|
| BK-7_20201105_7    	| 2342.26238 	| 57.006 	| 39.43    	|

Run 4:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| POC-50_20201107_12  	| 2295.59409 	| 53.408 	| 39.7     	|
| POR-385_20201105_8  	| 2255.15972 	| 52.336 	| 39.59    	|
| POC-239_20201103_3  	| 2325.1578  	| 54.049 	| 39.49    	|
| Initial2_20201103_4 	| 2343.93203 	| 56.65  	| 39.43    	|
| POC-257_20201103_4  	| 2321.67537 	| 55.956 	| 39.6     	|
| BK-4_20201103_4     	| 2343.80303 	| 57.351 	| 39.6     	|
| POR-253_20201103_4  	| 2292.41839 	| 56.323 	| 39.48    	|
| Initial2_20201104_5 	| 2346.28827 	| 59.052 	| 39.54    	|


#### 20220407

Run 1:

| SampleID            	| TA         	| Mass   	| Salinity 	|
|---------------------	|------------	|--------	|----------	|
| JUNK 1              	| 2462.74103 	| 48.867 	| 35       	|
| POR-75_20201107_11  	| 2266.84129 	| 51.645 	| 39.16    	|
| ACR-178_20201107_11 	| 2333.26496 	| 52.936 	| 39.9     	|
| POC-52_20201107_11  	| 2328.66141 	| 52.31  	| 39.14    	|
| POC-48_20201107_12  	| 2310.66864 	| 53.033 	| 38.9     	|
| ACR-186_20201107_12 	| 2287.20802 	| 54.479 	| 38.21    	|
| POC-55_20201107_11  	| 2298.00034 	| 54.821 	| 37.83    	|
| ACR-185_20201107_11 	| 2403.8172  	| 52.244 	| 39.46    	|
| ACR-180_20201107_11 	| 2308.76516 	| 54.219 	| 37.99    	|

Run 2:

| SampleID             	| TA         	| Mass   	| Salinity 	|
|----------------------	|------------	|--------	|----------	|
| JUNK 1               	| 2466.76751 	| 48.956 	| 35       	|
| POC-68_20201107_12   	| 2298.86364 	| 53.24  	| 37.61    	|
| POC-53_20201107_11   	| 2292.89003 	| 54.839 	| 39.06    	|
| BK-11_20201107_11    	| 2383.68147 	| 53.059 	| 39.73    	|
| POC-57_20201107_12   	| 2401.55067 	| 51.579 	| 39.6     	|
| ACR-187_20201107_12  	| 2285.52314 	| 54.9   	| 37.42    	|
| POR-79_20201107_11   	| 2237.75686 	| 54.288 	| 37.35    	|
| POR-76_20201107_11   	| 2161.95406 	| 54.583 	| 37.01    	|
| Initial1_20201107_12 	| 2322.32984 	| 53.464 	| 38.72    	|

Run 3:

| SampleID             	| TA         	| Mass   	| Salinity 	|
|----------------------	|------------	|--------	|----------	|
| JUNK 1               	| 2459.95448 	| 58.154 	| 35       	|
| BK-12_20201107_12    	| 2315.17967 	| 54.23  	| 38.59    	|
| Initial2_20201107_11 	| 2323.62604 	| 52.308 	| 38.47    	|
| Initial1_20201107_11 	| 2339.57832 	| 51.364 	| 39.3     	|
| POR-82_20201107_12   	| 2204.67128 	| 54.183 	| 38.1     	|
| POR-81_20201107_12   	| 2546.20421 	| 46.797 	| 42.17    	|
| POR-83_20201107_12   	| 2158.60913 	| 54.008 	| 37.96    	|
| Initial2_20201107_12 	| 2313.85678 	| 51.491 	| 38.7     	|


![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/E5%20Calcification%20Processing/november1.jpg?raw=true)  
![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/E5%20Calcification%20Processing/november2.jpg?raw=true)

## Salinity probe test info

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/E5%20Calcification%20Processing/salinityprobe-test.jpg?raw=true)

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

#### Waste pick up

When the bottles are ready to be picked up, fill out this [link](https://web.uri.edu/ehs/online-pickup/).

From: Emma Strand  
Email Address: emma_strand@uri.edu  
Location of Waste: CBLS 190  
PI: Hollie Putnam  
Waste Container 1-List all contents in waste container: *Insert all contents on the bottle label*.  
Quantity and size of container: 4L plastic jug  
Hazard Class: toxic    
*Repeat for as many bottles as we have.*  

Supplies Needed (Use dropdown menu below description to indicate quantity needed):  

4 liter plastic jug (for liquid wastes): 6

Additional comments: The bottles are located in the first row of benches in CBLS 190. Bottles to be picked up are marked with tape and "To Be Picked Up" label in cabinet labeled BD12.

#### Acid Bottle replacement

1. Purge the remaining acid out so that the lines and bottle are empty.  
2. This acid is now waste. This can be neutralized with seawater or DI water and poured down the sink (*contact PI to make sure you are doing this step correctly*).    
3. Connect the new acid bottle to the titrator lines and purge at least six times to fill the lines with the new acid.  
