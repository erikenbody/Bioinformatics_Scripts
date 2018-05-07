#!/bin/bash
#SBATCH -N 1
#SBATCH -n 20
#SBATCH -e run_norgal3.err            # File to which STDERR will be written
#SBATCH -o run_norgal3.out           # File to which STDOUT will be written
#SBATCH -J run_norgal           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=128000
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load anaconda3/5.1.0
export PATH=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre
module load gcc/4.9.4

python norgal.py -i 10_33240_naimii_CTGAAA.R1.fastq 10_33240_naimii_CTGAAA.R2.fastq -o 10_33240_naimii_CTGAAA --blast -t 20
