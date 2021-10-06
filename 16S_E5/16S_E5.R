# 16S E5 
# First pass run through 

library(plyr)
library(dplyr)
library(stringr)
library(tidyr)
library(readr)

## Creating metadata files 
## 1. Sample manifest file 
## filelist.csv created during pipeline in andromeda and scp to desktop to work with in R

file_names <- read.csv("filelist.csv", header = FALSE) %>% select(V2) %>% ## reading in filelist as dataframe and only the second column
  filter(str_detect(V2, "URI")) %>% # keeping only the rows that have a file name fastq.gz
  dplyr::rename(`absolute-filepath` = V2) # renaming to match the verbiage of qiime2 

sample_manifest <- file_names # creating a new df based on the original file_names df 
sample_manifest$path <- "/data/putnamlab/estrand/16S_E5/raw_files/" #adding the absolute file path

sample_manifest <- sample_manifest %>% unite(`absolute-filepath`, path, `absolute-filepath`, sep = "") %>% # merging the two columns to complete the file path 
  mutate(direction = case_when(grepl("R1", `absolute-filepath`) ~ "forward",
                               grepl("R2", `absolute-filepath`) ~ "reverse")) # creating a new column to state whether forward or reverse based on the R value in the sequence title name 

sample_manifest$`sample-id` <- substr(sample_manifest$`absolute-filepath`, 42, 46) # creating a new column based on the sample id value 
sample_manifest$`sample-id`[sample_manifest$`sample-id` == "URI5_"] <- "URI5" # removing the _ from URI15 
sample_manifest <- sample_manifest[, c(3, 1, 2)] # reordering the columns 

sample_manifest %>% write_csv(file = "sample_manifest_16S_E5.csv")

## 2. Sample metadata file 
