#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e angsd_vcf.err            # File to which STDERR will be written
#SBATCH -o angsd_vcf.out           # File to which STDOUT will be written
#SBATCH -J angsd_vcf           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=6-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load zlib/1.2.8
module load xz/5.2.2

angsd -b bam_list.txt -dovcf 1 -gl 1 -dopost 1 -domajorminor 1 -domaf 1 -snp_pval 1e-6
