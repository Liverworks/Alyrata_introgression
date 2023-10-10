library("ape")
source("/netscratch/dep_mercier/grp_novikova/software/twisst/plot_twisst.R")

data_file = "/netscratch/dep_mercier/grp_novikova/A.Lyrata/anna_g/vcfs/halleri_ute_snps.data.tsv"
weights_file = "/netscratch/dep_mercier/grp_novikova/A.Lyrata/anna_g/vcfs/halleri_ute_names.weights.tsv"
twisst_data <- import.twisst(weights_file, data_file)

twisst_data_smooth <- smooth.twisst(twisst_data)

pdf("ute_smooth.pdf", width=8, height=40)
plot.twisst(twisst_data_smooth) #, tree_type="unrooted")
dev.off()

pdf("ute_weights.pdf", width=10, height=40)
plot.twisst(twisst_data, tree_type="unrooted")
dev.off()

plot.twisst.summary(twisst_data, lwd=3, cex=0.7)

??smooth.twisst

unphased_interm2.wheights.tsv
unphased_interm2.wheights.tsv

par(mfrow = c(1,1), mar = c(4,4,1,1))
plot.weights(weights_dataframe=twisst_data$weights[[1]], positions=twisst_data$window_data[[1]][,c("start","end")],
             line_cols=topo_cols, fill_cols=topo_cols, stacked=TRUE)
plot.weights(weights_dataframe=twisst_data$weights[[1]], positions=twisst_data$window_data[[1]][,c("start","end")],
             line_cols=topo_cols, fill_cols=paste0(topo_cols,80), stacked=FALSE)


plot.weights(weights_dataframe=twisst_data_smooth$weights[[1]], positions=twisst_data_smooth$pos[[1]],
             line_cols=topo_cols, fill_cols=topo_cols, stacked=TRUE)

jpeg("1_boxes.jpeg", width=12, height=12)
plot.twisst.summary.boxplot(twisst_data, lwd=3, cex=0.7, outline=TRUE)


write.csv(twisst_data$window_data, "window_ph_sc2_50.csv", row.names = FALSE)
write.csv(twisst_data$weights_raw, "topo_ph_sc2_50.csv", row.names = FALSE)

twisst_data$window_data$scaffold9

top2_topos <- order(twisst_data$weights_overall_mean, decreasing=T)[1:2]

subset.twisst.by.topos(twisst_data, 2)
