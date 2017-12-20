#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=0-23:00:00
#SBATCH -e ./logs/filtsum.err            # File to which STDERR will be written
#SBATCH -o ./logs/filtsum.out           # File to which STDOUT will be written
#SBATCH -J filtsum           # Job name
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --qos=normal
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load anaconda/2.5.0
module load zlib/1.2.8

source activate ede_py

#SAMPLEDIR=/lustre/project/jk/Enbody_WD/WSFW_DDIG/reseq_WD/GATK_Haplotype_Caller/all_individuals/seperate_snps_indels
SAMPLEDIR=/lustre/project/jk/Enbody_WD/WSFW_DDIG/reseq_WD/GATK_Haplotype_Caller/all_individuals/
REF=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
#WORK_D=/lustre/project/jk/Enbody_WD/WSFW_DDIG/reseq_WD/GATK_Haplotype_Caller/all_individuals/seperate_snps_indels
WORK_D=/lustre/project/jk/Enbody_WD/WSFW_DDIG/reseq_WD/GATK_Haplotype_Caller/all_individuals/

cd $WORK_D

if [ -d "filtered_vcfs" ]; then echo "info dir exists" ; else mkdir filtered_vcfs; fi

OUT=filtered_vcfs

#vcftools --vcf $OUT/All_WSFW_fil.vcf --FILTER-summary --out $OUT/WSFW_AllFilters
vcftools --vcf $OUT/All_WSFW_passed_fil_NoCov.vcf --FILTER-summary --out $OUT/WSFW_NoCov
