#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=23:00:00
#SBATCH -e IndelRealigner2_%A_%a.err            # File to which STDERR will be written
#SBATCH -o IndelRealigner2_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J IndelRealigner2           # Job name
#SBATCH --mem=20000
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to
#
export PATH=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre

######MAKE SURE THESE DIRECTORIES EXIST####

#mkdir logs
INT=/home/eenbody/reseq_WD/Preprocessing_fixed/04_indel_realign/split_fai/
WORK_D=/lustre/project/jk/Enbody_WD/WSFW_DDIG/reseq_WD/Preprocessing_fixed/RBFW_outgroup
cd $WORK_D
SAMPLE=RBFW_220bp_GCTCAT
REF=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta

mkdir merged_realigned_bams

for i in {1..20};

do

java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/BI_software/GenomeAnalysisTK.jar \
-T IndelRealigner \
-R $REF \
-I $WORK_D/${SAMPLE}_dedup_sorted.bam \
-targetIntervals ./WSFW_indel_$i.intervals \
-L $INT/split_faiWSFW_ref_final_assembly.fasta_$i.interval_list \
-o ./${SAMPLE}_$i.realigned.bam

done

java -Xmx16g -jar ~/BI_software/picard.jar MergeSamFiles \
I=./${SAMPLE}_1.realigned.bam \
I=./${SAMPLE}_2.realigned.bam \
I=./${SAMPLE}_3.realigned.bam \
I=./${SAMPLE}_4.realigned.bam \
I=./${SAMPLE}_5.realigned.bam \
I=./${SAMPLE}_6.realigned.bam \
I=./${SAMPLE}_7.realigned.bam \
I=./${SAMPLE}_8.realigned.bam \
I=./${SAMPLE}_9.realigned.bam \
I=./${SAMPLE}_10.realigned.bam \
I=./${SAMPLE}_11.realigned.bam \
I=./${SAMPLE}_12.realigned.bam \
I=./${SAMPLE}_13.realigned.bam \
I=./${SAMPLE}_14.realigned.bam \
I=./${SAMPLE}_15.realigned.bam \
I=./${SAMPLE}_16.realigned.bam \
I=./${SAMPLE}_17.realigned.bam \
I=./${SAMPLE}_18.realigned.bam \
I=./${SAMPLE}_19.realigned.bam \
I=./${SAMPLE}_20.realigned.bam \
O=./merged_realigned_bams/${SAMPLE}_realigned.bam

java -Xmx16g -jar ~/BI_software/picard.jar SortSam \
I=./merged_realigned_bams/${SAMPLE}_realigned.bam \
O=./merged_realigned_bams/${SAMPLE}_realigned.sorted.bam \
SORT_ORDER=coordinate \
TMP_DIR=tmp

java -Xmx16g -jar ~/BI_software/picard.jar BuildBamIndex \
I=./merged_realigned_bams/${SAMPLE}_realigned.sorted.bam \
TMP_DIR=tmp

if [ -f ./merged_realigned_bams/${SAMPLE}_realigned.sorted.bam ]
then
  rm ./merged_realigned_bams/${SAMPLE}_realigned.bam
  for i in {1..20};
  do
  rm ./${SAMPLE}_$i.realigned.bam
  rm ./${SAMPLE}_$i.realigned.bai
  done
fi
