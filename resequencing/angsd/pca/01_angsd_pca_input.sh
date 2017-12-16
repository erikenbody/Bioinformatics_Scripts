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

module load zlib/1.2.8
module load xz/5.2.2
load module git/2.4.1

#variables
WORK_D=/home/eenbody/reseq_WD/angsd/angsd_pca
BAMLIST=$WORK_D/bam_list.txt
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
N_samp=37
RUN=WSFW_F_angsd1

BAMDIR=/home/eenbody/reseq_WD/Preprocessing_fixed/04_indel_realign/merged_realigned_bams
cd $BAMDIR
ls -d -1 $PWD/*.bam* >> bam_list.txt
cp bam_list.txt $WORK_D
cd $WORK_D

angsd -bam $BAMLIST -ref $REFGENOME -uniqueOnly 1 -P 20 \
-remove_bads 1 -trim 0 -minMapQ 20 -minQ 20 -only_proper_pairs 0 \
-nThreads 12 -out $WORK_D/WSFW_F_angsd1 -doCounts 1 -doMaf 1 -doMajorMinor 1 \
-GL 1 -skipTriallelic 1 -SNP_pval 1e-6 -doGeno 32 -doPost 1

#unzip for next step
gunzip *gz
