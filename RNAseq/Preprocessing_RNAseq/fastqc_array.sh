#!/bin/bash
#SBATCH -N 10
#SBATCH -n 1                   # Number of cores
#SBATCH -t 0-3:00               # Runtime in days-hours:minutes
#SBATCH -J FastQC               # job name
#SBATCH -o FastQC.%A.out        # File to which standard out will be written
#SBATCH -e FastQC.%A.err        # File to which standard err will be written


#fastqc --outdir . ~/merged/*S${SLURM_ARRAY_TASK_ID}.R*.fastq.gz
#FILENAME=`ls -1 *val_1.fq.gz | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
FILENAME=`ls -1 *_clp* | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`

fastqc --outdir ./fastqc $FILENAME
