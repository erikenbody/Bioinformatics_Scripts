#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e angsd_pca_input.err            # File to which STDERR will be written
#SBATCH -o angsd_pca_input.out           # File to which STDOUT will be written
#SBATCH -J angsd_pca_input           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=6-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to
#
module load zlib/1.2.8
module load xz/5.2.2
load module git/2.4.1

#variables
HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/angsd_pca_NR_auto
BAMLIST=$HOME_D/allpops_bamlist_NR.txt
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
RUN=autosome_scaffolds
REGIONS=$HOME_D/${RUN}.txt
N_samp=32
RUN=WSFW_F_NR_auto

cd $WORK_D

angsd -bam $BAMLIST -ref $REFGENOME -rf $REGIONS -uniqueOnly 1 -P 20 \
-remove_bads 1 -trim 0 -minMapQ 20 -minQ 20 -minMaf 0.01 -only_proper_pairs 0 -minInd 16 \
-out $RUN -doCounts 1 -doMaf 1 -doMajorMinor 1 \
-GL 1 -skipTriallelic 1 -SNP_pval 1e-6 -doGeno 32 -doPost 1

#unzip for next step
gunzip *gz
