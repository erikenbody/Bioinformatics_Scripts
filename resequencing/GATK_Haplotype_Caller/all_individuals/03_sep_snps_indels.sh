#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=23:00:00
#SBATCH -e sep.err            # File to which STDERR will be written
#SBATCH -o sep.out           # File to which STDOUT will be written
#SBATCH -J sep           # Job name
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --qos=normal
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

export PATH=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre

SAMPLEDIR=/home/eenbody/reseq_WD/GATK_Haplotype_Caller/all_individuals/
REF=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
WORK_D=/home/eenbody/reseq_WD/GATK_Haplotype_Caller/all_individuals/seperate_snps_indels

cd $WORK_D

java -Xmx16g -XX:ParallelGCThreads=1 -Djava.io.tmpdir=tmp -jar ~/BI_software/GenomeAnalysisTK.jar \
-T SelectVariants \
-nt 20 \
-R $REF \
-V $SAMPLEDIR/All_WSFW.vcf.gz \
-selectType SNP \
-o WSFW_raw_snps.vcf

java -Xmx16g -XX:ParallelGCThreads=1 -Djava.io.tmpdir=tmp -jar ~/BI_software/GenomeAnalysisTK.jar \
-T SelectVariants \
-nt 20 \
-R $REF \
-V $SAMPLEDIR/All_WSFW.vcf.gz \
-selectType INDEL \
-o WSFW_raw_indels.vcf
