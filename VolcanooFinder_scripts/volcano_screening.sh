

for OUTPUT in $(cat ../alyr_scaf) #../../Neobatrachus/Dovetail_genome/biggest_chrs_names.txt)
do
../../software/volcanofinder_v1.0/VolcanoFinder -ig 1000 ../put_filt_ww_$OUTPUT.tsv ../put_filt_ww_freq_spec.tsv -1 0 1 ../put_filt_ww_volcano_$OUTPUT.tsv &
done

