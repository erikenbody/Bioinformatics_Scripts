#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=0-23:00:00
#SBATCH -e ./logs/vcftfiltCov_2_9.err            # File to which STDERR will be written
#SBATCH -o ./logs/vcftfiltCov_2_9.out           # File to which STDOUT will be written
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

#run with per sample depth
vcftools --gzvcf $OUT/All_WSFW_passed.vcf.gz --min-meanDP 2.26 --max-meanDP 9.04 --recode --recode-INFO-all --stdout | gzip -c > $OUT/All_WSFW_passed_CovFil_2.26_9.04.vcf.gz
