#!/bin/bash
#SBATCH --qos=normal
#SBATCH --time=03:00:00
#SBATCH --verbose    ###        Verbosity logs error information into the error file
#SBATCH -J WSFW_kmer_fix_array
#SBATCH -N 1             ### Node count required for the job
#SBATCH -n 20   ### Number of tasks to be launched per Node
#SBATCH -o rmunfix_%A.o
#SBATCH -e rmunfix_%A.e


module purge
module load python/2.7.11

python ~/Bioinformatics_Scripts/RNAseq/QC_RNAseq/FilterUncorrectabledPEfastq.py -1 ./fq/*S${SLURM_ARRAY_TASK_ID}.R1.cor.fq.gz -2 ./fq/*S${SLURM_ARRAY_TASK_ID}.R2.cor.fq.gz -o fixed 2>&1 > rmunfixable_${SLURM_ARRAY_TASK_ID}.out
