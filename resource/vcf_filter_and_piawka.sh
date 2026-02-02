module load bcftools/v1.22 htslib/v1.22

vcf="/netscratch/dep_mercier/grp_novikova/A.Lyrata/Eur_lyrata/All_lyrata_final_allpos.vcf.gz"

cd $( dirname ${vcf} )

# Basic quality filter: first mask calls with FMT/DP<3 on per-sample basis,
# then exclude all sites that (1) have no data, (2) do not meet quality criteria.
# Do not filter by missingness here because data from few individuals of one species might be important for within-species sel scans

#bcftools filter -Ou -S . -e 'FMT/DP<4' ${vcf} |
#  bcftools view -e "(N_MISSING==N_SAMPLES) || (QD<2.0 || FS>60.0 || SOR>3 || MQ<40.0 || MQRankSum<-12.0 || ReadPosRankSum<-8.0)" \
#  --threads 128 -Oz -Wtbi -o ${vcf%.vcf*}_qual.vcf.gz

# Biallelic segregating sites: ADMIXTURE, 4fds etc.
#bcftools view -m2 -M2 -v snps -e 'AC==0 || AC==AN' ${vcf%.vcf*}_qual.vcf.gz -Oz -Wtbi --threads 128 -o ${vcf%.vcf*}_bial.vcf.gz

# fourfold degenerate sites (keeping invariants!)
degenotate="Filtered_helixer_degenotate/degeneracy_four-folds.bed"
awk '$5==4 {print $1,$2,$3}' OFS="\t" $degenotate > 4fds.bed
bcftools view -T 4fds.bed -V indels ${vcf%.vcf*}_qual.vcf.gz -Oz -Wtbi --threads 128 -o ${vcf%.vcf*}_4fds.vcf.gz

# piawka runs (using v9.0 cuz better)
piawka="/netscratch/dep_mercier/grp_novikova/software/piawka-dev/piawka"

# All-vs-all Nei's D divergence matrix for network and Fig 4B (too slow with anything but fourfold sites)
# Faster if a file with windows is given, this is how I make it:
fai="/netscratch/dep_mercier/grp_novikova/A.Lyrata/resources/NT1_220222.fasta.fai"
bedtools makewindows -w 100000 -b <( awk '{print $1"\t0\t"$2}' $fai ) > win100k.bed

# Also calculating Dxy just in case we want it on Fig 4B instead of Nei's D
$piawka calc -s nei,dxy -g divide -v ${vcf%.vcf*}_4fds.vcf.gz -b win100k.bed -j 96 | $piawka sum -s nei,dxy --ignore-chrs - > piawka_nei_ind_$( basename $vcf .vcf.gz ).bed # takes about 40h :(
$piawka dist -m nei piawka_nei_ind_$( basename $vcf .vcf.gz ).bed > piawka_nei_ind_$( basename $vcf .vcf.gz ).phy # this goes to splitstree

# lineages pi for fig 4A (better cut them off the metadata table)
# Can also use 4fds here since we care about neutral diversity & divergence
lineages="/netscratch/dep_mercier/grp_novikova/A.Lyrata/resources/piawka/Fourfolds_pi_pop"
$piawka calc -s pi -g $lineages -b win100k.bed -v ${vcf%.vcf*}_4fds.vcf.gz -j 96 | $piawka sum -s pi - > piawka_pi_lineage_$( basename $vcf .vcf.gz ).bed 

# lineage-pair-wise Fst for fig 4C (summarize across all chrs)
$piawka calc -s fst -g $lineages -b win100k.bed -v ${vcf%.vcf*}_4fds.vcf.gz -j 96 | $piawka sum -s fst --ignore-chrs - > piawka_fst_lineage_$( basename $vcf .vcf.gz ).bed 

# Figure 4 is drawn using the following notebook:
# /netscratch/dep_mercier/grp_novikova/nikita/notebooks/journal/resource_piawka/resource_piawka.Rmd
# WARNING: piawka v9.0 introduced new fields because of BED formatting. To make the notebook work with its output, simply remove the 2-4th fields: select(d, -c(2:4))

