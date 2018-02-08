# Usage: Rscript -i infile.covar -c component1-component2 -a annotation.file -o outfile.eps

suppressMessages(library(methods))
suppressMessages(library(optparse))
suppressMessages(library(ggplot2))
suppressMessages(library(qqman))
suppressMessages(library(dplyr))

#########FOR RUNNING THIS ON CLUSTER
option_list <- list(make_option(c('-i','--in_file'), action='store', type='character', default=NULL, help='Input file (output from ngsCovar)'),
                    make_option(c('-c','--comp'), action='store', type='character', default=1-2, help='Components for title'),
                    make_option(c('-a','--annot_file'), action='store', type='character', default=NULL, help='Annotation file with individual classification (2 column TSV with ID and ANNOTATION)'),
                    make_option(c('-o','--out_file'), action='store', type='character', default=NULL, help='Output file'),
                    make_option(c('-t','--file_type'),action='store', type='character', default=NULL, help='VCFTOOLS or ANGSD')
)
opt <- parse_args(OptionParser(option_list = option_list))

#################################################################################

#format for command line is:
#POP1=aida
#POP2=naimii
#CHR=autosomes
#Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP1}_${POP2}_a.pbs.txt -c ${POP1}_${POP1}_${CHR}_NoCov -o Results/${POP1}_${POP2}_${CHR}.pdf

if (opt$file_type == "ANGSD"){
# Read input file
pops <- read.table(opt$in_file, header=FALSE,row.names=NULL,skip=1)
#pops <- read.table("data/angsd_fst/nocov_skiptri/test.txt", header=FALSE,row.names=NULL,skip=1) #test run
colnames(pops)<-c("region","scaff","midPos","Nsites","fst")
sl50<-read.table("/home/eenbody/reseq_WD/angsd/fst_angsd/autosome_scaffolds_gr_50000_head.txt",header=TRUE,row.names=NULL)
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

####FIRST SETUP DEFAULT FST OUTPUT NO FILTERING#####
#input for comp should be: aida_naimii_autosomes_misc
#comp1<-as.character(c("aida_naimii_autosomes_misc"))
comp<-strsplit(opt$comp, "_",fixed=TRUE[[1]])
title<-paste(comp[[1]][3],": ",comp[[1]][1]," vs. ",comp[[1]][2]," (",comp[[1]][4],")",sep="")

out<-strsplit(as.character(pops$scaff), "_")
pops$scaff_num<-as.numeric(lapply(out,function(ss){ss[2]}))
pops.subset<-pops[complete.cases(pops),]
SNP<-c(1:(nrow(pops.subset)))
pops_df<-data.frame(SNP,pops.subset)

#####CALCULATE ZFST####
#on filtered dataset
#following Fan et al. 2017 Genome Biology
pops_df$zfst<-(pops_df$fst - mean(pops_df$fst))/sd(pops_df$fst)

#####NEXT SETUP FILTERING####

#Remove less than two windows per scaffold and less than 10 sites per window
pops_dff<-pops_df[as.numeric(ave(pops_df$scaff_num, pops_df$scaff_num, FUN=length)) >= 2, ]

#pops_dff<-pops_df %>% group_by(scaff_num) %>% filter(n() >= 2) #didnt work
#pops_dff<-pops_dff %>% group_by(Nsites) %>% filter(n() < 10) #didnt work
titlef<-paste(comp[[1]][3],": ",comp[[1]][1]," vs. ",comp[[1]][2]," (",comp[[1]][4]," No scaffs<2 windows)",sep="")

####CREATE PDF####

pdf(opt$out_file,height=8.5,width=11)
#pdf("output/test7.pdf",height=11,width=8.5) #for testing purposes
par(mfrow = c(2,1))
#manhattan(pops_df, chr="scaff_num",bp="midPos",p='fst',logp=FALSE,ylab="Fst",xlab="Scaffold", cex=0.3, main=title, suggestiveline = FALSE,genomewideline=FALSE)
#manhattan(pops_df, chr="scaff_num",bp="midPos",p='zfst',logp=FALSE,ylab="ZFst",xlab="Scaffold", cex=0.3, main=title, suggestiveline = FALSE,genomewideline=FALSE)
manhattan(pops_dff, chr="scaff_num",bp="midPos",p='fst',logp=FALSE,ylab="Fst",xlab="Scaffold", cex=0.3, main=titlef, suggestiveline=quantile(pops_dff$fst,0.99)[[1]],genomewideline=quantile(pops_dff$fst,0.999)[[1]])
manhattan(pops_dff, chr="scaff_num",bp="midPos",p='zfst',logp=FALSE,ylab="ZFst",xlab="Scaffold", cex=0.3, main=titlef, suggestiveline=quantile(pops_dff$zfst,0.99)[[1]],genomewideline=quantile(pops_dff$zfst,0.999)[[1]])
dev.off()
