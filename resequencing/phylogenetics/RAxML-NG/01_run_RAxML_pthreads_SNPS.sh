#!/bin/bash
#SBATCH -N 1
#SBATCH -n 20
#SBATCH -e run_RAxMLNG3.err            # File to which STDERR will be written
#SBATCH -o run_RAxMLNG3.out           # File to which STDOUT will be written
#SBATCH -J run_RAxMLNG           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=128000
#SBATCH --time=6-23:59:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load gcc/4.9.4

#raxml-ng --msa wsfw_concatenated.fasta --model GTR+G --threads 20 --prefix concat_fasta_pthreads_NOASC --bs-trees 100

cd /home/eenbody/reseq_WD/phylotree/RAxML-NG/snp_tree

raxml-ng --msa RAxML_input.phy.varsites.phy --all --model GTR+G+ASC_LEWIS --threads 20 --prefix RAxML_SNP_tree --bs-trees 100
