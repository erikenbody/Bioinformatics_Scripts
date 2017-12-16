#!/bin/bash

#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e genemark.err            # File to which STDERR will be written
#SBATCH -o genemark.out           # File to which STDOUT will be written
#SBATCH -J genemark             # Job name
#SBATCH --mem=64000
#SBATCH --qos=long
#SBATCH --time=6-21:00:00       # Runtime in D-HH:MM:SS
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

#module load anaconda
#source activate ede_py
#for some reason having trouble with YAML which I installed with conda
#found tip here (comments): https://alvinalexander.com/perl/edu/articles/pl010015/
#export PERL5LIB=/home/eenbody/.conda/envs/ede_py/lib/perl5/site_perl/5.22.0

WORK_D=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/Annotation/genemark
cd $WORK_D

perl /home/eenbody/BI_software/gm_et_linux_64/gmes_petap/gmes_petap.pl --ES --sequence ../WSFW_ref_noIUB.fasta
