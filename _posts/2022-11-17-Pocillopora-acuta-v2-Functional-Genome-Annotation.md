---
layout: post
title: Pocillopora acuta v2 Functional Genome Annotation
date: '2022-11-17'
categories: Processing
tags: genome-annotation, bioinformatics
projects: Holobiont Integration
---

# Pocillopora acuta v2 Functional Genome Annotation

Contents:  
- [**Setting Up Andromeda**](#Setting_up) 
- [**Align query protein sequences against databases**](#blast)  
- [**BLAST2GO**](#blast2go)  
- [**Merge for Full Annotation**](#merge)  


### References:  

For detailed explanations of each step, refer to the below pipelines. 

**Functional Annotation** 

- Erin Chille Functional Annotation: https://github.com/echille/Mcapitata_Developmental_Gene_Expression_Timeseries/blob/master/0-BLAST-GO-KO/2020-10-08-M-capitata-functional-annotation-pipeline.md  
- Jill Ashey Functional Annotation: https://github.com/JillAshey/FunctionalAnnotation/blob/main/FunctionalAnnotation_Worflow.md  
- Kevin Wong Functional Annotation: https://github.com/hputnam/Past_Genome/blob/master/genome_annotation_pipeline.md#functional-annotation-1
- Danielle Becker-Polinski Functional Annotation: https://github.com/daniellembecker/DanielleBecker_Lab_Notebook/blob/master/_posts/2021-12-08-Molecular-Underpinnings-Functional-Annotation-Pipeline.md#overview
- Emma Strand Mcap v3 functional annotation: https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-11-02-M.capitata-Genome-v3-Functional-Annotation.md



## <a name="Setting_up"></a> **Setting Up Andromeda** 

### Shared Protein Databases from the Putnam Lab

Make directory for genomes: `mkdir genome_annotation` & `mkdir genome_annotation/scripts`

Trembl path: `/data/putnamlab/shared/databases/trembl_db/uniprot_trembl.fasta`  
Swiss: `/data/putnamlab/shared/databases/swiss_db/uniprot_sprot.fasta`
Uniprot: `/data/putnamlab/shared/databases/nr/`. 

Download the protein fasta files from genome: 

`wget http://cyanophora.rutgers.edu/Pocillopora_acuta/Pocillopora_acuta_HIv2.genes.pep.faa.gz` & `gunzip Pocillopora_acuta_HIv2.genes.pep.faa.gz`  

**Count number of protein sequences.** 

```
zgrep -c ">" /data/putnamlab/estrand/Pocillopora_acuta_HIv2.genes.pep.faa 

output: 33730
```

## <a name="blast"></a> **Align query protein sequences against databases** 

### NCBI nr database

Output: .tab and .xml file of aligned sequence info. The .xml file is the important one - it will be used as input for Blast2GO

`pacuta_blast_nr.sh`: 

```
#!/bin/bash
#SBATCH --job-name="PA-nr"
#SBATCH -t 240:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --mem=128GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/genome_annotation #### this should be your new output directory so all the outputs ends up here
#SBATCH --error=../"%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output=../"%x_output.%j" #once your job is completed, any final job report comments will be put in this file

# load modules needed (specific need for my computer)
source /usr/share/Modules/init/sh # load the module function

# load modules needed
echo "START" $(date)
module load DIAMOND/2.0.0-GCC-8.3.0 #Load DIAMOND

echo "Updating Mcap annotation" $(date)
diamond blastp -b 2 -d /data/putnamlab/shared/databases/nr -q /data/putnamlab/estrand/Pocillopora_acuta_HIv2.genes.pep.faa -o Pacuta_v2_blastp_annot -f 100 -e 0.00001 -k 1 --threads $SLURM_CPUS_ON_NODE --tmpdir /tmp/

echo "Search complete... converting format to XML and tab"

diamond view -a Pacuta_v2_blastp_annot.daa -o Pacuta_v2_blastp_annot.xml -f 5
diamond view -a Pacuta_v2_blastp_annot.daa -o Pacuta_v2_blastp_annot.tab -f 6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen

echo "STOP" $(date)
```

Check how many hits this yielded:

```
$ wc -l Pacuta_v2_blastp_annot.tab

output: X Pacuta_v2_blastp_annot.tab # ~X hits out of 33730
```

### SwissProt Database 

Output: .xml file of aligned sequence info

`pacuta_swissprot_blast.sh`:

```
#!/bin/bash
#SBATCH --job-name="PA-swiss"
#SBATCH -t 240:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --mem=128GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/genome_annotation #### this should be your new output directory so all the outputs ends up here
#SBATCH --error=../"%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output=../"%x_output.%j" #once your job is completed, any final job report comments will be put in this file

# load modules needed (specific need for my computer)
source /usr/share/Modules/init/sh # load the module function

# load modules needed
echo "START" $(date)
module load BLAST+/2.11.0-gompi-2020b #load blast module

echo "Blast against swissprot database" $(date)
blastp -max_target_seqs 5 -num_threads 20 -db /data/putnamlab/shared/databases/swiss_db/swissprot_20220307 -query /data/putnamlab/estrand/Pocillopora_acuta_HIv2.genes.pep.faa -evalue 1e-5 -outfmt '5 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen' -out Pacuta_v2_swissprot_protein.out

echo "STOP" $(date)
```

### Trembl database 

#### Split fasta file into six different files to make trembl run faster 

Do this in bluewaves:

```
mkdir ../split_files
cd ../split_files/

module load pyfasta/0.5.2

pyfasta split -n 6 /data/putnamlab/estrand/Pocillopora_acuta_HIv2.genes.pep.faa

output:
creating new files:
/data/putnamlab/estrand/Pocillopora_acuta_HIv2.genes.pep.0.faa
/data/putnamlab/estrand/Pocillopora_acuta_HIv2.genes.pep.1.faa
/data/putnamlab/estrand/Pocillopora_acuta_HIv2.genes.pep.2.faa
/data/putnamlab/estrand/Pocillopora_acuta_HIv2.genes.pep.3.faa
/data/putnamlab/estrand/Pocillopora_acuta_HIv2.genes.pep.4.faa
/data/putnamlab/estrand/Pocillopora_acuta_HIv2.genes.pep.5.faa
```

Moved the above files to my genome annotation/split_files folder. 


`pacuta_trembl_blast.sh`

```
#!/bin/bash
#SBATCH --job-name="PA-trem"
#SBATCH -t 240:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --mem=128GB
#SBATCH --account=putnamlab
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/genome_annotation #### this should be your new output directory so all the outputs ends up here
#SBATCH --error="%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output="%x_output.%j" #once your job is completed, any final job report comments will be put in this file

# load modules needed (specific need for my computer)
source /usr/share/Modules/init/sh # load the module function

echo "START" $(date)

module load BLAST+/2.11.0-gompi-2020b #load blast module

# running the blast against the trembl database 
echo "Blast against trembl database" $(date)

# creating array for the split files 
array1=($(ls /data/putnamlab/estrand/genome_annotation/split_files/Pocillopora_acuta_HIv2.genes.pep.*.faa))

for i in ${array1[${SLURM_ARRAY_TASK_ID}]}
do
blastp -max_target_seqs 1 \
-num_threads $SLURM_CPUS_ON_NODE \
-db /data/putnamlab/shared/databases/trembl_db/trembl_20220307 \
-query ${i} \
-evalue 1e-5 \
-outfmt '5 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen' \
-out ${i}.xml
done

echo "STOP" $(date)
```

### InterPro 

Remove the * character in some of the protein files. 

`sed -i s/\*//g Pocillopora_acuta_HIv2.genes.pep.faa` 

i = in-place (edit file in place) s = substitute /replacement_from_reg_exp/replacement_to_text/ = search and replace statement * = what I want to replace Add nothing for replacement_to_text g = global (replace all occurances in file)


`pacuta_interpro.sh`: 

```
#!/bin/bash
#SBATCH --job-name="PA-int"
#SBATCH -t 240:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --mem=128GB
#SBATCH --export=NONE
#SBATCH -D /data/putnamlab/estrand/genome_annotation #### this should be your new output directory so all the outputs ends up here
#SBATCH --error="%x_error.%j" #if your job fails, the error report will be put in this file
#SBATCH --output="%x_output.%j" #once your job is completed, any final job report comments will be put in this file

# load modules needed (specific need for my computer)
source /usr/share/Modules/init/sh # load the module function

echo "START $(date)"

module load InterProScan/5.52-86.0-foss-2021a   
module load Java/11.0.2
java -version

# Run InterProScan
interproscan.sh -version
interproscan.sh -f XML -i /data/putnamlab/estrand/Pocillopora_acuta_HIv2.genes.pep.faa -b pacutav2.interpro -iprlookup -goterms -pa 
interproscan.sh -mode convert -f GFF3 -i pacutav2.interpro.xml -b pacutav2.interpro

echo "DONE $(date)"
```

### Moving and copying the produced XML files to local desk top 

```


```


## <a name="blast2go"></a> **BLAST2GO** 

These steps happen on local computer b/c its an interface that doesn't require code. The following B2G protocol is from Jill Ashey and her functional annotation protocol: https://github.com/JillAshey/FunctionalAnnotation/blob/main/FunctionalAnnotation_Worflow.md

1. Register for Blast2GO free membership: https://www.blast2go.com/b2g-register-basic. 
2. Downland Blast2GO program: https://www.biobam.com/blast2go-previous-versions/

### Load XML files from NCBI, SwissProt, and Trembl databases in B2G

To load the file, go to File<Load<Load Blast results<Load Blast XML (Legacy)

Once the file is loaded, a table loads with info about those BLAST results (nr, Tags, SeqName, Description, Length, Hits, e-Value, and sim mean). All of the cells should be orange with Tags that say BLASTED. This indicates that these sequences have only been blasted, not mapped or annotated.

Only one .xml file can be loaded at here! To analyze all .xml files, go through these steps with each one separately.

### Map GO terms 

To map results, select the mapping icon (white circle with green circle inside) at the top of the screen. Then select Run Mapping. A box will open up; don't change anything, click run. Depending on the number of BLAST results, mapping could take hours to days. B2G will continue running if the computer is in sleep mode. Mapping status can be checked under the Progress tab in the lower left box. If mapping retrieved a GO term that may be related to a certain sequence, that sequence row will turn light green. Only move forward when the Progress tab is 100% completed.

### Annotate GO terms

To annotate, select the annot icon (white circle with blue circle inside) at the top of the screen. Then select Run Annotation. A box will open up; don't change anything unless thresholds need to be adjusted. If no changes are necessary, click next through the boxes until the final one and click run. Depending on the mapping results, annotating could take hours to days. B2G will continue running if the computer is in sleep mode. Annotation status can be checked under the Progress tab in the lower left box. If a GO term has been successfully assigned to a sequence, that sequence row will turn blue. Only move forward when the Progress tab is 100% completed.

### Merge with InterPro Scan Results 

A .xml file was generated during the IPS step. This file can be loaded into B2G and merged with the newly mapped and annotated data from NCBI, SwissProt, or Trembl. Once these files are merged, new columns will appear with IPS GO and enzyme code information.

### Export files

Once the mapping, annotating, and IPS merging are complete, download the table as a .txt file (this is the only option to save in B2G, can change to .csv later if needed). 

## <a name="merge"></a> **Merge for Full Annotation** 

These steps happen in an R script. Mine can be found for the Pacuta v2 within Holobiont Integration molecular github page. This was modeled after Jill Ashey's script: https://github.com/JillAshey/FunctionalAnnotation/blob/main/RAnalysis/annotation_20211102.Rmd