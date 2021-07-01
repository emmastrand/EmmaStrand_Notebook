---
layout: post
title: Cell Counting HoloInt
date: '2021-05-25'
categories: Processing
tags: Cellometer, haemocytometer
projects: HoloInt
---

# Symbiont Density Processing

HoloIntegration project.

## Cellometer vs. haemocytometer trials

Cellometer data file [here](https://github.com/hputnam/Acclim_Dynamics/blob/master/Physiology_variables/cell-counts-cellometer.csv).  
haemocytometer data file [here](https://github.com/hputnam/Acclim_Dynamics/blob/master/Physiology_variables/cell-counts-haemo.csv).  

R code [here](https://github.com/hputnam/Acclim_Dynamics/blob/master/Scripts/Cell-Counts.Rmd). Cell counts calculated by cells.mL (from either haemocytometer or cellometer) * volume of homogenate / surface area of the coral fragment.

```
cellometer_sym_counts <- cellometer_sym_counts %>%
  mutate(cells.mL = count.mean,
         cells = cells.mL * vol_mL,
         cellometer.cells.cm2 = cells / surface.area.cm2)
```

3 species used: *Montipora capitata*, *Pocillopora acuta*, and *Porites asteroides*. Symbiont density converted to cells per mL and then standardized by homogenate volume and surface area.

![cell](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Cellometer-testing.png?raw=true)

The cellometer seems to be undercounting the Mcap samples - I think this is because the Mcap samples have a lot of clumps and need to be homogenized and then vortexed prior to counting.

## Next steps  

#### Notes

**20210526:**    
I tried the 5 mm homogenizer for 5 seconds and 20 seconds but it wasn't enough, even with vortexing after. The tube is so small that the homogenizer can't go very fast so I'm not sure it is breaking up the clumps like I need it to.

Homogenize little aliquots for 1 minute, vortex for 30 seconds. Then count on haemocytometer and cellometer.

OR thaw the large homogenates and homogenize for 45 seconds on higher speed. Vortex for 30 seconds. Then count on haemocytometer and cellometer.

**20210630:**      
I homogenized the Mcap samples for 30 seconds and this appeared to be enough for about half of them. Those half that looked great under the haemocytometer are still being undercounted on the cellometer.

There is no standard volume that goes into the haemocytometer, could this be causing an issue? Exactly 20 uL is placed into the cellometer slide. But then this would be an issue for all species and its not. 
