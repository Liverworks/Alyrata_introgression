samp=""
reads=""

#Mapping long reads to the genome
meryl count k=15 output merylDB_${samp} ../v2_assemblies/${samp}.fa 
meryl print greater-than distinct=0.9998 merylDB_${samp} > ${samp}_k15.txt
../../../../software/Winnowmap/bin/winnowmap -W ${samp}_k15.txt -ax map-pb ../v2_assemblies/${samp}.fa ${reads} | samtools view -Sb | samtools sort > ${samp}.bam &

#Consensus
samtools consensus --ambig -f fastq -o ${samp}_consensus.fq ${samp}_v1_winnow_back.bam

#PSMC
fq2psmcfa -q20 ${samp}_consensus.fq > ${samp}.psmcfa
splitfa ${samp}.psmcfa > ${samp}_split.psmcfa
psmc -N25 -t15 -r5 -p "4+25*2+4+6" -o ${samp}.psmc ${samp}.psmcfa

#Bootstraps
seq 100 | xargs -i echo psmc -N25 -t15 -r5 -b -p "4+25*2+4+6" -o ${samp}_round-{}.psmc ${samp}_split.psmcfa | sh

#Combining many samples for plotting
psmc_plot.pl -g 2 -u 7.1e-09 -R -M "AL27,AL56,AL85,AL08,MN47,TE11,TE4,TE8,NT8,NT9,NT12,BAM12.1,BAM12.3" With_eur With_Eur.psmc
