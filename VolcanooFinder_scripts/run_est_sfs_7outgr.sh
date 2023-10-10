#! /bin/bash

allele_n=260
snp_vcf="scaffold_8_puws_het.snps.vcf"
prefix="scaffold_8_puws"
n_samples=14

####outgroup1 - column number 127 sample 183 
####outgroup2 - columnn number 104 sample 184
#Change column numbers!

bcftools view -H ${snp_vcf} | cut -f 4,5,12,13 | sed 's/:[0123456789,\._ATGC\|]*//g' | sed 's/\t/,/g' |  awk -F, '{am=0;tm=0;gm=0;cm=0;as=0;ts=0;gs=0;cs=0;af=0;tf=0;gf=0;cf=0; if($1 ~ /[aA]/)  am=gsub(/0/,"");if($1 ~ /[tT]/) tm=gsub(/0/,"");if($1 ~ /[gG]/) gm=gsub(/0/,"");if($1 ~ /[cC]/) cm=gsub(/0/,""); if($2 ~ /[aA]/)  am=gsub(/1/,"");if($2 ~ /[tT]/) tm=gsub(/1/,"");if($2 ~ /[gG]/) gm=gsub(/1/,"");if($2 ~ /[cC]/) cm=gsub(/1/,""); printf "%d,%d,%d,%d\n", am,cm,gm,tm }' > ${prefix}_outgr_sfs 

#second outgroup

bcftools view -H ${snp_vcf} | cut -f 4,5,10,11,14,15,16 | sed 's/:[0123456789,\._ATGC\|]*//g' | sed 's/\t/,/g' |  awk -F, '{am=0;tm=0;gm=0;cm=0;as=0;ts=0;gs=0;cs=0;af=0;tf=0;gf=0;cf=0; if($1 ~ /[aA]/)  am=gsub(/0/,"");if($1 ~ /[tT]/) tm=gsub(/0/,"");if($1 ~ /[gG]/) gm=gsub(/0/,"");if($1 ~ /[cC]/) cm=gsub(/0/,""); if($2 ~ /[aA]/)  am=gsub(/1/,"");if($2 ~ /[tT]/) tm=gsub(/1/,"");if($2 ~ /[gG]/) gm=gsub(/1/,"");if($2 ~ /[cC]/) cm=gsub(/1/,""); printf "%d,%d,%d,%d\n", am,cm,gm,tm }' > ${prefix}_outgr_sfs_second 

bcftools view -H ${snp_vcf} | cut -f 4,5,17- | sed 's/:[0123456789,\._ATGC\|]*//g' | sed 's/\t/,/g' |  awk -F, '{am=0;tm=0;gm=0;cm=0;as=0;ts=0;gs=0;cs=0;af=0;tf=0;gf=0;cf=0; if($1 ~ /[aA]/)  am=gsub(/0/,"");if($1 ~ /[tT]/) tm=gsub(/0/,"");if($1 ~ /[gG]/) gm=gsub(/0/,"");if($1 ~ /[cC]/) cm=gsub(/0/,""); if($2 ~ /[aA]/)  am=gsub(/1/,"");if($2 ~ /[tT]/) tm=gsub(/1/,"");if($2 ~ /[gG]/) gm=gsub(/1/,"");if($2 ~ /[cC]/) cm=gsub(/1/,""); printf "%d,%d,%d,%d\n", am,cm,gm,tm }' > ${prefix}_sfs_snps 


cat ${prefix}_outgr_sfs | awk -F '[0]' ' { if (NF-1 == 3) print $0; else print "0,0,0,0";}' | sed 's/[24]/1/' > ${prefix}_outgr_sfs2
#Be careful here
cat ${prefix}_outgr_sfs_second | sed 's/[2468]/1/' | sed 's/10/1/' | awk -F '[0]' ' { if (NF-1 == 3) print $0; else print "0,0,0,0";}'  > ${prefix}_outgr_sfs_second2

#All columns to one file
paste ${prefix}_sfs_snps ${prefix}_outgr_sfs2 ${prefix}_outgr_sfs_second2 | sed -E 's/[[:space:]]+/ /g' | awk -F [,\ ] '{if ($1 + $2 + $3 + $4 == '"$allele_n"') {print $1","$2","$3","$4" "$5","$6","$7","$8" "$9","$10","$11","$12 } }' > ${prefix}_var.input
grep -v 0,0,0,0[[:space:]]0,0,0,0 ${prefix}_var.input | grep -v $allele_n > ${prefix}_var_small.input

#cat them to one file if you run the chromosomes separately
/netscratch/dep_mercier/grp_novikova/software/est-sfs-release-2.04/est-sfs est_config ${prefix}_var_small.input seed-file.txt ${prefix}_sfs.txt ${prefix}-pvalues.txt
