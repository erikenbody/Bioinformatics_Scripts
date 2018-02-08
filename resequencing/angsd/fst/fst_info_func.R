suppressMessages(library(optparse))
suppressMessages(library("rtracklayer"))
suppressMessages(library(methods))
suppressMessages(library(optparse))
#library(ggplot2)
#library(qqman)
suppressMessages(library(dplyr))
suppressMessages(library("IRanges"))
suppressMessages(library("GenomicRanges"))
suppressMessages(library("tibble"))

#########FOR RUNNING THIS ON CLUSTER
option_list <- list(make_option(c('-g','--gff_db_file'), action='store', type='character', default=NULL, help='Input gene info (custom made from gff, saved as.db))'),
                    make_option(c('-d','--fst_dir'), action='store', type='character', default=NULL, help='Directory where fst window file is'),
                    make_option(c('-i','--in_file'), action='store', type='character', default=NULL, help='Name of file to parse'),
                    make_option(c('-o','--out_dir'), action='store', type='character', default=NULL, help='Output file'),
                    make_option(c('-t','--file_type'),action='store', type='character', default=NULL, help='VCFTOOLS or ANGSD'),
                    make_option(c('-f','--filter_file'),action='store', type='character', default=NULL, help='for ANGSD, pull in a file to filter out short scaffolds')
)
opt <- parse_args(OptionParser(option_list = option_list))

#################################################################################

#for testing locally:
#opt$gff_db_file<-"gene_only.db"
#opt$fst_dir<-"data/angsd_fst/nocov_skiptri"
#opt$in_file<-"aida_naimii_autosome_All-Ind-MidFilt_50000-Win.fst.txt"
#opt$out_dir<-"output"
#opt$file_type<-"ANGSD"
#opt$filter_file<-"data/WSFW_scaffold_lengths.txt"
#

#for testing cluster
#opt$gff_db_file<-"/home/eenbody/WSFW_assembly_maker2.maker.output/functional_annotation/maker_functional_final_output/gene_only.db"
#opt$fst_dir<-"/home/eenbody/reseq_WD/angsd/fst_angsd/fst_actual_analysis/all_individuals/autosome/All-Ind-MidFilt"
#opt$in_file<-"aida_naimii_autosome_All-Ind-MidFilt_50000-Win.pbs.txt"
#opt$out_dir<-"GenesInWin"
#opt$file_type<-"ANGSD"
#opt$filter_file<-"/home/eenbody/reseq_WD/angsd/fst_angsd/autosome_scaffolds_gr_50000_head.txt"

gene.df<-dget(opt$gff_db_file)

#read files
if (opt$file_type == "ANGSD"){
  # Read input file
  pops <- read.table(paste(opt$fst_dir,opt$in_file,sep="/"), header=FALSE,row.names=NULL,skip=1)
  colnames(pops)<-c("region","scaff","midPos","Nsites","fst")
  sl50<-read.table(opt$filter_file,header=TRUE,row.names=NULL)
  pops<-merge(pops,sl50,all.x=FALSE,all.y=FALSE,by="scaff")
}

if (opt$file_type == "VCFTOOLS"){
  # Read input file
  pops <- read.table(opt$in_file, header=TRUE,row.names=NULL)
  pops$midPos<-round((pops$BIN_START + pops$BIN_END)/2,0)
  pops<-select(pops,BIN_START,CHROM,midPos,N_VARIANTS,WEIGHTED_FST)
  colnames(pops)<-NULL
  colnames(pops)<-c("region","scaff","midPos","Nsites","fst")
}

out<-strsplit(as.character(pops$scaff), "_")
pops$scaff_num<-as.numeric(lapply(out,function(ss){ss[2]}))

#####CALCULATE ZFST####
#on filtered dataset
#following Fan et al. 2017 Genome Biology
pops$zfst<-(pops$fst - mean(pops$fst))/sd(pops$fst)

#####NEXT SETUP FILTERING####

#Remove less than two windows per scaffold
pops_dff<-pops[as.numeric(ave(pops$scaff_num, pops$scaff_num, FUN=length)) >= 2, ]

#Setup regions for use in GRanges
pops2<-pops_dff
pops<-merge(pops2,sl50,all.x=FALSE,all.y=FALSE,by="scaff")
pops2$region <- gsub("(","",pops2$region,fixed=TRUE)
pops2$region <- gsub(")","-",pops2$region,fixed=TRUE)
#head(pops2)

out222<-strsplit(as.character(pops2$region), "-")
pops2$region2<-as.character(lapply(out222,function(ss){ss[3]}))
out333<-strsplit(as.character(pops2$region2), ",")
pops2$start<-as.character(lapply(out333,function(ss){ss[1]}))
pops2$end<-as.character(lapply(out333,function(ss){ss[2]}))
#head(pops2)

pops2$startW<-as.numeric(pops2$start) ; pops2$start<-NULL
pops2$endW<-as.numeric(pops2$end) ; pops2$end<-NULL

#QUANTILE subsets
pops99<-filter(pops2, pops2$zfst >= quantile(pops2$zfst,0.99))
pops99.9<-filter(pops2, pops2$zfst >= quantile(pops2$zfst,0.999))

#I encountered problem that for GRanges, must be same scaffolds in each apparently. Found solution for matching here:
#https://stackoverflow.com/questions/15227887/how-can-i-subset-rows-in-a-data-frame-in-r-based-on-a-vector-of-values
#this wasnt neccessary and didnt fix problem. I still get error, but thats OK
#cl.pops99 <- pops99[pops99$scaff %in% gene.df$seqid, ]
#cl.pops99.9 <- pops99.9[pops99.9$scaff %in% gene.df$seqid, ]
#cl.gene.df <- gene.df[gene.df$seqid %in% pops99$scaff,]

#must be numeric for GRanges
genes_in_windows<-function(x,y){
gr1<-GRanges(x$scaff,IRanges(x$startW,x$endW,names=x$fst))
gr2<-GRanges(y$seqid,IRanges(y$start,y$end,names=y$Name))
#seqlengths(gr1) = seqlengths(gr2)[names(seqlengths(gr1))]
fo <- findOverlaps(gr1, gr2)
xy<-cbind(x[queryHits(fo),], y[subjectHits(fo),])
return(xy)
}

#run the overlap function that identifies which genes in which windows
suppressWarnings(pops99.genes<-genes_in_windows(pops99,gene.df))
suppressWarnings(pops99.9.genes<-genes_in_windows(pops99.9,gene.df))

pops99.output<-pops99.genes %>% arrange(desc(zfst))
pops99.9.output<-pops99.9.genes %>% arrange(desc(zfst))

write.csv(pops99.output, paste(opt$out_dir,"/",opt$in_file,"_Genes_in_99q.csv",sep=""),row.names = FALSE)
write.csv(pops99.9.output, paste(opt$out_dir,"/",opt$in_file,"_Genes_in_99.9q.csv",sep=""),row.names = FALSE)
dput(pops99.output, paste(opt$out_dir,"/",opt$in_file,"_Genes_in_99q.db",sep=""))
dput(pops99.9.output, paste(opt$out_dir,"/",opt$in_file,"_Genes_in_99.9q.db",sep=""))

#save(pops99.9.output, file=paste(opt$out_dir,"/",opt$in_file,"_Genes_in_99.9q.db",sep=""))
#z<-load("output/aida_naimii_autosome_All-Ind-MidFilt_50000-Win.fst.txt_Genes_in_99.9q.db")

#number of genes per scaffold
num_genes_per_scaff99<-pops99.genes %>% group_by(scaff) %>% summarise(num_gene = n_distinct(Name))
num_genes_per_scaff99.9<-pops99.9.genes %>% group_by(scaff) %>% summarise(num_gene = n_distinct(Name))

write.table(num_genes_per_scaff99,paste(opt$out_dir,"/",opt$in_file,"_NUM_GENES_PER_SCAFFOLD_99.txt",sep=""),quote = FALSE,sep="\t",row.names = FALSE)
write.table(num_genes_per_scaff99.9,paste(opt$out_dir,"/",opt$in_file,"_NUM_GENES_PER_SCAFFOLD_99.9.txt",sep=""),quote = FALSE,sep="\t",row.names = FALSE)
#dput(num_genes_per_scaff99,paste(opt$out_dir,"/",opt$in_file,"_NUM_GENES_PER_SCAFFOLD_99.db",sep=""))
#dput(num_genes_per_scaff99,paste(opt$out_dir,"/",opt$in_file,"_NUM_GENES_PER_SCAFFOLD_99.9.db",sep=""))

levels= c("all",">99_quantile",">99.9_quantile")

##MAKE A SUMMARY TABLE

peak_tab <- data.frame(row.names=levels,
                       minFst = rep(NA, length(levels)),
                       maxFst = rep(NA, length(levels)),
                       meanFst = rep(NA, length(levels)),
                       minZfst = rep(NA, length(levels)),
                       maxZfst = rep(NA, length(levels)),
                       meanfZfst = rep(NA, length(levels)),
                       num_windows = rep(NA, length(levels)),
                       genes_in_windows = rep(NA, length(levels)),
                       mean_genes_per_window = rep(NA, length(levels)),
                       file = rep(NA, length(levels)))

peak_tab['all',] <- c(round(min(pops2$fst[pops2$fst>0]),3), round(max(pops2$fst[pops2$fst>0]),3), round(mean(pops2$fst[pops2$fst>0]),3),
                      round(min(pops2$zfst[pops2$zfst>0]),3), round(max(pops2$zfst[pops2$zfst>0]),3), round(mean(pops2$zfst[pops2$zfst>0]),3),
                      nrow(pops2), NA,NA,opt$in_file)

peak_tab['>99_quantile',] <- c(round(min(pops99$fst[pops99$fst>0]),3), round(max(pops99$fst[pops99$fst>0]),3), round(mean(pops99$fst[pops99$fst>0]),3),
                               round(min(pops99$zfst[pops99$zfst>0]),3), round(max(pops99$zfst[pops99$zfst>0]),3), round(mean(pops99$zfst[pops99$zfst>0]),3),
                               nrow(pops99), sum(num_genes_per_scaff99$num_gene),round(mean(num_genes_per_scaff99$num_gene),3),opt$in_file)

peak_tab['>99.9_quantile',] <- c(round(min(pops99.9$fst[pops99.9$fst>0]),3), round(max(pops99.9$fst[pops99.9$fst>0]),3), round(mean(pops99.9$fst[pops99.9$fst>0]),3),
                                 round(min(pops99.9$zfst[pops99.9$zfst>0]),3), round(max(pops99.9$zfst[pops99.9$zfst>0]),3), round(mean(pops99.9$zfst[pops99.9$zfst>0]),3),
                                 nrow(pops99.9), sum(num_genes_per_scaff99.9$num_gene),round(mean(num_genes_per_scaff99.9$num_gene),3),opt$in_file)
peak_tab<-rownames_to_column(peak_tab,var="subset")

write.table(peak_tab,paste(opt$out_dir,"/",opt$in_file,"_PEAK_TABLE.txt",sep=""),quote = FALSE,sep="\t",row.names=FALSE)

print(paste(opt$in_file,"done processing",sep=" "))
