---
layout: post
title: Pacuta Genomic Feature Analysis
date: '2022-11-21'
categories: Analysis
tags: methylation, pacuta
projects: Holobiont Integration
---

# Genomic Feature Analysis: P. acuta 

Prior to this script, run methylseq on raw sequences files: https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-10-21-HoloInt-WGBS-Analysis-Pipeline.md 

References: 
- Kevin Wong's pipeline: https://github.com/kevinhwong1/Thermal_Transplant_Molecular/blob/main/scripts/Past_Genomic_Feature_Analysis_20221014.md#char_gene
- Yaamini's pipeline: https://github.com/hputnam/Meth_Compare/blob/master/code/03.01-Generating-Genome-Feature-Tracks.ipynb 

**Come back to:**    
- Original gff3 doesn't contain introns -- needed?  
- #8 intergenic region error 
- Downstream flank CG motif 

## Setting Up Andromeda 

`mkdir mkdir genomic_feature` in `/data/putnamlab/estrand/HoloInt_WGBS` path. 

## Prepare reference file 

```
interactive 

module load SAMtools/1.9-foss-2018b

# create a fasta index file called that has the chromosome ID and length
samtools faidx Pocillopora_acuta_HIv2.assembly.fasta

# Double checking lengths: obtain sequence lengths for each "chromosome"
awk '$0 ~ ">" {print c; c=0;printf substr($0,2,100) "\t"; } $0 !~ ">" {c+=length($0);} END { print c; }' \
Pocillopora_acuta_HIv2.assembly.fasta \
> Pacuta.v2.genome_assembly-sequence-lengths.txt
```

`Pacuta.v2.genome_assembly-sequence-lengths.txt`: 

```
Pocillopora_acuta_HIv2___Sc0000000      15774912
Pocillopora_acuta_HIv2___Sc0000001      13657580
Pocillopora_acuta_HIv2___Sc0000002      11458840
Pocillopora_acuta_HIv2___Sc0000003      11317442
Pocillopora_acuta_HIv2___Sc0000004      10346329
Pocillopora_acuta_HIv2___Sc0000005      9803754
Pocillopora_acuta_HIv2___Sc0000006      8020306
Pocillopora_acuta_HIv2___Sc0000007      7567371
Pocillopora_acuta_HIv2___Sc0000008      7350670
```

## Genome annotation file 

file = `Pocillopora_acuta_HIv2.genes.gff3`: 

```
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        transcript      151     2746    .       +       .       ID=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        CDS     151     172     .       +       0       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        exon    151     172     .       +       0       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        CDS     264     304     .       +       2       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        exon    264     304     .       +       2       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        CDS     1491    1602    .       +       0       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        exon    1491    1602    .       +       0       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        CDS     1889    1990    .       +       2       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        exon    1889    1990    .       +       2       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        CDS     2107    2127    .       +       2       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
```

## Filtering GFF for specific features 

### 1. Genes 

`awk '{if ($3 == "gene") print $0;}' Pocillopora_acuta_HIv2.genes.gff3 > Pocillopora_acuta_HIv2.genesonly.gff3`

```
wc -l Pocillopora_acuta_HIv2.genesonly.gff3
0 Pocillopora_acuta_HIv2.genesonly.gff3

head 
# output is nothing ... they may be replaced by 'transcript' later down..
```

Moved to genomic_feature folder 

### 2. CDS 

`awk '{if ($3 == "CDS") print $0;}' Pocillopora_acuta_HIv2.genes.gff3 > Pocillopora_acuta_HIv2.genes.cds.gff3` 

```
wc -l Pocillopora_acuta_HIv2.genes.cds.gff3
222629 Pocillopora_acuta_HIv2.genes.cds.gff3

head Pocillopora_acuta_HIv2.genes.cds.gff3

Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        CDS     151     172     .       +       0       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        CDS     264     304     .       +       2       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        CDS     1491    1602    .       +       0       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        CDS     1889    1990    .       +       2       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        CDS     2107    2127    .       +       2       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        CDS     2727    2746    .       +       2       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        CDS     12326   12381   .       -       2       Parent=Pocillopora_acuta_HIv2___RNAseq.g24101.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        CDS     12709   12765   .       -       2       Parent=Pocillopora_acuta_HIv2___RNAseq.g24101.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        CDS     13453   13492   .       -       0       Parent=Pocillopora_acuta_HIv2___RNAseq.g24101.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        CDS     13691   13731   .       -       2       Parent=Pocillopora_acuta_HIv2___RNAseq.g24101.t1
```

### 3. Exon 

`awk '{if ($3 == "exon") print $0;}' Pocillopora_acuta_HIv2.genes.gff3 > Pocillopora_acuta_HIv2.genes.exon.gff3`

```
wc -l Pocillopora_acuta_HIv2.genes.exon.gff3
222629 Pocillopora_acuta_HIv2.genes.exon.gff3

head Pocillopora_acuta_HIv2.genes.exon.gff3
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        exon    151     172     .       +       0       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        exon    264     304     .       +       2       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        exon    1491    1602    .       +       0       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        exon    1889    1990    .       +       2       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        exon    2107    2127    .       +       2       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        exon    2727    2746    .       +       2       Parent=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        exon    12326   12381   .       -       2       Parent=Pocillopora_acuta_HIv2___RNAseq.g24101.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        exon    12709   12765   .       -       2       Parent=Pocillopora_acuta_HIv2___RNAseq.g24101.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        exon    13453   13492   .       -       0       Parent=Pocillopora_acuta_HIv2___RNAseq.g24101.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        exon    13691   13731   .       -       2       Parent=Pocillopora_acuta_HIv2___RNAseq.g24101.t1
```

### 4. Transcript 

This might be in place of 'gene' 

`awk '{if ($3 == "transcript") print $0;}' Pocillopora_acuta_HIv2.genes.gff3 > Pocillopora_acuta_HIv2.genes.transcript.gff3`

```
wc -l Pocillopora_acuta_HIv2.genes.transcript.gff3
33730 Pocillopora_acuta_HIv2.genes.transcript.gff3

head 
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        transcript      151     2746    .       +       .       ID=Pocillopora_acuta_HIv2___RNAseq.g24100.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        transcript      12326   13844   .       -       .       ID=Pocillopora_acuta_HIv2___RNAseq.g24101.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        transcript      27537   30797   .       +       .       ID=Pocillopora_acuta_HIv2___TS.g535.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        transcript      80090   82074   .       +       .       ID=Pocillopora_acuta_HIv2___RNAseq.g24103.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        transcript      157259  157816  .       +       .       ID=Pocillopora_acuta_HIv2___TS.g537.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        transcript      157827  158923  .       -       .       ID=Pocillopora_acuta_HIv2___RNAseq.g24105.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        transcript      157990  159015  .       +       .       ID=Pocillopora_acuta_HIv2___TS.g538.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        transcript      159138  159872  .       -       .       ID=Pocillopora_acuta_HIv2___RNAseq.g24106.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        transcript      162127  171732  .       +       .       ID=Pocillopora_acuta_HIv2___TS.g540.t1
Pocillopora_acuta_HIv2___Sc0000016      AUGUSTUS        transcript      180258  182640  .       +       .       ID=Pocillopora_acuta_HIv2___RNAseq.g24107.t1
```

#### This file doesn't contain introns.. come back to this?

### 5. All Regions 

Create 1kb flanking regions. Subtract existing genes so flanks do not have any overlap.

```
interactive 

module load BEDTools/2.27.1-foss-2018b

sort -i Pocillopora_acuta_HIv2.genes.transcript.gff3 > Pocillopora_acuta_HIv2.genes.transcript_sorted.gff3

head Pocillopora_acuta_HIv2.genes.transcript_sorted.gff3
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10006818        10008014        .       -       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28241.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10010616        10041252        .       -       .       ID=Pocillopora_acuta_HIv2___TS.g11023.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10042492        10044025        .       -       .       ID=Pocillopora_acuta_HIv2___TS.g11024.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10053602        10073742        .       +       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28244.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      1005584 1048605 .       +       .       ID=Pocillopora_acuta_HIv2___TS.g10216.t2
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      100768  106364  .       +       .       ID=Pocillopora_acuta_HIv2___RNAseq.g27408.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10079608        10082062        .       +       .       ID=Pocillopora_acuta_HIv2___TS.g11027.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10084651        10087199        .       -       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28246.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10089009        10091944        .       -       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28247.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10094453        10097322        .       -       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28248.t1
```

```
flankBed \
-i Pocillopora_acuta_HIv2.genes.transcript_sorted.gff3 \
-g ../../Pocillopora_acuta_HIv2.assembly.fasta.fai \
-b 1000 \
| subtractBed \
-a - \
-b Pocillopora_acuta_HIv2.genes.transcript_sorted.gff3 \
> Pocillopora_acuta_HIv2.flanks.gff

wc -l Pocillopora_acuta_HIv2.flanks.gff
68516 Pocillopora_acuta_HIv2.flanks.gff
```

### 6. Upstream flanks

```
flankBed \
-i Pocillopora_acuta_HIv2.genes.transcript_sorted.gff3 \
-g ../../Pocillopora_acuta_HIv2.assembly.fasta.fai \
-l 1000 \
-r 0 \
-s \
| subtractBed \
-a - \
-b Pocillopora_acuta_HIv2.genes.transcript_sorted.gff3 \
> Pocillopora_acuta_HIv2.flanks.Upstream.gff

head Pocillopora_acuta_HIv2.flanks.Upstream.gff
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10008015        10009014        .       -       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28241.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10041253        10042252        .       -       .       ID=Pocillopora_acuta_HIv2___TS.g11023.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10044026        10045025        .       -       .       ID=Pocillopora_acuta_HIv2___TS.g11024.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10052602        10053601        .       +       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28244.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      1004683 1005583 .       +       .       ID=Pocillopora_acuta_HIv2___TS.g10216.t2
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      99768   100767  .       +       .       ID=Pocillopora_acuta_HIv2___RNAseq.g27408.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10078608        10079607        .       +       .       ID=Pocillopora_acuta_HIv2___TS.g11027.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10087200        10088199        .       -       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28246.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10091945        10092944        .       -       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28247.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10097323        10098322        .       -       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28248.t1


wc -l Pocillopora_acuta_HIv2.flanks.Upstream.gff
34258 Pocillopora_acuta_HIv2.flanks.Upstream.gff
```

### 7. Downstream flanks

```
flankBed \
-i Pocillopora_acuta_HIv2.genes.transcript_sorted.gff3 \
-g ../../Pocillopora_acuta_HIv2.assembly.fasta.fai \
-l 0 \
-r 1000 \
-s \
| subtractBed \
-a - \
-b Pocillopora_acuta_HIv2.genes.transcript_sorted.gff3 \
> Pocillopora_acuta_HIv2.flanks.Downstream.gff

head Pocillopora_acuta_HIv2.flanks.Downstream.gff
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10005818        10006817        .       -       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28241.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10009616        10010615        .       -       .       ID=Pocillopora_acuta_HIv2___TS.g11023.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10041492        10042491        .       -       .       ID=Pocillopora_acuta_HIv2___TS.g11024.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10073743        10074742        .       +       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28244.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      1048606 1049605 .       +       .       ID=Pocillopora_acuta_HIv2___TS.g10216.t2
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      106365  107364  .       +       .       ID=Pocillopora_acuta_HIv2___RNAseq.g27408.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10082063        10083062        .       +       .       ID=Pocillopora_acuta_HIv2___TS.g11027.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10083651        10084650        .       -       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28246.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10088009        10089008        .       -       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28247.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10093453        10094452        .       -       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28248.t1

wc -l Pocillopora_acuta_HIv2.flanks.Downstream.gff
34260 Pocillopora_acuta_HIv2.flanks.Downstream.gff
```

### 8. Intergenic regions
  

```
complementBed \
-i Pocillopora_acuta_HIv2.genes.transcript_sorted.gff3 \
-g ../../Pocillopora_acuta_HIv2.assembly.fasta.fai \
| subtractBed \
-a - \
-b Pocillopora_acuta_HIv2.genes.transcript_sorted.gff3 \
| awk '{print $1"\t"$2"\t"$3}' \
> Pocillopora_acuta_HIv2.intergenic.bed
```

I ran into this error. Is this because it has 7 digits instead of 8? 

```
Error: Sorted input specified, but the file Pocillopora_acuta_HIv2.genes.transcript_sorted.gff3 has the following out of order record
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      1005584 1048605 .       +       .       ID=Pocillopora_acuta_HIv2___TS.g10216.t2
```

`Pocillopora_acuta_HIv2.genes.transcript_sorted.gff3`: 

```
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10006818        10008014        .       -       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28241.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10010616        10041252        .       -       .       ID=Pocillopora_acuta_HIv2___TS.g11023.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10042492        10044025        .       -       .       ID=Pocillopora_acuta_HIv2___TS.g11024.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10053602        10073742        .       +       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28244.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      1005584 1048605 .       +       .       ID=Pocillopora_acuta_HIv2___TS.g10216.t2
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      100768  106364  .       +       .       ID=Pocillopora_acuta_HIv2___RNAseq.g27408.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10079608        10082062        .       +       .       ID=Pocillopora_acuta_HIv2___TS.g11027.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10084651        10087199        .       -       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28246.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10089009        10091944        .       -       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28247.t1
Pocillopora_acuta_HIv2___Sc0000000      AUGUSTUS        transcript      10094453        10097322        .       -       .       ID=Pocillopora_acuta_HIv2___RNAseq.g28248.t1
```

Re-sorting like Kevin did resulted in an empty file..
`sort -i Pocillopora_acuta_HIv2.genes.transcript_sorted.gff3 > Pocillopora_acuta_HIv2.genes.transcript_sorted.gff3` 

**Have to come back to this?** 

## Create CpG motifs

```
module load EMBOSS/6.6.0-foss-2018b

fuzznuc \
-sequence ../../Pocillopora_acuta_HIv2.assembly.fasta \
-pattern CG \
-outfile Pacuta_v2_CpG.gff \
-rformat gff

head Pacuta_v2_CpG.gff
##gff-version 3
##sequence-region Pocillopora_acuta_HIv2___Sc0000000 1 15774912
#!Date 2022-11-21
#!Type DNA
#!Source-version EMBOSS 6.6.0.0
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        100     101     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.1;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        120     121     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.2;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        170     171     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.3;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        244     245     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.4;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        375     376     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.5;note=*pat pattern:CG
```

## Characterize CG motif locations in feature tracks

`module load BEDTools/2.27.1-foss-2018b`

### Transcript 

```
intersectBed \
-u \
-a Pacuta_v2_CpG.gff \
-b Pocillopora_acuta_HIv2.genes.transcript.gff3 \
> Pacuta-CGMotif-Transcript-Overlaps.txt
```

head `Pacuta-CGMotif-Transcript-Overlaps.txt`:

```
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        244     245     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.4;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        375     376     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.5;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        491     492     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.6;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        497     498     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.7;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        516     517     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.8;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        552     553     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.9;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        564     565     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.10;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        678     679     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.11;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        837     838     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.12;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        852     853     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.13;note=*pat pattern:CG
```

`wc -l Pacuta-CGMotif-Transcript-Overlaps.txt`: 4405179 Pacuta-CGMotif-Transcript-Overlaps.txt

### CDS

```
intersectBed \
-u \
-a Pacuta_v2_CpG.gff \
-b Pocillopora_acuta_HIv2.genes.cds.gff3 \
> Pacuta-CGMotif-CDS-Overlaps.txt
```

head `Pacuta-CGMotif-CDS-Overlaps.txt`:

```
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        244     245     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.4;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        375     376     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.5;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        1041    1042    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.17;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        1090    1091    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.18;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        1740    1741    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.39;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        1780    1781    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.40;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        1834    1835    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.41;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        1837    1838    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.42;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        2688    2689    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.66;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        7449    7450    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.253;note=*pat pattern:CG

```

`wc -l Pacuta-CGMotif-CDS-Overlaps.txt`: 1478389 Pacuta-CGMotif-CDS-Overlaps.txt

### Flanks

```
intersectBed \
-u \
-a Pacuta_v2_CpG.gff \
-b Pocillopora_acuta_HIv2.flanks.gff \
> Pacuta-CGMotif-Flanks-Overlaps.txt
```

```
head Pacuta-CGMotif-Flanks-Overlaps.txt

Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        100     101     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.1;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        120     121     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.2;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        170     171     2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.3;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        9413    9414    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.311;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        9426    9427    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.312;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        9531    9532    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.313;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        9573    9574    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.314;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        9673    9674    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.315;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        9678    9679    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.316;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        9681    9682    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.317;note=*pat pattern:CG
```

`wc -l Pacuta-CGMotif-Flanks-Overlaps.txt`: 1524269 Pacuta-CGMotif-Flanks-Overlaps.txt

### Upstream flanks

```
intersectBed \
-u \
-a Pacuta_v2_CpG.gff \
-b Pocillopora_acuta_HIv2.flanks.Upstream.gff \
> Pacuta-CGMotif-UpstreamFlanks-Overlaps.txt
```

```
head Pacuta-CGMotif-UpstreamFlanks-Overlaps.txt

Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        9413    9414    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.311;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        9426    9427    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.312;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        9531    9532    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.313;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        9573    9574    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.314;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        9673    9674    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.315;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        9678    9679    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.316;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        9681    9682    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.317;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        9704    9705    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.318;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        9711    9712    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.319;note=*pat pattern:CG
Pocillopora_acuta_HIv2___Sc0000000      fuzznuc nucleotide_motif        9763    9764    2       +       .       ID=Pocillopora_acuta_HIv2___Sc0000000.320;note=*pat pattern:CG
```

`wc -l Pacuta-CGMotif-UpstreamFlanks-Overlaps.txt`: 861078 Pacuta-CGMotif-UpstreamFlanks-Overlaps.txt

### Downstream flanks

```
intersectBed \
-u \
-a Pacuta_v2_CpG.gff \
-b Pocillopora_acuta_HIv2.flanks.Downstream.gff \
> Pacuta-CGMotif-DownstreamFlanks-Overlaps.txt
```

ERROR: Received illegal bin number 4294967295 from getBin call.
ERROR: Unable to add record to tree.

**Have to come back to this?** 

### Intergenic Region 

Error in above section so need to come back to this...

## Organize coverage files

`wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*5x_sorted.bedgraph > Pacuta-v2-5x-bedgraph-counts.txt`
`wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*10x_sorted.bedgraph > Pacuta-v2-10x-bedgraph-counts.txt`

## Characterize methylation for each CpG dinucleotide

Methylated: > 50% methylation
Sparsely methylated: 10-50% methylation
Unmethylated: < 10% methylation

### Methylated 

**5X** 

```
for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*5x_sorted.bedgraph
do
    awk '{if ($4 >= 50) { print $1, $2, $3, $4 }}' ${f} \
    > ${f}-Meth
done

wc -l *-Meth > ../Pacuta-v2-5x-Meth-counts.txt
```

**10X** 

```
for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*10x_sorted.bedgraph
do
    awk '{if ($4 >= 50) { print $1, $2, $3, $4 }}' ${f} \
    > ${f}-Meth
done
```