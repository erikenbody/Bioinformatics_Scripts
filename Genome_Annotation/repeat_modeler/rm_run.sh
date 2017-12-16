#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --qos=long
#SBATCH --time=6-21:00:00
#SBATCH -e rm_run.err            # File to which STDERR will be written
#SBATCH -o rm_run.out           # File to which STDOUT will be written
#SBATCH -J rm_run          # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load anaconda
source activate ede_py

WORK_D=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/Annotation

cd $WORK_D

RepeatModeler -engine ncbi -pa 20 -recoverDir RM_118443.MonOct231717042017 -database WSFW_ref_noIUB_db >& WSFW_repeat.out
