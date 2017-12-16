#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e rm_db.err            # File to which STDERR will be written
#SBATCH -o rm_db.out           # File to which STDOUT will be written
#SBATCH -J rm_db           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load anaconda
source activate ede_py

WORK_D=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/Annotation
REF=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW

cd $WORK_D

ln -s $REF/WSFW_ref_final_assembly.fasta .

BuildDatabase -name WSFW_ref_final_assembly_db -engine ncbi WSFW_ref_final_assembly.fasta
