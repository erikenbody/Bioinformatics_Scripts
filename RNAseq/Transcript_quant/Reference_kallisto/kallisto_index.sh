#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e kall_idx.err            # File to which STDERR will be written
#SBATCH -o kall_idx.out           # File to which STDOUT will be written
#SBATCH -J kall_idx            # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

FQ_DIR=/home/eenbody/RNAseq_WD/QC_RNAseq/rRNA_removal/silva_full_ref/
WORK_D=/home/eenbody/RNAseq_WD/Transcript_Quant/Reference_Kallisto

cd $WORK_D

kallisto index -i $WORK_D/ref/Trinity.idx $WORK_D/ref/WSFW_assembly_maker2.all.maker.transcripts.fasta
