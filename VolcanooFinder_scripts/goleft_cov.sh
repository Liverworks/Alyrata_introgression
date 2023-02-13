#! /bin/bash


for OUTPUT in $(cat ../acc_list.tmp)
do
goleft depth -p 5 -q 20 -r /biodata/dep_mercier/grp_novikova/A.Lyrata/ref/Alyrata/v2.1/assembly/Alyrata_384_v1.fa --prefix ../coverages/$OUTPUT /biodata/dep_mercier/grp_novikova/A.Lyrata/map_mpipz/$OUTPUT.fixmate.sort.markdup.bam
#echo $OUTPUT
done
