#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e salmon_%A_%a.err            # File to which STDERR will be written
#SBATCH -o salmon_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J salmon            # Job name
#SBATCH --mem=12000
#SBATCH --cpus-per-task=20
#SBATCH --time=23:00:00

module load anaconda
source activate salmon

TRANS_DATA=/home/eenbody/RNAseq_WD/Transcript_Quant/ref
FQ_DIR=/home/eenbody/RNAseq_WD/QC_RNAseq/rRNA_removal/silva_full_ref/
WORK_D=/home/eenbody/RNAseq_WD/Transcript_Quant/Salmon

cd $FQ_DIR

FILENAME=`ls -1 *clp.fq.1* | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
READ=$(echo $FILENAME | rev | cut -c 13- | rev)

cd $WORK_D

#salmon index -t WSFW_assembly_maker2.all.maker.transcripts.fasta -i wsfw_index

salmon quant -i wsfw_index -l ISF -p 20 -1 $FQ_DIR/${READ}_clp.fq.1.gz -2 $FQ_DIR/${READ}_clp.fq.2.gz -o ${READ}_out

#salmon quant -i wsfw_index -l A -p 20 -1 $FQ_DIR/${READ}_clp.fq.1.gz -2 $FQ_DIR/${READ}_clp.fq.2.gz -o ${READ}_out_libtest
