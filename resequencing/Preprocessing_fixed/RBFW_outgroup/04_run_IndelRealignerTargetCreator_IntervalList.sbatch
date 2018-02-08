#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=0-23:59:00
#SBATCH --qos=normal
#SBATCH -e indelcreator_%A_%a.err            # File to which STDERR will be written
#SBATCH -o indelcreator_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J indelcreator            # Job name
#SBATCH --mem=64000

export PATH=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre

INT=/home/eenbody/reseq_WD/Preprocessing_fixed/04_indel_realign/split_fai/
WORK_D=/lustre/project/jk/Enbody_WD/WSFW_DDIG/reseq_WD/Preprocessing_fixed/RBFW_outgroup
cd $WORK_D
SAMPLE=RBFW_220bp_GCTCAT
REF=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta

java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/BI_software/GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-nt 20 \
-R $REF \
-I $WORK_D/${SAMPLE}_dedup_sorted.bam \
-o WSFW_indel_${SLURM_ARRAY_TASK_ID}.intervals \
-L $INT/split_faiWSFW_ref_final_assembly.fasta_${SLURM_ARRAY_TASK_ID}.interval_list

#bad idea to do this (because this script is run as an ARRAY)
#sbatch ~/Bioinformatics_Scripts/resequencing/Preprocessing_fixed/RBFW_outgroup/05_run_IndelRealigner_LoopedIntervalList.sbatch
