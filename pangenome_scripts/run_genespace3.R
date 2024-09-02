wd='/netscratch/dep_mercier/grp_novikova/A.Lyrata/anna_g/genspace_try/halleri_v1.2_re' 
genomeIDs=c('NT1_v2', 'Wall10_v1.2', 'Pais09_v1.2')
#'MN47_v4','TSS_v1', 'LPT_v1', 'PTP_v0', 'NT1_v2','BOR_v1','AL27_v1', 'AL08_v2','TE4_v1','TE8_v1','TE11_v2','PU6_v3','WS1_v2','NT12_v2','NT8_v2','NT9_v2','BAM12_v2','al1_v2')
 #'MN47_v4','NT1_v2','BOR_v1','AL08_v2','TE4_v1','TE8_v1','TE11_v2','PU6_v2','WS1_v2','NT12_v2','NT8_v2','NT9_v2','BAM12_v2','al1_v2'
#ncores
n=60


library(GENESPACE)
path2mcscanx <- '/opt/share/software/scs/appStore/stretchApps/synteny/MCScanX/va8443a9/bin'

# If rerunning from scratch, remove orthofinder results
# unlink(paste0(wd, 'orthofinder'), recursive=T)

# Check input data
gpar <- init_genespace(wd=wd, 
                       genomeIDs=genomeIDs,
                       ploidy=rep(1, 3),
                       path2mcscanx=path2mcscanx,
                       nCores=n
)

# Run synteny analysis
out <- run_genespace(gpar, overwrite = T)

# Plot
ripd <- plot_riparian(gsParam=out, useRegions=F, syntenyWeight = 1)
