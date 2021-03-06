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
WORK_D=/home/eenbody/reseq_WD/angsd/folded_thetas
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
ANC=/home/eenbody/reseq_WD/phylotree/Results/rbfw_correct.fasta
RUN=autosome_scaffolds
REGIONS=$HOME_D/${RUN}.txt
SAMPLEDIR=/home/eenbody/reseq_WD/angsd/fst_angsd/auto/nocov_NR/

cd $WORK_D

for POP in aida moretoni naimii lorentzi
do
  thetaStat do_stat ${POP}.thetas.idx -win 50000 -step 10000  -outnames ${POP}_theta.thetasWindow.gz
  echo "done with $POP windows"
done
