---
layout: post
title: Cell Counting HoloInt
date: '2021-05-25'
categories: Processing
tags: Cellometer, haemocytometer
projects: HoloInt
---

# Symbiont Density Processing

See [Putnam Lab Cellometer protocol](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-05-26-Cellometer-Protocol.md) for more details on materials and protocol steps.

# Cellometer vs. haemocytometer trials

Cellometer data file [here](https://github.com/hputnam/Acclim_Dynamics/blob/master/Physiology_variables/cell-counts-cellometer.csv).  
haemocytometer data file [here](https://github.com/hputnam/Acclim_Dynamics/blob/master/Physiology_variables/cell-counts-haemo.csv).  

R code [here](https://github.com/hputnam/Acclim_Dynamics/blob/master/Scripts/Cell-Counts.Rmd). Cell counts calculated by cells.mL (from either haemocytometer or cellometer) * volume of homogenate / surface area of the coral fragment.

```
cellometer_sym_counts <- cellometer_sym_counts %>%
  mutate(cells.mL = count.mean,
         cells = cells.mL * vol_mL,
         cellometer.cells.cm2 = cells / surface.area.cm2)
```

2 species focused on: *Montipora capitata* and *Pocillopora acuta*.

![cell](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Cellometer-testing.png?raw=true)

R2 values are from the post-homogenizing samples.

## Recommended workflow

*P.acuta*: Homogenize for 30 seconds and use the SD100 slide.  
*M. capitata*: Homogenize for 1 minute and use the SD100 slide.

2 measurements per sample (1 slide per sample).

## Determining the number of counts to do per sample

Coefficient of variation = standard deviation / mean. For this variable we want CV to be under 10%. So we need to figure out how many measurements we need to do per sample to keep the CV under 10%. For the haemocytometer this is 6 counts per sample.

Below are the CV values for the post-homogenization samples (Mcap and Pacuta that were thawed and additionally homogenized). Based on this data, I think we only need 2 counts per sample.

| Species 	| Plug ID 	| CV with 2  	| CV with 3 	| Slide 	|
|---------	|---------	|------------	|-----------	|-------	|
| Mcap    	| 1353    	| 5.58%      	| 6.35%     	| PD300 	|
| Mcap    	| 1226    	| 0.86%      	| 0.83%     	| PD300 	|
| Mcap    	| 1822    	| 2.23%      	| 5.30%     	| PD100 	|
| Pacuta  	| 1256    	| 6.96%      	| 5.64%     	| PD100 	|
| Pacuta  	| 1432    	| 5.01%      	| 4.88%     	| PD100 	|
| Pacuta  	| 1045    	| 0.77%      	| 4.93%     	| PD100 	|
| Pacuta  	| 1098    	| 4.29%      	| 8.28%     	| PD100 	|

![c1c2](https://github.com/hputnam/Acclim_Dynamics/blob/master/Physiology_variables/cell-counts/Cellometer-c1c2.png?raw=true)

## Comparison to the literature

My range of cell count values is: 22,500 - 1,206,222 cells per cm2. Below are values from *P. acuta* in the literature

My range of cell count values: 500,000 - 2,500,000 cells per cm2. Below are values from *M. capitata* in the literature.

| Species     	| Location               	| Reported cell count range       	| Converted to the same units      	| Citation                  	|
|-------------	|------------------------	|---------------------------------	|----------------------------------	|---------------------------	|
| P. acuta    	| Kusu Island, Singapore 	| 0.1 - 3 million cell per cm2    	| 100,000 - 3,000,000 per cm2      	| Poquita-Du et al 2020     	|
| P. acuta    	| Kusu Island, Singapore 	| 10 - 100 x 10^6 per cm2         	| 10,000,000 - 100,000,000 per cm2 	| Pang et al 2021           	|
| P. acuta    	| Hawaii                 	| 6.1 - 7.89 x 10^5 per cm2       	| 789,000 per cm2                  	| Mason et al 2020          	|
| P. acuta    	| Mo'orea                	| 1.1 - 1.73 x 10^6 per cm2       	| 1,100,000 - 1,730,000 per cm2    	| Becker and Silbiger 2020  	|
| P. acuta    	| Hawaii                 	| 2.5 x 10^5 - 1.0 x 10^6 per cm2 	| 250,000 - 1,000,000 per cm2      	| Fox et al 2020            	|
| M. capitata 	| Hawaii                 	| 3 - 15 x 10^3 per cm2           	| 3,000 - 15,000 per cm2           	| Santos et al 2009         	|
| M. capitata 	| Hawaii                 	| 1 - 4 x 10^8 per gdw            	|                                  	| Padilla-Gamino et al 2013 	|
| M. capitata 	| Hawaii                 	| 500,000 - 2,500,000 per cm2     	| 500,000 - 2,500,000 per cm2      	| Ricci et al 2019          	|

## Troubleshooting

### Montipora capitata troubleshooting

We originally tried the SD100 slides, but the tissue homogenate was too clumpy and was getting stuck at the entry of the SD100 slide.

![clump](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/cellometer/mcap-clump.jpg?raw=true)

I then thawed the original 50 mL falcon tube of tissue homogenate and homogenized again for 30 seconds (see [Putnam Lab Airbrushing protocol](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2019-10-22-Airbrushing-Protocol.md) for details on the homogenization). I did this for 11 samples and then counted those on the haemocytometer. 5/11 samples were still clumpy after 30 seconds so I think the homogenization step should be 45 seconds.

This still caused the clumping effect at the beginning of the slide and the cellometer was still undercounting the samples.

Nexcelom sent us 5 PD300 slides to test out. These are deeper at 300 microns compared to SD100 slides are 89 microns. The SD100 slides take 20 uL volume input and PD300 slides take 60 uL volume input.

When I first tested the PD300 slide, the cellometer was still undercounting but I could see more symbionts in the image than the output value. In the settings for F1, I changed the maximum cell diameter size from 15 um to 100 um. This worked! The cellometer was counting all cells and this value was much closer to the haemocytometer count.

I then tried homogenizing the same M. capitata samples for an additional 30 seconds and this worked on the SD100 slide! As long as samples are thoroughly homogenized, then they fit in the SD100 slide and are extremely accurate to the haemocytometer values.


### Pocillopora acuta troubleshooting

*P. acuta* samples were not clumpy at all and fit well in the SD100 slides. I would suggest moving forward with the original aliquots of *P. acuta* and the SD100 slides and homogenizing these for 30 seconds to reduce the variation seen between slides.

### Troubleshooting Notes

**20210526:**    
I tried the 5 mm homogenizer for 5 seconds and 20 seconds but it wasn't enough, even with vortexing after. The tube is so small that the homogenizer can't go very fast so I'm not sure it is breaking up the clumps like I need it to.

Homogenize little aliquots for 1 minute, vortex for 30 seconds. Then count on haemocytometer and cellometer.

OR thaw the large homogenates and homogenize for 45 seconds on higher speed. Vortex for 30 seconds. Then count on haemocytometer and cellometer.

**20210630:**      
I homogenized the Mcap samples for 30 seconds and this appeared to be enough for about half of them. Those half that looked great under the haemocytometer are still being undercounted on the cellometer.

There is no standard volume that goes into the haemocytometer, could this be causing an issue? Exactly 20 uL is placed into the cellometer slide. But then this would be an issue for all species and its not.
