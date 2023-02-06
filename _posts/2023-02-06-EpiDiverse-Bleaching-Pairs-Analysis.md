---
layout: post
title: EpiDiverse Bleaching Pairs Analysis
date: '2023-02-06'
categories: Epidiverse, WGBS, methylation
tags: Epidiverse, WGBS, methylation
projects: KBay Bleaching Pairs
---

# EpiDiverse SNP Analysis for KBay Bleaching Pairs 

See WGBS pipeline for KBay Bleaching Pairs for starting input. 

#### Documentation 

- https://github.com/EpiDiverse/snp
- https://github.com/EpiDiverse/snp/blob/master/docs/usage.md (usage for options while running)

Workflow does the following: "The workflow pre-processes a collection of bam files from the EpiDiverse/WGBS pipeline using samtools, then masks genomic and/or bisulfite variation relative to the reference using custom scripts. Genomic masked alignments are then extracted into fastq format and tested for kmer diversity using kWIP for clustering groups. Bisulfite-masked alignments are taken forward for variant calling using a combination of [Freebayes](https://github.com/freebayes/freebayes) and post-call filtering with bcftools." 

![](https://github.com/EpiDiverse/snp/raw/master/docs/images/workflow.png)

[Freebayes](https://github.com/freebayes/freebayes) is a Bayesian genetic variant detector designed to find small polymorphisms, specifically SNPs (single-nucleotide polymorphisms), indels (insertions and deletions), MNPs (multi-nucleotide polymorphisms), and complex events (composite insertion and substitution events) smaller than the length of a short-read sequencing alignment. 

[Freebayes](https://github.com/freebayes/freebayes) uses short-read alignments (BAM files with Phred+33 encoded quality scores, now standard) for any number of individuals from a population and a reference genome (in FASTA format) to determine the most-likely combination of genotypes for the population at each position in the reference. It reports positions which it finds putatively polymorphic in variant call file (VCF) format. It can also use an input set of variants (VCF) as a source of prior information, and a copy number variant map (BED) to define non-uniform ploidy variation across the samples under analysis.

![](https://github.com/freebayes/freebayes/raw/v1.3.0/paper/haplotype_calling.png)

## Quick Start 

1. Install nextflow. https://www.nextflow.io/. This is a "workflow tool to run tasks across multiple compute infrastructures in a very portable manner. It comes with docker containers making installation trivial and results highly reproducible". Nextflow/22.04.0 downloaded to Andromeda already.
2. Install one of `docker`, `singularity`, or `conda`. 
3. Example code provided:

```
NXF_VER=20.07.1 nextflow run epidiverse/snp -profile <docker|singularity|conda> \
--input /path/to/wgbs/bam --reference /path/to/reference.fa
```

## Script 

`episnp.sh`:

```
#!/bin/bash
#SBATCH -t 100:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=128GB
#SBATCH --account=putnamlab
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_WGBS/EpiDiverse  
#SBATCH --error=output_messages/"%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output=output_messages/"%x_output.%j" #once your job is completed, any final job report comments will be put in this file

# load modules needed (specific need for my computer)
source /usr/share/Modules/init/sh # load the module function

# load modules needed
echo "START" $(date)
module load Nextflow/22.04.0

nextflow run epidiverse/snp \
-profile singularity \ 
--input /data/putnamlab/estrand/BleachingPairs_WGBS/BleachingPairs_methylseq_v3_2/bismark_deduplicated/*.bam \
--reference /data/putnamlab/estrand/Montipora_capitata_HIv3.assembly.fasta \
--output /data/putnamlab/estrand/BleachingPairs_WGBS/EpiDiverse \
--clusters \
--variants \
--coverage 5 \

echo "STOP" $(date) # this will output the time it takes to run within the output message
```

### Details 

Main command = `nextflow run epidiverse/snp [OPTIONS]` 

Input = `--input <ARG>` [required]: path to BAM files 
Reference genome == `--reference <ARG>`: fasta format of reference genome AND a corresponding fasta index *.fai file in the same location
Output directory == `--output <ARG>`: output directory path 

`-profile` = preset configuration options. https://app.gitbook.com/@epidiverse/s/project/epidiverse-pipelines/installation 

#### Modifiers 

If neither of the following two options are specified, the pipeline will run only the double-masking procedure and provide output bam files.

Run pipeline in variant calling mode. [default: off]: `--variants` 
Run pipeline in clustering mode. [default: off]: `--clusters` 

If `Variant Calling`:
- `--coverage <ARG>` [default = 0]
- `--ploidy <ARG>` [default = 2]
- `--regions <ARG>` [default = 100000]

I chose 5X coverage to reflect what we did in other scripts with this data. *Montipora capitata* genome is diploidy. If we do this with *Pocillopora acuta* genome, this will be triploidy (ARG = 3). 

`-resume [<ARG>]` : Specify this when restarting a pipeline. Nextflow will used cached results from any pipeline steps where the inputs are the same, continuing from where it got to previously. Give a specific pipeline name as an argument to resume it, otherwise Nextflow will resume the most recent. NOTE: This will not work if the specified run finished successfully and the cache was automatically cleared. (see: --debug)

## Files Created 

```
work/           # Directory containing the nextflow working files
snps/           # Finished results (configurable, see below)
.nextflow.log   # Log file from Nextflow
.nextflow/      # Nextflow cache and history information
```

~[](https://github.com/EpiDiverse/snp/blob/master/docs/images/directory.png)

*Below information from EpiDiverse github.* 

### 1. **Masking** 

After preprocessing input alignments (sort,calmd,index), nucleotide masking is performed either on bisulfite-converted positions or any genomic variation apparent in non-bisulfite contexts depending on whether the alignments should be used for variant calling, or sample clustering by k-mer similarity, respectively.

Output directory: `snps/bam/{clusters,variants}/`
- `*.bam`
- NB: Only saved if corresponding modes --clusters and/or --variants specified during pipeline run.

### 2. **Variant calling** 

Variant calling is performed with Freebayes, on whole genome bisulfite sequencing data which has been masked in bisulfite contexts and can be thus interpreted as normal sequencing data. Statistics are estimated with `bcftools stats` and plotted with `plot_vcfstats`.

Output directory: `snps/vcf/`

- `*.vcf.gz`

Full results from Freebayes (parallel), run using the following options:

- `--no-partial-observations`
- `--report-genotype-likelihood-max`
- `--genotype-qualities`
- `--min-repeat-entropy <ARG>`
- `--min-coverage <ARG>`

Output directory: `snps/stats/[SAMPLE]/`

![](https://github.com/EpiDiverse/snp/raw/master/docs/images/substitutions.png)

- `substitutions.png`: Overall counts for each substitution type.

![](https://github.com/EpiDiverse/snp/blob/master/docs/images/tstv_by_qual.png)

- `tstv_by_qual.png`: Overall transition/transversion ratio and counts by descending QUAL score

**Transition/transversion ratio** = ratio of the number of transitions to the number of transversions for a pair of sequences. 
- Transversion = The kind of base substitution in which a change in the DNA sequence is induced when purine base (A, G) is substituted by pyrimidine base (C, T) or vice versa. 
- Transition = Base subsitution in which a change in the DNA sequence is still in the original pyrmidine or purine group. i.e. Adenine changes to Guanine or Cytosine changes to Thymine. 

![](https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/All_transitions_and_transversions.svg/1200px-All_transitions_and_transversions.svg.png)

**QUAL** = phred-scaled quality score. High QUAL scores indicate high confidence calls. 

### 3. **khmer and kWIP** 

**kWIP** (k-mer weighted inner product) = This software implements a de novo, alignment free measure of sample genetic dissimilarity which operates upon raw sequencing reads. It is able to calculate the genetic dissimilarity between samples without any reference genome, and without assembling one. **kWIP** works by decomposing sequencing reads to short k-mers, hashing these k-mers and performing pairwise distance calculation between these sample k-mer hashes. kWIP uses [khmer](https://github.com/dib-lab/khmer) to hash sequencing reads. 

If `--clusters` has been specified during the pipeline run, then reads will be extracted from corresponding alignment files masking genomic variation, and ..

Output directory: `snps/`

![](https://github.com/EpiDiverse/snp/raw/master/docs/images/clustering.png)

`clustering.pdf`: Plots based on distance and kernel metrics from kWIP

**kernel metric** = similarity metric 

**k-mer** = sequence of k characters in a string (or nucleotides in a DNA sequence). Refers to all of a sequence's subsequences of length. For example:

Sequence: ATCGATCAC
3-mer #0: ATC
3-mer #1:  TCG
3-mer #2:   CGA
3-mer #3:    GAT
3-mer #4:     ATC
3-mer #5:      TCA
3-mer #6:       CAC

`kern.txt`: 

```
	sample4	sample2	sample5	sample1	sample6	sample3
sample4	1.34604e+07	6.22459e+06	4.36788e+06	4.66799e+06	5.61053e+06	8.39729e+06
sample2	6.22459e+06	1.20348e+07	2.69173e+06	3.49371e+06	4.32674e+06	7.43909e+06
sample5	4.36788e+06	2.69173e+06	8.6747e+06	2.83771e+06	3.45439e+06	4.39799e+06
sample1	4.66799e+06	3.49371e+06	2.83771e+06	6.48395e+06	3.57604e+06	5.13139e+06
sample6	5.61053e+06	4.32674e+06	3.45439e+06	3.57604e+06	8.81986e+06	6.17416e+06
sample3	8.39729e+06	7.43909e+06	4.39799e+06	5.13139e+06	6.17416e+06	1.64687e+07
```

`dist.txt`: 

```
	sample4	sample2	sample5	sample1	sample6	sample3
sample4	0	1.01088	1.09159	1.00033	0.98496	0.93380
sample2	1.01088	0	1.21372	1.09954	1.07707	0.97117
sample5	1.09159	1.21372	0	1.11501	1.10007	1.12432
sample1	1.00033	1.09954	1.11501	0	1.02676	1.00342
sample6	0.98496	1.07707	1.10007	1.02676	0	0.98763
sample3	0.93380	0.97117	1.12432	1.00342	0.98763	0
```

`hashes/*.ct.gz`: K-mer hashes for individual samples, derived from khmer

### 4. **Pipeline info** 

Output directory: `template/`

- `dag.svg`: DAG graph giving a diagrammatic view of the pipeline run. NB: If Graphviz was not installed when running the pipeline, this file will be in DOT format instead of SVG.
- `report.html`: Nextflow report describing parameters, computational resource usage and task bash commands used.
- `timeline.html`: A waterfall timeline plot showing the running times of the workflow tasks.
- `trace.txt`: A text file with machine-readable statistics about every task executed in the pipeline.