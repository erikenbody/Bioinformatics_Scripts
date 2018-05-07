#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e fq_prep.err            # File to which STDERR will be written
#SBATCH -o fq_prep.out           # File to which STDOUT will be written
#SBATCH -J fq_prep           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to


for filename in /home/eenbody/Enbody_WD/WSFW_DDIG/Raw_WSFW_WGS_name_fixed/merged_fastq/*.fastq.gz; do
  zcat $filename > ${filename}.fastq
done
