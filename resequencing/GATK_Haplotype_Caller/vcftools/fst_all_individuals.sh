#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=23:00:00
#SBATCH -e fstvcf.err            # File to which STDERR will be written
#SBATCH -o fstvcf.out           # File to which STDOUT will be written
#SBATCH -J fstvcf           # Job name
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --qos=normal
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load anaconda/2.5.0
module load zlib/1.2.8

source activate ede_py

WORK_D=/home/eenbody/reseq_WD/GATK_Haplotype_Caller/vcftools
VCF=/home/eenbody/reseq_WD/GATK_Haplotype_Caller/all_individuals/seperate_snps_indels/WSFW_filtered_snps.vcf

cd $WORK_D


POP1=aida
POP2=naimii
POP3=lorentzi
POP4=moretoni
CHR=autosomes
WINDOW=50000

vcftools --vcf $VCF --weir-fst-pop ${POP1}_bamlist.txt --weir-fst-pop ${POP2}_bamlist.txt --out fst_${POP1}_${POP2} --fst-window-size $WINDOW
