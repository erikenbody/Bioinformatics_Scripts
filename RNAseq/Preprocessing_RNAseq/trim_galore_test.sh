#!/bin/bash
#SBATCH --qos=normal
#SBATCH --time=01:00:00
#SBATCH --verbose    ###        Verbosity logs error information into the error file
#SBATCH -J WSFW_trim_galore
#SBATCH -N 1             ### Node count required for the job
#SBATCH -n 1   ### Number of tasks to be launched per Node
#SBATCH -o trimgalore_%A.out
#SBATCH -e trimgalore_%A.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=eenbody@tulane.edu

module load anaconda
source activate ede_py

trim_galore --paired --retain_unpaired --phred33 --output_dir trimmed_reads --fastqc --gzip --length 36 -q 5 --stringency 1 -e 0.1 .fq/*S${SLURM_ARRAY_TASK_ID}.R1.cor.fq .fq/*S${SLURM_ARRAY_TASK_ID}.R2.cor.fq
