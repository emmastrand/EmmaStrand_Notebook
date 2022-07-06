---
layout: post
title: Holobiont Integration ITS2 Pipeline 2022
date: '2022-07-05'
categories: Processing
tags: ITS2, DNA, holobiont integration
projects: Holobiont Integration
---

# Holobiont Integration ITS2 Bioinformatics pipeline - Andromeda version

I'm re-doing the pipeline for this so that when we publish this is reproducible. The first time around was done on my local computer in 2019.

Original pipeline on local computer, includes background information on ITS2, NG Sequencing, SymPortal: https://github.com/hputnam/Acclim_Dynamics/blob/master/ITS2_seq/ITS2_bioinformatic_pipeline.md.

This ITS2 on the cluster script edited from [K. Wong ITS2 andromeda pipeline](https://github.com/kevinhwong1/Porites_Rim_Bleaching_2019/blob/master/scripts/ITS2/PJB_Symportal_ITS2_Analysis.md) and [E. Strand ITS2 andromeda pipepline](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-01-14-KBay-Bleaching-Pairs-ITS2-Analysis-Pipeline.md)

## Set-up

### File location

Original on andromeda:

`/data/putnamlab/KITT/hputnam/ITS2/FULL_ITS2`.

Copy to my folder on andromeda. I copy these files instead of using the originals in case I make an error in coding and don't accidentally change the original sequence file.

`cp -r /data/putnamlab/KITT/hputnam/ITS2/FULL_ITS2/ /data/putnamlab/estrand/HoloInt_ITS2`

File path to reference for the below scripts:

`/data/putnamlab/estrand/HoloInt_ITS2/FULL_ITS2`.


### copy metadata file from local computer to andromeda

Outside of andromeda.

```
scp ~/MyProjects/Acclim_Dynamics/ITS2_seq/R_Input/ITS2_Full.csv emma_strand@ssh3.hac.uri.edu:/data/putnamlab/estrand/HoloInt_ITS2/HoloInt_ITS2_metadata.csv
```

## Scripts for analysis

See E. Strand's [Setting Up Andromeda and Conda Environment](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-01-14-KBay-Bleaching-Pairs-ITS2-Analysis-Pipeline.md#-setting-up-andromeda-and-conda-environment), [Creating a reference database](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-01-14-KBay-Bleaching-Pairs-ITS2-Analysis-Pipeline.md#-creating-a-reference-database), and [Testing installation and reference databases](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-01-14-KBay-Bleaching-Pairs-ITS2-Analysis-Pipeline.md#-testing-installation-and-reference-databases) sections on how to get SymPortal installed.

For Holobiont Integration project - SymPortal and SP reference database downloaded January 18th, 2022. (Include this info in paper).

### Loading SymPortal and metadata

`nano symportal_load.sh`. This takes 8+ hours.

```
#!/bin/bash
#SBATCH -t 48:00:00 #I ran this on 24:00:00 but just in case this takes longer b/c more files, use 48 next time
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab                  
#SBATCH --error="script_error_symportal_load" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_symportal_load" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Miniconda3/4.9.2

eval "$(conda shell.bash hook)"
conda activate symportal_env

module load SymPortal/0.3.21-foss-2020b
module unload SymPortal/0.3.21-foss-2020b

export PYTHONPATH=/data/putnamlab/estrand/SymPortal/:/data/putnamlab/estrand/SymPortal/lib/python3.7/site-packages:$PYTHONPATH

export PATH=/data/putnamlab/estrand/SymPortal/:/data/putnamlab/estrand/SymPortal/bin:$PATH

main.py --load /data/putnamlab/estrand/HoloInt_ITS2/FULL_ITS2 \
--name HoloInt1 \
--num_proc $SLURM_CPUS_ON_NODE \
--data_sheet /data/putnamlab/estrand/HoloInt_ITS2/HoloInt_ITS2_metadata.csv
```

`less output_script_symportal_load`:

```
# one line per file: only printing sample HP101 here to view
Lat and long are currently nan for HP101. Values will be set to 999

Creating data_set_sample objects
^MCreating data_set_sample HP101

Performing initial mothur QC
HP101: QC started
HP101: data_set_sample_instance_in_q.num_contigs = 63180
HP101: starting fwd PCR. This may take some time.
HP101: starting rev PCR. This may take some time.
HP101: data_set_sample_instance_in_q.post_qc_unique_num_seqs = 278
HP101: data_set_sample_instance_in_q.post_qc_absolute_num_seqs = 19738
HP101: Initial mothur complete

Performing potential sym tax screening QC
HP101: verifying seqs are Symbiodinium and determining clade
HP101: BLAST complete
HP101: 0 sequences thrown out initially due to being too divergent from reference sequences

Performing sym non sym tax screening QC
HP101: 0 sequences thrown out initially due to being too divergent from reference sequences
HP101: non_sym_unique_num_seqs = 0
HP101: non_sym_absolute_num_seqs = 0
HP101: unique_num_sym_seqs = 278
HP101: absolute_num_sym_seqs = 19738
HP101: size_violation_absolute = 0
HP101: size_violation_unique = 0
HP101: pre-med QC complete

HP108: starting MED analysis
HP108: padding sequences
HP108: decomposing
HP108: MED analysis complete
HP108: starting MED analysis
HP108: padding sequences
HP108: decomposing
HP108: MED analysis complete

Creating DataSetSampleSequencePM objects
Populating the consolidated sequence to sample and abundance dictionaryfor pre-MED sequence processing
Processing pre-MED seqs for sample 1 of 255

255 out of 255 samples successfully passed QC.
0 samples produced errors

...

DATA LOADING COMPLETE
DataSet id: 6
DataSet name: HoloInt1
Loading completed in 52766.7060508728s
DataSet loading_complete_time_stamp: 20220706T055541
```

`less script_error_symportal_load`:

```
# series of warning for negative eigenvalues.. come back to this.

/opt/software/scikit-bio/0.5.5-foss-2020b/lib/python3.8/site-packages/skbio/stats/ordination/_principal_coordinate_analysis.py:143: Runt
imeWarning: The result contains negative eigenvalues. Please compare their magnitude with the magnitude of some of the largest positive
eigenvalues. If the negative ones are smaller, it's probably safe to ignore them, but if they are large in magnitude, the results won't
be useful. See the Notes section for more details. The smallest eigenvalue is -0.00932804128381559 and the largest is 5.293133466289359.
```

file outputs:   
- mothur log file for every sequence file

Moved all mothur output to a new folder for organization.

```
$ mkdir mothur_output
$ mv mothur* mothur_output
```

### within SymPortal folder on andromeda

`$ ls SymPortal`

```
(base) [emma_strand@ssh3]/data/putnamlab/estrand/SymPortal% ls
bin               dbBackUp          django_general.py  lib          manage.py    pop_datasheet_seq_file_cols.py  reference_trees  sp_config.py        temp
data_analysis.py  db.sqlite3        easybuild          lib64        output.py    populate_db_ref_seqs.py         refSeqDB.fa      symbiodiniaceaeDB   tests
data_loading.py   distance.py       exceptions.py      LICENSE.txt  outputs      __pycache__                     seq_match.py     symportal_env.yml   virtual_objects.py
dbApp             distance.py.orig  general.py         main.py      plotting.py  README.md                       settings.py      symportal_utils.py
```

The output of each SymPortal run will go into `outputs` >  `analyses` and be assigned a #.

Within my folder analyses #2-5 were run for my Bleaching Pairs project.


### Running Analysis

`nano symportal_analysis.sh`. This takes ~10 minutes.

I used --analyse 6 because 2-5 in my analyses folder was from the Bleaching Pairs project so the next ID will be this one.

```
#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab                  
#SBATCH --error="script_error_run_analysis" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_run_analysis" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Miniconda3/4.9.2

eval "$(conda shell.bash hook)"
conda activate symportal_env

module load SymPortal/0.3.21-foss-2020b
module unload SymPortal/0.3.21-foss-2020b

export PYTHONPATH=/data/putnamlab/estrand/SymPortal/:/data/putnamlab/estrand/SymPortal/lib/python3.7/site-packages:$PYTHONPATH

export PATH=/data/putnamlab/estrand/SymPortal/:/data/putnamlab/estrand/SymPortal/bin:$PATH

# Checking dataset number
/data/putnamlab/estrand/SymPortal/main.py --display_data_sets

# Running analysis
/data/putnamlab/estrand/SymPortal/main.py --analyse 6 --name HoloInt1 --num_proc $SLURM_CPUS_ON_NODE

# Checking data analysis instances
/data/putnamlab/estrand/SymPortal/main.py --display_analyses
```

Analyses info (folder to be copied to local computer):

ANALYSIS COMPLETE: DataAnalysis:
        name: HoloInt1
        UID: 6

DataSet analysis_complete_time_stamp: 20220706T085312

2: BleachingPairs_analysis      20220119T073111
3: BleachingPairs_analysis      20220119T074538
4: BleachingPairs_analysis      20220119T074937
5: BleachingPairs_analysis      20220119T075742
6: HoloInt1     20220706T084046


### copying output to local computer for analysis in R

```
## in terminal window outside of andromeda
$ scp -r emma_strand@ssh3.hac.uri.edu:../../data/putnamlab/estrand/SymPortal/outputs/analyses/6/20220706T084046 ~/MyProjects/Acclim_Dynamics/ITS2_seq/SymPortal_Andromeda_2022_Output/  
```
