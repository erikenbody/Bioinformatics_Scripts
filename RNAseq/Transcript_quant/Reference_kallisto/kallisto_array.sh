#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e kallisto_%A_%a.err            # File to which STDERR will be written
#SBATCH -o kallisto_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J kallisto             # Job name
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=10:00:00              # Runtime in D-HH:MM:SS

FQ_DIR=/home/eenbody/RNAseq_WD/QC_RNAseq/rRNA_removal/silva_full_ref/
WORK_D=/home/eenbody/RNAseq_WD/Transcript_Quant/Reference_Kallisto

cd $FQ_DIR
FILENAME=`ls -1 *clp.fq.1* | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
READ=$(echo $FILENAME | rev | cut -c 13- | rev)
cd $WORK_D

kallisto quant -i $WORK_D/ref/Trinity.idx -o $WORK_D/${READ}.reference.kallisto_out -b 100 -t 20 --fr-stranded $FQ_DIR/${READ}_clp.fq.1.gz  $FQ_DIR/${READ}_clp.fq.2.gz
