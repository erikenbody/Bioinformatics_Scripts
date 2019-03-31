#!/bin/bash -l
#SBATCH -A snic2018-8-57
#SBATCH -p core -n 15
#SBATCH -M snowy
#SBATCH -t 24:00:00
#SBATCH -J repeatmod
#SBATCH -e repeatmod_A%.err            # File to which STDERR will be written
#SBATCH -o repeatmod_A%.out
#SBATCH --mail-type=all
#SBATCH --mail-user=erik.enbody@gmail.com

module load bioinfo-tools RepeatModeler/1.0.8_RM4.0.7

WORK_D=/home/eenbody/ruff/test_repeatmodeler
REF=genome.fasta

cd $WORK_D

#BuildDatabase -name "genome" -engine ncbi $REF
RepeatModeler -engine ncbi -pa 15 -database genome >& genome.out
