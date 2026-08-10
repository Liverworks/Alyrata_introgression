# Assembly
```mabs-hifiasm.py --pacbio_hifi_reads Raw_reads.fastq.gz --output_folder Pref --local_busco_dataset brassicales_odb10 --threads 30 # used ploidy parameter for tetraploids
ragtag.py scaffold  -f 100000 NT1_v2.fa Pref/The_best_assembly/assembly.fasta -o Pref_rt ```
Then keep only chromosomes, not the small contigs using **prepFa.py**.

## Run Helixer (gene annotation)
helixer_v0.3.3 Helixer.py --fasta-path UFR_v1.fa --gff-output-path UFR_v1_helixer.gff --lineage land_plant
