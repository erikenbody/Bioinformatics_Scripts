#!/bin/bash
# PCA for autosome. WSFW samples n=21

#SBATCH -p general
#SBATCH -n 12
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 50:00:00
#SBATCH -J angsd_pca
#SBATCH -o angsd_pca_%j.out
#SBATCH -e angsd_pca_%j.err
#SBATCH --mail-type=ALL        # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=yungwasin@fas.harvard.edu # Email to which notifications will be sent

# VARS:

BAMLIST=/n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/WSFW_21.bamlist
REFGENOME=/n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/WSFW_genome.fasta
#SITES=Code/E_cyan_snps_rm_zchrom_20170624.bed
N_samp=21
RUN=autosome_scafs_1e5_forANGSD
REGIONS=/n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/${RUN}.txt

#Use ANGSD 9.12
source new-modules.sh
module load gcc/4.8.2-fasrc01 ngsTools/20170201-fasrc01

#angsd sites index Code/E_cyan_snps_rm_zchrom_20170624.bed

# run angsd to do: (variant calling and estimate genotype LHs?) this will be faster if limit to the chroms used, using -rf option. [Remove this: -sites $SITES]
angsd -bam $BAMLIST -ref $REFGENOME -uniqueOnly 1 \
-remove_bads 1 -trim 0 -minMapQ 20 -minQ 20 -only_proper_pairs 0 -rf $REGIONS \
-nThreads 12 -out $WORK_D/${RUN} -doCounts 1 -doMaf 1 -doMajorMinor 1 \
-GL 1 -skipTriallelic 1 -SNP_pval 1e-6 -doGeno 32 -doPost 1

gunzip /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}.geno.gz
gunzip /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}.mafs.gz

N_SITES=`cat /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}.mafs | tail -n+2 | wc -l`
echo $N_SITES

###### run ngsTools
#Have to reload ngsTools
source new-modules.sh
module load ngsTools/0.615-fasrc01
ngsCovar -probfile /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}.geno -outfile /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}.covar \
-nind 21 -minmaf 0.05 -nsites $N_SITES

# be sure to change -nind !

###### PLOT PCA:
# set  environment
#NGSTOOLS=/n/sw/fasrcsw/apps/Core/ngsTools/0.615-fasrc01
#source new-modules.sh
#module load R/3.3.1-fasrc01

#Create a directory for your R package installs
mkdir -pv ~/apps/R
export R_LIBS_USER=$HOME/apps/R:$R_LIBS_USER
source new-modules.sh
module load R/3.3.3-fasrc01
export R_LIBS_USER=$HOME/apps/R:$R_LIBS_USER
R
install.packages("optparse", repos="http://cran.r-project.org")
q()

# for 21 samples
Rscript -e 'write.table(cbind(seq(1,21),c("WSFW_62_111595","WSFW_63_36001","WSFW_64_36014","WSFW_65_36016","WSFW_66_36040","WSFW_67_36047","WSFW_68_36053","WSFW_69_36093","WSFW_70_36099","WSFW_71_36112","19_47720_moretoni","20_36126_moretoni","21_36148_moretoni","22_36149_moretoni","23_36182_moretoni","24_36188_moretoni","32_47707_moretoni","33_47717_moretoni","34_47745_moretoni","35_47815_moretoni","WSFW_220bp"),c("M","M","M","M","M","M","M","M","M","M","F","F","F","F","F","F","F","F","F","F","M")), row.names=F, sep=" ", col.names=c("FID","IID","CLUSTER"), file="/n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/sample_annotations21.clst", quote=F)'

# now call the script to run PCA and print plot:
#Rscript $NGSTOOLS/scripts/plotPCA.R -i /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}.covar -c 1-2 -a /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/sample_annotations${N_samp}.clst -o /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}_c1-2.pca.pdf
Rscript /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/plotPCA_ed.R -i /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}.covar -c 1-2 -a /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/sample_annotations${N_samp}.clst -o /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}_c1-2.pca.pdf
Rscript /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/plotPCA_ed.R -i /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}.covar -c 3-4 -a /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/sample_annotations${N_samp}.clst -o /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}_c3-4.pca.pdf
Rscript /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/plotPCA_ed.R -i /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}.covar -c 5-6 -a /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/sample_annotations${N_samp}.clst -o /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}_c5-6.pca.pdf
Rscript /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/plotPCA_ed.R -i /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}.covar -c 7-8 -a /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/sample_annotations${N_samp}.clst -o /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}_c7-8.pca.pdf
Rscript /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/plotPCA_ed.R -i /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}.covar -c 9-10 -a /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/sample_annotations${N_samp}.clst -o /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}_c9-10.pca.pdf
Rscript /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/plotPCA_ed.R -i /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}.covar -c 11-12 -a /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/sample_annotations${N_samp}.clst -o /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}_c11-12.pca.pdf
Rscript /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/plotPCA_ed.R -i /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}.covar -c 13-14 -a /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/sample_annotations${N_samp}.clst -o /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}_c13-14.pca.pdf
Rscript /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/plotPCA_ed.R -i /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}.covar -c 15-16 -a /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/sample_annotations${N_samp}.clst -o /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}_c15-16.pca.pdf
Rscript /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/plotPCA_ed.R -i /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}.covar -c 17-18 -a /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/sample_annotations${N_samp}.clst -o /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}_c17-18.pca.pdf
Rscript /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/plotPCA_ed.R -i /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}.covar -c 19-20 -a /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/sample_annotations${N_samp}.clst -o /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}_c19-20.pca.pdf
Rscript /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/plotPCA_ed.R -i /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}.covar -c 21-21 -a /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/sample_annotations${N_samp}.clst -o /n/regal/edwards_lab/petrel/fairywren_reseq/WSFW/ANGSD_PCA/PCA/${RUN}_c21-21.pca.pdf
