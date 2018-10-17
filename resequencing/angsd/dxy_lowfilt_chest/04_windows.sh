#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e dxy_window.err            # File to which STDERR will be written
#SBATCH -o dxy_window.out           # File to which STDOUT will be written
#SBATCH -J dxy_window          # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=10000
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to
#

module load R/3.4.1-intel
export R_LIBS_USER=/home/eenbody/BI_software/R/Library:$R_LIBS_USER
