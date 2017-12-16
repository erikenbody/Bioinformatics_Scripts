#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e rsem_ref.err            # File to which STDERR will be written
#SBATCH -o rsem_ref.out           # File to which STDOUT will be written
#SBATCH -J rsem_ref            # Job name
#SBATCH --time=23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load rsem/1.2.31
module load bowtie2/2.3.3

TRANS_DATA=/home/eenbody/Enbody_WD/WSFW_DDIG/RNAseq_WD/Guided_Trinity/trinity_gg
FQ_DIR=/home/eenbody/RNAseq_WD/QC_RNAseq/rRNA_removal/silva_full_ref/
WORK_D=/home/eenbody/RNAseq_WD/Transcript_Quant/ref_RSEM

cd $WORK_D

rsem-prepare-reference --transcript-to-gene-map Trinity_gg_map --bowtie2 ref/Trinity-GG.fasta  transcripts_gg
