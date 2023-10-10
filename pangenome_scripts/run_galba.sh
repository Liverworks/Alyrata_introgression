#!/bin/bash
#BSUB -J galba_masker
#BSUB -q multicore40
#BSUB -M 80000 -R "rusage[mem=80000] "
#BSUB -n 40

CONDA_PATH="/netscratch/dep_mercier/grp_novikova/Neobatrachus/Jie/conda/anaconda3"
# Activate the 'ema' conda environment
source $CONDA_PATH/etc/profile.d/conda.sh
conda activate base
# Paths
export AUGUSTUS_SCRIPTS_PATH='/netscratch/dep_mercier/grp_novikova/Neobatrachus/Jie/software/Augustus/scripts'
export AUGUSTUS_CONFIG_PATH='/netscratch/dep_mercier/grp_novikova/Neobatrachus/Jie/software/Augustus/config'
export SCORER_PATH='/netscratch/dep_mercier/grp_novikova/Neobatrachus/Jie/software/miniprot-boundary-scorer'
export TSEBRA_PATH='/netscratch/dep_mercier/grp_novikova/Neobatrachus/Jie/software/TSEBRA/bin'
export MINIPROTHINT_PATH='/netscratch/dep_mercier/grp_novikova/Neobatrachus/Jie/software/miniprothint'
export GALBA_SCRIPTS_PATH='/netscratch/dep_mercier/grp_novikova/Neobatrachus/Jie/software/GALBA/scripts'

# Update PATH to include custom paths
export PATH=/netscratch/dep_mercier/grp_novikova/Neobatrachus/Jie/software/miniprot:$AUGUSTUS_SCRIPTS_PATH:$AUGUSTUS_CONFIG_PATH:$SCORER_PATH:$TSEBRA_PATH:$MINIPROTHINT_PATH:$GALBA_SCRIPTS_PATH:$PATH

# File locations
#genome_file='/netscratch/dep_mercier/grp_novikova/Neobatrachus/Jie/scripts/fake_10x/repeatmasker/repeatmaskerRM_Npictus_14703/Npictus_14703.1.fasta.masked'
genome_file='/netscratch/dep_mercier/grp_novikova/A.Lyrata/anna_g/mabs_assemblies/edta/nt5_sup_fix.fa.new.masked'
protein_file='/netscratch/dep_mercier/grp_novikova/A.Lyrata/anna_g/stlfr/bracker_try/Alyrata_384_v2.1.protein.fa'

# Execute
/netscratch/dep_mercier/grp_novikova/Neobatrachus/Jie/software/GALBA/scripts/galba.pl --genome=${genome_file} --prot_seq=${protein_file} --threads 40

