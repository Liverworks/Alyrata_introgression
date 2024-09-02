while IFS=" " read -r pref remainder
do
bwa mem -t 40 -M  Arabidopsis_centromere_contigs.fasta ../../Marc_data/${pref}_1.paired.fq.gz ../../Marc_data/${pref}_2.paired.fq.gz | samtools view -Sb -@ 40 | samtools sort -@ 40 > ${pref}_centromeres.bam
samtools sort -n ${pref}_centromeres.bam > ${pref}_centromeres.prepremarkdup.bam
samtools fixmate -rm ${pref}_centromeres.prepremarkdup.bam ${pref}_centromeres.premarkdup.bam
samtools sort ${pref}_centromeres.premarkdup.bam > ${pref}_centromeres.sortmarkdup.bam
samtools markdup -rs ${pref}_centromeres.sortmarkdup.bam ${pref}_centromeres.markdup.bam
samtools index ${pref}_centromeres.markdup.bam
samtools idxstats ${pref}_centromeres.markdup.bam > ${pref}.stats
done < "marc_list"
