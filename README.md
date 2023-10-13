# Daytona_WNV
A nextflow pipeline for West Nile Virus (WNV)

## What to do
The pipeline is developed to analyze WNV genome data in fastq format. It can identify the taxon species, the percent of reads mapped against reference genome, the coverage and depth of reference genome, consensus sequence, VADR flag, SNPs, ect. 

## Prerequisites
Nextflow is required. The detail of installation can be found in https://github.com/nextflow-io/nextflow.

Python v3.7 or higher  is required.

Singularity/Apptainer is also required. The detail of installation can be found in https://singularity-tutorial.github.io/01-installation/.

## Recommended conda environment installation
   ```bash
   conda create -n WNV -c conda-forge python=3.10
   ```
   ```bash
   conda activate WNV
   ```
## How to run
1. put your data files into directory /fastqs. Your data file's name should look like "JBS22002292_1.fastq.gz", "JBS22002292_2.fastq.gz". Test data can be found in the directory /fastqs/testdata. If you want to use the test data, copy them to the directory /fastqs.
2. open file "parames.yaml", set the parameters. 
3. get into the top directory of the pipeline, run
   ```bash
   sbatch ./daytona_wnv.sh
   ```
## Results
All results can be found in the directory /output.

### Note
1: For first running the pipeline, if there are no index files (*.fai, *.sa, *.pac, *.bwt, *.ann, *.amb) in the folder "reference", you need run the indexing command to generate 5 index files in the folder "reference": 
    ```bash
    bwa index reference.fasta 
    ```
    
2: Default python is v3.6 in HPG, while the pipeline requires at least python 3.7. Do not directly use "module load python" in HPG terminal, as the loaded python misses some modules, such as "site". The recommanded way is to install a higher python version by conda.  
