# Alyrata_introgression

A collection of homemade scripts for different things. The aim of this project is lab documentation.

### Twisst_scripts

Contains two scripts for phasing (diploids and tetraploids) and a twisst pipeline itself.

**Update TAC 2**  Added R scripts for visualisation. 

**Update TAC 3**  Latest scripts were publised on https://github.com/novikovalab/Siberian_Alyrata/tree/main/twisst_and_haplotypes.

### VolcanoFinder_scripts

Contains a data preparation step - prep_to_pol.sh, running the tool itself - volcano_screening.sh. Jupiter Notebooks are for making additional figures for VF targets: coverage and pi.

**Update TAC 2**  Added scripts for constructing SFS and VF input with an outgroup of 7 samples.

### pangenome_scripts

Everything for genome assemblies. **Max\_depth** script for assembly coverage analisys, **run\_galba** for GALBA annotation and **EDTA** for repeat masking. **Trash_scripts** contains a script for fasta preparation, running TRASH itself and phylogenetic tree making. Gene trees were made the same way. 

**Update TAC 3** Added notebooks for TE and gene analysis. Added scripts for running GENESPACE (**prep_genespace.sh**, **run_genespace3.R**).

### centromeres

**Update TAC 3** Notebooks with short-read centromere repeat analysis and repeat library analysis (including PCA). Script for mapping short reads on centromeric repeat is in **centr_mapper.sh**.

### Other files

**heatmap_try.sh** - making tables for heatmap of SNPs frequencies in genes. (Added one more version of this script.)

**Plot_maker** - a collection of python scripts for making some of the graphs.

**run_est_sfs.sh** - the data preparation and the command itself to make population SFS with est-sfs software.

**pi_nt1.py** - Script to calculate Pi between NT1 and MN47.

