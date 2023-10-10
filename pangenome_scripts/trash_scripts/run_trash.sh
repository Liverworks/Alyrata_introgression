#!/bin/bash
#BSUB -J trash
#BSUB -q bigmem
#BSUB -M 20000 -R "rusage[mem=20000] "
#BSUB -n 1

set -x #echo on

# This script runs TRASH for prediction of tandem repeats (we use it for centromere identification).

shopt -s expand_aliases
source /netscratch/dep_mercier/grp_novikova/nikita/.bashrc
conda activate /netscratch/dep_mercier/grp_novikova/nikita/.conda/envs/trash


# PLEASE use fasta only with long chromosomes. That can be acieved by running `python prepFa_fix.py` on your fasta!
#fa='/netscratch/dep_mercier/grp_novikova/A.Lyrata/anna_g/mabs_assemblies/trash/PU6_chrom.fa'
fa='PU6_dipl.fa'

TRASH_run.sh ${fa} --simpleplot

#Further steps one might want to consider:
# - Counting occurrences of different monomer lengths
#
# 	csvtk freq -nrTf width all.repeats* > monomer_counts.tsv
#	tsvtk plot line monomer_counts.tsv -X width -Y frequency --scatter > monomer_counts.png
#
# - Making *normal* GFF files with most frequent monomers and colors for IGV
#
# 	colors8=( '#E41A1C' '#377EB8' '#4DAf4A' '#984EA3' '#FF7F00' '#A65628' '#F781BF' '#999999' ) # brewer set2 palette
# 	echo '##gff-version 3' > frequent_repeats.gff
#	tail -n+2 monomer_counts.tsv |
#	head -n8 | cut -f1 |
#	paste - <( printf '%s\n' ${colors8[@]} ) |
#	while read -ra line; do
#		grep ",${line[0]}," Summary.of* |
#		gawk -v col="${line[1]}" -v mon="${line[0]}" -v FS=',' -v OFS='\t' \
	#			'{print $2, "TRASH", "satellite_DNA", $3, $4, ".", "-", ".", "Class="mon";color="col}' >> frequent_repeats.gff
#	done
