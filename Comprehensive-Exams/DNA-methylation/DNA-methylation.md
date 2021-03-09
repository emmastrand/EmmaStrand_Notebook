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

**Invertebrates**: location is non-random and mainly located in gene bodies (Li et al 2018). *From Eirin-Lopez and Putnam 2019*: Additionally, DNA methylation can commonly be found in gene bodies, where it hypothetically contributes to the reduction of transcriptional variation, reduction of spurious transcription, and facilitation of alternative splicing (reviewed in Roberts & Gavery 2012).   

**Vertebrates**: located in promoters regions and usually associated with turning "on and off" genes or gene silencing. *From Eirin-Lopez and Putnam 2019*: Repetitive CpG sequences (CpG islands) can be found located upstream in promoter regions, and here the presence of methylation can silence transcription by blocking the binding of transcription factors (but see Ford et al. 2017).

*From Eirin-Lopez and Putnam 2019*: Beyond the coding portions of the genome, DNA methylation can also be associated with intergenic regions and transposable elements, contributing to the silencing of transposable elements and viral elements that would otherwise result in genome disruption by sequence and DNA mutation (Rey et al. 2016).

Differentially expressed methylated regions are not necessarily the same as differentially expressed genes (Li et al 2018). DNA methylation changes don't necessarily correlated with gene expression changes.

DNA Methylation location in invertebrates (Li et al 2018)
![location](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/Comprehensive-Exams/DNA-methylation/images/Li2018-fig1.jpg?raw=true)

## Gene body methylation is established and maintained as a result of active transcription  

Found in mouse embryonic stem cells: [insert citation and info]

Li et al 2018: as a result of active transciption by RNA polymerase II and recruitment of histone-modifying protein SetD2 that trimethylates histone H3 at lysine 36 (H3K36me3). This histone mark is bound via PWWP (Pro-Trp-Trp-Pro) domain present in DNA methyltransferase DNMT3b (de novo) which then methylates surrounding DNA.

**come back to the above to full explore**

## DNA Methylation regulates transcriptional noise

DNA methylation regulates transcriptional homeostasis of algal symbiosis in the coral model Aiptasia ([Li et al 2018](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/Comprehensive-Exams/DNA-methylation/Li%20et%20al%202018.pdf)):  
- Methylated genes show significant reduction of spurius transcription and transcriptional noise.  
- Spurious transcription can produce partial transcripts that when translated results in truncated proteins that would interfere with native function.  
- Prefers CpG-poor regions  
- Gene body methylation is (+) correlated with expression: DNA methylation either: 1.) increases expression or 2.) is increased as a consequence of transcription.  

> Higher DNA methylation equals lower transcriptional variability.

## Methylation's role in differing life stages

Sex determination linked to differential methylation patterns: Half-smooth tongue sole (Shao et al 2014), 
