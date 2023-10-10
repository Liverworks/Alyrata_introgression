chrom=8

#Goes from filtered vcf of SNPs. Need to take care of outgroups.
grep -v \# scaffold_${chrom}_puws_het.snps.vcf | cut -f 1,2 > scaffold_${chrom}_puws_positions.txt
grep -v \# scaffold_${chrom}_puws_het.snps.vcf | cut -f 10-16 | sed 's/\:[0123456789,.:ATGC_|*]*//g' | awk -F '[01]' '{print NF-1}' > scaffold_${chrom}_puws_outgroup_ncalls.txt
grep -v \# scaffold_${chrom}_puws_het.snps.vcf | cut -f 10-16 | sed 's/\:[0123456789,.:ATGC_|*]*//g' | awk -F '[1]' '{print NF-1}' > scaffold_${chrom}_puws_outgroup_n1.txt
grep -v \# scaffold_${chrom}_puws_het.snps.vcf | cut -f 17- | sed 's/\:[0123456789,.:ATGC_|*]*//g' | awk -F '[1]' '{print NF-1}' > scaffold_${chrom}_puws_samples_n1.txt
grep -v \# scaffold_${chrom}_puws_het.snps.vcf | cut -f 17- | sed 's/\:[0123456789,.:ATGC_|*]*//g' | awk -F '[10]' '{print NF-1}' > scaffold_${chrom}_puws_samples_ncalls.txt
paste scaffold_${chrom}_puws_positions.txt scaffold_${chrom}_puws_outgroup_ncalls.txt scaffold_${chrom}_puws_outgroup_n1.txt scaffold_${chrom}_puws_samples_ncalls.txt scaffold_${chrom}_puws_samples_n1.txt | grep -v [[:space:]]0$ | awk '$5 != $6 {print $0}' > scaffold_${chrom}_puws_all_ncalls.tsv
echo -e "chr\tposition\tx\tn\tfolded" > scaffold_${chrom}_puws_allele_freq.tsv

#Filtering and sorting
awk '$3 != "0" { print $0 }' scaffold_${chrom}_puws_all_ncalls.tsv | awk -F "\t" ' $4 == "0" {print $1,$2,$6,$5,0}' | sed 's/ /\t/g' >> scaffold_${chrom}_puws_allele_freq.tsv
awk '$3 != "0" { print $0 }' scaffold_${chrom}_puws_all_ncalls.tsv | awk -F "\t" ' $4 == $3 {print $1,$2,$5-$6,$5,0}' | sed 's/ /\t/g' >> scaffold_${chrom}_puws_allele_freq.tsv
sort -n -k 2 scaffold_${chrom}_puws_allele_freq.tsv > scaffold_${chrom}_puws_allele_freq_sorted.tsv
