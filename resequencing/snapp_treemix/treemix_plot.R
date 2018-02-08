source("/home/eenbody/BI_software/treemix-1.13/src/plotting_funcs.R")

pdf("phylotree_fig.pdf",height=8.5,width=6)
plot_tree("out_stem")
dev.off()

pdf("phylotree_resid.pdf",height=8.5,width=6)
plot_resid("out_stem", "../poporder")
dev.off()
