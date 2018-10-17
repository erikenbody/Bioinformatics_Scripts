#!/bin/bash
#SBATCH -N 1
#SBATCH -n 20
#SBATCH -e angsds4dxy_%j.err            # File to which STDERR will be written
#SBATCH -o angsds4dxy_%j.out           # File to which STDOUT will be written
#SBATCH -J angsds4dxy           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --time=6-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to
#
module load zlib/1.2.8
module load xz/5.2.2
#
##
#variables
HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/dxy_lowfilt/outlier_scaff_chest
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
ANC=/home/eenbody/reseq_WD/phylotree/Results/rbfw_correct.fasta
RUN=autosome_scaffolds
#REGIONS=$HOME_D/${RUN}.txt
N_samp=32

cd $WORK_D

COMP=$1
REGIONS=$2

#July 3 I removed snp_pval 1e-3 and skiptri & GL?

angsd -bam $WORK_D/${COMP}_bamlist_NR.txt -ref $REFGENOME -anc $REFGENOME -rf $REGIONS -uniqueOnly 1 -P 20 \
-remove_bads 1 -trim 0 -minMapQ 20 -minQ 20 -only_proper_pairs 0 \
-out $COMP -doCounts 1 -doMaf 2 -doMajorMinor 4 -GL 1

gunzip -c ${COMP}.mafs.gz > ${COMP}.mafs
sed '1d' ${COMP}.mafs > ${COMP}_NH.mafs
cut -f 1-4 ${COMP}_NH.mafs > ${COMP}_NH_cut.mafs
angsd sites index ${COMP}_NH_cut.mafs
