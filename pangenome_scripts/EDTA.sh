#! /bin/bash
#BSUB -J EDTA
#BSUB -q bigmem
#BSUB -M 300000 -R "rusage[mem=200000]"
#BSUB -n 20

set -x #echo on

# This script runs EDTA TE predictor. More than 140 threads so not multicore queue.

shopt -s expand_aliases
source /netscratch/dep_mercier/grp_novikova/nikita/.bashrc
conda activate /netscratch/dep_mercier/grp_novikova/nikita/.conda/envs/EDTA

#fa='../../seemblies_only/WS1/ragtag.scaffolds.fasta'
fa="../te11_sup_fix.fa"
dir="te11_sup"
#echo $dir
#mkdir -p $dir &&
cd $dir

EDTA.pl --genome ${fa} --overwrite 1 --sensitive 1 --anno 1 --evaluate 1 --threads 20 #--cds genome.cds.fa --curatedlib file.liban --exclude file.bed

