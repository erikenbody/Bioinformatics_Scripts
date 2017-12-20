#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=23:00:00
#SBATCH -e plotqc_snp.err            # File to which STDERR will be written
#SBATCH -o plotqc_snp.out        # File to which STDOUT will be written
#SBATCH -J plotqc_snp           # Job name
#SBATCH --mem=64000
#SBATCH --qos=normal
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load R/3.4.1-intel
export R_LIBS_USER=/home/eenbody/BI_software/R/Library:$R_LIBS_USER

WORK_D=/home/eenbody/reseq_WD/GATK_Haplotype_Caller/all_individuals/seperate_snps_indels

cd $WORK_D

if [ -d "qual_info_snps/_QC_plots" ]; then echo "info dir exists" ; else mkdir qual_info_snps/_QC_plots; fi

for SITE in QD MQ FS SOR MQRS RPRS
do
  echo $SITE
  Rscript ~/Bioinformatics_Scripts/resequencing/GATK_Haplotype_Caller/all_individuals/plot_QC_dists.R snps_WSFW qual_info_snps/fake_exclude.txt qual_info_snps/_QC_plots qual_info_snps $SITE
done
