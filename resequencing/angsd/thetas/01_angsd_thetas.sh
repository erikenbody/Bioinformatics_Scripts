#!/bin/bash
#SBATCH -N 1
#SBATCH -n 20
#SBATCH -e thetas_%j.err            # File to which STDERR will be written
#SBATCH -o thetas_%j.out           # File to which STDOUT will be written
#SBATCH -J thetas           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=128000
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
WORK_D=/home/eenbody/reseq_WD/angsd/thetas
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
ANC=/home/eenbody/reseq_WD/phylotree/Results/rbfw_correct.fasta
RUN=autosome_scaffolds
REGIONS=$HOME_D/${RUN}.txt
SAMPLEDIR=/home/eenbody/reseq_WD/angsd/fst_angsd/auto/nocov_NR/

#I had maybe deleted these .sfs files within pop so need to recreate. Already ran aida in idev
#cd $SAMPLEDIR
#for POP in naimii lorentzi moretoni
#do
#  realSFS Results/${POP}.${RUN}.ref.saf.idx -P 20 > Results/${POP}.${RUN}.ref.sfs
#  echo "done with $POP sfs"
#done

cd $WORK_D

#now generate thetas
for POP in naimii lorentzi
do
  BAMLIST=$HOME_D/${POP}_bamlist_NR.txt
  angsd -bam $BAMLIST -rf $REGIONS -doSaf 1 -doMajorMinor 1 -doMaf 1 \
  -anc $ANC -GL 1 -P 20 -doThetas 1 -pest $SAMPLEDIR/Results/${POP}.${RUN}.ref.sfs \
  -out $POP
  thetaStat print ${POP}.thetas.idx > ${POP}_Theta_persite
  thetaStat do_stat ${POP}.thetas.idx
  echo "done with $POP thetas"
done
