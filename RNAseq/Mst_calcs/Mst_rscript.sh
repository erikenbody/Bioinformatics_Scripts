#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e mst.err            # File to which STDERR will be written
#SBATCH -o mst.out           # File to which STDOUT will be written
#SBATCH -J mst           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load R/3.4.1-intel
export R_LIBS_USER=/home/eenbody/BI_software/R/Library:$R_LIBS_USER

cd /home/eenbody/RNAseq_WD/Mst_Calcs

Rscript DirectionalSelection_MST_FST.R
