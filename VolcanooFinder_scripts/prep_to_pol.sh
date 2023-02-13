
#! /bin/bash
#BSUB -J volc_prep
#BSUB -q multicore20
#BSUB -M 10000 -R "rusage[mem=10000] "
#BSUB -o vol_prep_output.txt
#BSUB -e vol_prep_error.txt


inp='/biodata/dep_mercier/grp_novikova/Neobatrachus/results/merge_vcfs/Dovetail_All_updated200922_annotated.tabix.vcf.gz'
#out='/netscratch/dep_mercier/grp_novikova/A.Lyrata/anna_g/put'
out="../Naquilonius"
samp_names='Naquilonius_135604,Naquilonius_135605,Naquilonius_135634,Naquilonius_135679,Naquilonius_135716,Naquilonius_135756,Naquilonius_16579'
outgr='Npelobatoides_135600'

# Get samples from common vcf
bcftools view -s ${samp_names},${outgr} --threads 20 -O z -o ${out}.vcf.gz ${inp}

# Generate biallelic SNP file and non-variative sites file
bcftools view --threads 20 -O z  --max-alleles 1 ${out}.vcf.gz > ${out}.ref.vcf.gz
bcftools view --threads 20 -O z  --max-alleles 2 --min-alleles 2 --types snps ${out}.vcf.gz > ${out}.snps.vcf.gz

# Generate 3 files regarding to outgroup status
java -Xmx10g -jar /netscratch/dep_mercier/grp_novikova/software/snpEff/SnpSift.jar filter "isHet( GEN["${outgr}"] )" ${out}.snps.vcf.gz | gzip > ${out}.het.vcf.gz

java -Xmx10g -jar /netscratch/dep_mercier/grp_novikova/software/snpEff/SnpSift.jar filter "isHom( GEN["${outgr}"] ) & isRef( GEN["${outgr}"] )" ${out}.snps.vcf.gz | gzip > ${out}.hom.ref.vcf.gz

java -Xmx10g -jar /netscratch/dep_mercier/grp_novikova/software/snpEff/SnpSift.jar filter "isHom( GEN["${outgr}"] ) & ! isRef( GEN["${outgr}"] )" ${out}.snps.vcf.gz | gzip > ${out}.hom.2polarize.vcf.gz

# Counting conservative positions
bcftools view --threads 18 --exclude 'GT="mis"' -O z ${out}.ref.vcf.gz > ${out}.ref_miss.vcf.gz

bcftools view -H --threads 18 ${out}.ref_miss.vcf.gz | wc -l > ${out}_ref_count.txt

# Producing final files

python allele_freq_prep.py ${out}

tail -n +2 ${out}_freq_spec_0.tsv | cut -f 1,3 > ${out}_freq_spec.tsv
