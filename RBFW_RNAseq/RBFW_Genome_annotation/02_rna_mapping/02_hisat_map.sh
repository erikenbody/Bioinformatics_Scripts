#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=23:00:00
#SBATCH -e hisat_%A_%a.err            # File to which STDERR will be written
#SBATCH -o hisat_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J hisat             # Job name
#SBATCH -a 1-5
#SBATCH --cpus-per-task=20
#SBATCH --mail-type=all
#SBATCH --mail-user=erik.enbody@gmail.com

module load samtools/1.5

SAMPLEDIR=/home/eenbody/RBFW_RNAseq/Genome_annotation/input_RNAseq
WORK_D=/home/eenbody/RBFW_RNAseq/Genome_annotation/rna_mapping

cd $SAMPLEDIR
FILENAME=`ls -1 *fq.1.gz | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
SAMPLE=$(echo $FILENAME | rev | cut -c 12- | rev | uniq) ; echo $SAMPLE
cd $WORK_D

hisat2 -p 20 --dta -x RBFW -1 $SAMPLEDIR/${SAMPLE}clp.fq.1.gz -2 $SAMPLEDIR/${SAMPLE}clp.fq.2.gz -S ${SAMPLE}.sam

samtools sort -@ 20 -o ${SAMPLE}.bam ${SAMPLE}.sam

rm ${SAMPLE}.sam
