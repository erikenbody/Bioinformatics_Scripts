#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e angsd_fst.err            # File to which STDERR will be written
#SBATCH -o angsd_fst.out           # File to which STDOUT will be written
#SBATCH -J angsd_fst          # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

#this will be submitted as an array for all pops in pop.list.text

module load zlib/1.2.8
module load xz/5.2.2

HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/fst_angsd/zchr/cov_40_400_20Q/

cd $WORK_D

$ANGSD/misc/realSFS fst index Results/moretoni.zchr_scaffolds.ref.saf.idx Results/lorentzi.zchr_scaffolds.ref.saf.idx Results/naimii.zchr_scaffolds.ref.saf.idx Results/aida.zchr_scaffolds.ref.saf.idx -sfs Results/moretoni.zchr_scaffolds.ref.sfs -sfs Results/lorentzi.zchr_scaffolds.ref.sfs -sfs Results/naimii.zchr_scaffolds.ref.sfs -sfs Results/aida.zchr_scaffolds.ref.sfs -fstout Results/WSFW.pbs -whichFST
