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
- [**Running analysis**](#Running_analysis)      
- [**Troubleshooting**](#Troubleshooting)    
- [**Scripts**](#Scripts)   


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

Create a script to create conda environment. Run this as a script instead of within interactive mode, this steps takes awhile and you want to avoid this timing out on your computer instead of as a job on the cluster (4+ hours).

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

cd /data/putnamlab/estrand/SymPortal

eval "$(conda shell.bash hook)"
conda activate symportal_env

module load SymPortal/0.3.21-foss-2020b
module unload

export PYTHONPATH=/data/putnamlab/estrand/SymPortal/:/data/putnamlab/estrand/SymPortal/lib/python3.7/site-packages:$PYTHONPATH

export PATH=/data/putnamlab/estrand/SymPortal/:/data/putnamlab/estrand/SymPortal/bin:$PATH

python3 manage.py migrate

python3 populate_db_ref_seqs.py

module unload SymPortal/0.3.21-foss-2020b

echo "Mission Complete!" $(date)

```

Ouput from successful run:

```
$ cd /data/putnamlab/estrand/BleachingPairs_ITS2/scripts
$ nano output_script_ref_database

Operations to perform:
  Apply all migrations: dbApp
Running migrations:
  No migrations to apply.
All sequences already present in database.
Mission Complete! Fri Jan 14 17:18:16 EST 2022
```

## <a name="Test_database"></a> **Testing installation and reference databases**

Create a script to change installation specs and reference database.

"SymPortal was not built to run on a cluster, so permission access was tricky as you cannot write into the master installation module. Therefore, we need to change the python and SymPortal paths to the ones we created in our own directory. Additionally, some of the dependencies needed by SymPortal are only in the master installation module. To use these dependencies but write into our own SymPortal framework, we must load then unload the master SymPortal module in our script." from K.Wong's [analysis pipeline](https://github.com/kevinhwong1/Thermal_Transplant_Molecular/blob/main/scripts/Symportal_ThermalTransplant.md).

This takes 1+ hour.

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

Output:

```
Cleaning up after previous data analysis test: 1
Deleting /data/putnamlab/estrand/SymPortal/outputs/analyses/1
Cleaning up after previous data loading test: 4
Deleting /data/putnamlab/estrand/SymPortal/outputs/loaded_data_sets/4
Mission Complete! Tue Jan 18 11:15:16 EST 2022
```

## <a name="Load_data"></a> **Loading experimental data**

#### Creating metadata file

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

R script to create metadata file [link here](https://github.com/hputnam/HI_Bleaching_Timeseries/blob/main/scripts/ITS2_metadata.R) and script content at the bottom of this post. Open the blank template in excel and create the data columns in the R script to copy and paste into the excel worksheet. Added columns 'colony_id' and 'Bleach' for this project.

Fill in options:  
- sample_type: coral_field  
- host_phylum: cnidaria  
- host_class: anthozoa  
- host_order: scleractina  
- host_family: acroporidae  
- host_genus: montipora  
- host_species: capitata    

Secure copy paste metadata file to andromeda.

```
## in terminal window outside of andromeda
$ scp /Users/emmastrand/MyProjects/HI_Bleaching_Timeseries/data/ITS2/metadata/SymPortal_metadata.csv emma_strand@bluewaves.uri.edu:/data/putnamlab/estrand/BleachingPairs_ITS2/metadata/
```

#### Uploading metadata file

`$ cd /data/putnamlab/estrand/BleachingPairs_ITS2/scripts`  
`$ nano symportal_load.sh`

Copy and paste the below text into the symportal_load.sh file.

```
#!/bin/bash
#SBATCH -t 24:00:00
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

main.py --load /data/putnamlab/estrand/BleachingPairs_ITS2/raw_data \
--name BleachingPairs1 \
--num_proc $SLURM_CPUS_ON_NODE \
--data_sheet /data/putnamlab/estrand/BleachingPairs_ITS2/metadata/SymPortal_metadata.csv
```

## <a name="Running_analysis"></a> **Running analysis**

`$ cd /data/putnamlab/estrand/BleachingPairs_ITS2/scripts`  
`$ nano run_analysis.sh`

Copy and paste the below text into the run_analysis.sh script.

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
./main.py --display_data_sets

# Running analysis
./main.py --analyse 8 --name BleachingPairs_analysis --num_proc $SLURM_CPUS_ON_NODE

# Checking data analysis instances
./main.py --display_analyses
```

Secure copy paste the output to desktop.

```
## in terminal window outside of andromeda
$ scp emma_strand@bluewaves.uri.edu:/data/putnamlab/estrand/Symportal/outputs/analyses/
```

## <a name="Troubleshooting"></a> **Troubleshooting**

While trying to run the ref_database.sh script, I got the following error. See Ariana's pipeline on how she fixed this. Link at the top of this markdown file.

```
Traceback (most recent call last):
  File "populate_db_ref_seqs.py", line 6, in <module>
    from django.conf import settings
  File "/opt/software/SymPortal/0.3.21-foss-2020b/lib/python3.8/site-packages/django/conf/__init__.py", line 19, in <module>
    from django.utils.deprecation import RemovedInDjango40Warning
  File "/opt/software/SymPortal/0.3.21-foss-2020b/lib/python3.8/site-packages/django/utils/deprecation.py", line 5, in <modul$
    from asgiref.sync import sync_to_async
ModuleNotFoundError: No module named 'asgiref'
```

After fixing the above error, when running the ref_database.sh script, I got the following warnings. I think this is OK? I believe the program is creating a key when one isn't defined. Successful output message even with these warnings.   

```
System check identified some issues:

WARNINGS:
dbApp.AnalysisType: (models.W042) Auto-created primary key used when not defining a primary key type, by default 'django.db.m$
        HINT: Configure the DEFAULT_AUTO_FIELD setting or the AppConfig.default_auto_field attribute to point to a subclass o$
dbApp.Citation: (models.W042) Auto-created primary key used when not defining a primary key type, by default 'django.db.model$
        HINT: Configure the DEFAULT_AUTO_FIELD setting or the AppConfig.default_auto_field attribute to point to a subclass o$
dbApp.CladeCollection: (models.W042) Auto-created primary key used when not defining a primary key type, by default 'django.d$
        HINT: Configure the DEFAULT_AUTO_FIELD setting or the AppConfig.default_auto_field attribute to point to a subclass o$
dbApp.CladeCollectionType: (models.W042) Auto-created primary key used when not defining a primary key type, by default 'djan$
        HINT: Configure the DEFAULT_AUTO_FIELD setting or the AppConfig.default_auto_field attribute to point to a subclass o$
dbApp.DataAnalysis: (models.W042) Auto-created primary key used when not defining a primary key type, by default 'django.db.m$
        HINT: Configure the DEFAULT_AUTO_FIELD setting or the AppConfig.default_auto_field attribute to point to a subclass o$
dbApp.DataSet: (models.W042) Auto-created primary key used when not defining a primary key type, by default 'django.db.models$
        HINT: Configure the DEFAULT_AUTO_FIELD setting or the AppConfig.default_auto_field attribute to point to a subclass o$
dbApp.DataSetSample: (models.W042) Auto-created primary key used when not defining a primary key type, by default 'django.db.$
        HINT: Configure the DEFAULT_AUTO_FIELD setting or the AppConfig.default_auto_field attribute to point to a subclass o$
dbApp.DataSetSampleSequence: (models.W042) Auto-created primary key used when not defining a primary key type, by default 'dj$
        HINT: Configure the DEFAULT_AUTO_FIELD setting or the AppConfig.default_auto_field attribute to point to a subclass o$
dbApp.DataSetSampleSequencePM: (models.W042) Auto-created primary key used when not defining a primary key type, by default '$
        HINT: Configure the DEFAULT_AUTO_FIELD setting or the AppConfig.default_auto_field attribute to point to a subclass o$
dbApp.ReferenceSequence: (models.W042) Auto-created primary key used when not defining a primary key type, by default 'django$
        HINT: Configure the DEFAULT_AUTO_FIELD setting or the AppConfig.default_auto_field attribute to point to a subclass o$
dbApp.Study: (models.W042) Auto-created primary key used when not defining a primary key type, by default 'django.db.models.A$
        HINT: Configure the DEFAULT_AUTO_FIELD setting or the AppConfig.default_auto_field attribute to point to a subclass o$
dbApp.User: (models.W042) Auto-created primary key used when not defining a primary key type, by default 'django.db.models.Au$
        HINT: Configure the DEFAULT_AUTO_FIELD setting or the AppConfig.default_auto_field attribute to point to a subclass o$
```

When running the symportal_setup script, I got the following warnings. The output was still successful so I think this is OK?

```
/var/spool/slurmd/job106276/slurm_script: line 131: dirname: command not found
/var/spool/slurmd/job106276/slurm_script: line 131: dirname: command not found
/var/spool/slurmd/job106276/slurm_script: line 30: dirname: command not found
/var/spool/slurmd/job106276/slurm_script: line 31: dirname: command not found
/opt/software/scikit-bio/0.5.5-foss-2020b/lib/python3.8/site-packages/skbio/util/_testing.py:15: FutureWarning: pandas.util.t$
  import pandas.util.testing as pdt
Warning: [blastn] Examining 5 or more matches is recommended
```

When trying to upload the metadata (symportal_load.sh) I got the following errors: `Data sheet: {} is in an unrecognised format. Please ensure that it is either in .xlsx or .csv format.`.  


## <a name="Scripts"></a> **Scripts**

Creating a metadata file.

```
## ITS2 Metadata file
## notebook post to pipeline: https://github.com/emmastrand/EmmaStrand_Notebook/blob/master/_posts/2022-01-14-KBay-Bleaching-Pairs-ITS2-Analysis-Pipeline.md

library(plyr)
library(dplyr)
library(stringr)
library(tidyr)
library(readr)
library(ggplot2)

## creating file names for fastq path information
file_names <- read.csv("~/MyProjects/HI_Bleaching_Timeseries/data/ITS2/metadata/filenames.csv", header = FALSE) %>%
  dplyr::rename(seq.file = V1)

file_names <- file_names %>%
  mutate(direction = case_when(grepl("R1", seq.file) ~ "forward",
                               grepl("R2", seq.file) ~ "reverse")) # creating a new column to state whether forward or reverse based on the R value in the sequence title name

file_names$Sample.ID <- substr(file_names$seq.file, 1, 6) # creating a new column based on the sample id value

## creating metadata file from field information
collection.summary <- read.csv("~/MyProjects/HI_Bleaching_Timeseries/data/CollectionSummary.csv", header = TRUE) %>%
  select(-Biopsy., -Fragment.) %>% # removing 2 columns that are not needed for this metadata sheet
  dplyr::rename(Timepoint = Date)
collection.summary$Timepoint <- as.Date(collection.summary$Timepoint, format="%m/%d/%y")

sequencing.id <- read.csv("~/MyProjects/HI_Bleaching_Timeseries/data/16S/metadata/16S_sequencingID.csv", header = TRUE) %>%
  subset(Project == "ES_BP" & Type == "ITS2") %>% # selecting for just this 16S project's data and excluding Ariana and Kevin's
  dplyr::rename(ColonyID = Coral.ID) %>%
  select(Sample.ID, ColonyID, Timepoint) %>%
  mutate(Timepoint = case_when(
    Timepoint == "2019-07-20" ~ "2019-07-19",
    Timepoint == "2019-12-04" ~ "2019-12-04"))

sequencing.id$ColonyID <- sub(".","", sequencing.id$ColonyID)
sequencing.id$ColonyID <- sub(".","", sequencing.id$ColonyID) # do this twice to get rid of both the M and "-" symbol

collection.summary <- collection.summary %>% unite(Group, ColonyID, Timepoint, sep = " ")
sequencing.id <- sequencing.id %>% unite(Group, ColonyID, Timepoint, sep = " ")

metadata <- full_join(collection.summary, sequencing.id, by = "Group") %>% na.omit() %>%
  separate(Group, c("ColonyID", "Year", "Month", "Day")) %>%
  unite(Timepoint, Year, Month, sep = "-") %>% unite(Timepoint, Timepoint, Day, sep = "-")

## expanding metadata to include fastq path information

metadata <- full_join(metadata, file_names, by = "Sample.ID")
metadata <- metadata %>% spread(direction, seq.file)

metadata %>% write_csv(file = "~/MyProjects/HI_Bleaching_Timeseries/data/ITS2/metadata/metadata.csv")

```
