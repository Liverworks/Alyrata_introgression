array=(al1_1
al3_1
al4_1
MW0079472
MW0079507
MW0079546
MW0079552
MW0079572-1
MW0079572-2
MW0079573
MW0079575
MW0079578-1
MW0079584
MW0079589
MW0079606
MW0079609
MW0079610
MW0157478
MW0158708
MW0374083
MW0374084
MW0374087
MW0374095
MW0374101
MW0374102-2)

array2=(1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26)

for i in "${!array[@]}"; do
    echo "loooop"
    whatshap polyphase --ploidy 4 -t 28 -r /biodata/dep_mercier/grp_novikova/A.Lyrata/ref/Alyrata/v2.1/assembly/Alyrata_384_v1.fa --ignore-read-groups --sample ${array[i]}_4n -o sc7_tetro${array2[i+1]}.vcf sc7_tetro${array2[i]}.vcf /biodata/dep_mercier/grp_novikova/A.Lyrata/map_mpipz/${array[i]}.fixmate.sort.markdup.bam
done
