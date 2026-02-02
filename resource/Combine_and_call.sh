#!/bin/sh
#SBATCH --cpus-per-task=10
#SBATCH --job-name=eur_map
#SBATCH --partition=normal
#SBATCH --mem-per-cpu=10G


gatk GenomicsDBImport --java-options "-Xmx100G" \
    -L scaffold_8 \
    -R /biodata/dep_mercier/grp_novikova/A.Lyrata/ref/Alyrata/NT1_assembly/final_NT1/NT1_220222.fasta \
    -V pipeline/add.list \
 --overwrite-existing-genomicsdb-workspace \
 --reader-threads 8  --genomicsdb-workspace-path Add_sc8

gatk  --java-options "-Xmx235G" CombineGVCFs \
    -R /biodata/dep_mercier/grp_novikova/A.Lyrata/ref/Alyrata/NT1_assembly/final_NT1/NT1_220222.fasta \
    --variant  sample_nowilli.list  -L scaffold_2 -O Eur_lyrata_sc2.g.vcf.gz #sample_paths_cat.list
