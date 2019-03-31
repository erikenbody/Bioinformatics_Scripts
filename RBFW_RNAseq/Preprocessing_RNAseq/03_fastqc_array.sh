#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1                   # Number of cores
#SBATCH -t 0-23:00:00               # Runtime in days-hours:minutes
#SBATCH -J FastQC               # job name
#SBATCH -o FastQC.%A.out        # File to which standard out will be written
#SBATCH -e FastQC.%A.err        # File to which standard err will be written

cd /lustre/project/jk/Khalil_WD/RBFW_RNAseq/Preprocessing/Final_processed_fastq

FILENAME=`ls -1 *_clp* | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`

for FILENAME in `ls -1 *_clp*`
do
  fastqc --outdir ./fastqc $FILENAME
done
