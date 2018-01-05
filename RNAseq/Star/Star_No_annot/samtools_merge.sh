#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e sam_merge.err            # File to which STDERR will be written
#SBATCH -o sam_merge.out           # File to which STDOUT will be written
#SBATCH -J sam_merge              # Job name
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=23:00:00              # Runtime in D-HH:MM:SS

module load samtools/1.5

samtools merge WSFW_aligned_merged.bam *.bam*
