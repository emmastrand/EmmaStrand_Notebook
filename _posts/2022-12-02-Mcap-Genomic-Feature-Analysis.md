---
layout: post
title: Mcap Genomic Feature Analysis
date: '2022-12-02'
categories: Analysis
tags: methylation, mcap, genomic-feature
projects: Bleaching Pairs
---

# Genomic Feature Analysis: M. capitata

Prior to this script, run methylseq on raw sequences files: https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-10-21-HoloInt-WGBS-Analysis-Pipeline.md

References:

Kevin Wong's pipeline: https://github.com/kevinhwong1/Thermal_Transplant_Molecular/blob/main/scripts/Past_Genomic_Feature_Analysis_20221014.md#char_gene
Yaamini's pipeline: https://github.com/hputnam/Meth_Compare/blob/master/code/03.01-Generating-Genome-Feature-Tracks.ipynb

## Setting Up Andromeda

`mkdir mkdir genomic_feature` in `/data/putnamlab/estrand/BleachingPairs_WGBS` path. 

### Resources

https://bedtools.readthedocs.io/en/latest/content/general-usage.html

We are using bedtools but the function 'sort' independently is from UNIX and will sort a BED file by chromosome then by start position in the following manner:

```
sort -k 1,1 -k2,2n a.bed
chr1 1   10
chr1 80  180
chr1 750 10000
chr1 800 1000
```

## Prepare reference file

http://www.htslib.org/doc/faidx.html

```
interactive 

module load SAMtools/1.9-foss-2018b

# create a fasta index file called that has the chromosome ID and length
samtools faidx Montipora_capitata_HIv3.assembly.fasta

# Double checking lengths: obtain sequence lengths for each "chromosome"
awk '$0 ~ ">" {print c; c=0;printf substr($0,2,100) "\t"; } $0 !~ ">" {c+=length($0);} END { print c; }' \
Montipora_capitata_HIv3.assembly.fasta \
> Mcap.v3.genome_assembly-sequence-lengths.txt
```

`Mcap.v3.genome_assembly-sequence-lengths.txt`:

```
Montipora_capitata_HIv3___Scaffold_1    48529999
Montipora_capitata_HIv3___Scaffold_2    53177999
Montipora_capitata_HIv3___Scaffold_3    47342999
Montipora_capitata_HIv3___Scaffold_4    47716837
Montipora_capitata_HIv3___Scaffold_5    62411161
Montipora_capitata_HIv3___Scaffold_6    38979999
Montipora_capitata_HIv3___Scaffold_7    22000686
Montipora_capitata_HIv3___Scaffold_8    68683312
Montipora_capitata_HIv3___Scaffold_9    36520733
```

This is the same as the first column of fai file.

## Genome annotation file

file = `Montipora_capitata_HIv3.genes.gff3`:

```
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        transcript      27295   28641   .       -       .       ID=Montipora_capitata_HIv3___RNAseq.g37162.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        CDS     27295   28641   .       -       0       Parent=Montipora_capitata_HIv3___RNAseq.g37162.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        exon    27295   28641   .       -       0       Parent=Montipora_capitata_HIv3___RNAseq.g37162.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        transcript      40222   40725   .       -       .       ID=Montipora_capitata_HIv3___TS.g29675.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        CDS     40222   40725   .       -       0       Parent=Montipora_capitata_HIv3___TS.g29675.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        exon    40222   40725   .       -       0       Parent=Montipora_capitata_HIv3___TS.g29675.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        transcript      40811   41590   .       -       .       ID=Montipora_capitata_HIv3___TS.g29676.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        CDS     40811   41068   .       -       0       Parent=Montipora_capitata_HIv3___TS.g29676.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        exon    40811   41068   .       -       0       Parent=Montipora_capitata_HIv3___TS.g29676.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        CDS     41213   41590   .       -       0       Parent=Montipora_capitata_HIv3___TS.g29676.t1
```

## Filtering GFF for specific features

**File doesn't have introns..** 

### 1. Transcript 

`awk '{if ($3 == "transcript") print $0;}' ../../Montipora_capitata_HIv3.genes.gff3 > Montipora_capitata_HIv3.genes.transcript.gff3`

```
wc -l Montipora_capitata_HIv3.genes.transcript.gff3
54384 Montipora_capitata_HIv3.genes.transcript.gff3
```

```
head 

Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        transcript      27295   28641   .       -       .       ID=Montipora_capitata_HIv3___RNAseq.g37162.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        transcript      40222   40725   .       -       .       ID=Montipora_capitata_HIv3___TS.g29675.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        transcript      40811   41590   .       -       .       ID=Montipora_capitata_HIv3___TS.g29676.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        transcript      42258   43409   .       -       .       ID=Montipora_capitata_HIv3___TS.g29677.t1d
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        transcript      46906   47900   .       -       .       ID=Montipora_capitata_HIv3___TS.g29677.t1c
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        transcript      51776   52912   .       -       .       ID=Montipora_capitata_HIv3___TS.g29677.t1b
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        transcript      52946   54988   .       -       .       ID=Montipora_capitata_HIv3___TS.g29677.t1a
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        transcript      86103   150739  .       -       .       ID=Montipora_capitata_HIv3___RNAseq.g37168.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        transcript      117770  118084  .       -       .       ID=Montipora_capitata_HIv3___TS.g29678.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        transcript      118221  121020  .       +       .       ID=Montipora_capitata_HIv3___TS.g29679.t1
```

### 2. CDS

`awk '{if ($3 == "CDS") print $0;}' ../../Montipora_capitata_HIv3.genes.gff3 > Montipora_capitata_HIv3.genes.cds.gff3`

```
wc -l Montipora_capitata_HIv3.genes.cds.gff3
256031 Montipora_capitata_HIv3.genes.cds.gff3

head Montipora_capitata_HIv3.genes.cds.gff3

Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        CDS     27295   28641   .       -       0       Parent=Montipora_capitata_HIv3___RNAseq.g37162.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        CDS     40222   40725   .       -       0       Parent=Montipora_capitata_HIv3___TS.g29675.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        CDS     40811   41068   .       -       0       Parent=Montipora_capitata_HIv3___TS.g29676.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        CDS     41213   41590   .       -       0       Parent=Montipora_capitata_HIv3___TS.g29676.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        CDS     42258   43409   .       -       0       Parent=Montipora_capitata_HIv3___TS.g29677.t1d
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        CDS     46906   46994   .       -       2       Parent=Montipora_capitata_HIv3___TS.g29677.t1c
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        CDS     47645   47900   .       -       0       Parent=Montipora_capitata_HIv3___TS.g29677.t1c
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        CDS     51776   52912   .       -       0       Parent=Montipora_capitata_HIv3___TS.g29677.t1b
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        CDS     52946   54988   .       -       0       Parent=Montipora_capitata_HIv3___TS.g29677.t1a
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        CDS     86103   86152   .       -       2       Parent=Montipora_capitata_HIv3___RNAseq.g37168.t1
```

### 3. Exon

`awk '{if ($3 == "exon") print $0;}' ../../Montipora_capitata_HIv3.genes.gff3 > Montipora_capitata_HIv3.genes.exon.gff3`

```
wc -l Montipora_capitata_HIv3.genes.exon.gff3
256031 Montipora_capitata_HIv3.genes.exon.gff3

Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        exon    27295   28641   .       -       0       Parent=Montipora_capitata_HIv3___RNAseq.g37162.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        exon    40222   40725   .       -       0       Parent=Montipora_capitata_HIv3___TS.g29675.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        exon    40811   41068   .       -       0       Parent=Montipora_capitata_HIv3___TS.g29676.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        exon    41213   41590   .       -       0       Parent=Montipora_capitata_HIv3___TS.g29676.t1
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        exon    42258   43409   .       -       0       Parent=Montipora_capitata_HIv3___TS.g29677.t1d
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        exon    46906   46994   .       -       2       Parent=Montipora_capitata_HIv3___TS.g29677.t1c
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        exon    47645   47900   .       -       0       Parent=Montipora_capitata_HIv3___TS.g29677.t1c
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        exon    51776   52912   .       -       0       Parent=Montipora_capitata_HIv3___TS.g29677.t1b
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        exon    52946   54988   .       -       0       Parent=Montipora_capitata_HIv3___TS.g29677.t1a
Montipora_capitata_HIv3___Scaffold_12   AUGUSTUS        exon    86103   86152   .       -       2       Parent=Montipora_capitata_HIv3___RNAseq.g37168.t1
```

### 4. Flanks

Sort file: 

`sort -i Montipora_capitata_HIv3.genes.transcript.gff3 > Montipora_capitata_HIv3.genes.transcript_sorted.gff3` 

```
Montipora_capitata_HIv3___Scaffold_1000 AUGUSTUS        transcript      21009   23712   .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g3986.t1
Montipora_capitata_HIv3___Scaffold_1001 AUGUSTUS        transcript      14196   21833   .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g4276.t1
Montipora_capitata_HIv3___Scaffold_1003 AUGUSTUS        transcript      16446   24147   .       -       .       ID=Montipora_capitata_HIv3___RNAseq.g15523.t1
Montipora_capitata_HIv3___Scaffold_1003 AUGUSTUS        transcript      21159   21866   .       +       .       ID=Montipora_capitata_HIv3___TS.g14206.t1
Montipora_capitata_HIv3___Scaffold_1004 AUGUSTUS        transcript      1740    1997    .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g3848.t1
Montipora_capitata_HIv3___Scaffold_1004 AUGUSTUS        transcript      2104    3014    .       +       .       ID=Montipora_capitata_HIv3___TS.g20461.t1
Montipora_capitata_HIv3___Scaffold_1004 AUGUSTUS        transcript      7692    23873   .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g3851.t1
Montipora_capitata_HIv3___Scaffold_1006 AUGUSTUS        transcript      13419   19921   .       -       .       ID=Montipora_capitata_HIv3___RNAseq.g45732.t1
Montipora_capitata_HIv3___Scaffold_1006 AUGUSTUS        transcript      5652    7658    .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g45731.t1
Montipora_capitata_HIv3___Scaffold_1007 AUGUSTUS        transcript      16164   17335   .       -       .       ID=Montipora_capitata_HIv3___RNAseq.g40069.t2
```

https://bedtools.readthedocs.io/en/latest/content/tools/flank.html

https://bedtools.readthedocs.io/en/latest/content/tools/flank.html. 1000 on either side of the region

https://bedtools.readthedocs.io/en/latest/content/tools/subtract.html

BEDTools/2.30.0-GCC-11.2.0

Create 1kb flanking regions. Subtract existing genes so flanks do not have any overlap.

```
interactive 

module load BEDTools/2.27.1-foss-2018b 

flankBed \
-i Montipora_capitata_HIv3.genes.transcript_sorted.gff3 \
-g ../../Montipora_capitata_HIv3.assembly.fasta.fai \
-b 1000 \
| subtractBed \
-a - \
-b Montipora_capitata_HIv3.genes.transcript_sorted.gff3 \
> Montipora_capitata_HIv3.flanks.gff
```

`wc -l Montipora_capitata_HIv3.flanks.gff`: 110436

head `Montipora_capitata_HIv3.flanks.gff`:

```
Montipora_capitata_HIv3___Scaffold_1000 AUGUSTUS        transcript      20009   21008   .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g3986.t1
Montipora_capitata_HIv3___Scaffold_1000 AUGUSTUS        transcript      23713   24712   .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g3986.t1
Montipora_capitata_HIv3___Scaffold_1001 AUGUSTUS        transcript      13196   14195   .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g4276.t1
Montipora_capitata_HIv3___Scaffold_1001 AUGUSTUS        transcript      21834   22833   .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g4276.t1
Montipora_capitata_HIv3___Scaffold_1003 AUGUSTUS        transcript      15446   16445   .       -       .       ID=Montipora_capitata_HIv3___RNAseq.g15523.t1
Montipora_capitata_HIv3___Scaffold_1003 AUGUSTUS        transcript      24148   25137   .       -       .       ID=Montipora_capitata_HIv3___RNAseq.g15523.t1
Montipora_capitata_HIv3___Scaffold_1004 AUGUSTUS        transcript      740     1739    .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g3848.t1
Montipora_capitata_HIv3___Scaffold_1004 AUGUSTUS        transcript      1998    2103    .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g3848.t1
Montipora_capitata_HIv3___Scaffold_1004 AUGUSTUS        transcript      1104    1739    .       +       .       ID=Montipora_capitata_HIv3___TS.g20461.t1
Montipora_capitata_HIv3___Scaffold_1004 AUGUSTUS        transcript      1998    2103    .       +       .       ID=Montipora_capitata_HIv3___TS.g20461.t1
```

### 5. Upstream flanks

```
interactive 

module load BEDTools/2.27.1-foss-2018b 

flankBed \
-i Montipora_capitata_HIv3.genes.transcript_sorted.gff3 \
-g ../../Montipora_capitata_HIv3.assembly.fasta.fai \
-l 1000 \
-r 0 \
-s \
| subtractBed \
-a - \
-b Montipora_capitata_HIv3.genes.transcript_sorted.gff3 \
> Montipora_capitata_HIv3.flanks.Upstream.gff
```

`wc -l Montipora_capitata_HIv3.flanks.Upstream.gff`: 55272

`head Montipora_capitata_HIv3.flanks.Upstream.gff`

```
Montipora_capitata_HIv3___Scaffold_1000 AUGUSTUS        transcript      20009   21008   .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g3986.t1
Montipora_capitata_HIv3___Scaffold_1001 AUGUSTUS        transcript      13196   14195   .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g4276.t1
Montipora_capitata_HIv3___Scaffold_1003 AUGUSTUS        transcript      24148   25137   .       -       .       ID=Montipora_capitata_HIv3___RNAseq.g15523.t1
Montipora_capitata_HIv3___Scaffold_1004 AUGUSTUS        transcript      740     1739    .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g3848.t1
Montipora_capitata_HIv3___Scaffold_1004 AUGUSTUS        transcript      1104    1739    .       +       .       ID=Montipora_capitata_HIv3___TS.g20461.t1
Montipora_capitata_HIv3___Scaffold_1004 AUGUSTUS        transcript      1998    2103    .       +       .       ID=Montipora_capitata_HIv3___TS.g20461.t1
Montipora_capitata_HIv3___Scaffold_1004 AUGUSTUS        transcript      6692    7691    .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g3851.t1
Montipora_capitata_HIv3___Scaffold_1006 AUGUSTUS        transcript      19922   20921   .       -       .       ID=Montipora_capitata_HIv3___RNAseq.g45732.t1
Montipora_capitata_HIv3___Scaffold_1006 AUGUSTUS        transcript      4652    5651    .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g45731.t1
Montipora_capitata_HIv3___Scaffold_1007 AUGUSTUS        transcript      17336   18335   .       -       .       ID=Montipora_capitata_HIv3___RNAseq.g40069.t2
```

### 6. Downstream flanks

```
interactive 

module load BEDTools/2.27.1-foss-2018b 

flankBed \
-i Montipora_capitata_HIv3.genes.transcript_sorted.gff3 \
-g ../../Montipora_capitata_HIv3.assembly.fasta.fai \
-l 0 \
-r 1000 \
-s \
| subtractBed \
-a - \
-b Montipora_capitata_HIv3.genes.transcript_sorted.gff3 \
> Montipora_capitata_HIv3.flanks.Downstream.gff
```

`head Montipora_capitata_HIv3.flanks.Downstream.gff`: 

```
Montipora_capitata_HIv3___Scaffold_1000 AUGUSTUS        transcript      23713   24712   .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g3986.t1
Montipora_capitata_HIv3___Scaffold_1001 AUGUSTUS        transcript      21834   22833   .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g4276.t1
Montipora_capitata_HIv3___Scaffold_1003 AUGUSTUS        transcript      15446   16445   .       -       .       ID=Montipora_capitata_HIv3___RNAseq.g15523.t1
Montipora_capitata_HIv3___Scaffold_1004 AUGUSTUS        transcript      1998    2103    .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g3848.t1
Montipora_capitata_HIv3___Scaffold_1004 AUGUSTUS        transcript      3015    4014    .       +       .       ID=Montipora_capitata_HIv3___TS.g20461.t1
Montipora_capitata_HIv3___Scaffold_1004 AUGUSTUS        transcript      23874   24873   .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g3851.t1
Montipora_capitata_HIv3___Scaffold_1006 AUGUSTUS        transcript      12419   13418   .       -       .       ID=Montipora_capitata_HIv3___RNAseq.g45732.t1
Montipora_capitata_HIv3___Scaffold_1006 AUGUSTUS        transcript      7659    8658    .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g45731.t1
Montipora_capitata_HIv3___Scaffold_1007 AUGUSTUS        transcript      15164   16163   .       -       .       ID=Montipora_capitata_HIv3___RNAseq.g40069.t2
Montipora_capitata_HIv3___Scaffold_1007 AUGUSTUS        transcript      1       939     .       -       .       ID=Montipora_capitata_HIv3___RNAseq.g40068.t1
```

`wc -l Montipora_capitata_HIv3.flanks.Downstream.gff`: 55168


### 7. Intergenic regions

https://bedtools.readthedocs.io/en/latest/content/tools/complement.html

https://davetang.org/muse/2013/01/18/defining-genomic-regions/

```
interactive 

module load BEDTools/2.27.1-foss-2018b 

complementBed \
-i Montipora_capitata_HIv3.genes.transcript_sorted2.gff3 \
-g ../../Montipora_capitata_HIv3.assembly.fasta.fai \
| subtractBed \
-a - \
-b Montipora_capitata_HIv3.flanks.gff \
| awk '{print $1"\t"$2"\t"$3}' \
> Montipora_capitata_HIv3.intergenic.bed
```

Error: 

```
Error: Sorted input specified, but the file Montipora_capitata_HIv3.genes.transcript_sorted.gff3 has the following out of order record
Montipora_capitata_HIv3___Scaffold_1006 AUGUSTUS        transcript      5652    7658    .       +       .       ID=Montipora_capitata_HIv3___RNAseq.g45731.t1
```

## Create CpG motifs

```
interactive

module load EMBOSS/6.6.0-foss-2018b

fuzznuc \
-sequence ../../Montipora_capitata_HIv3.assembly.fasta \
-pattern CG \
-outfile Mcapitata_v3_CpG.gff \
-rformat gff
```

`head Mcapitata_v3_CpG.gff`:

```
##gff-version 3
##sequence-region Montipora_capitata_HIv3___Scaffold_1 1 48529999
#!Date 2022-12-02
#!Type DNA
#!Source-version EMBOSS 6.6.0.0
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        12      13      2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.1;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        74      75      2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.2;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        99      100     2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.3;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        111     112     2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.4;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        132     133     2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.5;note=*pat pattern:CG
```

## Characterize CG motif locations in feature tracks

### 1. Transcript 

```
interactive
module load BEDTools/2.27.1-foss-2018b

intersectBed \
-u \
-a Mcapitata_v3_CpG.gff \
-b Montipora_capitata_HIv3.genes.transcript.gff3 \
> Mcap-CGMotif-Transcript-Overlaps.txt
```

head -5 `Mcap-CGMotif-Transcript-Overlaps.txt`:

```
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        22736   22737   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.816;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        22745   22746   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.817;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        22756   22757   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.818;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        22771   22772   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.819;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        22799   22800   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.820;note=*pat pattern:CG
```

`wc -l Mcap-CGMotif-Transcript-Overlaps.txt`: 11342754

### 2. CDS

```
interactive
module load BEDTools/2.27.1-foss-2018b

intersectBed \
-u \
-a Mcapitata_v3_CpG.gff \
-b Montipora_capitata_HIv3.genes.cds.gff3 \
> Mcap-CGMotif-CDS-Overlaps.txt
```

head -5 `Mcap-CGMotif-CDS-Overlaps.txt`:

```
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        22736   22737   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.816;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        22745   22746   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.817;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        22756   22757   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.818;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        22771   22772   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.819;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        22799   22800   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.820;note=*pat pattern:CG
```

`wc -l Mcap-CGMotif-CDS-Overlaps.txt`: 2086191

### 3. Flanks 

```
interactive
module load BEDTools/2.27.1-foss-2018b

intersectBed \
-u \
-a Mcapitata_v3_CpG.gff \
-b Montipora_capitata_HIv3.flanks.gff \
> Mcap-CGMotif-Flanks-Overlaps.txt
```

head -5 `Mcap-CGMotif-Flanks-Overlaps.txt`:

```
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        21738   21739   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.770;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        21744   21745   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.771;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        21778   21779   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.772;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        21782   21783   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.773;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        21791   21792   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.774;note=*pat pattern:CG
```

`wc -l Mcap-CGMotif-Flanks-Overlaps.txt`: 2658192

### 4. Upstream Flanks 

```
interactive
module load BEDTools/2.27.1-foss-2018b

intersectBed \
-u \
-a Mcapitata_v3_CpG.gff \
-b Montipora_capitata_HIv3.flanks.Upstream.gff \
> Mcap-CGMotif-UpstreamFlanks-Overlaps.txt
```

head -5 `Mcap-CGMotif-UpstreamFlanks-Overlaps.txt`:

```
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        36193   36194   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.1232;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        36200   36201   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.1233;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        36208   36209   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.1234;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        36227   36228   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.1235;note=*pat pattern:CG
Montipora_capitata_HIv3___Scaffold_1    fuzznuc nucleotide_motif        36239   36240   2       +       .       ID=Montipora_capitata_HIv3___Scaffold_1.1236;note=*pat pattern:CG
```

`wc -l Mcap-CGMotif-UpstreamFlanks-Overlaps.txt`: 1446369

### 5. Downstream Flanks

```
interactive
module load BEDTools/2.27.1-foss-2018b

intersectBed \
-u \
-a Mcapitata_v3_CpG.gff \
-b Montipora_capitata_HIv3.flanks.Downstream.gff \
> Mcap-CGMotif-DownstreamFlanks-Overlaps.txt
```

Error: 

```
ERROR: Received illegal bin number 4294967295 from getBin call.
ERROR: Unable to add record to tree.
```

*We only use the gff file created from this in further steps so I think this is OK to leave for now..* 

### 6. Intergenic Region

Come back to this.. the last command didn't work. 

### Create summary file

`wc -l *CGMotif* > Mcap-v3-CGMotif-Overlaps-counts.txt`

### Export files 

scp emma_strand@ssh3.hac.uri.edu:/data/putnamlab/estrand/BleachingPairs_WGBS/genomic_feature/Mcap-v3-CGMotif-Overlaps-counts.txt ~/MyProjects/HI_Bleaching_Timeseries/Dec-July-2019-analysis/output/WGBS/genomic_feature/

## Organize coverage files

`wc -l /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*5x_sorted.bedgraph > Mcap-v3-5x-bedgraph-counts.txt`

```
head Mcap-v3-5x-bedgraph-counts.txt

   10795712 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph
    9475520 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/17_S134_5x_sorted.bedgraph
   10544006 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/18_S154_5x_sorted.bedgraph
   11086014 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/21_S119_5x_sorted.bedgraph
    8324187 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/22_S120_5x_sorted.bedgraph
    9565847 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/23_S141_5x_sorted.bedgraph
    7217442 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/24_S147_5x_sorted.bedgraph
   15508592 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/25_S148_5x_sorted.bedgraph
    6679878 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/26_S121_5x_sorted.bedgraph
   13129157 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/28_S122_5x_sorted.bedgraph
```

`wc -l /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*10x_sorted.bedgraph > Mcap-v3-10x-bedgraph-counts.txt`

```
head Mcap-v3-10x-bedgraph-counts.txt

   2849086 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph
   1898361 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/17_S134_10x_sorted.bedgraph
   2928908 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/18_S154_10x_sorted.bedgraph
   3191365 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/21_S119_10x_sorted.bedgraph
   1454107 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/22_S120_10x_sorted.bedgraph
   1885121 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/23_S141_10x_sorted.bedgraph
   1044970 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/24_S147_10x_sorted.bedgraph
   9192668 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/25_S148_10x_sorted.bedgraph
    839032 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/26_S121_10x_sorted.bedgraph
   5449797 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/28_S122_10x_sorted.bedgraph
```

### Export to computer 

```
scp emma_strand@ssh3.hac.uri.edu:/data/putnamlab/estrand/BleachingPairs_WGBS/genomic_feature/Mcap-v3-10x-bedgraph-counts.txt ~/MyProjects/HI_Bleaching_Timeseries/Dec-July-2019-analysis/output/WGBS/genomic_feature/
```

## Characterize methylation for each CpG dinucleotide

Methylated: > 50% methylation Sparsely methylated: 10-50% methylation Unmethylated: < 10% methylation

`characterize-meth.sh`: (~20 min)

```
#!/bin/bash
#SBATCH --job-name="ch-meth"
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=128GB
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_WGBS/genomic_feature
#SBATCH --cpus-per-task=3
#SBATCH --error="%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output="%x_output.%j" #once your job is completed, any final job report comments will be put in this file

## Methylated

# 5X
for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*5x_sorted.bedgraph
do
    awk '{if ($4 >= 50) { print $1, $2, $3, $4 }}' ${f} \
    > ${f}-Meth
done

wc -l /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*5x_sorted.bedgraph-Meth > Mcap-v3-5x-Meth-counts.txt

#10X
for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*10x_sorted.bedgraph
do
    awk '{if ($4 >= 50) { print $1, $2, $3, $4 }}' ${f} \
    > ${f}-Meth
done

wc -l /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*10x_sorted.bedgraph-Meth > Mcap-v3-10x-Meth-counts.txt

## Sparsely methylated

# 5X 
for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*5x_sorted.bedgraph
do
    awk '{if ($4 < 50) { print $1, $2, $3, $4}}' ${f} \
    | awk '{if ($4 > 10) { print $1, $2, $3, $4 }}' \
    > ${f}-sparseMeth
done

wc -l /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*5x_sorted.bedgraph-sparseMeth > Mcap-v3-5x-sparseMeth-counts.txt

# 10X
for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*10x_sorted.bedgraph
do
    awk '{if ($4 < 50) { print $1, $2, $3, $4}}' ${f} \
    | awk '{if ($4 > 10) { print $1, $2, $3, $4 }}' \
    > ${f}-sparseMeth
done

wc -l /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*10x_sorted.bedgraph-sparseMeth > Mcap-v3-10x-sparseMeth-counts.txt

## Unmethylated

# 5X 
for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*5x_sorted.bedgraph
do
    awk '{if ($4 <= 10) { print $1, $2, $3, $4 }}' ${f} \
    > ${f}-unMeth
done

wc -l /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*5x_sorted.bedgraph-unMeth > Mcap-v3-5x-unMeth-counts.txt

# 10X
for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*10x_sorted.bedgraph
do
    awk '{if ($4 <= 10) { print $1, $2, $3, $4 }}' ${f} \
    > ${f}-unMeth
done

wc -l /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*10x_sorted.bedgraph-unMeth > Mcap-v3-10x-unMeth-counts.txt
```

`head 31_S127_10x_sorted.bedgraph-Meth`:

```
Montipora_capitata_HIv3___Scaffold_1 125094 125096 81.818182
Montipora_capitata_HIv3___Scaffold_1 125100 125102 100.000000
Montipora_capitata_HIv3___Scaffold_1 155639 155641 70.000000
Montipora_capitata_HIv3___Scaffold_1 155642 155644 70.000000
Montipora_capitata_HIv3___Scaffold_1 155647 155649 70.000000
Montipora_capitata_HIv3___Scaffold_1 1941113 1941115 50.000000
Montipora_capitata_HIv3___Scaffold_1 2219657 2219659 100.000000
Montipora_capitata_HIv3___Scaffold_1 2219702 2219704 100.000000
Montipora_capitata_HIv3___Scaffold_1 2496356 2496358 100.000000
Montipora_capitata_HIv3___Scaffold_1 2496366 2496368 100.000000
```

`head 31_S127_5x_sorted.bedgraph-sparseMeth`:

```
Montipora_capitata_HIv3___Scaffold_1 19435 19437 20.000000
Montipora_capitata_HIv3___Scaffold_1 19470 19472 20.000000
Montipora_capitata_HIv3___Scaffold_1 45037 45039 16.666667
Montipora_capitata_HIv3___Scaffold_1 46738 46740 16.666667
Montipora_capitata_HIv3___Scaffold_1 55009 55011 33.333333
Montipora_capitata_HIv3___Scaffold_1 55031 55033 33.333333
Montipora_capitata_HIv3___Scaffold_1 55086 55088 40.000000
Montipora_capitata_HIv3___Scaffold_1 55240 55242 16.666667
Montipora_capitata_HIv3___Scaffold_1 55323 55325 40.000000
Montipora_capitata_HIv3___Scaffold_1 55329 55331 40.000000
```

`head 31_S127_5x_sorted.bedgraph-unMeth`:

```
Montipora_capitata_HIv3___Scaffold_1 15484 15486 0.000000
Montipora_capitata_HIv3___Scaffold_1 15488 15490 0.000000
Montipora_capitata_HIv3___Scaffold_1 15512 15514 0.000000
Montipora_capitata_HIv3___Scaffold_1 15526 15528 0.000000
Montipora_capitata_HIv3___Scaffold_1 15532 15534 0.000000
Montipora_capitata_HIv3___Scaffold_1 23208 23210 0.000000
Montipora_capitata_HIv3___Scaffold_1 24442 24444 0.000000
Montipora_capitata_HIv3___Scaffold_1 24488 24490 0.000000
Montipora_capitata_HIv3___Scaffold_1 24543 24545 0.000000
Montipora_capitata_HIv3___Scaffold_1 25426 25428 0.000000
```

`head Mcap-v2-10x-unMeth-counts.txt`: 

```
   2348835 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph-unMeth
   1580362 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/17_S134_10x_sorted.bedgraph-unMeth
   2427203 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/18_S154_10x_sorted.bedgraph-unMeth
   2702887 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/21_S119_10x_sorted.bedgraph-unMeth
   1235397 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/22_S120_10x_sorted.bedgraph-unMeth
   1573808 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/23_S141_10x_sorted.bedgraph-unMeth
    855323 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/24_S147_10x_sorted.bedgraph-unMeth
   7591191 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/25_S148_10x_sorted.bedgraph-unMeth
    705389 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/26_S121_10x_sorted.bedgraph-unMeth
   4521605 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/28_S122_10x_sorted.bedgraph-unMeth
```

### Export files 

```
scp emma_strand@ssh3.hac.uri.edu:/data/putnamlab/estrand/BleachingPairs_WGBS/genomic_feature/Mcap-v3-5x-unMeth-counts.txt ~/MyProjects/HI_Bleaching_Timeseries/Dec-July-2019-analysis/output/WGBS/genomic_feature/ 
## copy all counts files 
```

## Characterize genomic locations of CpGs

### Create BED files

`create-bed.sh`:

```
#!/bin/bash
#SBATCH --job-name="bedfiles"
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=128GB
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_WGBS/genomic_feature #### this is the output from the merge cov step above 
#SBATCH --cpus-per-task=3
#SBATCH --error="%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output="%x_output.%j" #once your job is completed, any final job report comments will be put in this file

## Create BED files

# 5X 

for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*5x_sorted.bedgraph
do
    awk '{print $1"\t"$2"\t"$3"\t"$4}' ${f} > ${f}.bed
    wc -l ${f}.bed
done

for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*5x_sorted.bedgraph-Meth
do
    awk '{print $1"\t"$2"\t"$3"\t"$4}' ${f} > ${f}.bed
    wc -l ${f}.bed
done

for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*5x_sorted.bedgraph-sparseMeth
do
    awk '{print $1"\t"$2"\t"$3"\t"$4}' ${f} > ${f}.bed
    wc -l ${f}.bed
done

for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*5x_sorted.bedgraph-unMeth
do
    awk '{print $1"\t"$2"\t"$3"\t"$4}' ${f} > ${f}.bed
    wc -l ${f}.bed
done

# 10X 

for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*10x_sorted.bedgraph
do
    awk '{print $1"\t"$2"\t"$3"\t"$4}' ${f} > ${f}.bed
    wc -l ${f}.bed
done

for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*10x_sorted.bedgraph-Meth
do
    awk '{print $1"\t"$2"\t"$3"\t"$4}' ${f} > ${f}.bed
    wc -l ${f}.bed
done

for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*10x_sorted.bedgraph-sparseMeth
do
    awk '{print $1"\t"$2"\t"$3"\t"$4}' ${f} > ${f}.bed
    wc -l ${f}.bed
done

for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*10x_sorted.bedgraph-unMeth
do
    awk '{print $1"\t"$2"\t"$3"\t"$4}' ${f} > ${f}.bed
    wc -l ${f}.bed
done
```

`head 31_S127_5x_sorted.bedgraph-Meth.bed`:

```
Montipora_capitata_HIv3___Scaffold_1    25463   25465   80.000000
Montipora_capitata_HIv3___Scaffold_1    25467   25469   80.000000
Montipora_capitata_HIv3___Scaffold_1    30081   30083   60.000000
Montipora_capitata_HIv3___Scaffold_1    33086   33088   100.000000
Montipora_capitata_HIv3___Scaffold_1    33092   33094   100.000000
Montipora_capitata_HIv3___Scaffold_1    33106   33108   100.000000
Montipora_capitata_HIv3___Scaffold_1    34584   34586   100.000000
Montipora_capitata_HIv3___Scaffold_1    34591   34593   100.000000
Montipora_capitata_HIv3___Scaffold_1    53239   53241   80.000000
Montipora_capitata_HIv3___Scaffold_1    53321   53323   60.000000
```

## Characterize genomic locations of CpGs for each section: Transcript, CDS, Downstream flanks, Flanks, Upstream flanks, Exons, Intergenic

*Intergenic isn't working right now -- see above errors.*

`characterize-loc.sh`:

```
#!/bin/bash
#SBATCH --job-name="ch-loc"
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=128GB
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_WGBS/genomic_feature #### this is the output from the merge cov step above 
#SBATCH --cpus-per-task=3
#SBATCH --error="%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output="%x_output.%j" #once your job is completed, any final job report comments will be put in this file

# load modules needed (specific need for my computer)
source /usr/share/Modules/init/sh # load the module function

module load BEDTools/2.27.1-foss-2018b

##  Transcripts 

for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*bed
do
  intersectBed \
  -u \
  -a ${f} \
  -b ../genomic_feature/Montipora_capitata_HIv3.genes.transcript.gff3 \
  > ${f}-paTranscript
done

## CDS 

for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*bed
do
  intersectBed \
  -u \
  -a ${f} \
  -b ../genomic_feature/Montipora_capitata_HIv3.genes.cds.gff3 \
  > ${f}-paCDS
done

## Exons 

for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*bed
do
  intersectBed \
  -u \
  -a ${f} \
  -b ../genomic_feature/Montipora_capitata_HIv3.genes.exon.gff3 \
  > ${f}-paExon
done

## Flanking regions

for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*bed
do
  intersectBed \
  -u \
  -a ${f} \
  -b ../genomic_feature/Montipora_capitata_HIv3.flanks.gff \
  > ${f}-paFlanks
done

## Upstream flanking Regions

for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*bed
do
  intersectBed \
  -u \
  -a ${f} \
  -b ../genomic_feature/Montipora_capitata_HIv3.flanks.Upstream.gff  \
  > ${f}-paFlanksUpstream
done

## Downstream flanking Regions

for f in /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*bed
do
  intersectBed \
  -u \
  -a ${f} \
  -b ../genomic_feature/Montipora_capitata_HIv3.flanks.Downstream.gff  \
  > ${f}-paFlanksDownstream
done

## Intergenic: errors in above script 
## Introns: not in original file
```

### Create counts txt files

`mkdir counts` 

#### 1. Downstream flanks 

Bin issue so come back to this.. 

#### 2. Upstream Flanks

```
wc -l /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*10x*paFlanksUpstream > Mcap-paFlanksUpstream10X-counts.txt 

# head -5 Mcap-paFlanksUpstream10X-counts.txt
     180249 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph.bed-paFlanksUpstream
    20720 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph-Meth.bed-paFlanksUpstream
    12757 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph-sparseMeth.bed-paFlanksUpstream
   146772 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph-unMeth.bed-paFlanksUpstream
        0 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.tab_gene_CpG_10x_enrichment.bed-paFlanksUpstream

wc -l /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*5x*paFlanksUpstream > Mcap-paFlanksUpstream5X-counts.txt 

# head -5 Mcap-paFlanksUpstream5X-counts.txt
    658119 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph.bed-paFlanksUpstream
     79724 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph-Meth.bed-paFlanksUpstream
     56551 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph-sparseMeth.bed-paFlanksUpstream
    521844 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph-unMeth.bed-paFlanksUpstream
         0 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.tab_gene_CpG_5x_enrichment.bed-paFlanksUpstream
```

#### 3. Flanks

```
wc -l /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*10x*paFlanks > Mcap-paFlanks10X-counts.txt 

# head -5 Mcap-paFlanks10X-counts.txt
      318895 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph.bed-paFlanks
     35533 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph-Meth.bed-paFlanks
     22483 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph-sparseMeth.bed-paFlanks
    260879 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph-unMeth.bed-paFlanks
         0 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.tab_gene_CpG_10x_enrichment.bed-paFlanks

wc -l /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*5x*paFlanks > Mcap-paFlanks5X-counts.txt 

# head -5 Mcap-paFlanks5X-counts.txt
   1200943 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph.bed-paFlanks
    144546 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph-Meth.bed-paFlanks
    105872 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph-sparseMeth.bed-paFlanks
    950525 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph-unMeth.bed-paFlanks
         0 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.tab_gene_CpG_5x_enrichment.bed-paFlanks
```

#### 4. CDS 

```
wc -l /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*10x*paCDS > Mcap-paCDS10X-counts.txt  

# head -5 Mcap-paCDS10X-counts.txt  
      386063 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph.bed-paCDS
     54100 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph-Meth.bed-paCDS
     30214 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph-sparseMeth.bed-paCDS
    301749 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph-unMeth.bed-paCDS
      1087 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.tab_gene_CpG_10x_enrichment.bed-paCDS

wc -l /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*5x*paCDS > Mcap-paCDS5X-counts.txt 

# head -5 Mcap-paCDS5X-counts.txt
   1138119 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph.bed-paCDS
    175177 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph-Meth.bed-paCDS
    101845 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph-sparseMeth.bed-paCDS
    861097 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph-unMeth.bed-paCDS
     57295 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.tab_gene_CpG_5x_enrichment.bed-paCDS
```

#### 5. Transcript 

```
wc -l /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*5x*paTranscript > Mcap-paTranscript5X-counts.txt  

# head -5 Mcap-paTranscript5X-counts.txt 
      5402504 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph.bed-paTranscript
     935567 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph-Meth.bed-paTranscript
     473909 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph-sparseMeth.bed-paTranscript
    3993028 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph-unMeth.bed-paTranscript
      87180 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.tab_gene_CpG_5x_enrichment.bed-paTranscript

wc -l /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*10x*paTranscript > Mcap-paTranscript10X-counts.txt  

# head -5 Mcap-paTranscript10X-counts.txt 
   1430466 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph.bed-paTranscript
    208924 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph-Meth.bed-paTranscript
     95478 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph-sparseMeth.bed-paTranscript
   1126064 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph-unMeth.bed-paTranscript
      1667 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.tab_gene_CpG_10x_enrichment.bed-paTranscript
```

#### 6. Exon

```
wc -l /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*5x*paExon > Mcap-paExon5X-counts.txt  

# head -5 Mcap-paExon5X-counts.txt 
   1138119 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph.bed-paExon
    175177 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph-Meth.bed-paExon
    101845 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph-sparseMeth.bed-paExon
    861097 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.bedgraph-unMeth.bed-paExon
     57295 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_5x_sorted.tab_gene_CpG_5x_enrichment.bed-paExon

wc -l /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*10x*paExon > Mcap-paExon10X-counts.txt  

# head -5 Mcap-paExon10X-counts.txt 
    386063 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph.bed-paExon
     54100 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph-Meth.bed-paExon
     30214 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph-sparseMeth.bed-paExon
    301749 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.bedgraph-unMeth.bed-paExon
      1087 /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/16_S138_10x_sorted.tab_gene_CpG_10x_enrichment.bed-paExon
```

### Export files 

```
scp -r emma_strand@ssh3.hac.uri.edu:/data/putnamlab/estrand/BleachingPairs_WGBS/genomic_feature/counts ~/MyProjects/HI_Bleaching_Timeseries/Dec-July-2019-analysis/output/WGBS/genomic_feature/

scp emma_strand@ssh3.hac.uri.edu:/data/putnamlab/estrand/BleachingPairs_WGBS/genomic_feature/Mcap-CGMotif-UpstreamFlanks-Overlaps.txt ~/MyProjects/HI_Bleaching_Timeseries/Dec-July-2019-analysis/output/WGBS/genomic_feature/
```

## Canonical Coverage Track with unionbedg

**below script producing this error: bash: 43: command not found for the -i flag** 

bedtools unionbedg combines multiple bedgraph files into a single file check that one can direcctly compare coverage (and other text-values such as genotypes) across multiple samples. Reference: https://github.com/hputnam/Meth_Compare/blob/master/code/01.10-Mcap-Canonical-Coverage-Track.ipynb

Bedgraphs: `/data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3/*.bedgraph`

`unionbedg.sh`:

```
#!/bin/bash
#SBATCH --job-name="unionbedg"
#SBATCH -t 500:00:00
#SBATCH --mem=128GB
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/BleachingPairs_WGBS/merged_cov_genomev3 
#SBATCH --error="%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output="%x_output.%j" #once your job is completed, any final job report comments will be put in this file

# load modules needed (specific need for my computer)
source /usr/share/Modules/init/sh # load the module function
module load BEDTools/2.27.1-foss-2018b

# 5x 
unionBedGraphs \
-header \
-filler N/A \
-names 16   17  18  21  22  23 \
24  25  26  28  29  2 \
30  31  32  33  34  35 \
37  38  39  40  41  42 \ 
43  44  45  46  47  4 \
50  51  52  54  55  56 \
57  58  59  6 \
-i \
16_S138_5x_sorted.bedgraph \
17_S134_5x_sorted.bedgraph \
18_S154_5x_sorted.bedgraph \
21_S119_5x_sorted.bedgraph \
22_S120_5x_sorted.bedgraph \
23_S141_5x_sorted.bedgraph \
24_S147_5x_sorted.bedgraph \
25_S148_5x_sorted.bedgraph \
26_S121_5x_sorted.bedgraph \
28_S122_5x_sorted.bedgraph \
29_S153_5x_sorted.bedgraph \
2_S128_5x_sorted.bedgraph \
30_S124_5x_sorted.bedgraph \
31_S127_5x_sorted.bedgraph \
32_S130_5x_sorted.bedgraph \
33_S142_5x_sorted.bedgraph \
34_S136_5x_sorted.bedgraph \
35_S137_5x_sorted.bedgraph \
37_S140_5x_sorted.bedgraph \
38_S129_5x_sorted.bedgraph \
39_S145_5x_sorted.bedgraph \
40_S135_5x_sorted.bedgraph \
41_S151_5x_sorted.bedgraph \
42_S131_5x_sorted.bedgraph \
43_S143_5x_sorted.bedgraph \
44_S125_5x_sorted.bedgraph \
45_S156_5x_sorted.bedgraph \
46_S133_5x_sorted.bedgraph \
47_S155_5x_sorted.bedgraph \
4_S146_5x_sorted.bedgraph \
50_S139_5x_sorted.bedgraph \
51_S126_5x_sorted.bedgraph \
52_S150_5x_sorted.bedgraph \
54_S144_5x_sorted.bedgraph \
55_S123_5x_sorted.bedgraph \
56_S149_5x_sorted.bedgraph \
57_S152_5x_sorted.bedgraph \
58_S157_5x_sorted.bedgraph \
59_S158_5x_sorted.bedgraph \
6_S132_5x_sorted.bedgraph \
> ../genomic_feature/Union5x.bedgraph

# 10x
unionBedGraphs \
-header \
-filler N/A \
-names 16   17  18  21  22  23 \
24  25  26  28  29  2 \
30  31  32  33  34  35 \
37  38  39  40  41  42 \ 
43  44  45  46  47  4 \
50  51  52  54  55  56 \
57  58  59  6 \
-i \
16_S138_10x_sorted.bedgraph \
17_S134_10x_sorted.bedgraph \
18_S154_10x_sorted.bedgraph \
21_S119_10x_sorted.bedgraph \
22_S120_10x_sorted.bedgraph \
23_S141_10x_sorted.bedgraph \
24_S147_10x_sorted.bedgraph \
25_S148_10x_sorted.bedgraph \
26_S121_10x_sorted.bedgraph \
28_S122_10x_sorted.bedgraph \
29_S153_10x_sorted.bedgraph \
2_S128_10x_sorted.bedgraph \
30_S124_10x_sorted.bedgraph \
31_S127_10x_sorted.bedgraph \
32_S130_10x_sorted.bedgraph \
33_S142_10x_sorted.bedgraph \
34_S136_10x_sorted.bedgraph \
35_S137_10x_sorted.bedgraph \
37_S140_10x_sorted.bedgraph \
38_S129_10x_sorted.bedgraph \
39_S145_10x_sorted.bedgraph \
40_S135_10x_sorted.bedgraph \
41_S151_10x_sorted.bedgraph \
42_S131_10x_sorted.bedgraph \
43_S143_10x_sorted.bedgraph \
44_S125_10x_sorted.bedgraph \
45_S156_10x_sorted.bedgraph \
46_S133_10x_sorted.bedgraph \
47_S155_10x_sorted.bedgraph \
4_S146_10x_sorted.bedgraph \
50_S139_10x_sorted.bedgraph \
51_S126_10x_sorted.bedgraph \
52_S150_10x_sorted.bedgraph \
54_S144_10x_sorted.bedgraph \
55_S123_10x_sorted.bedgraph \
56_S149_10x_sorted.bedgraph \
57_S152_10x_sorted.bedgraph \
58_S157_10x_sorted.bedgraph \
59_S158_10x_sorted.bedgraph \
6_S132_10x_sorted.bedgraph \
> ../genomic_feature/Union10x.bedgraph
```

`head Union5x.bedgraph`:

```

```

`head Union10x.bedgraph`:

```

```

### export these files to computer 

```
scp emma_strand@ssh3.hac.uri.edu:/data/putnamlab/estrand/BleachingPairs_WGBS/genomic_feature/Union5x.bedgraph ~/MyProjects/HI_Bleaching_Timeseries/Dec-July-2019-analysis/output/WGBS/genomic_feature/
scp emma_strand@ssh3.hac.uri.edu:/data/putnamlab/estrand/BleachingPairs_WGBS/genomic_feature/Union10x.bedgraph ~/MyProjects/HI_Bleaching_Timeseries/Dec-July-2019-analysis/output/WGBS/genomic_feature/
```