#!/bin/bash -l
#SBATCH -A snic2018-8-57
#SBATCH -p node -n 20
#SBATCH -t 6-23:00:00
#SBATCH -J augustus1
#SBATCH -e augustus1_%A.err            # File to which STDERR will be written
#SBATCH -o augustus1_%A.out
#SBATCH --mail-type=all
#SBATCH --mail-user=erik.enbody@gmail.com


module load bioinfo-tools maker/3.01.2-beta


cd /home/eenbody/ruff/Genome_annotation/01_maker_evi_based_partial_sat/train_augustus

optimize_augustus.pl --species=sat sat.gb.train --cpus=20
