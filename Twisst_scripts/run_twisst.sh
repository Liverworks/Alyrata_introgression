vcf_pref="phased_sc6_ex"
ploidy="ploidy_extended.txt"
min_calls=62 # 80% of number of samples
outgr="SRR2082718"
groups="A.txt"

python3 ../../software/twisst/genomics_general/VCF_processing/parseVCF.py -o ${vcf_pref}.gen --ploidyFile $ploidy -i ${vcf_pref}.vcf.gz --minQual 30 --gtf flag=DP min=8
python3 genomics_general-0.4/filterGenotypes.py -i ${vcf_pref}.gen --ploidyFile $ploidy -o ${vcf_pref}_filt.gen --verbose --minCalls $min_calls --minAlleles 2 --minVarCount 2 -t 26 --maxHet 0.75
python3 genomics_general-0.4/phylo/phyml_sliding_windows.py --windType sites -w 100 -g ${vcf_pref}_filt.gen -p ${vcf_pref} -T 15 -Mi 20 --model GTR --optimise n  # -Mi 20 --model GTR --optimise n
python3 ../../software/twisst/twisst.py -t ${vcf_pref}.trees.gz -w ${vcf_pref}.wheights.tsv -g PUT -g TMT -g PUD -g TMD --groupsFile $groups # --outgroup $outgr
