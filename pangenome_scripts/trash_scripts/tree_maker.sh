# Input is ootput from trash
cut -f 2,3,4 -d , all.repeats.from.Athaliana_sc1.fa.csv | grep ,159, | cut -d , -f 1,3,4 | shuf -n 10 > Athaliana_rand.txt
cut -f 2 -d , Athaliana_rand.txt | sed 's/\"//g' > Athaliana_seq.txt

# Here I run Hash_and_reverse function in R (https://github.com/vlothec/pancentromere/blob/main/cen178_identification/src/fn_hash_and_reverse.R)
paste <(cut -f 1,3 -d , Athaliana_rand.txt) Athaliana_hashed.txt >> Athaliana_hashed.fa

# Then I make fasta out of this table using simple editor

#Tree construction, used the same script for gene trees.
#Example for A.halleri repeats.

linsi Wall10_rand.fa > Wall10_align.fa
python fatophy.py
iqtree -bb 1000 -s Wall10.phylip 
