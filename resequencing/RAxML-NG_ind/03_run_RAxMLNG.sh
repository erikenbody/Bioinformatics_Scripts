#!/bin/bash
#SBATCH -N 1
#SBATCH -n 20
#SBATCH -e run_RAxMLNG.err            # File to which STDERR will be written
#SBATCH -o run_RAxMLNG.out           # File to which STDOUT will be written
#SBATCH -J run_RAxMLNG           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=128000
#SBATCH --time=6-23:59:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

WORK_D=/home/eenbody/reseq_WD/phylotree/RAxML-NG_ind
cd $WORK_D

raxml-ng --msa wsfw_phylo_input_16ind.fasta --all --model GTR+G --threads 20 --prefix wsfw_fasta_input_16ind --bs-trees 100
