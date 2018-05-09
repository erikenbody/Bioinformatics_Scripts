#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e vcf2snapp.err            # File to which STDERR will be written
#SBATCH -o vcf2snapp.out           # File to which STDOUT will be written
#SBATCH -J vcf2snapp           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=128000
#SBATCH --time=6-23:59:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

cd /lustre/project/jk/Enbody_WD/WSFW_DDIG/reseq_WD/phylotree/setup_snapp

module load python/2.7.11

#python ~/Bioinformatics_Scripts/resequencing/setup_snapp/vcf2snapp.py -in RAxML_input.vcf
python ~/Bioinformatics_Scripts/resequencing/setup_snapp/vcf2snapp.py -in All_WSFW_passed_CovFil_2.26_9.04.vcf
