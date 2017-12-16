#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=23:00:00
#SBATCH -e ./logs/IndelRealigner_%A_%a.err            # File to which STDERR will be written
#SBATCH -o ./logs/IndelRealigner_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J IndelRealigner           # Job name
#SBATCH --mem=20000

export PATH=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre

SAMPLEDIR=/home/eenbody/reseq_WD/Preprocessing_fixed/03_sort_idx_sum
REF=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
WORK_D=/home/eenbody/reseq_WD/Preprocessing_fixed/04_indel_realign

######MAKE SURE THESE DIRECTORIES EXIST####
#mkdir merged_realigned_bams
#mkdir logs


cd $SAMPLEDIR
FILENAME=`ls -1 *sorted.bam | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
SAMPLE=$(echo $FILENAME | rev | cut -c 18- | rev)
cd $WORK_D

for i in {1..20};

do

java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/BI_software/GenomeAnalysisTK.jar \
-T IndelRealigner \
-R $REF \
-I $SAMPLEDIR/${SAMPLE}_dedup_sorted.bam \
-targetIntervals ./WSFW_indel_$i.intervals \
-L split_fai/split_faiWSFW_ref_final_assembly.fasta_$i.interval_list \
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
