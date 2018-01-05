#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=23:00:00
#SBATCH -e vcfinfo_in.err            # File to which STDERR will be written
#SBATCH -o vcfinfo_in.out        # File to which STDOUT will be written
#SBATCH -J vcfinfo           # Job name
#SBATCH --mem=64000
#SBATCH --qos=normal
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load anaconda/2.5.0
module load zlib/1.2.8

source activate ede_py

SAMPLEDIR=/home/eenbody/reseq_WD/GATK_Haplotype_Caller/all_individuals/04_seperate_snps_indels
if [ -d "qual_info_indels" ]; then echo "info dir exists" ; else mkdir qual_info_indels; fi


vcftools --gzvcf $SAMPLEDIR/WSFW_raw_indels.vcf --out qual_info_indels/indels_WSFW_MQ --get-INFO MQ

vcftools --gzvcf $SAMPLEDIR/WSFW_raw_indels.vcf --out qual_info_indels/indels_WSFW_DP --get-INFO DP

vcftools --gzvcf $SAMPLEDIR/WSFW_raw_indels.vcf --out qual_info_indels/indels_WSFW_RPRS --get-INFO ReadPosRankSum

vcftools --gzvcf $SAMPLEDIR/WSFW_raw_indels.vcf --out qual_info_indels/indels_WSFW_BQRS --get-INFO BaseQRankSum

vcftools --gzvcf $SAMPLEDIR/WSFW_raw_indels.vcf --out qual_info_indels/indels_WSFW_MQRS --get-INFO MQRankSum

vcftools --gzvcf $SAMPLEDIR/WSFW_raw_indels.vcf --out qual_info_indels/indels_WSFW_QD --get-INFO QD

vcftools --gzvcf $SAMPLEDIR/WSFW_raw_indels.vcf --out qual_info_indels/indels_WSFW_MLEAC --get-INFO MLEAC

vcftools --gzvcf $SAMPLEDIR/WSFW_raw_indels.vcf --out qual_info_indels/indels_WSFW_MLEAF --get-INFO MLEAF

vcftools --gzvcf $SAMPLEDIR/WSFW_raw_indels.vcf --out qual_info_indels/indels_WSFW_CRS --get-INFO ClippingRankSum

vcftools --gzvcf $SAMPLEDIR/WSFW_raw_indels.vcf --out qual_info_indels/indels_WSFW_ExH --get-INFO ExcessHet

vcftools --gzvcf $SAMPLEDIR/WSFW_raw_indels.vcf --out qual_info_indels/indels_WSFW_SOR --get-INFO SOR

vcftools --gzvcf $SAMPLEDIR/WSFW_raw_indels.vcf --out qual_info_indels/indels_WSFW_missing --missing-indv

vcftools --gzvcf $SAMPLEDIR/WSFW_raw_indels.vcf --out qual_info_indels/indels_WSFW_FS --get-INFO FS
