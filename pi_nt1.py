#!/usr/bin/python3

#from optparse import OptionParser
#parser = OptionParser()
#parser.add_option("-v", "--vcf", dest="vcf", help="vcf file name", default="")
#parser.add_option("-d", "--dir", dest="dir", help="input directory", default="")
#(options, args) = parser.parse_args()

#hom,het=0,0
#out=open("%s/%s.homhet"%(options.dir,options.vcf),"w")
#for line in open("%s/%s"%(options.dir,options.vcf)):
#    if "#" in line: 
#        pass
#    else:
#        line=line.strip().split() 
#        if len(line[3])==1 and len(line[4])==1 and line[4]!="*":
#            gen=line[9].split(":")[0].split("/")
#            if len(set(gen))==1 and set(gen)!=set(["."]):
#                hom=hom+1
#            if len(set(gen))==2 and set(gen)!=set(["."]):
#                het=het+1
#out.write("%s,%s\n"%(hom,het))
#out.close()



import os.path
import gzip
import re
import sys

arg = sys.argv[1] # argument is a gzipped VCF
path = '.' if '/' not in arg else os.path.dirname(arg)
prefix = re.search('(.*)vcf', os.path.basename(arg)).group(1)

with gzip.open(arg, 'rt') as infile:
    for line in infile:
        if line.startswith("##"): # passing comments
            continue
        elif line.startswith("#CHROM"): # reading samples` names
            names = line.strip().split()[9:]
            pibeta = [[0, 0] for _ in names]  # first figure for all checked nucl, second for different
            #print(pibeta)
        else:
            line = line.strip().split() 
            if len(line[3]) == 1 and len(line[4]) == 1 and line[4] != "*": # detect 1 nucleotide long variations
                samples = line[9:]
                for i, sample in enumerate(samples):
                    gen = sample.split(":")[0].split("/")
                    if set(gen) != {'.'}:
                        for variation in gen:
                            if variation == '0':
                                pibeta[i][0] += 1
                            elif variation == '1':
                                pibeta[i][1] += 1
                                #pibeta[i][0] += 1
                # print(pibeta)
print(pibeta)
with open('NT1_pibeta.tsv', 'w') as out:
    out.write('sample\ttotal_nucleotides\ttotal_variations\tpibeta\n')
    for i, name in enumerate(names):
        out.write(name + "\t" + str(pibeta[i][0] + pibeta[i][1]) + "\t" + str(pibeta[i][1]) + "\t" + str(pibeta[i][0]/(pibeta[i][0]+pibeta[i][1])) + '\n')
       

