#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e fix_readspergene.err            # File to which STDERR will be written
#SBATCH -o fix_readspergene.out           # File to which STDOUT will be written
#SBATCH -J fix_readspergene           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=10000
#SBATCH --time=0-1:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

WORK_D=/home/eenbody/RNAseq_WD/Star/Star_annot_gene_names/Results/ReadsPerGene
cd $WORK_D

for f in *.tab
do
  echo "Processing $f file..."
  # take action on each file. $f store current file name
  awk 'NR>4 {print $1 "\t" $3}' $f > DEseq.input/${f}.DEseq.input
done

awk 'NR>4 {print $1 "\t" $3}' 10-33254-aida-Chest_S10.ReadsPerGene.out.tab  > DEseq.input/10-33254-aida-Chest_S10.ReadsPerGene.out.tab.DEseq.input
