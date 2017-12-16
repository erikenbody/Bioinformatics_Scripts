#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=10:00:00
#SBATCH -e sort_ind_%A_%a.err            # File to which STDERR will be written
#SBATCH -o sort_ind_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J sort_ind            # Job name
#SBATCH --mem=64000

export PATH=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre

SAMPLEDIR=/home/eenbody/reseq_WD/Preprocessing_fixed/02_dedup
WORK_D=/home/eenbody/reseq_WD/Preprocessing_fixed/03_sort_idx_sum
REF=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta

cd $SAMPLEDIR
FILENAME=`ls -1 *dedup.bam | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
SAMPLE=$(echo $FILENAME | rev | cut -c 11- | rev)
cd $WORK_D

java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/BI_software/picard.jar SortSam \
I=$SAMPLEDIR/${SAMPLE}_dedup.bam \
O=${SAMPLE}_dedup_sorted.bam \
SORT_ORDER=coordinate \
TMP_DIR=tmp

java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/BI_software/picard.jar BuildBamIndex \
I=${SAMPLE}_dedup_sorted.bam \
TMP_DIR=tmp

java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/BI_software/picard.jar CollectAlignmentSummaryMetrics \
I=${SAMPLE}_dedup_sorted.bam \
R=$REF \
METRIC_ACCUMULATION_LEVEL=SAMPLE \
METRIC_ACCUMULATION_LEVEL=READ_GROUP \
O=${SAMPLE}_alignment_metrics.txt \
TMP_DIR=tmp

java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/BI_software/picard.jar ValidateSamFile \
I=${SAMPLE}_dedup_sorted.bam \
O=${SAMPLE}_validate.txt MODE=SUMMARY \
TMP_DIR=tmp
