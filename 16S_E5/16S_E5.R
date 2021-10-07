# 16S E5 
# First pass run through 

library(plyr)
library(dplyr)
library(stringr)
library(tidyr)
library(readr)
library(ggplot2)

## CREATING METADATA FILES 
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

sample_manifest$`sample-id` <- substr(sample_manifest$`absolute-filepath`, 42, 47) # creating a new column based on the sample id value 
sample_manifest$`sample-id`[sample_manifest$`sample-id` == "URI5_S"] <- "URI5" # removing the _S from URI15 
sample_manifest$`sample-id`[sample_manifest$`sample-id` == "URI63_"] <- "URI63" # removing the _ from URI63 
sample_manifest$`sample-id`[sample_manifest$`sample-id` == "URI57_"] <- "URI57" # removing the _ from URI57 
sample_manifest <- sample_manifest[, c(3, 1, 2)] # reordering the columns 

sample_manifest %>% write_csv(file = "sample_manifest_16S_E5.csv")

## 2. Sample metadata file 
## Downloaded from: https://docs.google.com/spreadsheets/d/1A764av1a3VORX6m9aDUEcoY9Bx9l0fvGtV5ycm2J9Wo/edit#gid=1085368873
## Open in excel. In the first row, add "#q2:types" and then either "categorical" or "numeric" in subsequent rows

metadata <- read.csv("metadata.csv", header = TRUE) %>% select(SampleID, timepoint, collection_date, collection_site, colony_id) # selecting desired columns 
metadata$SampleID <- paste("URI", metadata$SampleID, sep="") #adding the URI verbiage to the sample ID
metadata[1,1] <- "#q2:types"

metadata <- metadata %>% rename(`#SampleID` = SampleID)

write.table(metadata, "metadata.txt", sep = "\t", row.names = FALSE, quote = FALSE)

## PLOTTING DENOISE DATA 
## "denoising-stats.qzv" viewed in QIIME2 View. tsv downloaded from that webpage for input in the following script

denoise <- read.table("denoising_stats.tsv", sep="\t", header = TRUE) # read in tsv file obtained from QIIME2 view 

denoise <- denoise[, c(1,2,3,5,6,8,4,9)] # reordering columns to make it easier to plot 
denoise <- denoise %>% gather(statistic, value, 2:6) # aggregates the three variables we are interested in to make it easier to plot 

denoise$statistic <- factor(denoise$statistic, levels=c("input","filtered","denoised","merged","non.chimeric"))

denoise.plot <- ggplot(data = denoise, aes(x = statistic, y = value)) +
  theme_classic() + geom_boxplot() +
  geom_jitter(color="black", size=0.4, alpha=0.9) + 
  theme(legend.position = "none") +
  scale_color_manual(values = cols) + 
  ylab("# of reads") + ggtitle("Denoising statistics for E5 16S test run (12 samples)") +
  theme(plot.title = element_text(hjust = 0.5)) +
  xlab("statistic"); denoise.plot

ggsave(file="denoising-statistics.png", denoise.plot, width = 11, height = 6, units = c("in"))


