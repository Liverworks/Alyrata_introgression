#! /bin/bash
#BSUB -J dipl
#BSUB -q normal
#BSUB -M 2000 -R "rusage[mem=2000]"
#BSUB -n 10
#BSUB -o dipl_%J_output.txt
#BSUB -e dipl_%J_error.txt

set -x #echo on

# This script picks two random alleles from polyploids in a mixed-ploidy VCF and outputs diploid VCF
# This version uses GNU parallel to speed things up.

vcf='All_lyrata_fourfolds.vcf.gz'
#out=/netscratch/dep_mercier/grp_novikova/Potamogeton/phylogeny/admixture/${vcf#*vcf/}
out=${vcf%.vcf*}_dipl.vcf.gz
#mkdir -p ${out%/*}

dipscript="/netscratch/dep_mercier/grp_novikova/nikita/scripts/vcf_analysis/admixture/diploidize-vcf.gawk"

zcat ${vcf} | pv |
  parallel -j8 --pipe --keep-order --block 10M $dipscript |
  bgzip -@ 8 > $out

