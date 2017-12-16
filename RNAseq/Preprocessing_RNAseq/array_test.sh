
#!/bin/bash

#SBATCH --qos=normal
#SBATCH -n 1 # one core
#SBATCH -N 1 # on one node
#SBATCH -t 0-2:00 # Running time of 2 hours
#SBATCH -o arraytest_%A_%a.out # Standard output
#SBATCH -e arraytest_%A_%a.err # Standard error

echo "SLURM_JOBID: " $SLURM_JOBID
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID
echo "SLURM_ARRAY_JOB_ID: " $SLURM_ARRAY_JOB_ID

arrayfile=`ls *.fq | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`

cp $arrayfile ./out/

${test8:6:9}.txt
