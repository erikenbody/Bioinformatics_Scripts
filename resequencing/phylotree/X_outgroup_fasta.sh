#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e rbfw_bwa2.err            # File to which STDERR will be written
#SBATCH -o rbfw_bwa2.out           # File to which STDOUT will be written
#SBATCH -J rbfw_bwa           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to


#FLAWED


WORK_D=/home/eenbody/reseq_WD/phylotree
cd $WORK_D

REF=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta

module load bwa
module load samtools/1.5
module load zlib/1.2.8
module load xz/5.2.2

#bwa mem -M -t 20 -p $REF Results/RBFW_final_assembly.fasta

 # samtools mpileup -uf $REF Results/rbfw_aligned.sort.bam | bcftools call -c | ~/BI_software/bcftools/misc/vcfutils.pl vcf2fq > rbfw_consensus.fastq

seqtk seq rbfw_consensus.fastq > rbfw_fixed_consensus.fa

#workbench below:
#samtools mpileup -uf $REF Results/rbfw_aligned.sort.bam > for_bcf.vcf

#bcftools view -cg - | ~/BI_software/bcftools/misc/vcfutils.pl vcf2fq > consensus.fastq
