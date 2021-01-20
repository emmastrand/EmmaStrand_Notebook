# Steps for QC and Analysis of Bisulfite Sequencing Data

1. Download data from raw data repository
	* Bisulfite converted sequence files
	* Reference genome file
2. Run checksum to confirm full data retrival 
3. Run quality control checks on the sequencing data (Fastqc)
	* MBD and MeDIP BS Data
	
	* RRBS Data
	
	* Whole Genome Data
	
4. Trim and Quality Filter
5. Map BS reads to genome
6. Quantify methylation ratio of the loci
7. Filter methylation data for context and coverage
8. Analyze global methylation patterns
9. Determining differentially methylated loci
10. Identifying the genomic location of the differentially methylated loci
11. Visualization of DML