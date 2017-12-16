#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e fastqc%A_%a.err            # File to which STDERR will be written
#SBATCH -o fastqc%A_%a.out           # File to which STDOUT will be written
#SBATCH -J fastqc             # Job name
#SBATCH --time=10:00:00              # Runtime in D-HH:MM:SS

WORK_D=/home/eenbody/Enbody_WD/WSFW_DDIG/reseq_WD/rs_lane_merge

cd $WORK_D

FILENAME=`ls -1 *fastq* | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`

fastqc --outdir ./fastqc $FILENAME
