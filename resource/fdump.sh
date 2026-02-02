

for i in `cat ~/Downloads/SRR_Acc_List1.txt`; do
fastq-dump --outdir . --gzip --skip-technical --read-filter pass --dumpbase --split-3 --clip  ${i}
done
