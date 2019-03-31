#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=23:00:00
#SBATCH --cpus-per-task=20
#SBATCH -J stringtie
#SBATCH -a 1-5
#SBATCH -e stringtie_%A_%a.err            # File to which STDERR will be written
#SBATCH -o stringtie_%A_%a.out
#SBATCH --mail-type=all
#SBATCH --mail-user=erik.enbody@gmail.com

module load samtools/1.5

SAMPLEDIR=/home/eenbody/RBFW_RNAseq/Genome_annotation/input_RNAseq
WORK_D=/home/eenbody/RBFW_RNAseq/Genome_annotation/rna_mapping
cd $WORK_D

FILENAME=`ls -1 *.bam | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
SAMPLE="${FILENAME%.*}"

stringtie $FILENAME -l $SAMPLE -p 20 -o ${SAMPLE}.gtf
