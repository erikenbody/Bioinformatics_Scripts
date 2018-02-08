#library("rnaseqGene")#
library("DESeq2")
library("RColorBrewer")
library("gplots")#
library("genefilter")
library("optparse")
library("ggplot2")

#########FOR RUNNING THIS ON CLUSTER
option_list <- list(make_option(c('-d','--dir'), action='store', type='character', default=NULL, help='Input file (output from ngsCovar)'),
                    make_option(c('-o','--out_file'), action='store', type='character', default=1-2, help='Components for title'))

opt <- parse_args(OptionParser(option_list = option_list))
#################################################################################

#directory<- "data/star_DoCounts"
directory<- opt$dir
# "" defines what the files you want to load have in common
list.files(directory)

afterF<-grep("after",list.files(directory),value=TRUE)
afterF2<-gsub("_","-",afterF)
sep.tab<-read.table(text=afterF2,sep="-")
afterFCondition<-as.character(sep.tab$V5)
afterFName<-as.character(sep.tab$V2)
afterFPart<-as.character(sep.tab$V4)

maleF<-grep("-M-",list.files(directory),value=TRUE)
maleF2<-gsub("_","-",maleF)
sep.tab3<-read.table(text=maleF2,sep="-")
maleFCondition<-as.character(sep.tab3$V4)
maleFName<-as.character(sep.tab3$V2)
maleFPart<-as.character(sep.tab3$V5)

allFiles <- grep("ReadsPerGene",list.files(directory),value=TRUE)
#split_files<-gsub("_","-",allFiles)
allFiles<-setdiff(allFiles,afterF)
allFiles<-setdiff(allFiles,maleF)
split_files<-gsub("_","-",allFiles)
split_files2<-gsub("-before-","-",split_files)
sep.tab2<-read.table(text=split_files2,sep="-")
allCondition<-as.character(sep.tab2$V3)
allName<-as.character(sep.tab2$V2)
allPart<-as.character(sep.tab2$V4)

sampleFiles<-c(afterF,maleF,allFiles)
samplePop<-c(afterFCondition,maleFCondition,allCondition)
sampleName<-c(afterFName,maleFName,allName)
samplePart<-c(afterFPart,maleFPart,allPart)

sampleTable<-data.frame(sampleName=sampleFiles, fileName=sampleFiles, population=samplePop,name=sampleName,part=samplePart)
sampleTable$PopPart<-as.factor(paste(sampleTable$population,sampleTable$part,sep="_"))

ddsHTSeq2<-DESeqDataSetFromHTSeqCount(sampleTable=sampleTable, directory=directory, design=~PopPart)

dds<-DESeq(ddsHTSeq2)
res<-results(dds)
dds <- estimateSizeFactors(dds)

rld <- rlog(dds, blind=TRUE)

#plotPCA(rld, intgroup = c("PopPart"))
#dev.copy(png,"all_samples_pca")
#dev.off()

pdf(opt$out_file,height=11,width=8.5)
pcaData<-plotPCA(rld, intgroup = c("population","part"),returnData=TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))
ggplot(pcaData, aes(PC1, PC2, color=part, shape=population)) +
  geom_point(size=3) +
  xlab(paste0("PC1: ",percentVar[1],"% variance")) +
  ylab(paste0("PC2: ",percentVar[2],"% variance")) +
  coord_fixed()
dev.off()
