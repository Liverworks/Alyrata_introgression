import sys
import gzip

pref = sys.argv[1]

batch = "chr\tposition\tx\tn\tfolded\n"
#pref = "put"
first = pref + ".het.vcf.gz"
outp = pref + "_allele_freq_all.tsv"
with gzip.open(first, 'r') as infile:
    with open(outp, 'w') as out:
        for line in infile:
            if line.startswith("#"): # passing the header
                continue
            else:
                line = line.strip().split() 
                #if # len(line[3]) == 1 and len(line[4]) == 1 and line[4] != "*": # detect 1 nucleotide long variations
                #iterlines += 1
                samples = line[9:-1]
                var_al = 0
                all_al = 0
                gen = []
                for sample in samples:
                    gen = gen + sample.split(":")[0].split("/") # check if there is a variation in the position
                    #print(gen)
                if set(gen) != {"."}: 
                    for variation in gen:
                        if variation == '.':
                            continue
                        elif int(variation) > 0:   
                            var_al += 1
                            all_al += 1
                        elif variation == '0':
                            all_al += 1
                if all_al > 0:
                    batch += (line[0] + "\t" + line[1] + "\t")
                    batch += (str(var_al) + "\t" + str(all_al) + "\t1\n")
            if len(batch) > 100000:
                out.write(batch)
                batch = ""
        out.write(batch)

batch = ""
second = pref + ".hom.ref.vcf.gz"
with gzip.open(second, 'r') as infile:
    with open(outp, 'a') as out:
        for line in infile:
            if line.startswith("#"): # passing the header
                continue
            else:
                line = line.strip().split() 
                samples = line[9:-1]
                var_al = 0
                all_al = 0
                gen = []
                for sample in samples:
                    gen = gen + sample.split(":")[0].split("/") # check if there is a variation in the position
                    #print(gen)
                if set(gen) != {"."}:
                    #print(gen)
                    for variation in gen:
                        if variation == '.':
                            continue
                        elif int(variation) > 0:
                            var_al += 1
                            all_al += 1
                        elif variation == '0':
                            all_al += 1
                    if all_al > 0:
                        batch += (line[0] + "\t" + line[1] + "\t")
                        gen = line[-1].split(":")[0].split("/")
                        #batch += (str(var_al) + "\t" + str(all_al) + "\t0\n")
                        if set(gen) != {"."}:
                            batch += (str(var_al) + "\t" + str(all_al) + "\t0\n")
                        else:
                            batch += (str(var_al) + "\t" + str(all_al) + "\t1\n")
            if len(batch) > 500000:
                #print("writing")
                out.write(batch)
                batch = ""
        out.write(batch)
        #print("writing")

batch = ""
third = pref + ".hom.2polarize.vcf.gz"
with gzip.open(third, 'r') as infile:
    with open(outp, 'a') as out:
        for line in infile:
            if line.startswith("#"): # passing the header
                continue
            else:
                line = line.strip().split()
                samples = line[9:-1]
                var_al = 0
                all_al = 0
                gen = []
                for sample in samples:
                    gen = gen + sample.split(":")[0].split("/") # check if there is a variation in the position
                    #print(gen)
                if set(gen) != {"."}:
                    #print(gen)
                    for variation in gen:
                        if variation == '.':
                            continue
                        elif int(variation) > 0:
                            all_al += 1
                        elif variation == '0':
                            all_al += 1
                            var_al += 1
                    if all_al > 0:
                        batch += (line[0] + "\t" + line[1] + "\t")
                        batch += (str(var_al) + "\t" + str(all_al) + "\t0\n")
                        #gen = line[-1].split(":")[0].split("/")
            if len(batch) > 100000:
                #print("writing")
                out.write(batch)
                batch = ""
        out.write(batch)
        #print("writing")"""

import pandas as pd


freq = pd.read_csv(outp, sep="\t")
outp2 = outp[0:-4] + "_sorted.tsv"

freq.sort_values(by=['chr', 'position']).to_csv(outp2, sep="\t", index=False)


spect = freq[(freq.n == freq.n.max()) & (freq.folded == 0)].x.value_counts()

reffile = pref + "_ref_count.txt"
with open(reffile) as wcl:
    for i in wcl.readlines():
        ref = i.split()[0]
        break
spect[0] = spect[0] + int(ref)
sum_pos = spect.sum()
spect2 = pd.DataFrame(spect)
spect2["fraction"] = spect2.x / sum_pos

outp = pref + "_freq_spec_0.tsv"
spect2.sort_index().to_csv(outp, sep="\t", header=False)
