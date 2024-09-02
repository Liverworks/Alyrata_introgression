source /netscratch/dep_mercier/grp_novikova/nikita/.bashrc

#wd="/netscratch/dep_mercier/grp_novikova/Potamogeton/pangenome/GENESPACE/wd"

fa="/netscratch/dep_mercier/grp_novikova/A.Lyrata/anna_g/mabs_assemblies/v2_assemblies/Pais_09_V1.2_re.fasta"
gff="/netscratch/dep_mercier/grp_novikova/A.Lyrata/anna_g/mabs_assemblies/v2_assemblies/Pais09_v1.2_helixer.gff"
id="Pais09_v1.2"
wd="/netscratch/dep_mercier/grp_novikova/A.Lyrata/anna_g/genspace_try/halleri_v1.2_re"

samtools faidx $fa
# 1. Subset GFF by chromosomal scaffolds
bedtools intersect -header -a $gff -b <( fai2bed $fa.fai ) > ${gff%.*}_chr.gff

# 2. Convert GFF subset to 4-column BED
grep -P "\tgene\t" ${gff%.*}_chr.gff | gff2bed | cut -f1-4 > ${gff%.*}_chr.bed

# 3. Get peptide sequences
conda activate /netscratch/dep_mercier/grp_novikova/nikita/.conda/envs/agat
agat_sp_extract_sequences.pl --gff ${gff%.*}_chr.gff -f $fa -p -o ${gff%.*}_chr_pep.fa
seqkit replace -p '\..*' -r '' ${gff%.*}_chr_pep.fa > ${gff%.*}_chr_pep_renamed.fa

# 4. Link these files in the GENESPACE run directory
mkdir -p $wd &&
cd $wd &&
mkdir -p bed peptide &&
ln -s ${gff%.*}_chr.bed bed/$id.bed
ln -s ${gff%.*}_chr_pep_renamed.fa peptide/$id.fa
