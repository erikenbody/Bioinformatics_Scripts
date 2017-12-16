#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e trin_map.err            # File to which STDERR will be written
#SBATCH -o trin_map.out           # File to which STDOUT will be written
#SBATCH -J trin_map            # Job name
#SBATCH --time=23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load rsem/1.2.31

TRANS_DATA=/home/eenbody/Enbody_WD/WSFW_DDIG/RNAseq_WD/Guided_Trinity/trinity_gg
FQ_DIR=/home/eenbody/RNAseq_WD/QC_RNAseq/rRNA_removal/silva_full_ref/
WORK_D=/home/eenbody/RNAseq_WD/Transcript_Quant/ref_RSEM

cd $WORK_D
mkdir ref
ln -s $TRANS_DATA/Trinity-GG.fasta ./ref

extract-transcript-to-gene-map-from-trinity ./ref/Trinity-GG.fasta Trinity_gg_map
