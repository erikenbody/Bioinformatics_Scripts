#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e plink2treemix.err            # File to which STDERR will be written
#SBATCH -o plink2treemix.out           # File to which STDOUT will be written
#SBATCH -J plink2treemix           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load python/2.7.11

python ~/Bioinformatics_Scripts/resequencing/snapp_treemix/plink2treemix.py wsfw_plink_rf.frq.strat.gz treemix.frq.gz
