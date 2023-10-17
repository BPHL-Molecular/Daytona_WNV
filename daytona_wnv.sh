#!/bin/bash
#SBATCH --account=bphl-umbrella
#SBATCH --qos=bphl-umbrella
#SBATCH --job-name=WNV
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=400gb
#SBATCH --output=wnv.%j.out
#SBATCH --error=wnv.%j.err
#SBATCH --time=48:00:00

module load nextflow
module load apptainer

NXF_SINGULARITY_CACHEDIR=./
export NXF_SINGULARITY_CACHEDIR

APPTAINER_CACHEDIR=./
export APPTAINER_CACHEDIR

nextflow run wnv.nf -params-file params.yaml

sort ./output/*/report.txt | uniq > ./output/sum_report.txt
sed -i '/sampleID\tk_species/d' ./output/sum_report.txt
sed -i '1i sampleID\tk_species\tk_percent\treference\tstart\tend\tnum_raw_reads\tnum_clean_reads\tnum_mapped_reads\tpercent_mapped_clean_reads\tcov_bases_mapped\tpercent_genome_cov_map\tmean_depth\tmean_base_qual\tmean_map_qual\tassembly_length\tnumN\tpercent_ref_genome_cov\tVADR_flag\tQC_flag' ./output/sum_report.txt

cat ./output/assemblies/*.fa > ./output/assemblies.fasta
 

mv ./*.out ./output
mv ./*err ./output

dt=$(date "+%Y%m%d%H%M%S")
mv ./output ./output-$dt
rm -r ./work
#rm -r ./cache