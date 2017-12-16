#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e sam_sort.err            # File to which STDERR will be written
#SBATCH -o sam_sort.out           # File to which STDOUT will be written
#SBATCH -J sam_sort              # Job name
#SBATCH --mem=256000
#SBATCH --time=23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --cpus-per-task=20
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load samtools/1.5

#samtools sort -m 64G -T star.align -@ 20 -o star_ref2_Aligned_sorted.bam star_ref2_Aligned.out.bam

#samtools sort -m 4G -T star.align -@ 20 -o star_ref2_Aligned_sorted.bam star_ref2_Aligned.out.bam

samtools sort -m 4G -T WSFW_align -@ 20 -o WSFW_aligned_merged_sort.bam WSFW_aligned_merged.bam
