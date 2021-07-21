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

## Montipora capitata

We originally tried the SD100 slides, but the tissue homogenate was too clumpy and was getting stuck at the entry of the slide.

![clump]()

I then thawed the original 50 mL falcon tube of tissue homogenate and homogenized again for 30 seconds (see [Putnam Lab Airbrushing protocol](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2019-10-22-Airbrushing-Protocol.md) for details on the homogenization). I did this for 11 samples and then counted those on the haemocytometer. 5/11 samples were still clumpy after 30 seconds so I think the homogenization step should be 45 seconds.

## Pocillopora acuta

*P. acuta* samples were not clumpy at all and fit well in the SD100 slides. I would suggest moving forward with the original aliquots of *P. acuta* and the SD100 slides.


#### Processing Notes

**20210526:**    
I tried the 5 mm homogenizer for 5 seconds and 20 seconds but it wasn't enough, even with vortexing after. The tube is so small that the homogenizer can't go very fast so I'm not sure it is breaking up the clumps like I need it to.

Homogenize little aliquots for 1 minute, vortex for 30 seconds. Then count on haemocytometer and cellometer.

OR thaw the large homogenates and homogenize for 45 seconds on higher speed. Vortex for 30 seconds. Then count on haemocytometer and cellometer.

**20210630:**      
I homogenized the Mcap samples for 30 seconds and this appeared to be enough for about half of them. Those half that looked great under the haemocytometer are still being undercounted on the cellometer.

There is no standard volume that goes into the haemocytometer, could this be causing an issue? Exactly 20 uL is placed into the cellometer slide. But then this would be an issue for all species and its not.
