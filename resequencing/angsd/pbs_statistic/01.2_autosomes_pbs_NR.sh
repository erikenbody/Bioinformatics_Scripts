#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e pbs1_%A.err            # File to which STDERR will be written
#SBATCH -o pbs1_%A.out           # File to which STDOUT will be written
#SBATCH -J pbs1           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load zlib/1.2.8
module load xz/5.2.2
module load R/3.4.1-intel
export R_LIBS_USER=/home/eenbody/BI_software/R/Library:$R_LIBS_USER

CHR=autosome
#aida_more_combined ; aid_more_combined_NR ; cov_40_300_20Q ; nocov_NR ; nocov_skiptri
EXT=nocov_NR
#all or NR
SUBSET=NR
DESCRIPTION=NR-MidFilt

HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/pbs_statistic
SAMPLEDIR=/home/eenbody/reseq_WD/angsd/fst_angsd/auto/$EXT
cd $WORK_D
mkdir $DESCRIPTION
cd $DESCRIPTION

#if [ -d "ManPlots" ]; then echo "ManPlot dir exists" ; else mkdir ManPlots; fi

#variables
POP1=aida
POP2=naimii
POP3=lorentzi
POP4=moretoni

WIN1=50000
WIN2=25000

#run with moretoni instead of aida, because it has more individuals

realSFS fst index $SAMPLEDIR/Results/${POP4}.${CHR}_scaffolds.ref.saf.idx $SAMPLEDIR/Results/${POP2}.${CHR}_scaffolds.ref.saf.idx $SAMPLEDIR/Results/${POP3}.${CHR}_scaffolds.ref.saf.idx -sfs $SAMPLEDIR/Results/${POP4}_${POP2}.sfs -sfs $SAMPLEDIR/Results/${POP4}_${POP3}.sfs -sfs $SAMPLEDIR/Results/${POP2}_${POP3}.sfs -fstout ${POP4}_${POP2}_${POP3}_${CHR}_${DESCRIPTION} -whichFST 0

realSFS fst stats2 ${POP4}_${POP2}_${POP3}_${CHR}_${DESCRIPTION}.fst.idx -win 50000 -step 25000 -whichFST 0 > ${POP4}_${POP2}_${POP3}_${CHR}_${DESCRIPTION}_50000-Win.fst.txt
