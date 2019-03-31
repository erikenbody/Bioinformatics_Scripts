#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --qos=long
#SBATCH -e trinity_%A.err            # File to which STDERR will be written
#SBATCH -o trinity_%A.out           # File to which STDOUT will be written
#SBATCH -J trinity               # Job name
#SBATCH --mem=256000
#SBATCH --cpus-per-task=15
#SBATCH --time=1-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

#first try:
#module load trinity/2.4.0
#module load bowtie2/2.3.3

SAMPLEDIR=/home/eenbody/RBFW_RNAseq/Genome_annotation/input_RNAseq
WORK_D=/lustre/project/jk/Khalil_WD/RBFW_RNAseq/Genome_annotation/trinity
cd $WORK_D

# Trinity --seqType fq --jaccard_clip --SS_lib_type FR --max_memory 225G --min_kmer_cov 1 --CPU 20 --left $SAMPLEDIR/mpg_L13566-1_F101_S32_clp.fq.1.gz,$SAMPLEDIR/mpg_L13570-1_B06_S38_clp.fq.1.gz,$SAMPLEDIR/mpg_L14933-1_malMel-H-B10_S57_clp.fq.1.gz,$SAMPLEDIR/mpg_L14946-1_malMel-P-B10_S3_clp.fq.1.gz,$SAMPLEDIR/mpg_L14920-1_malMel-A-B10_S37_clp.fq.1.gz --right $SAMPLEDIR/mpg_L13566-1_F101_S32_clp.fq.2.gz,$SAMPLEDIR/mpg_L13570-1_B06_S38_clp.fq.2.gz,$SAMPLEDIR/mpg_L14933-1_malMel-H-B10_S57_clp.fq.2.gz,$SAMPLEDIR/mpg_L14946-1_malMel-P-B10_S3_clp.fq.2.gz,$SAMPLEDIR/mpg_L14920-1_malMel-A-B10_S37_clp.fq.2.gz

#-----------------
#trying updated version (2.8.4) after failed run. Line 28 is the failed command. Doesnt work even with 2.8
# source activate /home/eenbody/BI_software/conda_environments/ede_py2
# module load samtools

# ~/BI_software/trinityrnaseq-Trinity-v2.8.4/Trinity --single "/lustre/project/jk/Khalil_WD/RBFW_RNAseq/Genome_annotation/trinity/trinity_out_dir/read_partitions/Fb_1/CBin_1113/c111364.trinity.reads.fa" --output "/lustre/project/jk/Khalil_WD/RBFW_RNAseq/Genome_annotation/trinity/trinity_out_dir/read_partitions/Fb_1/CBin_1113/c111364.trinity.reads.fa.out" --CPU 1 --max_memory 1G --run_as_paired --SS_lib_type F --seqType fa --trinity_complete --full_cleanup --jaccard_clip --min_kmer_cov 1

#-----------------

#or trying without jaccard clip and 2.8.4.  installed to salmon environ
#should be lib type RF opps
module load anaconda samtools
source activate salmon
export PATH=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre
module load gcc/6.3.0

~/BI_software/trinityrnaseq-Trinity-v2.8.4/Trinity --output Trinity_no_jc --seqType fq --SS_lib_type RF --max_memory 225G --min_kmer_cov 1 --CPU 15 --left $SAMPLEDIR/mpg_L13566-1_F101_S32_clp.fq.1.gz,$SAMPLEDIR/mpg_L13570-1_B06_S38_clp.fq.1.gz,$SAMPLEDIR/mpg_L14933-1_malMel-H-B10_S57_clp.fq.1.gz,$SAMPLEDIR/mpg_L14946-1_malMel-P-B10_S3_clp.fq.1.gz,$SAMPLEDIR/mpg_L14920-1_malMel-A-B10_S37_clp.fq.1.gz --right $SAMPLEDIR/mpg_L13566-1_F101_S32_clp.fq.2.gz,$SAMPLEDIR/mpg_L13570-1_B06_S38_clp.fq.2.gz,$SAMPLEDIR/mpg_L14933-1_malMel-H-B10_S57_clp.fq.2.gz,$SAMPLEDIR/mpg_L14946-1_malMel-P-B10_S3_clp.fq.2.gz,$SAMPLEDIR/mpg_L14920-1_malMel-A-B10_S37_clp.fq.2.gz
