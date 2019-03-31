#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=23:00:00
#SBATCH -e hisat_%A_%a.err            # File to which STDERR will be written
#SBATCH -o hisat_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J hisat             # Job name
#SBATCH --cpus-per-task=20
#SBATCH --mail-type=all
#SBATCH --mail-user=erik.enbody@gmail.com

WORK_D=/home/eenbody/RBFW_RNAseq/Genome_annotation/rna_mapping
cd $WORK_D

REF=/home/eenbody/RBFW_RNAseq/RBFW_reference_genome/RBFW.final.assembly.fasta

hisat2-build -p 20 $REF RBFW
