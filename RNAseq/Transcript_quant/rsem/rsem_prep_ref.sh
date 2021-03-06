#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e rsem_ref.err            # File to which STDERR will be written
#SBATCH -o rsem_ref.out           # File to which STDOUT will be written
#SBATCH -J rsem_ref            # Job name
#SBATCH --time=23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load rsem/1.2.31
module load bowtie2/2.3.3

rsem-prepare-reference --transcript-to-gene-map Trinity_map.txt --bowtie2 Trinity.fasta  transcripts
