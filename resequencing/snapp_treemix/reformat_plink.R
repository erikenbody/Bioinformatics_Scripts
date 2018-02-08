#editing plink file
#plink<-read.table("data/plink_subset.fq",header=TRUE)
plink<-read.table("wsfw_plink.frq.strat",header=TRUE)
#head(plink)
#plink$SNP2<-rep(1:(nrow(plink)/5),length.out=nrow(plink),each=5)
plink$SNP<-NULL
plink$SNP<-rep(1:nrow(plink),length.out=nrow(plink),each=5)
plink<-plink[c(1,8,2:7)]
#head(plink)
write.table(plink,"wsfw_plink_rf.frq.strat",row.names=FALSE,quote = FALSE,col.names = TRUE,sep="\t")
