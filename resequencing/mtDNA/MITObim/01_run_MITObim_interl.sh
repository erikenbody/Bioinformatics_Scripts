#!/bin/bash
#SBATCH -N 1
#SBATCH -n 20
#SBATCH -e run_mito_il_%A_%a_RS.err            # File to which STDERR will be written
#SBATCH -o run_mito_il_%A_%a_RS.out           # File to which STDOUT will be written
#SBATCH -J run_mito_il          # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --time=6-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long

module load gcc/4.9.4

SAMPLEDIR=/home/eenbody/reseq_WD/Preprocessing_fixed/0X_interleaved_fastq
WORK_D=/home/eenbody/reseq_WD/mtDna/MITObim/interleaved
cd $SAMPLEDIR

FILENAME=`ls -1 *.fastq.gz | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
SAMPLE=$(echo $FILENAME | rev | cut -c 10- | rev | uniq) ; echo $SAMPLE

cd $WORK_D
mkdir $SAMPLE
cd $SAMPLE

MITObim.pl -start 1 -end 30 -sample $SAMPLE --clean yes --pair yes -ref rbfw -readpool $SAMPLEDIR/$FILENAME --quick $WORK_D/rbfw_mtdna_genome.fasta
