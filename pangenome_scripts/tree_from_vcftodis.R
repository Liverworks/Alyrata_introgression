dt<-read.table("/netscratch/dep_mercier/grp_novikova/A.Lyrata/anna_g/mabs_assemblies/mapping/All_try_cov1.mat")
rownames(dt)<- c("AL08", "AL27", "AL56", "AL85", "BOR", "BAM12.1", "BAM12.3", "NT1", "NT12", "NT8", "NT9", "TE11", "TE4", "TE8", "PU6", "WS1", "al1", "MN47", "PTP", "LPT", "TSS", "Ped", "Ceb_c", "Ceb_d", "Wall10", "Pais09", "ASS3_AA", "ASS3_AT", "AS530_AA", "AS530_AT", "AS150_AA", "AS150_AT", "ColCEN")
colnames(dt)<- c("samples", "AL08", "AL27", "AL56", "AL85", "BOR", "BAM12.1", "BAM12.3", "NT1", "NT12", "NT8", "NT9", "TE11", "TE4", "TE8", "PU6", "WS1", "al1", "MN47", "PTP", "LPT", "TSS", "Ped", "Ceb_c", "Ceb_d", "Wall10", "Pais09", "ASS3_AA", "ASS3_AT", "AS530_AA", "AS530_AT", "AS150_AA", "AS150_AT", "ColCEN")
dt = dt[,-1]
pdf("/home/aglushkevich/tree_all.pdf") #nj(dist(dt))
plot(nj(dist(dt)))
dev.off()
tree = root(tree, "", resolve.root=T)
tree = nj(dist(dt))
tree = root(tree, "ColCEN", resolve.root=T)
pdf("/home/aglushkevich/tree_all_rooted.pdf") #nj(dist(dt))
plot(tree)
dev.off()
