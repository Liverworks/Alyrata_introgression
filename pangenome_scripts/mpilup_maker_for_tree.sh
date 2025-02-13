samtools mpileup -f ../v2_assemblies/NT1_v2.fa AL08_to_NT1_assembly20.bam AL27_to_NT1_assembly20.bam AL56_to_NT1_assembly20.bam AL85_to_NT1_assembly20.bam BOR_to_NT1_assembly20.bam BAM12.1_to_NT1_assembly20.bam BAM12.3_to_NT1_assembly20.bam NT1_to_NT1_assembly20.bam NT12_to_NT1_assembly20.bam NT8_to_NT1_assembly20.bam NT9_to_NT1_assembly20.bam TE11_to_NT1_assembly20.bam TE4_to_NT1_assembly20.bam TE8_to_NT1_assembly20.bam PU6_to_NT1_assembly20.bam WS1_to_NT1_assembly20.bam al1_to_NT1_assembly20.bam MN47_to_NT1_assembly20.bam PTP_to_NT1_assembly20.bam LPT_to_NT1_assembly20.bam TSS_to_NT1_assembly20.bam Ped_to_NT1_assembly20.bam Ceb_c_to_NT1_assembly20.bam Ceb_d_to_NT1_assembly20.bam Wall10_to_NT1_assembly20.bam Pais09_to_NT1_assembly20.bam ASS3_AA_to_NT1_assembly20.bam ASS3_AT_to_NT1_assembly20.bam AS530_AA_to_NT1_assembly20.bam AS530_AT_to_NT1_assembly20.bam AS150_AA_to_NT1_assembly20.bam AS150_AT_to_NT1_assembly20.bam ColCEN_to_NT1_assembly20.bam > All_try.mpileup
#Getting only positions where all samples have coverage 1
grep -v [[:space:]]0[[:space:]] All_try.mpileup | grep -E '([^1]*[[:space:]]1[[:space:]]){33}' > All_try_cov1.mpileup
cut -f 3,1,2,5,8,11,14,17,20,23,26,29,32,35,38,41,44,47,50,53,56,59,62,65,68,71,74,77,80,83,86,89,92,95,98,101 All_try_cov1.mpileup > All_try_cov1.tsv
#All . and , to zero, then python to make everything else 1
sed -i 's/\^//g' All_try_cov1.tsv
sed -i 's/\]//g' All_try_cov1.tsv
sed -i 's/\[//g' All_try_cov1.tsv
sed -i 's/\"//g' All_try_cov1.tsv
sed -i 's/\$//g' All_try_cov1.tsv
sed -i 's/a/A/g' All_try_cov1.tsv
sed -i 's/t/T/g' All_try_cov1.tsv
sed -i 's/c/C/g' All_try_cov1.tsv
sed -i 's/g/G/g' All_try_cov1.tsv
sed -i 's/sCAffold/scaffold/g' All_try_cov1.tsv
sed -i 's/\t,\t/\t0\t/g' All_try_cov1.tsv
sed -i 's/\t,\t/\t0\t/g' All_try_cov1.tsv
sed -i 's/\t,$/\t0/g' All_try_cov1.tsv
sed -i 's/\t\.$/\t0/g' All_try_cov1.tsv
sed -i 's/\t\.\t/\t0\t/g' All_try_cov1.tsv
sed -i 's/\t\.\t/\t0\t/g' All_try_cov1.tsv
sed -i 's/\.//g' All_try_cov1.tsv
sed -i 's/,//g' All_try_cov1.tsv
grep -v 0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0[[:space:]]0 All_try_cov1.tsv > All_try_cov1_var.tsv
python mpilup_to_vcf.py
#Then reheader
