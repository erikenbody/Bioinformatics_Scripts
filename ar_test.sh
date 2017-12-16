#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e artest.err            # File to which STDERR will be written
#SBATCH -o artest.out           # File to which STDOUT will be written
#SBATCH -J artest              # Job name
#SBATCH --time=23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load star/2.5.2a

FILENAME=`ls -1 *clp.fq.1* | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
READ=$(echo $FILENAME | rev | cut -c 13- | rev)
NEWNAME=${READ:6}

echo $READ
