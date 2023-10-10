from Bio import SeqIO

records = SeqIO.parse("NT1_rand_mafft.fa", "fasta")
count = SeqIO.write(records, "NT1_rand_mafft.phylip", "phylip")
print("Converted %i records" % count)
