#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=6-23:00:00
#SBATCH -e coverage.err            # File to which STDERR will be written
#SBATCH -o coverage.out           # File to which STDOUT will be written
#SBATCH -J coverage           # Job name
#SBATCH --mem=64000
#SBATCH --qos=long
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

#just trying to get some overall stats

export PATH=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre

#SAMPLEDIR=/home/eenbody/reseq_WD/Preprocessing_fixed/03_sort_idx_sum
REF=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
WORK_D=/home/eenbody/reseq_WD/GATK_Haplotype_Caller/coverage

BAMLIST=$WORK_D/allpops_bamlist.list

java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/BI_software/GenomeAnalysisTK.jar \
-T DepthOfCoverage \
   -R $REF \
   -o WSFW_coverage \
   -I $BAMLIST \
   --minBaseQuality 20 \
   --minMappingQuality 20 \
   --omitDepthOutputAtEachBase \
   -omitIntervals \
   --omitLocusTable
