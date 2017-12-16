#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=20
#SBATCH -e aug_opt2.err           # File to which STDERR will be written
#SBATCH -o aug_opt2.out         # File to which STDOUT will be written
#SBATCH -J aug_opt       # Job name
#SBATCH --mem=128000                     # Memory requested
#SBATCH --qos=long
#SBATCH --time=7-00:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

module load anaconda
source activate ede_py

WORK_D=/home/eenbody/maker_mpich/train_augustus
cd $WORK_D

optimize_augustus.pl --species=wsfw WSFW.gb.train --cpus=20
