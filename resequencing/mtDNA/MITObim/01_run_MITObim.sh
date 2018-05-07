#!/bin/bash
#SBATCH -N 1
#SBATCH -n 20
#SBATCH -e run_mito.err            # File to which STDERR will be written
#SBATCH -o run_mito.out           # File to which STDOUT will be written
#SBATCH -J run_mito           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=128000
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to


MITObim.pl -start 1 -end 30 -sample sample10 -ref --clean yes rbfw -readpool 10_33240_naimii_CTGAAA.R1.fastq.gz --quick rbfw_mtdna_genome.fasta

MITObim.pl -start 1 -end 30 -sample sample11 -ref --clean yes rbfw -readpool 11_33248_aida_CTGGCC.R1.fastq.gz --quick rbfw_mtdna_genome.fasta
