#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=23:00:00
#SBATCH -e RNA_preprocess_%A_%a.err            # File to which STDERR will be written
#SBATCH -o RNA_preprocess_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J RNA_preprocess             # Job name
#SBATCH --cpus-per-task=20


SAMPLEDIR=/lustre/project/jk/Khalil_WD/RBFW_RNAseq/raw_RNAseq
WORK_D=/lustre/project/jk/Khalil_WD/RBFW_RNAseq/Preprocessing

cd $SAMPLEDIR
#FILENAME=`ls -1 *_R1_001.fastq.gz | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'` # Ran before we got brains
FILENAME=`ls -1 *malMel*R1*fastq.gz | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'` # Ran when we got brains
SAMPLE=$(echo $FILENAME | rev | cut -c 17- | rev | uniq)
cd $WORK_D

#mkdir rCorr
cd rCorr
perl /home/eenbody/Enbody_WD/BI_software/rcorrector/run_rcorrector.pl -t 20 -1 $SAMPLEDIR/${SAMPLE}_R1_001.fastq.gz -2 $SAMPLEDIR/${SAMPLE}_R2_001.fastq.gz
cd ..

echo 'done with rcorrector'

module load python/2.7.11

python ~/Bioinformatics_Scripts/RNAseq/QC_RNAseq/FilterUncorrectabledPEfastq.py -1 rCorr/${SAMPLE}_R1_001.cor.fq.gz -2 rCorr/${SAMPLE}_R2_001.cor.fq.gz -o fixed 2>&1 > rmunfixable_${SAMPLE}.out

echo 'done with kmerfix'
gzip fixed_${SAMPLE}_R1_001.cor.fq
gzip fixed_${SAMPLE}_R2_001.cor.fq

module load anaconda
#source activate ede_py

trim_galore --paired --retain_unpaired --phred33 --output_dir . --fastqc --gzip --length 36 -q 5 --stringency 1 -e 0.1 fixed_${SAMPLE}_R1_001.cor.fq.gz fixed_${SAMPLE}_R2_001.cor.fq.gz

echo 'done with trimgalore'
