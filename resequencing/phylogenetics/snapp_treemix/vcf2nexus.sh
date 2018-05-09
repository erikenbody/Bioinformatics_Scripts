#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e vcf2nexus.err            # File to which STDERR will be written
#SBATCH -o vcf2nexus.out           # File to which STDOUT will be written
#SBATCH -J vcf2nexus           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normall
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

WORK_D=/home/eenbody/reseq_WD/phylotree/for_plink
cd $WORK_D

#just hangs - doesnt seem to work
perl ~/Bioinformatics_Scripts/resequencing/snapp_treemix/vcf2nex.pl tree_input.vcf tree_input.nex
