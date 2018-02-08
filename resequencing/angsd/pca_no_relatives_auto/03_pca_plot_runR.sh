#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e rPCA.err            # File to which STDERR will be written
#SBATCH -o rPCA.out           # File to which STDOUT will be written
#SBATCH -J rPCA           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=1
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to
#
module load R/3.4.1-intel
export R_LIBS_USER=/home/eenbody/BI_software/R/Library:$R_LIBS_USER

#installing package only required to do once
#R
#install.packages("optparse", repos="http://cran.r-project.org")
#q()

RUN=WSFW_F_NR_auto
RSCRIPTS=~/Bioinformatics_Scripts/resequencing/angsd
WORK_D=/home/eenbody/reseq_WD/angsd/angsd_pca_NR_auto
N_samp=32
cd $WORK_D

mkdir pca_figs

Rscript -e 'write.table(cbind(seq(1,32),c("11_33248","12_33249","13_33252","14_33253","15_33254","17_33257","10_33240","1_33221","2_33223","3_33225","4_33228","5_33230","6_33232","19_47720","20_36126","21_36148","22_36149","23_36182","24_36188","32_47707","33_47717","35_47815","18_33297","25_47617","26_47623","27_47631","28_47653","29_47657","30_47672","31_47683","36_97513","37_97528"),c("aida","aida","aida","aida","aida","aida","naimii","naimii","naimii","naimii","naimii","naimii","naimii","moretoni","moretoni","moretoni","moretoni","moretoni","moretoni","moretoni","moretoni","moretoni","lorentzi","lorentzi","lorentzi","lorentzi","lorentzi","lorentzi","lorentzi","lorentzi","lorentzi","lorentzi")), row.names=F, sep=" ", col.names=c("FID","IID","CLUSTER"), file="sample_annotations32.clst", quote=F)'

Rscript $RSCRIPTS/plotPCA_ed.R -i $WORK_D/${RUN}.covar -c 1-2 -a $WORK_D/sample_annotations${N_samp}.clst -o $WORK_D/pca_figs/${RUN}_c1-2.pca.pdf
Rscript $RSCRIPTS/plotPCA_ed.R -i $WORK_D/${RUN}.covar -c 3-4 -a $WORK_D/sample_annotations${N_samp}.clst -o $WORK_D/pca_figs/${RUN}_c3-4.pca.pdf
Rscript $RSCRIPTS/plotPCA_ed.R -i $WORK_D/${RUN}.covar -c 5-6 -a $WORK_D/sample_annotations${N_samp}.clst -o $WORK_D/pca_figs/${RUN}_c5-6.pca.pdf
Rscript $RSCRIPTS/plotPCA_ed.R -i $WORK_D/${RUN}.covar -c 7-8 -a $WORK_D/sample_annotations${N_samp}.clst -o $WORK_D/pca_figs/${RUN}_c7-8.pca.pdf
Rscript $RSCRIPTS/plotPCA_ed.R -i $WORK_D/${RUN}.covar -c 9-10 -a $WORK_D/sample_annotations${N_samp}.clst -o $WORK_D/pca_figs/${RUN}_c9-10.pca.pdf
Rscript $RSCRIPTS/plotPCA_ed.R -i $WORK_D/${RUN}.covar -c 11-12 -a $WORK_D/sample_annotations${N_samp}.clst -o $WORK_D/pca_figs/${RUN}_c11-12.pca.pdf
Rscript $RSCRIPTS/plotPCA_ed.R -i $WORK_D/${RUN}.covar -c 13-14 -a $WORK_D/sample_annotations${N_samp}.clst -o $WORK_D/pca_figs/${RUN}_c13-14.pca.pdf
Rscript $RSCRIPTS/plotPCA_ed.R -i $WORK_D/${RUN}.covar -c 15-16 -a $WORK_D/sample_annotations${N_samp}.clst -o $WORK_D/pca_figs/${RUN}_c15-16.pca.pdf
Rscript $RSCRIPTS/plotPCA_ed.R -i $WORK_D/${RUN}.covar -c 17-18 -a $WORK_D/sample_annotations${N_samp}.clst -o $WORK_D/pca_figs/${RUN}_c17-18.pca.pdf
Rscript $RSCRIPTS/plotPCA_ed.R -i $WORK_D/${RUN}.covar -c 19-20 -a $WORK_D/sample_annotations${N_samp}.clst -o $WORK_D/pca_figs/${RUN}_c19-20.pca.pdf
Rscript $RSCRIPTS/plotPCA_ed.R -i $WORK_D/${RUN}.covar -c 21-22 -a $WORK_D/sample_annotations${N_samp}.clst -o $WORK_D/pca_figs/${RUN}_c21-22.pca.pdf
