#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e il_fastq.err            # File to which STDERR will be written
#SBATCH -o il_fastq.out           # File to which STDOUT will be written
#SBATCH -J il_fastq           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to


export PATH=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre

SAMPLE_D=/home/eenbody/reseq_WD/Preprocessing_fixed/04_indel_realign/merged_realigned_bams
WORK_D=/home/eenbody/reseq_WD/Preprocessing_fixed/0X_interleaved_fastq
cd $WORK_D

FILENAME=`ls -1 *.bam | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
SAMPLE=$(echo $FILENAME | rev | cut -c 22- | rev | uniq)

java -Xmx60g -XX:ParallelGCThreads=1 -jar ~/BI_software/picard.jar SamToFastq \
	I=$FILENAME \
	FASTQ=${SAMPLE}.fastq \
	CLIPPING_ATTRIBUTE=XT CLIPPING_ACTION=2 INTERLEAVE=true NON_PF=true \
	TMP_DIR=./tmp

gzip ${SAMPLE}.fastq
