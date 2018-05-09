#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e iqtree.err            # File to which STDERR will be written
#SBATCH -o iqtree.out           # File to which STDOUT will be written
#SBATCH -J iqtree           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

WORK_D=/home/eenbody/reseq_WD/phylotree/Results/iqtree_run_fixed
cd $WORK_D

#iqtree -s Results/all.genomes.fasta -nt 20
iqtree -s wsfw_conc2.fasta -o melanocephalus -nt 20 -t PARS
