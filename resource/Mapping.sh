#! /bin/bash
#SBATCH --array=1-24
#SBATCH --cpus-per-task=10
#SBATCH --job-name=eur_map
#SBATCH --partition=normal
#SBATCH --mem-per-cpu=5G
#SBATCH --output=job_output_%j.out
#SBATCH --error=job_output_%j.err


#samples="/netscratch/dep_mercier/grp_novikova/A.Lyrata/S_locus/uliana/listcov"
#samples=''
names='pipeline/6999_samps'
samples='pipeline/6999_names'
###125

echo "STARTING JOB"
num=$SLURM_ARRAY_TASK_ID\p
acc=`sed -n ${num} ${names} | cut -d " " -f1`
name=`sed -n ${num} ${samples} | cut -d " " -f1`
#echo ${acc}
#acc="Balt2"
#name="A24112-1"
raw="/biodata/dep_mercier/grp_novikova/A.Lyrata/Raw_lyrata_Feb25"

ref='/biodata/dep_mercier/grp_novikova/A.Lyrata/ref/Alyrata/NT1_assembly/final_NT1/NT1_220222'
#out='/netscratch/dep_mercier/grp_novikova/A.Lyrata/S_locus/lyrata_November2021_to_NT1_220222'
#out='/netscratch/dep_mercier/grp_novikova/A.Lyrata/S_locus/lyrata_old_to_NT1_220222'
out="."
####TRIMM READS

first=`ls ${raw}/A${name}_EKDL250001154-1A_22WW5FLT3_L8_1.fq.gz`
second=`ls ${raw}/A${name}_EKDL250001154-1A_22WW5FLT3_L8_2.fq.gz`
java -ea -Xmx18g -Xms1g -XX:ParallelGCThreads=4 -cp /opt/share/software/packages/BBMap_38.90/bin/current/ jgi.BBDuk t=4 in=${first} in2=${second} \
    out=${out}/${acc}_1.paired.fq.gz out2=${out}/${acc}_2.paired.fq.gz \
    outm=${out}/${acc}_1.unpaired.fq.gz outm2=${out}/${acc}_2.unpaired.fq.gz \
    ref=/netscratch/dep_mercier/grp_novikova/shared/adapters.fa \
    ktrim=r k=23 mink=11 hdist=1 tbo tpe qtrim=rl trimq=15 minlen=70
##############

####bwa index ${ref}.fasta
bwa mem -t 10 -M -R '@RG\tID:lyr_'${acc}'\tSM:'${acc}'\tPL:Illumina\tLB:lyr_'${acc} ${ref}.fasta ${acc}_1.paired.fq.gz ${acc}_2.paired.fq.gz > ${acc}.sam
wait
#rm ${out}/${acc}_*.paired.fq
####samtools view -bh -F 0x2 ${out}/${acc}.sam > ${out}/${acc}.splitreads_filtered.bam
samtools view -bh -t ${ref}.fasta.fai -o ${acc}.bam ${acc}.sam
wait
rm ${acc}.sam
samtools sort ${acc}.bam -o ${acc}.sort.bam -T ${acc}_temp
wait
rm ${acc}.bam
####samtools index ${out}/${acc}.splitreads_filtered.sort.bam
samtools sort -n ${acc}.sort.bam -o ${acc}.sortn.bam -T ${acc}_temp
wait
rm ${acc}.sort.bam
samtools fixmate -rm ${acc}.sortn.bam ${acc}.fixmate.sortn.bam
wait
rm ${acc}.sortn.bam
samtools sort ${acc}.fixmate.sortn.bam -o ${acc}.fixmate.sort.bam -T ${acc}_temp
wait
rm ${acc}.fixmate.sortn.bam
samtools markdup -rs ${acc}.fixmate.sort.bam ${acc}.fixmate.sort.markdup.bam
samtools index ${acc}.fixmate.sort.markdup.bam
wait
rm ${acc}.fixmate.sort.bam

#if test -f "${out}/${acc}.fixmate.sort.markdup.bam"; then
#source ~/.profile
#source ~/.bashrc
module load goleft/0.2.3
goleft covstats ${out}/${acc}.fixmate.sort.markdup.bam > ${out}/goleft/${acc}.covstats
#fi


####module load picard/2.23.5
#java -jar ${PICARD_HOME}/picard.jar CreateSequenceDictionary R=${ref}.fasta O=${ref}.dict

gatk --java-options "-Xmx35G" HaplotypeCaller  \
   -R ${ref}.fasta \
   -I ${out}/${acc}.fixmate.sort.markdup.bam \
   -O ${out}/${acc}.g.vcf.gz \
   -ERC GVCF \
   --sample-ploidy 2 \
   --output-mode EMIT_ALL_CONFIDENT_SITES
