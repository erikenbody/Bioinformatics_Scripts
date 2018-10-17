#!/bin/bash
#SBATCH --qos=normal
#SBATCH --time=03:00:00
#SBATCH --verbose    ###        Verbosity logs error information into the error file
#SBATCH -J 1WSFW_test_bowtie2
#SBATCH -N 1             ### Node count required for the job
#SBATCH -n 1   ### Number of tasks to be launched per Node
#SBATCH --cpus-per-task=20      # Number of threads per task (OMP threads)
#SBATCG --men=24000
#SBATCH -o rmunfix_%A.o
#SBATCH -e rmunfix_%A.e
#SBATCH --mail-type=ALL
#SBATCH --mail-user=eenbody@tulane.edu

module load bowtie2

bowtie2 --very-sensitive-local --phred33 -x ../zefi_rRNA -1 ../fq/fixed_5-33253-aida-Chest_S5.R1.cor_val_1.fq.gz -2 ../fq/fixed_5-33253-aida-Chest_S5.R2.cor_val_2.fq.gz --threads 20 --norc --met-file 5_metadata.txt --al-conc-gz 5_mapped.fastq.gz --un-conc-gz 5_unmapped.fastq.gz --al-gz 5singlemapped.fastq.gz --un-gz 5singleunmapped.fastq.gz -S 5ut.sam
