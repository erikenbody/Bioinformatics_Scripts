#!/bin/bash
#SBATCH --qos=normal
#SBATCH --time=03:00:00
#SBATCH --verbose    ###        Verbosity logs error information into the error file
#SBATCH -J WSFW_kmer_fix
#SBATCH -N 1             ### Node count required for the job
#SBATCH -n 1   ### Number of tasks to be launched per Node
#SBATCH -o rmunfix_%A.o
#SBATCH -e rmunfix_%A.e
#SBATCH --mail-type=ALL
#SBATCH --mail-user=eenbody@tulane.edu

r1=`basename $1`
r2=`basename $2`

module purge
module load python/2.7.11

python ~/Bioinformatics_Scripts/RNAseq/QC_RNAseq/FilterUncorrectabledPEfastq.py -1 $1 -2 $2 -o fixed 2>&1 > rmunfixable_$r1.out
