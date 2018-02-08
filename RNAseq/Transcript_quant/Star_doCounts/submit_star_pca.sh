#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e star_pca.err            # File to which STDERR will be written
#SBATCH -o star_pca.out           # File to which STDOUT will be written
#SBATCH -J star_pca           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=10000
#SBATCH --time=0-1:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load R/3.4.1-intel
export R_LIBS_USER=/home/eenbody/BI_software/R/Library:$R_LIBS_USER

# WORK_D=/home/eenbody/RNAseq_WD/Star/Star_annot/Results/PCA
# cd $WORK_D
#
# Rscript ~/Bioinformatics_Scripts/RNAseq/Transcript_quant/Star_doCounts/star_makepca.r -d "/home/eenbody/RNAseq_WD/Star/Star_annot/Results/ReadsPerGene" -o "rnaseq_all_individuals_pca.pdf"
###

WORK_D=/home/eenbody/RNAseq_WD/Star/Star_annot_gene_names/Results/PCA
cd $WORK_D

Rscript ~/Bioinformatics_Scripts/RNAseq/Transcript_quant/Star_doCounts/star_makepca.r -d "/home/eenbody/RNAseq_WD/Star/Star_annot_gene_names/Results/ReadsPerGene/DEseq.input" -o "rnaseq_all_individuals_pca_noheader.pdf"
