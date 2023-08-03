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

##### Example code

Linear mixed models that I ran. The default for lmer and lmes are dummy coding.   

```
## SUM/EFFECT CODING WITH NO RANDOM FACTOR NESTING
Pacuta_Resp_LMER <- lmer(Rdark_umol.cm2.hr ~ Timepoint*Temperature*CO2 + (1|Tank), na.action=na.omit, data=pacuta_photoresp, contrasts = list(Timepoint = "contr.sum", Temperature = "contr.sum", CO2 = "contr.sum"))

## SUM/EFFECT CODING WITH RANDOM FACTOR NESTING
Pacuta_Resp_LMER2 <- lmer(Rdark_umol.cm2.hr ~ Timepoint*Temperature*CO2 + (1|Tank:Temperature:Timepoint) + (1|Tank:CO2:Timepoint), na.action=na.omit, data=pacuta_photoresp, contrasts = list(Timepoint = "contr.sum", Temperature = "contr.sum", CO2 = "contr.sum"))

## DUMMY(TREATMENT) CODING WITH NO RANDOM FACTOR NESTING
Pacuta_Resp_LMER3 <- lmer(Rdark_umol.cm2.hr ~ Timepoint*Temperature*CO2 + (1|Tank), na.action=na.omit, data=pacuta_photoresp, contrasts = list(Timepoint = "contr.treatment", Temperature = "contr.treatment", CO2 = "contr.treatment"))

## DUMMY(TREATMENT) CODING WITH RANDOM FACTOR NESTING
Pacuta_Resp_LMER4 <- lmer(Rdark_umol.cm2.hr ~ Timepoint*Temperature*CO2 + (1|Tank:Temperature:Timepoint) + (1|Tank:CO2:Timepoint), na.action=na.omit, data=pacuta_photoresp, contrasts = list(Timepoint = "contr.treatment", Temperature = "contr.treatment", CO2 = "contr.treatment"))
```

ANOVAs run on these models

```
# Type III Wald chisquare tests
pacuta_resp_anova <- Anova(Pacuta_Resp_LMER, ddf="lme4", type='III')
pacuta_resp_anova2 <- Anova(Pacuta_Resp_LMER2, ddf="lme4", type='III')
pacuta_resp_anova3 <- Anova(Pacuta_Resp_LMER3, ddf="lme4", type='III')
pacuta_resp_anova4 <- Anova(Pacuta_Resp_LMER4, ddf="lme4", type='III')
```

Output:

SUM/EFFECT CODING WITH NO RANDOM FACTOR NESTING

```
> pacuta_resp_anova
Analysis of Deviance Table (Type III Wald chisquare tests)

Response: Rdark_umol.cm2.hr
                              Chisq Df Pr(>Chisq)    
(Intercept)               1258.9685  1  < 2.2e-16 ***
Timepoint                   93.7193  4  < 2.2e-16 ***
Temperature                 24.2031  1  8.669e-07 ***
CO2                          0.2234  1    0.63645    
Timepoint:Temperature       10.6742  4    0.03048 *  
Timepoint:CO2                2.3610  4    0.66968    
Temperature:CO2              0.2563  1    0.61270    
Timepoint:Temperature:CO2    8.4694  4    0.07582 .  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

SUM/EFFECT CODING WITH RANDOM FACTOR NESTING

```
> pacuta_resp_anova2
Analysis of Deviance Table (Type III Wald chisquare tests)

Response: Rdark_umol.cm2.hr
                              Chisq Df Pr(>Chisq)    
(Intercept)               2096.6798  1  < 2.2e-16 ***
Timepoint                   87.4169  4  < 2.2e-16 ***
Temperature                 40.3078  1  2.169e-10 ***
CO2                          0.3721  1    0.54188    
Timepoint:Temperature        9.9564  4    0.04117 *  
Timepoint:CO2                2.2023  4    0.69861    
Temperature:CO2              0.4268  1    0.51357    
Timepoint:Temperature:CO2    7.8998  4    0.09532 .  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

DUMMY(TREATMENT) CODING WITH NO RANDOM FACTOR NESTING

```
> pacuta_resp_anova3
Analysis of Deviance Table (Type III Wald chisquare tests)

Response: Rdark_umol.cm2.hr
                             Chisq Df Pr(>Chisq)    
(Intercept)               192.6901  1  < 2.2e-16 ***
Timepoint                  18.6304  4  0.0009288 ***
Temperature                 2.4110  1  0.1204884    
CO2                         0.0397  1  0.8420698    
Timepoint:Temperature       2.0783  4  0.7213606    
Timepoint:CO2               5.7862  4  0.2156901    
Temperature:CO2             0.3664  1  0.5449574    
Timepoint:Temperature:CO2   8.4694  4  0.0758207 .  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

DUMMY(TREATMENT) CODING WITH RANDOM FACTOR NESTING

```
> pacuta_resp_anova4
Analysis of Deviance Table (Type III Wald chisquare tests)

Response: Rdark_umol.cm2.hr
                             Chisq Df Pr(>Chisq)    
(Intercept)               207.9667  1  < 2.2e-16 ***
Timepoint                  17.3776  4   0.001632 **
Temperature                 2.6021  1   0.106722    
CO2                         0.0428  1   0.836014    
Timepoint:Temperature       1.9385  4   0.747063    
Timepoint:CO2               5.3971  4   0.248920    
Temperature:CO2             0.3955  1   0.529433    
Timepoint:Temperature:CO2   7.8998  4   0.095317 .  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

With no model, just three way ANOVA. This looks the most similar to anova2 above with sum coding and nested random factors.

```
test.aov <- aov(Rdark_umol.cm2.hr ~ Timepoint*Temperature*CO2, data = pacuta_photoresp)
summary(test.aov)

Df Sum Sq Mean Sq F value   Pr(>F)    
Timepoint                   4 0.7024  0.1756  22.045 4.56e-13 ***
Temperature                 1 0.3239  0.3239  40.659 5.65e-09 ***
CO2                         1 0.0030  0.0030   0.375   0.5415    
Timepoint:Temperature       4 0.0800  0.0200   2.511   0.0465 *  
Timepoint:CO2               4 0.0177  0.0044   0.555   0.6956    
Temperature:CO2             1 0.0034  0.0034   0.431   0.5132    
Timepoint:Temperature:CO2   4 0.0635  0.0159   1.992   0.1015    
Residuals                 100 0.7965  0.0080                     
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
179 observations deleted due to missingness
```

Figure to go along with this data below. The models that use sum coding seem to match more of the effects happening that I see in this figure..

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/stats-coding-example-figure.png?raw=true)

![](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/images/stats-models-contrast-example.jpg?raw=true)
