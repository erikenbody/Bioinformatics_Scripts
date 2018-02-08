#! /usr/bin/Rscript
options(warn=-1) #suppress warnings during execution
#author:https://github.com/rcristofari

##TO-DO LIST
#ADD THE COUNT DATA FROM ANGSD USING THE -dumpCounts 2 OPTION
#THINK ABOUT HOW TO ADD THE GENOTYPE LIKELIHOOD DATA TOO


args <- commandArgs(TRUE)

#Exception if no argument is provided
if(length(args) < 1) {
  args <- "--help"
}

###########################################################################################
#	#HELP SECTION
###########################################################################################

if("--help" %in% args) {
  cat("
	_________________________________________________________________________________________________

	angsd2vcf
	_________________________________________________________________________________________________

	Converts a genotype call file produced by ANGSD into a VCF format, used for analysis in other
	packages, or for SNP call comparison using VCFtools perl scripts. Note that it will set a quality
	score of 30 by default. Genotypes should be in 012 format, as output by ANGSD using the '-doGeno 3'
	option (Major, minor and calls). Read counts are as output by ANGSD with '-doCounts 1 -dumpCounts 2'
	options. Input files may be gzipped.

	Arguments:
	--bam=		path to the BAM file list used in ANGSD
	--geno=		path to the ANGSD genotype file
	--counts=	path to the ANGSD counts file
	--out=		path to write the vcf file
	--help      	print this text

	Example:
	./angsd2vcf.R --bam=./BAM.list --geno=./angsd.geno.gz --counts=./angsd.counts.gz --out=./outfile.vcf
	_________________________________________________________________________________________________

")
q(save="no")}

###########################################################################################
#	#STANDARD ARGUMENT PARSER
###########################################################################################

parseArgs <- function(x) strsplit(sub("^--", "", x), "=")
argsDF <- as.data.frame(do.call("rbind", parseArgs(args)))
argsL <- as.list(as.character(argsDF$V2))
names(argsL) <- argsDF$V1

## --bam error
if(is.null(argsL$bam)) {
  stop("No BAM file list has been provided")}
##--geno error
if(is.null(argsL$geno)) {
	stop("No genotype file has been provided")}
##--counts error
if(is.null(argsL$counts)) {
	stop("No read counts file has been provided")}
## --out error
if(is.null(argsL$out)) {
  stop("No output folder has been provided")}

###########################################################################################
#	#SETTING UP THE PATHS
###########################################################################################
argsL$bam -> path_bam
argsL$geno -> path_geno
argsL$counts -> path_counts
argsL$out -> path_out

###########################################################################################
#	#CHECKING AND FORMATTING THE INPUT
###########################################################################################

#Check the input
if(file.exists(eval(path_bam))==FALSE){stop("BAM file list not found.")}
if(file.exists(eval(path_geno))==FALSE){stop("Genotype file not found.")}
if(file.exists(eval(path_counts))==FALSE){stop("Depth file not found.")}
#Check the output directory
if(file.exists(dirname(eval(path_out)))==FALSE){stop("Output directory not found")}

#Reading in the BAM file list
parse_command <- paste("cat ", path_bam, " | rev | cut -f 1 -d '/' | rev", sep="", collapse="")
system(eval(parse_command), intern=T)->bam.list
sub("^([^.]*).*", "\\1", bam.list)->bam.list

#Reading the Geno file
read.csv(eval(path_geno), header=F, sep='\t')->geno
nrow(geno)->nsites
ncol(geno)-5->nind

#Reading the Counts file
read.csv(eval(path_counts), header=T, sep='\t')->counts
counts[,1:ncol(counts)-1]->counts
as.matrix(counts)->counts

#Measuring the list & checking
nbam<-length(bam.list)
if((nbam==nind)==F){stop("Genotype file does contain the right number of individuals")}

###########################################################################################
#	#DISPLAY RECAP
###########################################################################################

cat("\n\tWriting VCF file for ", nind," samples at ", nsites, " sites...", sep="", collapse="")

###########################################################################################
#	#INITIATE THE VCF FILE
###########################################################################################

line1<-'##fileformat=VCFv4.0'
line2<-paste('##fileDate=', gsub('-','',Sys.Date()), sep='', collapse='')
line3<-'##source="angsd2vcf.R"'
line4<-'##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">'
#line7<-'##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Read Depth">'
#line8<-'##FORMAT=<ID=GL,Number=.,Type=Float,Description="Genotype Likelihood">'
header_data <- rbind(line1, line2, line3, line4)
write.table(header_data, eval(path_out), sep='\t', append=F, quote=F, row.names=F, col.names=F)

###########################################################################################
#	#CONVERT AND WRITE THE DATA
###########################################################################################

vcf.header<-c('#CHROM','POS','ID','REF','ALT','QUAL','FILTER','INFO','FORMAT',bam.list)
emptycol<-numeric(nsites)

metadata<-cbind(geno[,1:2],emptycol,geno[,3:4],emptycol,emptycol,emptycol,emptycol)
data<-geno[,5:(nind+4)]
data[data==-1]<-'./.'
data[data==0]<-'0/0'
data[data==1]<-'0/1'
data[data==2]<-'1/1'
as.matrix(data)->data
paste(data, counts, sep=':')->data
matrix(data, ncol=nind)->data

#Fix the genotypes with null coverage:
data[data=='0/0:0']<-'./.:0'
data[data=='0/1:0']<-'./.:0'
data[data=='1/1:0']<-'./.:0'

vcf<-cbind(metadata, data)
names(vcf)<-vcf.header
vcf$ID <- '.'
vcf$QUAL<-30
vcf$FILTER <- '.'
vcf$INFO <- '.'
vcf$FORMAT<-'GT:DP'

write.table(vcf, eval(path_out), sep='\t', append=T, quote=F, row.names=F, col.names=T)

cat("done.\n\n")

quit('no')
