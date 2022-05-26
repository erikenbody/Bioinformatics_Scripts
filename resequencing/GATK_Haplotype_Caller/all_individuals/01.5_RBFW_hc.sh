#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=23:00:00
#SBATCH -e ./logs/variant_caller_%A_%a.err            # File to which STDERR will be written
#SBATCH -o ./logs/variant_caller_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J VariantCaller           # Job name
#SBATCH --mem=64000
#SBATCH --cpus-per-task=1
#SBATCH --qos=normal

export PATH=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre

SAMPLEDIR=/home/eenbody/reseq_WD/Preprocessing_fixed/03_sort_idx_sum
REF=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
WORK_D=/home/eenbody/reseq_WD/GATK_Haplotype_Caller/all_individuals

if [ -d "logs" ]; then echo "logs file exists" ; else mkdir logs; fi
if [ -d "01_haplotype_caller" ]; then echo "logs file exists" ; else mkdir 01_haplotype_caller; fi

#cd $SAMPLEDIR
#FILENAME=`ls -1 *sorted.bam | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
#SAMPLE=$(echo $FILENAME | rev | cut -c 18- | rev)
cd $WORK_D
OUT=01_haplotype_caller
RBFW=/home/eenbody/reseq_WD/Preprocessing_fixed/RBFW_outgroup/merged_realigned_bams/RBFW_220bp_GCTCAT_realigned.sorted.bam

module load samtools
#samtools view -b $RBFW scaffold_142 > RBFW_sc142.bam

java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/BI_software/GenomeAnalysisTK.jar \
-T HaplotypeCaller \
-R $REF \
-minPruning 1 \
-minDanglingBranchLength 1 \
--emitRefConfidence GVCF \
-I RBFW_sc142.bam \
-o RBFW_sc142_inv.vcf \
-variant_index_type LINEAR -variant_index_parameter 128000
