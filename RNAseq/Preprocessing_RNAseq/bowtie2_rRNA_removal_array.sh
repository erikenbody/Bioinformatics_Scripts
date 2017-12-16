#!/bin/bash
#SBATCH --qos=normal
#SBATCH --time=06:00:00
#SBATCH --verbose    ###        Verbosity logs error information into the error file
#SBATCH -J WSFW_bowtie2_rRNA_array
#SBATCH -N 1             ### Node count required for the job
#SBATCH -n 1   ### Number of tasks to be launched per Node
#SBATCH --mem=4000
#SBATCH -o rRNA_%A_%a.out # Standard output
#SBATCH -e rRNA_%A_%a.err # Standard error

module load bowtie2

FILENAME=`ls -1 *val_1.fq.gz | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
READ=$(echo $FILENAME | rev| cut -c 20- | rev)
NEWNAME=${READ:6}

#with ref downloaded from bbduk people
#bowtie2 --very-sensitive-local --phred33 -x ../ribokmers -1 ${READ}.R1.cor_val_1.fq.gz -2 ${READ}.R2.cor_val_2.fq.gz --threads 1 --norc --met-file ${NEWNAME}_metadata.txt --al-conc-gz ${NEWNAME}.mpp.fq.gz --un-conc-gz ${NEWNAME}.clp.fq.gz --al-gz ${NEWNAME}.mps.fq.gz --un-gz ${NEWNAME}.cls.fq.gz -S ${NEWNAME}.sam

#with ref I created
bowtie2 --very-sensitive-local --phred33 -x ../SILVA_128_LSURef_SSURef_Nr99_tax_silva_trunc_singleline_DNA -1 ${READ}.R1.cor_val_1.fq.gz -2 ${READ}.R2.cor_val_2.fq.gz --threads 1 --norc --met-file ${NEWNAME}_metadata.txt --al-conc-gz ${NEWNAME}_mpp.fq.gz --un-conc-gz ${NEWNAME}_clp.fq.gz --al-gz ${NEWNAME}_mps.fq.gz --un-gz ${NEWNAME}_cls.fq.gz -S ${NEWNAME}.sam

#.mpp = pairs that mapped to rRNA
#.mps = singles that mapped to rRNA
#.clp = pairs that did not map to rRNA
#.cls = singls that did not map to rRNA

rm ${NEWNAME}.sam
