---
layout: post
title: KBay Bleaching Pairs ITS2 Analysis Pipeline
date: '2022-01-14'
categories: Analysis
tags: DNA, 16S, KBay, bioinformatics
projects: KBay Bleaching Pairs
---

# KBay Bleaching Pairs ITS2 Analysis Pipeline

Putnam Lab ITS2 Protocol found [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2020-01-31-ITS2-Sequencing-Protocol.md) and notebook post on the laboratory work found [here](https://github.com/kevinhwong1/KevinHWong_Notebook/blob/master/_posts/2021-11-09-20211109-ITS2-KW-AH-ES-samples.md).  

Other examples of this pipeline analysis:  
- K.Wong *Porites asteroides* [pipeline](https://github.com/kevinhwong1/Thermal_Transplant_Molecular/blob/main/scripts/Symportal_ThermalTransplant.md)      
- A.Huffmyer *M. capitata* [pipeline part 1](https://github.com/AHuffmyer/ASH_Putnam_Lab_Notebook/blob/master/_posts/2021-12-29-Mcapitata-Development-ITS2-Analysis-Part-1.md) and [part 2](https://github.com/AHuffmyer/ASH_Putnam_Lab_Notebook/blob/master/_posts/2021-12-29-Mcapitata-Development-ITS2-Analysis-Part-2.md)  

This analysis was performed on the URI HPC Andromeda cluster using the [SymPortal Framework](https://github.com/didillysquat/SymPortal_framework).  

#### KBay Bleaching Pairs project

Project github: [HI_Bleaching_Pairs](https://github.com/hputnam/HI_Bleaching_Timeseries)  
Molecular laboratory work spreadsheet: [excel doc](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/data/Molecular-labwork.xlsx)  

40 adult coral biopsies of *M. capitata* used for molecular analysis from July 2019 and December 2019 time points. Laboratory work for this project found [here](https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2021-11-09-KBay-Bleaching-Pairs-16S-Processing.md).

Raw data path (not edit-able): ../../data/putnamlab/shared/ES_BP_ITS2  
Raw data path (edit-able): ../../data/putnamlab/estrand/BleachingPairs_ITS2/raw_data    
Output data path: ../../data/putnamlab/estrand/BleachingPairs_ITS2

Contents:
- [**Setting Up Andromeda and Conda Environment**](#Setting_up)  
- [**Creating the reference database**](#Ref_database)   
- [**Testing installation and reference databases**](#Test_database)  
- [**Loading experimental data**](#Load_data)  


## <a name="Setting_up"></a> **Setting Up Andromeda and Conda Environment**

Sign into andromeda: `$ ssh -l emma_strand ssh3.hac.uri.edu`.  
Navigate to data folder (path for all following scripts): `$ cd ../../data/putnamlab/shared/ES_BP_ITS2`

Double check number files in the folder: `$ ls -l | wc -l`. The output should be 80 (1 reverse and 1 forward for each sample; 40 x 2 = 80 files).

Make new folders for output and scripts:  
- Navigate to own username folder: `$ cd ../../data/putnamlab/estrand`.    
- Make a new directory within own username for the outputs: `$ mkdir BleachingPairs_ITS2`.    
- Navigate to the new directory: `$ cd BleachingPairs_ITS2`.  
- Make a new directory for the raw data: `$ mkdir raw_data`.      
- Make a new directory for the fastqc output in the new project folder: `$ mkdir fastqc_results`.  
- Make a new directory for the scripts: `$ mkdir scripts`.

Copy the raw data from the shared folder to the new 'raw_data' folder: `$ cp /data/putnamlab/shared/ES_BP_ITS2/*fastq.gz /data/putnamlab/estrand/BleachingPairs_ITS2/raw_data`.

#### Copy SymPortal into personal folder for permission access

```
$ cd data/putnamlab/estrand/
$ rsync -rl /opt/software/SymPortal/0.3.21-foss-2019b/ ./SymPortal/
```

#### Modify the settings and config file

Generate a secret key to then copy and paste into the settings.py file.

```
$ cd /data/putnamlab/estrand/SymPortal
$ module load SymPortal
$ mv settings_blank.py ./settings.py
$ mv sp_config_blank.py ./sp_config.py
$ base64 /dev/urandom | head -c50

# output
OWzKZQLX7r4KNHir09BMJGO4cSUp04mtmVmkz3XGzg8qsyQxZj
```

Copy and past the above secret key into the settings.py file.

```
$ nano settings.py

## output:
import os

dbPath = os.path.join(os.path.dirname(__file__), 'db.sqlite3')

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3', # Add 'postgresql_psycopg2', 'mysql', 'sqlite3' or 'oracle'.
        'NAME': '{}'.format(dbPath),                      # Or path to database file if using sqlite3.
        'OPTIONS': {'timeout':200}
    }
}



# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = False

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.dummy.DummyCache',
    }
}


INSTALLED_APPS = (
    'dbApp',
    )

### PASTE KEY BELOW HERE IN BETWEEN THE ''
SECRET_KEY = 'OWzKZQLX7r4KNHir09BMJGO4cSUp04mtmVmkz3XGzg8qsyQxZj'
####
```

Input user information into the config file.

```
$ nano sp_config.py

## output:
system_type = "local"
user_name = "undefined" ## INSERT USERNAME HERE
user_email = "undefined" ## INSERT EMAIL HERE

## Edited to:
system_type = "local"
user_name = "emma_strand"
user_email = "emma_strand@uri.edu"
```

#### Creating SymPortal conda environment

Create a script to create conda environment. Run this as a script instead of within interactive mode, this steps takes awhile and you want to avoid this timing out on your computer instead of as a job on the cluster (3+ hours).

```
$ cd /data/putnamlab/estrand/BleachingPairs_ITS2/scripts
$ nano create_conda.sh

## copy and paste below into the script

#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab                  
#SBATCH --error="script_error_create_conda" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_create_conda" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Miniconda3/4.9.2
module load SymPortal

conda env create -f $EBROOTSYMPORTAL/symportal_env.yml

```

## <a name="Ref_database"></a> **Creating a reference database**

Create a script to create a reference database

```
$ cd /data/putnamlab/estrand/BleachingPairs_ITS2/scripts
$ nano ref_database.sh

## copy and paste below into the script

#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab                  
#SBATCH --error="script_error_ref_database" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_ref_database" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Miniconda3/4.9.2

eval "$(conda shell.bash hook)"
conda activate symportal_env

module load SymPortal

python3 manage.py migrate

##### Populating reference_sequences

python3 populate_db_ref_seqs.py

module unload SymPortal

```

## <a name="Test_database"></a> **Testing installation and reference databases**

Create a script to change installation specs and reference database.

"SymPortal was not built to run on a cluster, so permission access was tricky as you cannot write into the master installation module. Therefore, we need to change the python and SymPortal paths to the ones we created in our own directory. Additionally, some of the dependencies needed by SymPortal are only in the master installation module. To use these dependencies but write into our own SymPortal framework, we must load then unload the master SymPortal module in our script." from K.Wong's [analysis pipeline](https://github.com/kevinhwong1/Thermal_Transplant_Molecular/blob/main/scripts/Symportal_ThermalTransplant.md).

```
$ cd /data/putnamlab/estrand/BleachingPairs_ITS2/scripts
$ nano symportal_setup.sh

## copy and paste the below commands in the bash script

#!/bin/bash
#SBATCH -t 24:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --mem=100GB
#SBATCH --mail-type=BEGIN,END,FAIL #email you when job starts, stops and/or fails
#SBATCH --mail-user=emma_strand@uri.edu #your email to send notifications
#SBATCH --account=putnamlab                  
#SBATCH --error="script_error_symportal_setup" #if your job fails, the error report will be put in this file
#SBATCH --output="output_script_symportal_setup" #once your job is completed, any final job report comments will be put in this file

source /usr/share/Modules/init/sh # load the module function

module load Miniconda3/4.9.2

eval "$(conda shell.bash hook)"
conda activate symportal_env

module load SymPortal/0.3.21-foss-2020b
module unload

export PYTHONPATH=/data/putnamlab/estrand/SymPortal/:/data/putnamlab/estrand/SymPortal/lib/python3.7/site-packages:$PYTHONPATH

export PATH=/data/putnamlab/estrand/SymPortal/:/data/putnamlab/estrand/SymPortal/bin:$PATH

##### Checking installation
python3 -m tests.tests

echo "Mission Complete!" $(date)
```

## <a name="Load_data"></a> **Loading experimental data**

#### Uploading metadata file

Downloaded [blank template](https://symportal.org/static/resources/SymPortal_datasheet_20190419.xlsx) from Symportal to create metadata sheet.

Create file for list of raw sequence file names and secure copy paste that in a terminal window outside of Andromeda.

```
$ cd /data/putnamlab/estrand/BleachingPairs_ITS2
$ mkdir metadata
$ cd /data/putnamlab/estrand/BleachingPairs_ITS2/raw_data
$ mv filenames.csv ../metadata/

## in terminal window outside of andromeda
$ scp emma_strand@bluewaves.uri.edu:/data/putnamlab/estrand/BleachingPairs_ITS2/metadata/filenames.csv /Users/emmastrand/MyProjects/HI_Bleaching_Timeseries/data/ITS2/metadata/
```

Left off at creating the R script to make the metadata. 
