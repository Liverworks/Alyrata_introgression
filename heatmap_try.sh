gene="AL1G35730"
outgr="SRR2082718"
gr_names=(Eur_dipl
Eur_tetr
Sib_dipl
Sib_tetr)
vcf_path="/netscratch/dep_mercier/grp_novikova/A.Lyrata/map/with_Majda/cohort_all1-12.vcf.gz"

group_array=(ERR3514897,ERR3514898,ERR3514899,ERR3514883,ERR3514884,ERR3514885,ERR3514886
ERR3514856,ERR3514857,ERR3514858,ERR3514859,ERR3514860,ERR3514861,ERR3514862,ERR3514863,ERR3514864,ERR3514865,ERR3514866,ERR3514867,ERR3514868,ERR3514869,ERR3514870,ERR3514871,ERR3514872,ERR3514873,ERR3514874,ERR3514875,ERR3514876,ERR3514877,ERR3514878,ERR3514879,ERR3514880,ERR3514881,ERR3514882,,ERR3514887,ERR3514888,ERR3514889,ERR3514890,ERR3514891,ERR3514892,ERR3514893,ERR3514894,ERR3514895,ERR3514896
MW0079559,MW0079560,MW0079564,MW0079585,MW0079591,MW0079604,MW0079895,MW0158707,MW0079491,MW0079496,MW0079497,MW0079500,MW0079537,MW0079538,MW0079545,MW0079553,MW0079579,MW0079581,MW0158706,NT12_1_1,NT13_9_1,NT14_1_1,NT14_10_1,NT14_11_1,NT14_4_1,NT14_5_1,NT14_6_1,NT14_7_1,NT14_8_1,NT15_1_1,NT15_2_1,NT15_3_1,NT15_4_1,NT15_5_1,NT2_1_1,NT2_2_1,NT2_3_1,NT2_5_1,NT4_2_1,NT4_3_1,NT5_1_1,NT5_2_1,NT5_3_1,NT8_2_1,NT8_3_1,NT8_4_1,NT8_5_1,NT9_1_1,NT9_2_1,NT9_3_1,NT9_4_1,NT9_5_1,
al1_1_4n,al3_1_4n,al4_1_4n,MW0079472_4n,MW0079507_4n,MW0079544_4n,MW0079546_4n,MW0079552_4n,MW0079572-1_4n,MW0079572-2_4n,MW0079573_4n,MW0079575_4n,MW0079578-1_4n,MW0079606_4n,MW0079610_4n,MW0157478_4n,MW0158708_4n,MW0079584_4n,MW0079589_4n,MW0079609_4n,MW0374083_4n,MW0374084_4n,MW0374087_4n,MW0374095_4n,MW0374101_4n,MW0374102-2_4n)

joinByChar() {
local IFS="$1"
shift
echo "$*"
}
full_list=$(joinByChar , "${group_array[@]}")  # Join all samples together

# Get gene intervals
intervals=$(grep ${gene} /biodata/dep_mercier/grp_novikova/A.Lyrata/ref/Alyrata/v2.1/annotation/Alyrata_384_v2.1.gene.gff3 | grep CDS | cut -f 1,4,5 | awk '{print $1":"$2"-"$3}' | paste -sd ',')

# Subset the samples and the gene intervals from the big vcf

#echo ${full_list}
#echo ${outgr}
#echo ${full_list},${outgr}
bcftools view --threads 20 -O z -s ${full_list},${outgr} -r ${intervals} --max-alleles 2 --force-samples --min-alleles 2 --types snps ${vcf_path} > ${gene}.snps.vcf.gz


# Get files with number of alleles for each group
for i in "${!gr_names[@]}"; do
bcftools view --force-samples -s ${outgr},${group_array[i]} ${gene}.snps.vcf.gz > work.vcf
echo "loooop"
bcftools view -H work.vcf | cut -f 4,5,10 | sed 's/:[0123456789,\._ATGC\|]*//g' | sed 's/\t/,/g' |  awk -F, '{am=0;tm=0;gm=0;cm=0;as=0;ts=0;gs=0;cs=0;af=0;tf=0;gf=0;cf=0; if($1 ~ /[aA]/)  am=gsub(/0/,"");if($1 ~ /[tT]/) tm=gsub(/0/,"");if($1 ~ /[gG]/) gm=gsub(/0/,"");if($1 ~ /[cC]/) cm=gsub(/0/,""); if($2 ~ /[aA]/)  am=gsub(/1/,"");if($2 ~ /[tT]/) tm=gsub(/1/,"");if($2 ~ /[gG]/) gm=gsub(/1/,"");if($2 ~ /[cC]/) cm=gsub(/1/,""); printf "%d,%d,%d,%d\n", am,cm,gm,tm }' > preoutgr_sfs
sed 's/1/0/g' preoutgr_sfs | sed 's/2/1/' > outgr_sfs
bcftools view -H work.vcf | cut -f 4,5,11- | sed 's/:[0123456789,\._ATGC\|]*//g' | sed 's/\t/,/g' |  awk -F, '{am=0;tm=0;gm=0;cm=0;as=0;ts=0;gs=0;cs=0;af=0;tf=0;gf=0;cf=0; if($1 ~ /[aA]/)  am=gsub(/0/,"");if($1 ~ /[tT]/) tm=gsub(/0/,"");if($1 ~ /[gG]/) gm=gsub(/0/,"");if($1 ~ /[cC]/) cm=gsub(/0/,""); if($2 ~ /[aA]/)  am=gsub(/1/,"");if($2 ~ /[tT]/) tm=gsub(/1/,"");if($2 ~ /[gG]/) gm=gsub(/1/,"");if($2 ~ /[cC]/) cm=gsub(/1/,""); printf "%d,%d,%d,%d\n", am,cm,gm,tm }' > sfs_snps
bcftools view -H work.vcf | cut -f 2 > coords
paste -d "," coords sfs_snps outgr_sfs | grep -v 0,0,0,0$ > ${gene}_${gr_names[i]}.csv
done

