#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e rsem_exp_%A_%a.err            # File to which STDERR will be written
#SBATCH -o rsem_exp_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J rsem_exp             # Job name
#SBATCH --mem=12000
#SBATCH --cpus-per-task=20
#SBATCH --time=10:00:00              # Runtime in D-HH:MM:SS

module load bowtie2/2.3.3
module load rsem/1.2.31

#WILL NEED TO UPDATE THIS PATH AFTER YOU EDITED TRANSCRIPT_QUANT PATH
TRANS_DATA=/home/eenbody/RNAseq_WD/Transcript_Quant/ref_RSEM
FQ_DIR=/home/eenbody/RNAseq_WD/QC_RNAseq/rRNA_removal/silva_full_ref/
WORK_D=/home/eenbody/RNAseq_WD/Transcript_Quant/

cd $FQ_DIR

FILENAME=`ls -1 *clp.fq.1* | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
READ=$(echo $FILENAME | rev | cut -c 13- | rev)

cd $WORK_D

rsem-calculate-expression --bowtie2 --num-threads 20 --strand-specific --paired-end  $FQ_DIR/${READ}_clp.fq.1.gz  $FQ_DIR/${READ}_clp.fq.2.gz  $TRANS_DATA/transcripts_gg  ${READ}_RSEM_bowtie2
