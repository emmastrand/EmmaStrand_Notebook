# DNA Methylation

A compilation of resources on understanding why the addition of that little methyl group matters.

For more information on the bioinformatic processes: [Methylation-Bioinfo.md]()

## What is DNA methylation

From [compgenomr](https://compgenomr.github.io/book/what-is-dna-methylation.html):  

**10.1 What is DNA methylation?**  
Cytosine methylation (5-methylcytosine, 5mC) is one of the main covalent base modifications in eukaryotic genomes, generally observed on CpG dinucleotides. Methylation can also rarely occur in a non-CpG context, but this was mainly observed in human embryonic stem and neuronal cells (Lister, Pelizzola, Dowen, et al. 2009; Lister, Mukamel, Nery, et al. 2013). DNA methylation is a part of the epigenetic regulation mechanism of gene expression. It is cell-type-specific DNA modification. It is reversible but mostly remains stable through cell division. There are roughly 28 million CpGs in the human genome, 60–80% are generally methylated. Less than 10% of CpGs occur in CG-dense regions that are termed CpG islands in the human genome (Smith and Meissner 2013). It has been demonstrated that DNA methylation is also not uniformly distributed over the genome, but rather is associated with CpG density. In vertebrate genomes, cytosine bases are usually unmethylated in CpG-rich regions such as CpG islands and tend to be methylated in CpG-deficient regions. Vertebrate genomes are largely CpG deficient except at CpG islands. **Conversely, invertebrates such as Drosophila melanogaster and Caenorhabditis elegans do not exhibit cytosine methylation and consequently do not have CpG rich and poor regions but rather a steady CpG frequency over their genomes (Deaton and Bird 2011).**

## How DNA Methylation Works

Diagram I made of methylation and de-methylation: found [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/Comprehensive-Exams/DNA-methylation/DNA_methylation_20201007.pdf).

From [compgenomr](https://compgenomr.github.io/book/what-is-dna-methylation.html):

**10.1.1 How DNA methylation is set?**  
DNA methylation is established by DNA methyltransferases DNMT3A and DNMT3B in combination with DNMT3L and maintained through cell division by the methyltransferase DNMT1 and associated proteins. DNMT3a and DNMT3b are in charge of the de novo methylation during early development. Loss of 5mC can be achieved passively by dilution during replication or exclusion of DNMT1 from the nucleus. Recent discoveries of the ten-eleven translocation (TET) family of proteins and their ability to convert 5-methylcytosine (5mC) into 5-hydroxymethylcytosine (5hmC) in vertebrates provide a path for catalyzed active DNA demethylation (Tahiliani, Koh, Shen, et al. 2009). Iterative oxidations of 5hmC catalyzed by TET result in 5-formylcytosine (5fC) and 5-carboxylcytosine (5caC). 5caC mark is excised from DNA by G/T mismatch-specific thymine-DNA glycosylase (TDG), which as a result reverts cytosine residue to its unmodified state (He, Li, Li, et al. 2011). Apart from these, mainly bacteria, but possibly higher eukaryotes, contain base modifications on bases other than cytosine, such as methylated adenine or guanine (Clark, Spittle, Turner, et al. 2011).

![meth-set](https://ars.els-cdn.com/content/image/1-s2.0-S0022283617300839-gr1.jpg)

## Location of methylation

**Invertebrates**: location is non-random and mainly located in gene bodies (Li et al 2018). *From Eirin-Lopez and Putnam 2019*: Additionally, DNA methylation can commonly be found in gene bodies, where it hypothetically contributes to the reduction of transcriptional variation, reduction of spurious transcription, and facilitation of alternative splicing (reviewed in Roberts & Gavery 2012). Methylation is spread evenly across a gene.

**Vertebrates**: located in promoters regions and usually associated with turning "on and off" genes or gene silencing. *From Eirin-Lopez and Putnam 2019*: Repetitive CpG sequences (CpG islands) can be found located upstream in promoter regions, and here the presence of methylation can silence transcription by blocking the binding of transcription factors (but see Ford et al. 2017).

*From Eirin-Lopez and Putnam 2019*: Beyond the coding portions of the genome, DNA methylation can also be associated with intergenic regions and transposable elements, contributing to the silencing of transposable elements and viral elements that would otherwise result in genome disruption by sequence and DNA mutation (Rey et al. 2016).

Differentially expressed methylated regions are not necessarily the same as differentially expressed genes (Li et al 2018). DNA methylation changes don't necessarily correlated with gene expression changes.

DNA Methylation location in invertebrates (Li et al 2018)
![location](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/Comprehensive-Exams/DNA-methylation/images/Li2018-fig1.jpg?raw=true)

## Gene body methylation is established and maintained as a result of active transcription  

Found in mouse embryonic stem cells: [insert citation and info]

Li et al 2018: as a result of active transcription by RNA polymerase II and recruitment of histone-modifying protein SetD2 that trimethylates histone H3 at lysine 36 (H3K36me3). This histone mark is bound via PWWP (Pro-Trp-Trp-Pro) domain present in DNA methyltransferase DNMT3b (de novo) which then methylates surrounding DNA.

**come back to the above to full explore**  
Sarda et al 2012

## DNA Methylation regulates transcriptional noise

DNA methylation regulates transcriptional homeostasis of algal symbiosis in the coral model Aiptasia ([Li et al 2018](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/Comprehensive-Exams/DNA-methylation/Li%20et%20al%202018.pdf)):  
- Methylated genes show significant reduction of spurius transcription and transcriptional noise.  
- Spurious transcription can produce partial transcripts that when translated results in truncated proteins that would interfere with native function.  
- Prefers CpG-poor regions  
- Gene body methylation is (+) correlated with expression: DNA methylation either: 1.) increases expression or 2.) is increased as a consequence of transcription.  

> Higher DNA methylation equals lower transcriptional variability.

## Methylation's role in differing life stages

Larvae and adult life stages can differ in methylation patterning:  
- Sea lamprey (Covelo-Soto et al 2015)

Sex determination linked to differential methylation patterns: Half-smooth tongue sole (Shao et al 2014), temperature-mediated sex determination in fish (Ellison et al 2015, Navarro-Martin et al 2011) and sea turtles (Venegas et al 2016).

## Methylation occurs in a bimodal distribution

Roberts & Gavery 2012

Dimond and Roberts 2016


## Coral methylation patterns are dynamic

Methylation profiles (RADSeq techniques) of *Porites asteroides* converged in a common garden setting (decreased in % methylated CpGs). Corals from several reefs in Belize were transplanted to a common garden for 1 year. Positive & significant relationship b/w genetic and epigenetic variation = evidence for methylation heritability. Differentially methylated loci = intracellular signaling, apoptosis, gene regulation, epigenetic crosstalk ([Dimond and Roberts 2019](https://www.frontiersin.org/articles/10.3389/fmars.2019.00792/full)).  
- calcium-independent protein kinase C-like: involved in intracellular signaling (typically associated with hypomethylation)  
- tax1-binding protein homolog: negative regulation of apoptotic processes via negative regulation of NF=kB transcription factor activity. Loss of symbionts is associated with elevated levels of NF-kB.  
- U5 small nuclear ribonucleoprotein 200 kDa helicase: mRNA splicing via role in the spliceosome.  
- putative FAM98A protein: positive regulation of cell proliferation, gene expression, and protein methylation.  

> The above functions seem to be housekeeping functions that were differentially methylated? This involved in heritability? Long term change in housekeeping methylation levels. Not short-term env. inducible?

In reduced pH conditions, *Montipora capitata* global methylation levels did not change, but *Pocillopora acuta*'s increased after 6 week exposure. Caveat: Mcap could have undergone increases and decreases that leveled out to an appearance of no response(Putnam et al 2016()).  

Dixon et al 2018

Increase in genome-wide methylation in *Stylophora pistillata* when exposed to pH conditions for 2 years. Changes modified gene expression and altered pathways in cell cycle regulation. [Liew et al 2018](https://advances.sciencemag.org/content/4/6/eaar8028/tab-pdf)

Dimond et al 2017

## Seasonal changes in methylation

*Acropora cervicornis*, over a 17-month period, displayed methylation changes that correlated to sea surface temperature change and this is consist across genets, source sites, and site-specific conditions. Methylation-Sensitive Amplified Polymorphism (MSAP) methods. ([Rodriquez-Casariego et al 2020](https://environmentalepigenetics.com/wp-content/uploads/2020/09/71_Rodriguez-Casariego_FMARS2020.pdf)).

## Ocean acidification induced methylation changes

([Venkataraman et al 2020](https://www.frontiersin.org/articles/10.3389/fmars.2020.00225/full)) description below.

7 day exposure to extremely elevated pCO2 conditions in pteropod resulted in reduced global methylation after 1 day exposure and leveled off to control after 6 days. MethylFlash Quantification Kit methods ([Bogan et al 2020](https://www.frontiersin.org/articles/10.3389/fmars.2019.00788/full)).


## Env2Methylation-Methylation2Phenotype

Ryu et al 2018  
Metzger & Schulte 2016   

## Methylation is modulator of alternative splicing

Lev Maor et al 2015

## Transgenerational methylation

Sea urchins were acclimated during gametogenesis in up-welling and non-upwelling conditions and progeny from these populations were raised in high and low pCO2 treatments. Sampled across 3 developmental stages. Differential progeny methylation correlated to differential paternal condition and progeny condition correlated very little to progeny methylation. Methods: Pico methyl-seq library prep kit, Illumina HiSeq4000 lanes ([Strader et al 2019](https://reader.elsevier.com/reader/sd/pii/S0022098118304428?token=7A673DBF0F9364D45CC3CA59338F1AD9F7BA84D41CFC4B2A716B9B82295F12545FE507016A8B3B4237FA9EC1E967E3E4&originRegion=us-east-1&originCreation=20210413191404)).

Liew et al 2018

Rondon et al 2017

Ocean acidification conditions for 28 days resulted in 598 differentially methylated loci (DML), mostly in exons. Changes seen in reproductive tissue in eastern oyster means that these changes could be inherited. Measured by MBD-BS methods. DML involved in protein ubiquitination ([Venkataraman et al 2020](https://www.frontiersin.org/articles/10.3389/fmars.2020.00225/full)).
