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

WORK_D=/lustre/project/jk/Enbody_WD/WSFW_DDIG/reseq_WD/phylotree/IQ-TREE_phylip
cd $WORK_D

#iqtree -s Results/all.genomes.fasta -nt 20

#this made the file without invariant sites
#iqtree -s RAxML_input.phy -nt AUTO -m GTR+ASC -st DNA -bb 1000

#then ran this
iqtree -s RAxML_input.phy.varsites.phy -nt AUTO -m GTR+ASC -st DNA -bb 1000
