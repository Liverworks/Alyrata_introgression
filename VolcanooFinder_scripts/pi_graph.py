import os.path
import gzip
import re
import sys
import pandas as pd
import seaborn as sns

arg = "put.snps.vcf.gz"
chrom = "scaffold_8\t"
pibets = {}
with gzip.open(arg, 'rt') as infile:
    for line in infile:
        if line.startswith(chrom) == False: # passing comments
            continue
        else:
            #print(line)
            line = line.strip().split() 
            samples = line[9:-1]
            var_al = 0
            all_al = 0
            gen = []
            for sample in samples:
                gen = gen + sample.split(":")[0].split("/")
                #print(gen)
            if set(gen) != {"."}:
                for variation in gen:
                    if variation == '0':
                        var_al += 1
                    elif variation == '1':
                        all_al += 1
                        #pibeta[i][0] += 1
                #print(var_al, all_al)
                pibets[int(line[1])] = all_al/(var_al+all_al)
                # print(pibeta)
#print(pibets)

arg = "put.ref.vcf.gz"
chrom = "scaffold_8\t"
with gzip.open(arg, 'rt') as infile:
    for line in infile:
        if line.startswith(chrom) == False: # passing comments
            continue
        else:
            line = line.strip().split()
            pibets[int(line[1])] = 0

pib = pd.DataFrame.from_dict(pibets, orient='index', columns=['pi'])
pib.to_csv("put_pi_8chr.tsv", sep='\t')

a = 11900
b = 12000
glad = []
for i in range(a, b): # Not for chr edges!
    i_start = i - 50
    i_stop = i + 50
    glad_i = []
    for k in range(i_start, i_stop):
        try:
            glad_i.append(pibets[k])
        except:
            continue
    glad.append(sum(glad_i)/100)


plplot = sns.lineplot(data=glad)
fig = plplot.get_figure()
fig.savefig("try_chr8_100.png")

a = 11900
b = 12000
glad = []
for i in range(a, b): # Not for chr edges!
    i_start = i - 50
    i_stop = i + 50
    glad_i = []
    for k in range(i_start, i_stop):
        try:
            glad_i.append(pibets[k])
        except:
            continue
    glad.append(sum(glad_i)/len(glad_i))

plplot = sns.lineplot(data=glad)
fig = plplot.get_figure()
fig.savefig("try_chr8_mean.png")

