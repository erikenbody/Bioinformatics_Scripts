#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e kall_idx.err            # File to which STDERR will be written
#SBATCH -o kall_idx.out           # File to which STDOUT will be written
#SBATCH -J kall_idx            # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

FQ_DIR=/lustre/project/jk/Khalil_WD/RBFW_RNAseq/Preprocessing/Final_processed_fastq
WORK_D=/lustre/project/jk/Khalil_WD/RBFW_RNAseq/Transcript_quant/kallisto_wsfw_reference

cd $WORK_D
mkdir ref

kallisto index -i $WORK_D/ref/WSFW_transcripts.idx $WORK_D/ref/WSFW_assembly_maker2.all.maker.transcripts.fasta
