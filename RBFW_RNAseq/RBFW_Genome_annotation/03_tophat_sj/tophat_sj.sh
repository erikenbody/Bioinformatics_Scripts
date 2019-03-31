#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=23:00:00
#SBATCH --cpus-per-task=20
#SBATCH -J tophat
#SBATCH -e tophat_%A_%a.err            # File to which STDERR will be written
#SBATCH -o tophat_%A_%a.out
#SBATCH --mail-type=all
#SBATCH --mail-user=erik.enbody@gmail.com

module load bowtie2/2.3.3 tophat/2.1.1

WORK_D=/lustre/project/jk/Khalil_WD/RBFW_RNAseq/Genome_annotation/tophat_sj
cd $WORK_D
REF=/home/eenbody/RBFW_RNAseq/RBFW_reference_genome/RBFW.final.assembly.fasta

#bowtie2-build $REF RBFW
#tophat --library-type fr-firststrand -p 20 -o $WORK_D --no-sort-bam --no-convert-bam RBFW mpg_L13566-1_F101_S32_clp.fq.1.gz,mpg_L13570-1_B06_S38_clp.fq.1.gz,mpg_L14933-1_malMel-H-B10_S57_clp.fq.1.gz,mpg_L14946-1_malMel-P-B10_S3_clp.fq.1.gz,mpg_L14920-1_malMel-A-B10_S37_clp.fq.1.gz,mpg_L13566-1_F101_S32_clp.fq.2.gz,mpg_L13570-1_B06_S38_clp.fq.2.gz,mpg_L14933-1_malMel-H-B10_S57_clp.fq.2.gz,mpg_L14946-1_malMel-P-B10_S3_clp.fq.2.gz,mpg_L14920-1_malMel-A-B10_S37_clp.fq.2.gz

awk '{if($5 >= 5) print $0}' junctions.bed > high_quality_junctions.bed
tophat2gff3 high_quality_junctions.bed > high_quality_junctions.gff
