#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=0-23:00:00
#SBATCH -e ./logs/vcftfiltCov3.err            # File to which STDERR will be written
#SBATCH -o ./logs/vcftfiltCov3.out           # File to which STDOUT will be written
#SBATCH -J vcffiltCov           # Job name
#SBATCH --mem=64000
#SBATCH --qos=normal
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load anaconda/2.5.0
module load zlib/1.2.8

source activate ede_py

SAMPLEDIR=/lustre/project/jk/Enbody_WD/WSFW_DDIG/reseq_WD/GATK_Haplotype_Caller/all_individuals/
REF=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
WORK_D=/lustre/project/jk/Enbody_WD/WSFW_DDIG/reseq_WD/GATK_Haplotype_Caller/all_individuals/

cd $WORK_D

if [ -d "filtered_vcfs" ]; then echo "info dir exists" ; else mkdir filtered_vcfs; fi
OUT=filtered_vcfs

#vcftools --vcf $OUT/All_WSFW_fil.vcf --min-meanDP 81.5 --max-meanDP 326.1 --min-alleles 2 --max-alleles 2 --maf 0.1 --max-missing 0.2 --remove-filtered badSeq --remove-filtered badStramd --remove-filtered badMap --recode --recode-INFO-all --stdout | gzip -c > $OUT/All_WSFW_passed_CovFil.vcf.gz
vcftools --vcf $OUT/All_WSFW_fil.vcf --min-meanDP 2.0 --max-meanDP 326.1 --min-alleles 2 --max-alleles 2 --maf 0.1 --max-missing 0.2 --remove-filtered badSeq --remove-filtered badStramd --remove-filtered badMap --recode --recode-INFO-all --stdout | gzip -c > $OUT/All_WSFW_passed_CovFil_2_320.vcf.gz
