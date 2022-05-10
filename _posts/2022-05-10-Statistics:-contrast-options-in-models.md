---
layout: post
title: Statistics - contrast options in models
date: '2022-05-10'
categories: Analysis
tags: statistics
projects: Putnam Lab
---

# Statistics: Contrasts and deviation coding

Resources used:  
- [Coding schemes for categorical variables in regression](https://www.polyu.edu.hk/cbs/sjpolit/coding_schemes.html)  
- [Contrast coding](https://marissabarlaz.github.io/portfolio/contrastcoding/)  
- [Understanding Sum Contrasts for Regression Models: A Demonstration](https://rpubs.com/monajhzhu/608609)  
- [R LIBRARY CONTRAST CODING SYSTEMS FOR CATEGORICAL VARIABLES](https://stats.oarc.ucla.edu/r/library/r-library-contrast-coding-systems-for-categorical-variables/#DEVIATION)  
- [Core Guide: Dummy and Effect Coding in the Analysis of Factorial Designs](https://sites.globalhealth.duke.edu/rdac/wp-content/uploads/sites/27/2020/08/Core-Guide_Dummy-and-Effect-Coding_16-03-20.pdf)

General notes, but I'm still trying to figure out what this all means...

**Contrast definition**: Linear combination of variables that allows comparison of different treatments. Alternate coding methods besides the default allows researchers to ask specific questions about the relationship between variables.

**"dummy coding"/treatment (default)**: This compares each level of a categorical variable to a reference level. By default, the reference level is the first level of the categorical variable in alphabetical order.

**Effect/Deviation/Sum coding**: This compares the mean of a dependent variable for a given level to the overall mean of the dependent variables. Essentially comparing the mean in a given level of variable (i.e. treatment) to the unweighted mean in all levels of the variable (treatment). **This has been suggested to be best for factorial designs. See Core Guide link above for this citation and paper reference.**

**Helmert coding**: This compares each level of a categorical variable to the mean of subsequent levels of the variable.


In my experiment (stresss period for an example), factors are:
- Temperature: ambient vs high    
- CO2: ambient vs high    
- Timepoint: Week 1, Week 2, Week 4, Week 6, Week 8

Treatment coding (Default) will compare the mean of the high temperature to the ambient temperature b/c ambient is set as the reference level based on alphabetical order.

Sum coding (deviant) will compare the high temperature to the mean of the all of the dependent (ambient and high).

**Helpful summary from Core guide link above**:

This is a brief introduction to dummy and effect coding in regression analysis, with an emphasis in factorial experiments. In factorial designs, where the researcher-controlled factors exist, effect coding is preferred due to the property of orthogonality that comes with more reasonable estimates of both the main and interaction effects and the convenience for interpretation. Outside the scope of factorial design, especially where the factors are not experimentally manipulated or sample size are extremely unbalanced, dummy coding is still the generally more preferred method. 
