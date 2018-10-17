suppressMessages(library(optparse))
library(data.table);library(plyr);library(magrittr);library(zoo);library(dplyr)

option_list <- list(make_option(c('-t','--theta_file'), action='store', type='character', default=NULL, help='Input theta file')
)
opt <- parse_args(OptionParser(option_list = option_list))


theta <- fread(opt$theta_file)[,-1]
theta$contig <- as.factor(theta$contig)

pi_win <- list()
snp_win <- list()
contig_win <- list()
for(i in levels(theta$contig)){
  temp <- subset(theta, contig==i)
  len <- max(temp$position)
  win <- 50000 # change window length if needed
  step <- 50000 # change step length if needed
  start <- seq(min(temp$position), max(temp$position), step)
  end <- start+win-1
  for(x in 1:length(start)) {
    ipos <- which(temp$position>=start[x] & temp$position<=end[x])
    val <- sum(temp$pairwise[ipos])/length(ipos)
    pi_win[[length(pi_win)+1]] <- val
    snp_win[[length(snp_win)+1]] <- length(ipos)
    contig_win[[length(contig_win)+1]] <- i
  }
}

pi_df <- as.data.frame(cbind(unlist(pi_win), unlist(snp_win), unlist(contig_win)))
colnames(pi_df) <- c("value", "snps", "scaffold")
pi_df$value <- as.numeric(as.character(pi_df$value))
pi_df$row <- 1:nrow(pi_df)
pi_df$stat <- rep("pi", nrow(pi_df))
pi_df$rollmean <- rollmean(pi_df$value, 50, na.pad = TRUE)
pi_df$outlier <- pi_df$value <= quantile(pi_df$value,0.005, na.rm = TRUE)
