#!/bin/bash
#SBATCH -N 1
#SBATCH -n 20
#SBATCH -e run_RAxMLNGmt.err            # File to which STDERR will be written
#SBATCH -o run_RAxMLNGmt.out           # File to which STDOUT will be written
#SBATCH -J run_RAxMLNG           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=128000
#SBATCH --time=6-23:59:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load gcc/4.9.4

#raxml-ng --msa wsfw_concatenated.fasta --model GTR+G --threads 20 --prefix concat_fasta_pthreads_NOASC --bs-trees 100

cd /home/eenbody/reseq_WD/mtDna/RAxML-ng_mtDNA

#only one thread needed
#raxml-ng --msa wsfw_filtered_heavy_edit.phy --all --model GTR+G -prefix RAxML_mtDNA_tree --bs-trees 100
raxml-ng --msa wsfw_og_filtered_heavy_edit_nogaps.phy --all --threads 1 --model GTR+G -prefix RAxML_mtDNA_tree_og_nogap --bs-trees 100
