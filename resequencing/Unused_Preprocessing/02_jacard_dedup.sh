#!/bin/bash

#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=10:00:00
#SBATCH -e dedup_%A_%a.err            # File to which STDERR will be written
#SBATCH -o dedup_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J dedup            # Job name
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20

export PATH=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre

SAMPLEDIR1=/home/eenbody/reseq_WD/Preprocessing/fastq_to_bam
SAMPLEDIR2=/home/eenbody/reseq_WD/Preprocessing/2fastq_to_bam
SAMPLEDIR3=/home/eenbody/reseq_WD/Preprocessing/3fastq_to_bam
WORK_D=/home/eenbody/reseq_WD/Preprocessing/02_dedup

cd $SAMPLEDIR1
FILENAME=`ls -1 *mergebamalign.bam | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
SAMPLE=$(echo $FILENAME | rev | cut -c 21- | rev)
cd $WORK_D

java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/BI_software/picard.jar MarkDuplicates TMP_DIR=tmp \
I=$SAMPLEDIR1/${SAMPLE}_1_mergebamalign.bam \
I=$SAMPLEDIR2/${SAMPLE}_2_mergebamalign.bam \
I=$SAMPLEDIR3/${SAMPLE}_3_mergebamalign.bam \
O=${SAMPLE}_dedup.bam METRICS_FILE=${SAMPLE}_dedup_metrics.txt \
REMOVE_DUPLICATES=false TAGGING_POLICY=All
