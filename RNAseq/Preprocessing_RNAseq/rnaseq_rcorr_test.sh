#!/bin/bash
#SBATCH --qos=normal
#SBATCH --time=01:00:00
#SBATCH --verbose    ###        Verbosity logs error information into the error file
#SBATCH -J WSFW_rcorr_array
#SBATCH -N 1             ### Node count required for the job
#SBATCH -n 20   ### Number of tasks to be launched per Node
#SBATCH -o rcorr.out
#SBATCH -e rcorr.error.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=eenbody@tulane.edu

#mkdir w$SLURM_JOBID
#cd w$SLURM_JOBID


#FILENAME=${FILES[$SLURM_ARRAY_TASK_ID]}

#perl /home/eenbody/Enbody_WD/BI_software/rcorrector/run_rcorrector.pl -t 12 -1 $FILES.R1.fastq.gz${SLURM_ARRAY_TASK_ID} -2 $FILES.R2.fastq.gz${SLURM_ARRAY_TASK_ID}
#perl /home/eenbody/Enbody_WD/BI_software/rcorrector/run_rcorrector.pl -t 12 -1 ./fq/"$FILENAME".R1.fastq.gz -2 ./fq/"$FILENAME".R2.fastq.gz
#this wokred for 11-38

perl /home/eenbody/Enbody_WD/BI_software/rcorrector/run_rcorrector.pl -t 12 -1 ./fq/*S${SLURM_ARRAY_TASK_ID}.R1.fastq.gz -2 ./fq/*S${SLURM_ARRAY_TASK_ID}.R2.fastq.gz
