#!/bin/bash
#SBATCH --qos=normal
#SBATCH --time=03:00:00
#SBATCH --verbose    ###        Verbosity logs error information into the error file
#SBATCH -J 3WSFW_test_bowtie2
#SBATCH -N 1             ### Node count required for the job
#SBATCH -n 1   ### Number of tasks to be launched per Node
#SBATCH -o rRNA_%A_%a.out # Standard output
#SBATCH -e rRNA_%A_%a.err # Standard error
#SBATCH --mem=24000
#SBATCH --mail-type=ALL
#SBATCH --mail-user=eenbody@tulane.edu

module load bowtie2

bowtie2 --very-sensitive-local --phred33 -x ../ribokmers -1 ../fq/fixed_32-33297-lorentzi-SP-after_S31.R1.cor_val_1.fq.gz -2 ../fq/fixed_32-33297-lorentzi-SP-after_S31.R2.cor_val_2.fq.gz --threads 1 --norc --met-file 32_metadata.txt --al-conc-gz 32_mapped.fastq.gz --un-conc-gz 32_unmapped --al-gz 32singlemapped.fastq.gz --un-gz 32singleunmapped.fastq.gz
