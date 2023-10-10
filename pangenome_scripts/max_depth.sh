#! /bin/bash
#BSUB -M 8000 -R "rusage[mem=8000] "


#Developed by Jie Wang. Calculated coverages in gene regions.
acc="al4"
#cat ../${acc}/The_best_assembly/assembly.bp.hap1.p_ctg.fa ../${acc}/The_best_assembly/assembly.bp.hap2.p_ctg.fa > ${acc}_merged_genome.fasta
cat  ../../stlfr/new_whitelist/${acc}/supernova_result.1.fasta.gz ../../stlfr/new_whitelist/${acc}/supernova_result.2.fasta.gz > ${acc}_merged_genome.fasta.gz
gunzip ${acc}_merged_genome.fasta.gz
minimap2 -ax asm5 /biodata/dep_mercier/grp_novikova/A.Lyrata/ref/Alyrata/NT1_assembly/final_NT1/NT1_220222.fasta ${acc}_merged_genome.fasta > ${acc}_minimap2.sam &&

samtools view -bS ${acc}_minimap2.sam > ${acc}_minimap2.bam &&

samtools sort ${acc}_minimap2.bam -o ${acc}_minimap2_sort.bam &&

bedtools genomecov -ibam ${acc}_minimap2_sort.bam -d -split > ${acc}_bed_ds.graph &&

awk '{OFS="\t"; print $1, $2-1, $2, $3}' ${acc}_bed_ds.graph > ${acc}_bed_ds_interval.bed &&

bedtools intersect -a ${acc}_bed_ds_interval.bed -b /netscratch/dep_mercier/grp_novikova/A.Lyrata/S_locus/NT1_assembly/final_NT1/NT1_220222.gff3 -wa -wb > ${acc}_final.bed
