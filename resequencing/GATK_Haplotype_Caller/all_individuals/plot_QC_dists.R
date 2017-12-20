#!/usr/bin/env Rscript

args <- commandArgs(TRUE)

#4 required arguments are 1) species, 2) file of sites to exclude from previous coverage work 3) output dir for plots, 4) path to directory with quality stats ifo
sp <- args[1]
exclude_file <- args[2]
plot_dir <- args[3]
qual_dir <- args[4]
stat <- args[5]


#library(tidyverse) #ede could not install on cypress
library(ggplot2)
library(readr) #ede added
library(dplyr) #ede added
library(tidyr) #ede added

exclude <- read_tsv(exclude_file,col_names = c("scaffold","pos_-1","pos"))

exclude <- exclude %>% unite(scaffold,pos,sep = "_",col = "scaff_pos") %>% select("scaff_pos")

#First look at quality by depth, or QD
if (stat == "QD"){

QD <- read_tsv(paste(qual_dir,"/",sp,"_QD.INFO",sep=""),col_names = TRUE,na = "?")

ggplot(data=QD) + geom_density(mapping=aes(x=QD)) + ggtitle(label=paste(sp,stat,"unfiltered",sep=" "),subtitle=paste(nrow(QD)," sites",sep=""))
ggsave(filename=paste(plot_dir,"/",sp,"_",stat,"_unfiltered.pdf",sep=""),device="pdf")

#Filter non-biallelic sites and sites excluded by 1.5x depth of coverage

QD <- QD %>% filter(nchar(REF)==1 & nchar(ALT) == 1) %>% unite(CHROM,POS,sep="_",col="scaff_pos",remove=FALSE) %>% anti_join(exclude,by="scaff_pos") %>% arrange(CHROM,POS)

ggplot(data=QD) + geom_density(mapping=aes(x=QD)) + ggtitle(label=paste(sp,stat,"SNPS 1.5x coverage filter",sep=" "),subtitle=paste(nrow(QD)," sites",sep=""))
ggsave(filename=paste(plot_dir,"/",sp,"_",stat,"_snps_covfilter.pdf",sep=""),device="pdf")

rm(QD)
}

########################################
#Next, "mapping quality" or MQ

if (stat == "MQ"){


MQ <- read_tsv(paste(qual_dir,"/",sp,"_MQ.INFO",sep=""),col_names = TRUE,na = "?")


ggplot(data=MQ) + geom_density(mapping=aes(x=MQ)) + ggtitle(label=paste(sp,stat,"unfiltered",sep=" "),subtitle=paste(nrow(MQ)," sites",sep=""))
ggsave(filename=paste(plot_dir,"/",sp,"_",stat,"_unfiltered.pdf",sep=""),device="pdf")

#Filter non-biallelic sites and sites excluded by 1.5x depth of coverage

MQ <- MQ %>% filter(nchar(REF)==1 & nchar(ALT) == 1) %>% unite(CHROM,POS,sep="_",col="scaff_pos",remove=FALSE) %>% anti_join(exclude,by="scaff_pos") %>% arrange(CHROM,POS)

ggplot(data=MQ) + geom_density(mapping=aes(x=MQ)) + ggtitle(label=paste(sp,stat,"SNPS 1.5x coverage filter",sep=" "),subtitle=paste(nrow(MQ)," sites",sep=""))
ggsave(filename=paste(plot_dir,"/",sp,"_",stat,"_snps_covfilter.pdf",sep=""),device="pdf")

ggplot(data=MQ) + geom_density(mapping=aes(x=MQ)) + ggtitle(label=paste(sp,stat,"SNPS 1.5x coverage filter",sep=" "),subtitle=paste(nrow(MQ)," sites",sep="")) + xlim(c(0,80))
ggsave(filename=paste(plot_dir,"/",sp,"_",stat,"_snps_covfilter_constrained.pdf",sep=""),device="pdf")

rm(MQ)
}

########################################
#Next, "FisherStrand" or FS
if (stat == "FS"){

FS <- read_tsv(paste(qual_dir,"/",sp,"_FS.INFO",sep=""),col_names = TRUE,na = "?")

ggplot(data=FS) + geom_density(mapping=aes(x=FS)) + ggtitle(label=paste(sp,stat,"unfiltered",sep=" "),subtitle=paste(nrow(FS)," sites",sep="")) + xlim(c(0,50))
ggsave(filename=paste(plot_dir,"/",sp,"_",stat,"_unfiltered.pdf",sep=""),device="pdf")

#Filter non-biallelic sites and sites excluded by 1.5x depth of coverage

FS <- FS %>% filter(nchar(REF)==1 & nchar(ALT) == 1) %>% unite(CHROM,POS,sep="_",col="scaff_pos",remove=FALSE) %>% anti_join(exclude,by="scaff_pos") %>% arrange(CHROM,POS)

ggplot(data=FS) + geom_density(mapping=aes(x=FS)) + ggtitle(label=paste(sp,stat,"SNPS 1.5x coverage filter",sep=" "),subtitle=paste(nrow(FS)," sites",sep="")) + xlim(c(0,100))
ggsave(filename=paste(plot_dir,"/",sp,"_",stat,"_snps_covfilter.pdf",sep=""),device="pdf")

FS <- FS %>% filter(FS != 0)

ggplot(data=FS) + geom_density(mapping=aes(x=FS)) + ggtitle(label=paste(sp,stat,"SNPS 1.5x coverage filter",sep=" "),subtitle=paste(nrow(FS)," sites",sep="")) + xlim(c(0,100))
ggsave(filename=paste(plot_dir,"/",sp,"_",stat,"_snps_covfilter_no0s.pdf",sep=""),device="pdf")

rm(FS)
}

########################################
#Next, "Strand Odds Ratio" or SOR
if (stat == "SOR"){

SOR <- read_tsv(paste(qual_dir,"/",sp,"_SOR.INFO",sep=""),col_names = TRUE,na = "?")

ggplot(data=SOR) + geom_density(mapping=aes(x=SOR)) + ggtitle(label=paste(sp,stat,"unfiltered",sep=" "),subtitle=paste(nrow(SOR)," sites",sep=""))
ggsave(filename=paste(plot_dir,"/",sp,"_",stat,"_unfiltered.pdf",sep=""),device="pdf")

#Filter non-biallelic sites and sites excluded by 1.5x depth of coverage

SOR <- SOR %>% filter(nchar(REF)==1 & nchar(ALT) == 1) %>% unite(CHROM,POS,sep="_",col="scaff_pos",remove=FALSE) %>% anti_join(exclude,by="scaff_pos") %>% arrange(CHROM,POS)

ggplot(data=SOR) + geom_density(mapping=aes(x=SOR)) + ggtitle(label=paste(sp,stat,"SNPS 1.5x coverage filter",sep=" "),subtitle=paste(nrow(SOR)," sites",sep=""))
ggsave(filename=paste(plot_dir,"/",sp,"_",stat,"_snps_covfilter.pdf",sep=""),device="pdf")

rm(SOR)
}

########################################
#Next, "mapping quality rank sum" or MQRS
if (stat == "MQRS"){

MQRS <- read_tsv(paste(qual_dir,"/",sp,"_MQRS.INFO",sep=""),col_names = TRUE,na = "?")

ggplot(data=MQRS) + geom_density(mapping=aes(x=MQRankSum)) + ggtitle(label=paste(sp,stat,"unfiltered",sep=" "),subtitle=paste(nrow(MQRS)," sites",sep="")) + xlim(c(-10,10))
ggsave(filename=paste(plot_dir,"/",sp,"_",stat,"_unfiltered.pdf",sep=""),device="pdf")

#Filter non-biallelic sites and sites excluded by 1.5x depth of coverage

MQRS <- MQRS %>% filter(nchar(REF)==1 & nchar(ALT) == 1) %>% unite(CHROM,POS,sep="_",col="scaff_pos",remove=FALSE) %>% anti_join(exclude,by="scaff_pos") %>% arrange(CHROM,POS)

ggplot(data=MQRS) + geom_density(mapping=aes(x=MQRankSum)) + ggtitle(label=paste(sp,stat,"SNPS 1.5x coverage filter",sep=" "),subtitle=paste(nrow(MQRS)," sites",sep="")) + xlim(c(-10,10))
ggsave(filename=paste(plot_dir,"/",sp,"_",stat,"_snps_covfilter.pdf",sep=""),device="pdf")

rm(MQRS)
}

########################################
#Next, "read pos rank sum" or RPRS
if (stat == "RPRS"){


RPRS <- read_tsv(paste(qual_dir,"/",sp,"_RPRS.INFO",sep=""),col_names = TRUE,na = "?")

ggplot(data=RPRS) + geom_density(mapping=aes(x=ReadPosRankSum)) + ggtitle(label=paste(sp,stat,"unfiltered",sep=" "),subtitle=paste(nrow(RPRS)," sites",sep=""))
ggsave(filename=paste(plot_dir,"/",sp,"_",stat,"_unfiltered.pdf",sep=""),device="pdf")

#Filter non-biallelic sites and sites excluded by 1.5x depth of coverage

RPRS <- RPRS %>% filter(nchar(REF)==1 & nchar(ALT) == 1) %>% unite(CHROM,POS,sep="_",col="scaff_pos",remove=FALSE) %>% anti_join(exclude,by="scaff_pos") %>% arrange(CHROM,POS)

ggplot(data=RPRS) + geom_density(mapping=aes(x=ReadPosRankSum)) + ggtitle(label=paste(sp,stat,"SNPS 1.5x coverage filter",sep=" "),subtitle=paste(nrow(RPRS)," sites",sep=""))
ggsave(filename=paste(plot_dir,"/",sp,"_",stat,"_snps_covfilter.pdf",sep=""),device="pdf")

rm(RPRS)
}
