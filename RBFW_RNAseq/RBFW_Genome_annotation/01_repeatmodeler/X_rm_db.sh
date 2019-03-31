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
source activate ~/BI_software/conda_environments/ede_py2/

WORK_D=/home/eenbody/RBFW_RNAseq/Genome_annotation/repeatmodeler

cd $WORK_D

~/BI_software/RepeatModeler-open-1.0.10/BuildDatabase -name "RBFW.final.assembly" -engine ncbi RBFW.final.assembly.fasta

#this failed:
#Number of sequences (bp) added to database: 0 ( 0 bp )

#find . -type f -exec sed -i 's/oldstring/new string/g' {} \;
