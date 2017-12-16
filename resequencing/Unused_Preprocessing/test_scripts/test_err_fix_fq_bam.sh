#!/bin/bash

#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=10:00:00
#SBATCH -e fq_bam_%A_%a.err            # File to which STDERR will be written
#SBATCH -o fq_bam_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J fq_bam             # Job name
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20

export PATH=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre
module load bwa/0.7.15

FASTQDIR=/home/eenbody/Enbody_WD/WSFW_DDIG/Raw_WSFW_WGS/WGS_Lane1/Lane5.indexlength_6/Fastq
WORK_D=/home/eenbody/Enbody_WD/WSFW_DDIG/reseq_WD/Preprocessing/fastq_to_bam
REF=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW
cd $FASTQDIR

#sample needs to be uniq! This whole pipeline requires setting up reference with index+dictionary (see readme)

FILENAME=`ls -1 *R1.fastq.gz | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
SAMPLE=$(echo $FILENAME | rev | cut -c 13- | rev | uniq)
SAMPLEREPNUM=1
FLOWCELL=CB29KANXX
LANE=5
DATE=2017-09-08

cd $WORK_D

set -o pipefail

java -Xmx3g -XX:ParallelGCThreads=20 -jar ~/BI_software/picard.jar SamToFastq \
	I=${SAMPLE}_${SAMPLEREPNUM}_markilluminaadapters.bam \
	FASTQ=/dev/stdout \
	CLIPPING_ATTRIBUTE=XT CLIPPING_ACTION=2 INTERLEAVE=true NON_PF=true \
	TMP_DIR=./tmp | \
bwa mem -M -t 20 -p $REF/WSFW_ref_noIUB.fasta /dev/stdin | \
java -Xmx3g -XX:ParallelGCThreads=20 -jar ~/BI_software/picard.jar MergeBamAlignment \
	ALIGNED_BAM=/dev/stdin \
	UNMAPPED_BAM=${SAMPLE}_${SAMPLEREPNUM}_fastqtosam.bam \
	OUTPUT=${SAMPLE}_${SAMPLEREPNUM}_mergebamalign.bam \
	R=$REF/WSFW_ref_noIUB.fasta CREATE_INDEX=true ADD_MATE_CIGAR=true \
	CLIP_ADAPTERS=false CLIP_OVERLAPPING_READS=true \
	INCLUDE_SECONDARY_ALIGNMENTS=true MAX_INSERTIONS_OR_DELETIONS=-1 \
	PRIMARY_ALIGNMENT_STRATEGY=MostDistant ATTRIBUTES_TO_RETAIN=XS \
	TMP_DIR=./tmp

if [ -f ${SAMPLE}_${SAMPLEREPNUM}_mergebamalign.bam ]
then
  rm ${SAMPLE}_${SAMPLEREPNUM}_fastqtosam.bam
  rm ${SAMPLE}_${SAMPLEREPNUM}_markilluminaadapters.bam
fi
