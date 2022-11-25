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

## Setting Up Andromeda 

`mkdir mkdir genomic_feature` in `/data/putnamlab/estrand/HoloInt_WGBS` path. 

## Resources 

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

This is the same as the first column of fai file. 

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

https://bedtools.readthedocs.io/en/latest/content/tools/flank.html

BEDTools/2.30.0-GCC-11.2.0 

Create 1kb flanking regions. Subtract existing genes so flanks do not have any overlap.

```
interactive 

module load BEDTools/2.27.1-foss-2018b #but sort function independently doesn't require this ; the next chunk of code will 

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

https://bedtools.readthedocs.io/en/latest/content/tools/flank.html. 
1000 on either side of the region 

https://bedtools.readthedocs.io/en/latest/content/tools/subtract.html

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
  
https://bedtools.readthedocs.io/en/latest/content/tools/complement.html

https://davetang.org/muse/2013/01/18/defining-genomic-regions/


```
complementBed \
-i Pocillopora_acuta_HIv2.genes.transcript_sorted2.gff3 \
-g ../../Pocillopora_acuta_HIv2.assembly.fasta.fai \
| subtractBed \
-a - \
-b Pocillopora_acuta_HIv2.flanks.gff \
| awk '{print $1"\t"$2"\t"$3}' \
> Pocillopora_acuta_HIv2.intergenic.bed
```

There is some mismatch between the transcript_sorted file and fai file.. I tried both Bedtools version v2.27 and 2.30 but got the same error. 

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
`sort -i Pocillopora_acuta_HIv2.genes.transcript_sorted.gff3 > Pocillopora_acuta_HIv2.genes.transcript_sorted2.gff3` 

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

*We only use the gff file created from this in further steps so I think this is OK to leave for now..* 

### Intergenic Region 

Error in above section so need to come back to this...

## Organize coverage files

`wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*5x_sorted.bedgraph > Pacuta-v2-5x-bedgraph-counts.txt`

```
head Pacuta-v2-5x-bedgraph-counts.txt

    6865623 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_5x_sorted.bedgraph
    8069887 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1051_5x_sorted.bedgraph
    7444259 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1059_5x_sorted.bedgraph
    7980157 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1090_5x_sorted.bedgraph
    6832422 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1103_5x_sorted.bedgraph
    2852639 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1147_5x_sorted.bedgraph
    6283492 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1159_5x_sorted.bedgraph
    6976028 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1168_5x_sorted.bedgraph
    7422350 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1184_5x_sorted.bedgraph
    7882151 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1205_5x_sorted.bedgraph
```

`wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*10x_sorted.bedgraph > Pacuta-v2-10x-bedgraph-counts.txt`

```
head Pacuta-v2-10x-bedgraph-counts.txt

    3982376 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_10x_sorted.bedgraph
    5467738 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1051_10x_sorted.bedgraph
    5273220 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1059_10x_sorted.bedgraph
    5707710 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1090_10x_sorted.bedgraph
    3913593 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1103_10x_sorted.bedgraph
     527796 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1147_10x_sorted.bedgraph
    3262202 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1159_10x_sorted.bedgraph
    4656862 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1168_10x_sorted.bedgraph
    5010797 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1184_10x_sorted.bedgraph
    5914757 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1205_10x_sorted.bedgraph
```

## Characterize methylation for each CpG dinucleotide

Methylated: > 50% methylation
Sparsely methylated: 10-50% methylation
Unmethylated: < 10% methylation

`characterize-meth.sh`: (~20 min)

```
#!/bin/bash
#SBATCH --job-name="ch-meth"
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=128GB
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS/genomic_feature #### this is the output from the merge cov step above 
#SBATCH --cpus-per-task=3
#SBATCH --error="%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output="%x_output.%j" #once your job is completed, any final job report comments will be put in this file

## Methylated

# 5X
for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*5x_sorted.bedgraph
do
    awk '{if ($4 >= 50) { print $1, $2, $3, $4 }}' ${f} \
    > ${f}-Meth
done

wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*5x_sorted.bedgraph-Meth > Pacuta-v2-5x-Meth-counts.txt

#10X
for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*10x_sorted.bedgraph
do
    awk '{if ($4 >= 50) { print $1, $2, $3, $4 }}' ${f} \
    > ${f}-Meth
done

wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*10x_sorted.bedgraph-Meth > Pacuta-v2-10x-Meth-counts.txt

## Sparsely methylated

# 5X 
for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*5x_sorted.bedgraph
do
    awk '{if ($4 < 50) { print $1, $2, $3, $4}}' ${f} \
    | awk '{if ($4 > 10) { print $1, $2, $3, $4 }}' \
    > ${f}-sparseMeth
done

wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*5x_sorted.bedgraph-sparseMeth > Pacuta-v2-5x-sparseMeth-counts.txt

# 10X
for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*10x_sorted.bedgraph
do
    awk '{if ($4 < 50) { print $1, $2, $3, $4}}' ${f} \
    | awk '{if ($4 > 10) { print $1, $2, $3, $4 }}' \
    > ${f}-sparseMeth
done

wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*10x_sorted.bedgraph-sparseMeth > Pacuta-v2-10x-sparseMeth-counts.txt

## Unmethylated

# 5X 
for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*5x_sorted.bedgraph
do
    awk '{if ($4 <= 10) { print $1, $2, $3, $4 }}' ${f} \
    > ${f}-unMeth
done

wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*5x_sorted.bedgraph-unMeth > Pacuta-v2-5x-unMeth-counts.txt

# 10X
for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*10x_sorted.bedgraph
do
    awk '{if ($4 <= 10) { print $1, $2, $3, $4 }}' ${f} \
    > ${f}-unMeth
done

wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*10x_sorted.bedgraph-unMeth > Pacuta-v2-10x-unMeth-counts.txt
```

`head 2012_5x_sorted.bedgraph-Meth`:

```
Pocillopora_acuta_HIv2___Sc0000000 25824 25826 90.000000
Pocillopora_acuta_HIv2___Sc0000000 25835 25837 81.818182
Pocillopora_acuta_HIv2___Sc0000000 27032 27034 85.714286
Pocillopora_acuta_HIv2___Sc0000000 27058 27060 90.909091
Pocillopora_acuta_HIv2___Sc0000000 27074 27076 86.666667
Pocillopora_acuta_HIv2___Sc0000000 27634 27636 53.333333
Pocillopora_acuta_HIv2___Sc0000000 27685 27687 95.454545
Pocillopora_acuta_HIv2___Sc0000000 27791 27793 91.666667
Pocillopora_acuta_HIv2___Sc0000000 27906 27908 61.111111
Pocillopora_acuta_HIv2___Sc0000000 28031 28033 83.333333
```

`head 1445_5x_sorted.bedgraph-sparseMeth`:

```
Pocillopora_acuta_HIv2___Sc0000000 1363 1365 16.666667
Pocillopora_acuta_HIv2___Sc0000000 3023 3025 12.500000
Pocillopora_acuta_HIv2___Sc0000000 3149 3151 18.181818
Pocillopora_acuta_HIv2___Sc0000000 5760 5762 14.285714
Pocillopora_acuta_HIv2___Sc0000000 9015 9017 22.222222
Pocillopora_acuta_HIv2___Sc0000000 9158 9160 11.111111
Pocillopora_acuta_HIv2___Sc0000000 11110 11112 16.666667
Pocillopora_acuta_HIv2___Sc0000000 11118 11120 14.285714
Pocillopora_acuta_HIv2___Sc0000000 13679 13681 12.500000
Pocillopora_acuta_HIv2___Sc0000000 13682 13684 12.500000
```

`head 1445_5x_sorted.bedgraph-unMeth`:

```
Pocillopora_acuta_HIv2___Sc0000000 119 121 0.000000
Pocillopora_acuta_HIv2___Sc0000000 243 245 0.000000
Pocillopora_acuta_HIv2___Sc0000000 374 376 0.000000
Pocillopora_acuta_HIv2___Sc0000000 490 492 0.000000
Pocillopora_acuta_HIv2___Sc0000000 496 498 0.000000
Pocillopora_acuta_HIv2___Sc0000000 515 517 0.000000
Pocillopora_acuta_HIv2___Sc0000000 551 553 10.000000
Pocillopora_acuta_HIv2___Sc0000000 563 565 0.000000
Pocillopora_acuta_HIv2___Sc0000000 1040 1042 0.000000
Pocillopora_acuta_HIv2___Sc0000000 1089 1091 0.000000
```

`head Pacuta-v2-10x-unMeth-counts.txt`:

```
   101484 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_10x_sorted.bedgraph-Meth
   135771 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1051_10x_sorted.bedgraph-Meth
   127601 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1059_10x_sorted.bedgraph-Meth
   131345 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1090_10x_sorted.bedgraph-Meth
    88841 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1103_10x_sorted.bedgraph-Meth
     8871 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1147_10x_sorted.bedgraph-Meth
    79578 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1159_10x_sorted.bedgraph-Meth
   130632 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1168_10x_sorted.bedgraph-Meth
   110800 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1184_10x_sorted.bedgraph-Meth
   111070 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1205_10x_sorted.bedgraph-Meth
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
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS/genomic_feature #### this is the output from the merge cov step above 
#SBATCH --cpus-per-task=3
#SBATCH --error="%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output="%x_output.%j" #once your job is completed, any final job report comments will be put in this file

## Create BED files

# 5X 

for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*5x_sorted.bedgraph
do
    awk '{print $1"\t"$2"\t"$3"\t"$4}' ${f} > ${f}.bed
    wc -l ${f}.bed
done

for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*5x_sorted.bedgraph-Meth
do
    awk '{print $1"\t"$2"\t"$3"\t"$4}' ${f} > ${f}.bed
    wc -l ${f}.bed
done

for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*5x_sorted.bedgraph-sparseMeth
do
    awk '{print $1"\t"$2"\t"$3"\t"$4}' ${f} > ${f}.bed
    wc -l ${f}.bed
done

for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*5x_sorted.bedgraph-unMeth
do
    awk '{print $1"\t"$2"\t"$3"\t"$4}' ${f} > ${f}.bed
    wc -l ${f}.bed
done

# 10X 

for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*10x_sorted.bedgraph
do
    awk '{print $1"\t"$2"\t"$3"\t"$4}' ${f} > ${f}.bed
    wc -l ${f}.bed
done

for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*10x_sorted.bedgraph-Meth
do
    awk '{print $1"\t"$2"\t"$3"\t"$4}' ${f} > ${f}.bed
    wc -l ${f}.bed
done

for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*10x_sorted.bedgraph-sparseMeth
do
    awk '{print $1"\t"$2"\t"$3"\t"$4}' ${f} > ${f}.bed
    wc -l ${f}.bed
done

for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*10x_sorted.bedgraph-unMeth
do
    awk '{print $1"\t"$2"\t"$3"\t"$4}' ${f} > ${f}.bed
    wc -l ${f}.bed
done
```

`head head 2012_10x_sorted.bedgraph-Meth.bed`:

```
Pocillopora_acuta_HIv2___Sc0000000      25824   25826   90.000000
Pocillopora_acuta_HIv2___Sc0000000      25835   25837   81.818182
Pocillopora_acuta_HIv2___Sc0000000      27032   27034   85.714286
Pocillopora_acuta_HIv2___Sc0000000      27058   27060   90.909091
Pocillopora_acuta_HIv2___Sc0000000      27074   27076   86.666667
Pocillopora_acuta_HIv2___Sc0000000      27634   27636   53.333333
Pocillopora_acuta_HIv2___Sc0000000      27685   27687   95.454545
Pocillopora_acuta_HIv2___Sc0000000      27791   27793   91.666667
Pocillopora_acuta_HIv2___Sc0000000      27906   27908   61.111111
Pocillopora_acuta_HIv2___Sc0000000      28031   28033   83.333333
```

### Characterize genomic locations of CpGs for each section: Transcript, CDS, Downstream flanks, Flanks, Upstream flanks, Exons, Intergenic

*Intergenic isn't working right now -- see above errors.* 

`characterize-loc.sh`: 

```
#!/bin/bash
#SBATCH --job-name="ch-loc"
#SBATCH -t 500:00:00
#SBATCH --nodes=1 --ntasks-per-node=10
#SBATCH --mem=128GB
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/HoloInt_WGBS/genomic_feature #### this is the output from the merge cov step above 
#SBATCH --cpus-per-task=3
#SBATCH --error="%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output="%x_output.%j" #once your job is completed, any final job report comments will be put in this file


# load modules needed (specific need for my computer)
source /usr/share/Modules/init/sh # load the module function

module load BEDTools/2.27.1-foss-2018b

##  Transcripts 

for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*bed
do
  intersectBed \
  -u \
  -a ${f} \
  -b Pocillopora_acuta_HIv2.genes.transcript.gff3 \
  > ${f}-paTranscript
done

## CDS 

for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*bed
do
  intersectBed \
  -u \
  -a ${f} \
  -b Pocillopora_acuta_HIv2.genes.cds.gff3 \
  > ${f}-paCDS
done

## Flanking regions

for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*bed
do
  intersectBed \
  -u \
  -a ${f} \
  -b Pocillopora_acuta_HIv2.flanks.gff \
  > ${f}-paFlanks
done

## Upstream flanking Regions

for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*bed
do
  intersectBed \
  -u \
  -a ${f} \
  -b Pocillopora_acuta_HIv2.flanks.Upstream.gff  \
  > ${f}-paFlanksUpstream
done

## Downstream flanking Regions

for f in /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*bed
do
  intersectBed \
  -u \
  -a ${f} \
  -b ../genomic_feature/Pocillopora_acuta_HIv2.flanks.Downstream.gff  \
  > ${f}-paFlanksDownstream
done

## Intergenic: 
## Introns: not in original file
```

Error for downtstream flanks:

ERROR: Received illegal bin number 4294967295 from getBin call.
ERROR: Unable to add record to tree.

### Create counts txt files 

`mkdir counts.txt `
`cd counts.txt`

#### Downstream Flanks 

```
# I accidentally added "5X" to all files so I need to include that in calling..
wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*10x*paFlanksDownstream5X > counts.txt/Pacuta-paFlanksDownstream10X-counts.txt

$ head -2 Pacuta-paFlanksDownstream10X-counts.txt
0 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_10x_sorted.bedgraph.bed-paFlanksDownstream5X
0 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_10x_sorted.bedgraph-Meth.bed-paFlanksDownstream5X

wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*5x*paFlanksDownstream5X > counts.txt/Pacuta-paFlanksDownstream5X-counts.txt

$ head -2 Pacuta-paFlanksDownstream5X-counts.txt
0 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_5x_sorted.bedgraph.bed-paFlanksDownstream5X
0 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_5x_sorted.bedgraph-Meth.bed-paFlanksDownstream5X
```

`head 1647_5x_sorted.bedgraph-Meth.bed-paFlanksDownstream5X` = empty... Downstream flanks don't appear to work. 

This is because of a bin issue with downstream flanks. 


#### Upstream Flanks

```
wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*10x*paFlanksUpstream > Pacuta-paFlanksUpstream10X-counts.txt | head -2

# output 
    342145 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_10x_sorted.bedgraph.bed-paFlanksUpstream
      3777 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_10x_sorted.bedgraph-Meth.bed-paFlanksUpstream


wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*5x*paFlanksUpstream > Pacuta-paFlanksUpstream5X-counts.txt | head -2 
# output 
    580660 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_5x_sorted.bedgraph.bed-paFlanksUpstream
      7511 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_5x_sorted.bedgraph-Meth.bed-paFlanksUpstream
```

#### Flanks 

```
wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*10x*paFlanks > Pacuta-paFlanks10X-counts.txt | head -2

#output 
    571789 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_10x_sorted.bedgraph.bed-paFlanks
      8339 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_10x_sorted.bedgraph-Meth.bed-paFlanks

wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*5x*paFlanks > Pacuta-paFlanks5X-counts.txt | head -2

#output 
   1001849 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_5x_sorted.bedgraph.bed-paFlanks
     17638 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_5x_sorted.bedgraph-Meth.bed-paFlanks
```

#### CDS 

```
wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*10x*paCDS > Pacuta-paCDS10X-counts.txt | head -2

#output
    897455 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_10x_sorted.bedgraph.bed-paCDS
     43673 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_10x_sorted.bedgraph-Meth.bed-paCDS

wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*5x*paCDS > Pacuta-paCDS5X-counts.txt | head -2

#output 
    1195194 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_5x_sorted.bedgraph.bed-paCDS
      69117 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_5x_sorted.bedgraph-Meth.bed-paCDS
``` 

#### Transcript 

```
wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*5x*paTranscript > Pacuta-paTranscript10X-counts.txt | head -2

#output 
    3216893 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_5x_sorted.bedgraph.bed-paTranscript
     154520 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_5x_sorted.bedgraph-Meth.bed-paTranscript

wc -l /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/*10x*paTranscript > Pacuta-paTranscript5X-counts.txt | head -2

#output 
   2059224 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_10x_sorted.bedgraph.bed-paTranscript
      81997 /data/putnamlab/estrand/HoloInt_WGBS/merged_cov_genomev2/1047_10x_sorted.bedgraph-Meth.bed-paTranscript
```

Left off at:
1.) make list of current issues to address 
2.) next step after making counts.txt files 