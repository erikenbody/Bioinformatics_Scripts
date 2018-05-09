#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e plink.err            # File to which STDERR will be written
#SBATCH -o plink.out           # File to which STDOUT will be written
#SBATCH -J plink           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to
#

WORK_D=/home/eenbody/reseq_WD/angsd/fst_angsd
cd $WORK_D

~/BI_software/plink-1.9/plink --allow-extra-chr --distance-matrix -vcf ./angsdput.vcf --out plinktest
