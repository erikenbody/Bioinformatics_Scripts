#!/bin/bash
#SBATCH -N 1
#SBATCH -n 20
#SBATCH -e mafft_align.err            # File to which STDERR will be written
#SBATCH -o mafft_align.out           # File to which STDOUT will be written
#SBATCH -J run_mito_il          # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal

cd ~/lustre/project/jk/Enbody_WD/WSFW_DDIG/reseq_WD/mtDna/MAFFT_align

#mafft --globalpair --thread 20 wsfw_mtdna_cat.fasta > wsfw_aln.fasta
mafft --globalpair --thread 20 wsfw_mtdna_cat_og.fasta > wsfw_aln_og.fasta
