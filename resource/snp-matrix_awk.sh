#! /bin/bash
#BSUB -J mat
#BSUB -q normal
#BSUB -M 100 -R "rusage[mem=100]"
#BSUB -n 1

set -x #echo on

# This script takes biallelic SNPs from a VCF file and converts it to a TSV matrix with SNP states.
# SNP state is a proportion of ALT alleles in the sample's genotype.
# It could have transposed the matrix so that rows were samples, but the table is harder to be imported into R this way.

vcf='../anna_g/mabs_assemblies/mapping/longreads_all_june2025_pericentr.vcf.gz'
outname='../anna_g/mabs_assemblies/mapping/longreads_all_june2025_pericentr_matrix.tsv'

zcat ${vcf} |
gawk 'BEGIN { OFS="\t" }
     !/##/ {if (/#CHROM/) { print }
            else if ($4$5 ~ /^[ATGC]{2}$/) {
                for (i=10; i<=NF; i++) {
                    if ($i ~ /^\./) { $i = "." }
                    else { gsub(/:.*/, "", $i); $i = gsub(/1/, "1", $i) / (length($i)+1) * 2 }
                }
                print
            }
      }' |
cut --complement -f3-9  > ${outname}
