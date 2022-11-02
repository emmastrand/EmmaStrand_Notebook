---
layout: post
title: DNA Methylation Analysis Central Working Document
date: '2022-08-24'
categories: Processing
tags: DNA, methylation, bioinformatics
projects: Putnam Lab
---

# DNA Methylation Sequencing Analysis Central Document

This will be my working document to connect all the datasets and different analysis pipelines together. I'm working with 2 datasets for my own dissertation: Holobiont Integration and KBay Bleaching Pairs, and a separate project on oyster nutrition. 

![](https://www.creativebiomart.net/epigenetics/wp-content/themes/epigenetics/upload/images/DNA-Methylation-Analysis-Service-1.jpg)  
Diagram reference: Creative Biomart: Epigenetics

![](https://labster-image-manager.s3.amazonaws.com/18ddc19c-4564-44b4-a843-2ea5ceccb0d8/DNA_methylation.en.x512.png)  
Diagram reference: Labster Theory 

## Projects 

### Holobiont Integration (WGBS)

Adult *Pocillopora acuta* fragments from Kaneohe Bay, Hawai'i.

Github repo link: [here](https://github.com/hputnam/Acclim_Dynamics).

How do DNA methylation patterns in *Pocillopora acuta*: 
- Change with chronic stress treatments: temperature and ocean acidification? 
- Is there a core methylation pattern regardless of environmental change? 

How do DNA methylation patterns in Symbiodinaeceae *Cladocopium spp.*: 
- Change with chronic stress treatments: temperature and ocean acidification? 
- Is there a core methylation pattern regardless of environmental change? 

[Holobiont Integration WGBS pipeline](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-10-21-HoloInt-WGBS-Analysis-Pipeline.md )

### Diploidy vs Triploidy: Holobiont Integration (WGBS)

Adult *Pocillopora acuta* fragments from Kaneohe Bay, Hawai'i. 

No github repo link yet. 

How are DNA methylation patterns in *Pocillopora acuta* impacted by ploidy status? 

No pipeline link yet. 

### KBay Bleaching Pairs (WGBS)

Adult *Montipora capitata* fragments from Kaneohe Bay, Hawai'i.  

Github repo link: [here](https://github.com/hputnam/HI_Bleaching_Timeseries).

- How do DNA methylation patterns change during seasonal changes (July vs. December)?  
- How do DNA methylation patterns change pre- and post- bleaching event (July vs. December)? This may be hard to distinguish from the above question of seasonality..   
- Are there particular DNA methylation patterns that are associated with 'stronger' phenotypes?  

[KBay WGBS pipeline](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-10-21-KBay-Bleaching-Pairs-WGBS-Analysis-Pipeline.md)

### Point Judith, Rhode Island (MBD-BS)

Github repo link: [here](https://github.com/hputnam/Cvir_Nut_Int). 

Adult *C. virginica* oysters from gut tissue. How nutrient enrichment change (or not change) DNA methylation patterns? 

[Cvir MBD-BS pipeline](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-05-09-Point-Judith-Oyster-DNA-Methylation-(MBD-BS).md). 


## Resources on DNA methylation analysis 

- NF-Core methylseq pipeline: https://nf-co.re/methylseq/1.5/usage. This webpage from nf-core has been extremely helpful in learning all the flags and necessary parameters to use. 
- Bismark docs: http://felixkrueger.github.io/Bismark/Docs/. 
- Strand and Wong DNA methylation analysis guide: https://github.com/Putnam-Lab/Lab_Management/blob/master/Bioinformatics_%26_Coding/Workflows/Methylation_QC.md
- Wong (Porites asteroides) pipeline: https://github.com/kevinhwong1/Thermal_Transplant_Molecular/blob/main/scripts/Past_WGBS_Workflow.md
- Becker presentation from lab meeting 2021 on methylseq: https://docs.google.com/presentation/d/1qNMI2-LmyvqwNZ4J8FaHIg7d-niXm5jxEeeL1aobXeI/edit#slide=id.p4 
- Becker WGBS workflow (Pocillopora verrucosa): https://github.com/hputnam/Becker_E5/blob/master/Bioinformatics/Workflows/Becker_WGBS_Workflow.md
- Methods comparison (Trigg et al 2021): https://onlinelibrary.wiley.com/doi/pdf/10.1111/1755-0998.13542. 

### Reference Genomes Used

- *Pocillopora acuta*: http://cyanophora.rutgers.edu/Pocillopora_acuta/   
- *Porites asteroides*: https://www.biorxiv.org/content/10.1101/2022.07.01.498470v1.abstract 
- *Pocillopora verrucosa*: http://pver.reefgenomics.org/download/Pver_genome_assembly_v1.0.fasta.gz; [Buitrago-Lopez et al 2020](https://academic.oup.com/gbe/article/12/10/1911/5898631)
- *Montipora capitata*: http://cyanophora.rutgers.edu/montipora/
- *Crassostrea virginica*: https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/022/765/GCF_002022765.2_C_virginica-3.0/GCF_002022765.2_C_virginica-3.0_genomic.fna.gz

*Before using a reference genome, be sure to double check if there is a newer version released and how that will affect your pipeline.* 

## Lab work / Pre-bioinformatic processing 

### Whole Genome Bisulfite Sequencing 

- Pico Methyl Seqeuncing Kit testing: https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2020-10-21-WGBS-Pico-Methyl-Seq-Test-Run.md
- Holobiont Integration lab work (WGBS): https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-04-08-HoloInt-WGBS-Sample-Processing.md 
- KBay Bleaching Pairs lab work (WGBS; done by M. Schedl from Putnam Lab): https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-05-18-KBay-Dec-July-2019-WGBS.md

### Methyl Binding Domain Bisulfite Sequencing
  
- Protocol from M. Schedl in the Putnam Lab (work done for Cvir project): https://github.com/hputnam/Cvir_Nut_Int#m-schedl-mbdbs-library-preps 

