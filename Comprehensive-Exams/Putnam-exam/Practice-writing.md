# Practice writing questions

These are questions that I think may come up in the exam (or something close). Questions were not given to me beforehand.

Four main points to study (from HP):  
1. signal transduction pathways; feedback loops, specific examples  
2. alternative interpretations for why methylation might not be the only player  
3. epigenetics/methylation details and history of the field  
4. interaction between genetics for evolutionary outcomes


#### Practice questions

1. **Describe how a signal (like temperature) is translated to a physiological response, maintenance of homeostasis, and epigenetic changes.**

*Sensing and relaying the environmental signal (like temperature): signal transduction pathways*

Signal transduction pathways are made of a series of responses that starts with a signaling molecule that triggers a downstream activation of several response proteins that produce secondary messengers that then signal a change in cell proteins (and therefore gene expression and phenotype).

A change in temperature is sensed by temperature-sensing ion channel systems. This includes:  
1. transient receptor potential (TRP) cation channel subunits that are encoded by TRP genes. thermoTRPs are tuned to respond to either not harmful temperature fluctuations just beyond optimal range or potentially damaging temperature changes, and there are different types of thermoTRPs that vary in function: some detect mild heating, some extreme heating, and some the most extreme temperatures.  
2. cGMP-gated ion channels that respond to differences in [cGMP] (which varies with temperature).

Both channels are either opened or closed based on signal molecule, this is both a channel and a receptor. Activated thermoTRP channels result in depolarization of cellular membrane that then activates voltage-dependent ion channels and flushing the intracellular space/cytoplasm with calcium. The change in ionic calcium acts as a second messenger signal.

Second messengers are small enough to move through gap junctions in between cells, therefore signaling is shared among cell communities and extracellular signaling is amplified. Examples include ionic calcium and cyclic-AMP (cAMP). Messengers then activated cell proteins that alter gene expression and therefore phenotype.

Below is an example of a pathway in arthropods that is proposed to be the same in corals:  
1. Temperature sensed by ion channel system.  
2. This changes activity of a G-protein, which regulates activity of membrane-associated enzymes like phospholipase.  
3. Those enzymes drive production of soluble messengers like IP3 that cross the membrane of the ER to bind to IP3 gated calcium channels.  
4. The above channels open and allow calcium in the ER to flood into the cytoplasm and propogate effects of temperature.  

*Physiological response at a cellular level and maintenance of homeostasis.*

Part of the response to a change in temperature could be up-regulating an organism's cellular stress response, which includes the antioxidant system. In two lines of defense, the organism can reduce free radicals like superoxide to hydrogen peroxide via either Mn-SOD or Cu-Zn-SOD (superoxide dismutases) and reduce hydrogen peroxide to water via catalase, glutathione peroxidase (GPx), and peroxiredoxin (Prx). The organism can regulate this response on several levels: altering protein concentrations and expression, gene expression of a particular response, or regulating that gene expression further via epigenetic modifications.     

*Potential epigenetic changes due to the above physiological response.*  

DNA methylation in particular is triggered by higher gene expression, thus if an organism is using a particular gene set more often it would advantageous to add methyl groups to those gene bodies to more tightly regulate its expression. We know that DNA methylation patterning is dynamic in response to environmental stress or new conditions/environment (Putnam et al 2016, Dimond and Roberts 2019, Dixon et al 2018, Liew et al 2018).

2. **Describe the interactions between genetics and epigenetics, and the consequences for evolutionary outcomes. Explain the 'inherited gene regulation (IGR)' approach.**

The inherited gene regulation approach summarizes 'non-genetic' inheritance (NGI) and 'non-genetic' factors that alter genome activity and regulate gene expression, defined by three principles:  
1. 'non-genetic' factors are functionally interdependent with, rather than separate from, DNA sequence    
2. Mechanisms vary widely phylogenetically and operationally   
3. epigenetic elements are probabilistic, interactive regulatory factors and not deterministic 'epialleles' with defined genomic locations and effects.

Any NGI portion may be negative or positive. Methylation marks don't always mean a positive influence; especially if transmitted to offspring via germline.

*Epigenetic modifications are inherently genetic*  
Allelic variants and mutations can influence the genes that encode for the various enzymes involved in epigenetic pathways. And whether or not a methylation mark can depend on 1.) presence of CpG dinucleotides and the amount of CpG nucleotides in a genome can influence how much it is able to methylate (base composition), 2.) histone-modifying enzymes are recruited by transcription factors that can recognize DNA sequence motifs (location of target site matters). So this inherently also depends on the sequence available to methylate.  

*Widely diverse*

Difference in vertebrates and invertebrates: location and function of methylation, # of DMNT genes used (3 in mammalian vs. 5-12 in teleost fish), and erasure during germ cell development (paternal methylation conserved in zebrafish vs. erased in mammalians).

*Epigenetic mechanisms are facultative*

IGR mechanisms operate at larger genomic region scale - not nucleotide resolution (methylation marks altogether on a gene or promoter is important but an individual methylation mark on an exact nucleotide is usually irrelevant). 'Chromatin landscapes' are not generated by one mechanism alone: interplay of methylation, de-methylation on DNA and histones together. IGR patterning can be set over several generations; the effects of a grandparental organism can influence progeny several generations later.

Not the only player:  
- miRNAs, histone modifications, interplay of both.  
- gene duplication  
- horizontal gene transfer  
- allelic polymorphism  
- local adaptation  
- RNA editing: alternative splicing or changing base composition  
- protein function/flexibility  
- Plasticity: stress induced unmasking of cryptic genetic variation  
- Symbiosis with other organisms


3. **Describe the pathways involved in DNA methylation at a cellular level.**

DNA methylation refers to the addition of a methyl (CH3) group to a cytosine nucleotide to form 5-methyl-cytosine (5mc). Methylated cytosines usually occur in CpG dinucleotides and is carried out by several DNA methyltransferase enzymes (DNMTs). DNMT1 is responsible for maintenance of existing methylation marks, and DNMT3a/b function results in new (de novo) methylation. DMNTs (and histone methyl transferases - HMTs) receive a donor methyl group from the metabolite SAM. This pathway is energy intensive and requires folate and ATP for DMNT3s to add the methyl group to a cytosine. Removing a methylation can occur in either active or passive de-methylation. In active de-methylation, ten eleven translocation (TET) enzyme will use oxygen and alpha-ketoglutarate (aKG) metabolite to remove the methyl group and transform the cytosine to its original form. Passive de-methlation occurs when a methyl group is lost in several rounds of DNA replication and where DNMT1 does not maintain that mark. Because both DMNT and TET enzymes are metabolite-dependent, an organism needs to have enough energy from food and metabolic function to allocate to epigenetic processes.

In vertebrates, this functions like a transcription on and off switch, with DNA methylation located heavily on promoter regions and total methylation levels around 70-80%. In invertebrates, methylation patterns are spread out evenly across gene bodies with methylation levels ~16-18%, although variable across taxa in corals (Trigg et al 2021). Here methylation serves more as a gene expression regulatory mechanism and affects the choice of transcription initiation site rather than an on and off switch.mDNA methylation is a result of active transcription: higher expression levels will signal to the organism that more regulation is needed for that set of genes. Genes used more often and for daily function ("housekeeping genes") have historically higher methylation levels compared to those genes that aren't used as often or are environmentally inducible. This results in a bimodal distribution of CpG Observed/Expected values. Over time methylation causes hypermutation of cytosines to thymines, so when observing the number of CpG dinucleotides in a genome there will be a smaller CpG Observed/Expected value when historical methylation levels are high.

Once a methylation mark is set, enzymes like MBD proteins and zinc-finger proteins can read the methylation and carry out that influenced function.  

4. **Describe the history of the epigenetic field and starting theories on environmental epigenetics.**

Conrad Waddington (1930s - 1970s) synthesized field of genetics, embryology, and evolution; part of that was "epigenetic landscape" portrayed as inclined surfaces with cascade of ridges and valleys representing the "either/or" fate choices made by a developing cell. The idea that an embryo develops into several types of cells (somatic cells) from the same genetic material. Metaphor for the connection between genotype and phenotype. Captures the ability to be flexible and plastic when a cell develop or responds to a stimulus. 

5. **Classify three major issues of analysis and experiments moving forward in the field of epigenetics.**

1. Elucidating cause and effect relationships between epigenetic marks and environmental signals.  
2. How does this change in differing life stages and with cue predictability  
3. Interplay of epigenetic modifications (most studies can't measure all of them in the same context bc $$$)  
4. Demonstrating capacity for transgenerational inheritance (TGI)  
5. How do selection and epigenetic marks interact? How adaptive is epigenetics?
