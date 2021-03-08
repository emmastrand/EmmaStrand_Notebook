# DNA Methylation

A compilation of resources on understanding why the addition of that little methyl group matters.

## What is DNA methylation

From [compgenomr](https://compgenomr.github.io/book/what-is-dna-methylation.html):  

**10.1 What is DNA methylation?**  
Cytosine methylation (5-methylcytosine, 5mC) is one of the main covalent base modifications in eukaryotic genomes, generally observed on CpG dinucleotides. Methylation can also rarely occur in a non-CpG context, but this was mainly observed in human embryonic stem and neuronal cells (Lister, Pelizzola, Dowen, et al. 2009; Lister, Mukamel, Nery, et al. 2013). DNA methylation is a part of the epigenetic regulation mechanism of gene expression. It is cell-type-specific DNA modification. It is reversible but mostly remains stable through cell division. There are roughly 28 million CpGs in the human genome, 60–80% are generally methylated. Less than 10% of CpGs occur in CG-dense regions that are termed CpG islands in the human genome (Smith and Meissner 2013). It has been demonstrated that DNA methylation is also not uniformly distributed over the genome, but rather is associated with CpG density. In vertebrate genomes, cytosine bases are usually unmethylated in CpG-rich regions such as CpG islands and tend to be methylated in CpG-deficient regions. Vertebrate genomes are largely CpG deficient except at CpG islands. **Conversely, invertebrates such as Drosophila melanogaster and Caenorhabditis elegans do not exhibit cytosine methylation and consequently do not have CpG rich and poor regions but rather a steady CpG frequency over their genomes (Deaton and Bird 2011).**

## How DNA Methylation Works

Diagram I made of methylation and de-methylation: found [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/Comprehensive-Exams/DNA-methylation/DNA_methylation_20201007.pdf).

From [compgenomr](https://compgenomr.github.io/book/what-is-dna-methylation.html):

**10.1.1 How DNA methylation is set?**  
DNA methylation is established by DNA methyltransferases DNMT3A and DNMT3B in combination with DNMT3L and maintained through cell division by the methyltransferase DNMT1 and associated proteins. DNMT3a and DNMT3b are in charge of the de novo methylation during early development. Loss of 5mC can be achieved passively by dilution during replication or exclusion of DNMT1 from the nucleus. Recent discoveries of the ten-eleven translocation (TET) family of proteins and their ability to convert 5-methylcytosine (5mC) into 5-hydroxymethylcytosine (5hmC) in vertebrates provide a path for catalyzed active DNA demethylation (Tahiliani, Koh, Shen, et al. 2009). Iterative oxidations of 5hmC catalyzed by TET result in 5-formylcytosine (5fC) and 5-carboxylcytosine (5caC). 5caC mark is excised from DNA by G/T mismatch-specific thymine-DNA glycosylase (TDG), which as a result reverts cytosine residue to its unmodified state (He, Li, Li, et al. 2011). Apart from these, mainly bacteria, but possibly higher eukaryotes, contain base modifications on bases other than cytosine, such as methylated adenine or guanine (Clark, Spittle, Turner, et al. 2011).

## Bioinformatics pipelines

[DNA methylation analysis using bisulfite sequencing data](https://compgenomr.github.io/book/bsseq.html)  
