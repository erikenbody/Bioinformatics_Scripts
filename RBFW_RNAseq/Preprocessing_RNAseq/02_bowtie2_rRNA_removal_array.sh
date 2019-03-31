#!/bin/bash
#SBATCH --qos=normal
#SBATCH --time=23:00:00
#SBATCH --verbose    ###        Verbosity logs error information into the error file
#SBATCH -J WSFW_bowtie2_rRNA_array
#SBATCH -N 1             ### Node count required for the job
#SBATCH -n 1   ### Number of tasks to be launched per Node
#SBATCH --cpus-per-task=20
#SBATCH -o rRNA_%A_%a.out # Standard output
#SBATCH -e rRNA_%A_%a.err # Standard error

module load bowtie2

WORK_D=/lustre/project/jk/Khalil_WD/RBFW_RNAseq/Preprocessing
cd $WORK_D

#FILENAME=`ls -1 *val_1.fq.gz | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
FILENAME=`ls -1 *malMel*val_1.fq.gz | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`

READ=$(echo $FILENAME | rev| cut -c 24- | rev)
NEWNAME=${READ:6}

#with ref I created
bowtie2 --very-sensitive-local --phred33 -x ~/RNAseq_WD/QC_RNAseq/rRNA_removal/SILVA_128_LSURef_SSURef_Nr99_tax_silva_trunc_singleline_DNA -1 ${READ}_R1_001.cor_val_1.fq.gz -2 ${READ}_R2_001.cor_val_2.fq.gz --threads 20 --nofw --met-file ${NEWNAME}_metadata.txt --al-conc-gz ${NEWNAME}_mpp.fq.gz --un-conc-gz ${NEWNAME}_clp.fq.gz --al-gz ${NEWNAME}_mps.fq.gz --un-gz ${NEWNAME}_cls.fq.gz -S ${NEWNAME}.sam

#.mpp = pairs that mapped to rRNA
#.mps = singles that mapped to rRNA
#.clp = pairs that did not map to rRNA
#.cls = singls that did not map to rRNA

rm ${NEWNAME}.sam
