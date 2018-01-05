#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=0-23:00:00
#SBATCH -e sepsexchr.err            # File to which STDERR will be written
#SBATCH -o sepsexchr.out           # File to which STDOUT will be written
#SBATCH -J sepsexchr           # Job name
#SBATCH --mem=64000
#SBATCH --qos=normal
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to


module load zlib
module load xz

WORK_D=/home/eenbody/reseq_WD/GATK_Haplotype_Caller/all_individuals/filtered_vcfs
cd $WORK_D

if [ -d "zchr" ]; then echo "dir exists" ; else mkdir zchr; fi
if [ -d "autosomes" ]; then echo "dir exists" ; else mkdir autosomes; fi

#Ran these in idev
# gunzip All_WSFW_passed_CovFil_2_320.vcf.gz
# bgzip All_WSFW_passed_CovFil_2_320.vcf
# tabix All_WSFW_passed_CovFil_2_320.vcf.gz
# bcftools view -R z_scaffolds.bed -o zchr/Z_WSFW_passed_CovFil_2_320.vcf All_WSFW_passed_CovFil_2_320.vcf.gz
# bcftools view -R autosome_scaffolds.bed -o autosomes/autosomes_WSFW_passed_CovFil_2_320.vcf All_WSFW_passed_CovFil_2_320.vcf.gz
#
# gunzip All_WSFW_passed.vcf.gz
# bgzip All_WSFW_passed.vcf
# tabix All_WSFW_passed.vcf.gz
# bcftools view -R z_scaffolds.bed -o zchr/Z_WSFW_passed.vcf All_WSFW_passed.vcf.gz
# bcftools view -R autosome_scaffolds.bed -o autosomes/autosomes_WSFW_passed.vcf All_WSFW_passed.vcf.gz

bgzip All_WSFW_fil.vcf
tabix All_WSFW_fil.vcf.gz
bcftools view -R z_scaffolds.bed -o zchr/Z_WSFW_fil.vcf.gz -O z All_WSFW_fil.vcf.gz
bcftools view -R autosome_scaffolds.bed -o autosomes/autosomes_WSFW_fil.vcf.gz -O z All_WSFW_fil.vcf.gz
