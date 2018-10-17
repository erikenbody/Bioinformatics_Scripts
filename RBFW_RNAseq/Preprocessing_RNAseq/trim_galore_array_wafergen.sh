#!/bin/bash
#SBATCH --qos=normal
#SBATCH --time=03:00:00
#SBATCH --verbose    ###        Verbosity logs error information into the error file
#SBATCH -J WSFW_trim_galore2
#SBATCH -N 20             ### Node count required for the job
#SBATCH -n 2   ### Number of tasks to be launched per Node
#SBATCH -o trimgalore_%A.out
#SBATCH -e trimgalore_%A.err

module load anaconda
source activate ede_py

trim_galore --paired --retain_unpaired --phred33 -a AAGATCGGAAGAGC  -a2 GATCGTCGGACTGTAGAA --output_dir wafer_trimmed_reads --fastqc --gzip --length 36 -q 5 --stringency 1 -e 0.1 ./fq/*S${SLURM_ARRAY_TASK_ID}.R1.cor.fq ./fq/*S${SLURM_ARRAY_TASK_ID}.R2.cor.fq
