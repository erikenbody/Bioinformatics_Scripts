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

WORK_D=/lustre/project/jk/Enbody_WD/WSFW_DDIG/reseq_WD/Preprocessing_fixed/RBFW_outgroup
cd $WORK_D
SAMPLE=RBFW_220bp_GCTCAT

java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/BI_software/picard.jar MarkDuplicates TMP_DIR=tmp \
I=$WORK_D/${SAMPLE}_1_mergebamalign.bam \
O=${SAMPLE}_dedup.bam METRICS_FILE=${SAMPLE}_dedup_metrics.txt \
REMOVE_DUPLICATES=false TAGGING_POLICY=All

sbatch ~/Bioinformatics_Scripts/resequencing/Preprocessing_fixed/RBFW_outgroup/03_sort_index_summary.sh
