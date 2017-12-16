#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e satsuma2.err            # File to which STDERR will be written
#SBATCH -o satsuma2.out           # File to which STDOUT will be written
#SBATCH -J satsuma          # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=6-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

#originally ran Satsuma, but realized it would take forever. SatsumaSynteny seems to be just as sensitive and runs in a fraction of the time.
#also forgot to set -n, so if you want to run Satsuma (normal), will run faster if set -n 20

WORK_D=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/satsuma_chr_map
cd $WORK_D

~/BI_software/satsuma-code/SatsumaSynteny -n 19 -q WSFW_ref_final_assembly.fasta -t zefi_zchr.fasta -o zchr_out_battleship
