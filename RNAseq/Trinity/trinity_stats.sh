#!/bin/bash
#SBATCH -J concordstats
#SBATCH -N 1
#SBATCH -n 1 #Number of cores
#SBATCH -t 23:30:00  #Runtime in minutes
#SBATCH --mem=6000  #Memory per node in MB
#SBATCH -e trinity_stats.err            # File to which STDERR will be written
#SBATCH -o trinity_stats.out
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

module load samtools
module load bowtie2
module load trinity

SAM_nameSorted_to_uniq_count_stats.pl trinity_assembly_bowtie2.nameSorted.bam
