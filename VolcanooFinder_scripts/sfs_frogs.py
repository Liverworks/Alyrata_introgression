from collections import Counter
import matplotlib.pyplot as plt
import pandas as pd

# To get a matrix from a vcf without header: cut -f 10- PREFIX_snps.tsv | sed 's/:[0123456789,:.\|/ATGC_]*\t/\t/g' | cut -f 1 -d ":" | sed  's/\//\t/g' > PREFIX_snps_matrix.tsv &

n_alleles = 0
sfs_alleles = []
n_nonvar_sites = 0 # insert number of nonvariant sites with no missing data

with open("PREFIX_snps_matrix.tsv", "r") as snps:
    for snp in snps.readlines():
        snp = snp.strip().split("\t")
        #print(snp)
        if len(snp) < n_alleles:
            print(snp)
            break
        elif len(snp) > n_alleles:
            n_alleles = len(snp)
        if len(Counter(snp).keys()) <= 2:
            #print(Counter(snp).values())
            #print(min(Counter(snp).values()))
            sfs_alleles.append(min(Counter(snp).values())) # Saving frequency of minor allele

print(len(sfs_alleles))

sfs = Counter(sfs_alleles)
print(sfs)

# Saving the output and plotting
sfs_tab = pd.DataFrame(sfs.items())
sfs_tab = sfs_tab.rename(columns = {0: "genotype", 1: "frequency"})
sfs_tab["genotype"][sfs_tab.genotype == max(sfs_tab.genotype)]  = 0
sfs_tab.frequency[sfs_tab.genotype == 0] += n_nonvar_sites
sfs_tab =  sfs_tab.sort_values(by='genotype')

sfs_tab.to_csv("PREFIX_sfs.tsv", sep="\t", index=False)
plt.bar(height=sfs_tab.iloc[:,1], x=[i for i in range(len(sfs_tab))], width=1, color="green")
plt.yscale(value="log")
plt.xlim([-1, len(sfs_tab)])
plt.xlabel("genotype count")
plt.ylabel("Number of alleles")
plt.savefig('PREFIX_sfs.pdf')
