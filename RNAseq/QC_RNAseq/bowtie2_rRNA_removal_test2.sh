#!/bin/bash
#SBATCH --qos=normal
#SBATCH --time=03:00:00
#SBATCH --verbose    ###        Verbosity logs error information into the error file
#SBATCH -J 2WSFW_test_bowtie2
#SBATCH -N 1             ### Node count required for the job
#SBATCH -n 1   ### Number of tasks to be launched per Node
#SBATCH --mem=24000
#SBATCH -o rmunfix_%A.o
#SBATCH -e rmunfix_%A.e
#SBATCH --mail-type=ALL
#SBATCH --mail-user=eenbody@tulane.edu

module load bowtie2

bowtie2 --very-sensitive-local --phred33 -x ../zefi_rRNA -1 ../fq/fixed_41-47745-moretoni-SP_S40.R1.cor_val_1.fq.gz -2 ../fq/fixed_41-47745-moretoni-SP_S40.R2.cor_val_2.fq.gz --threads 1 --norc --met-file 41_metadata.txt --al-conc-gz 41_mapped.fastq.gz --un-conc-gz 41_unmapped.fastq.gz --al-gz 41singlemapped.fastq.gz --un-gz 41singleunmapped.fastq.gz -S 41out.sam
