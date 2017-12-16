#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e kall_abun.err            # File to which STDERR will be written
#SBATCH -o kall_abun.out           # File to which STDOUT will be written
#SBATCH -J kall_abun           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

abundance_estimates_to_matrix.pl --est_method kallisto \
--gene_trans_map /home/eenbody/RNAseq_WD/Transcript_Quant/RSEM/ref/Trinity_map.txt \
--out_prefix kallisto \
--name_sample_by_basedir \
ref/10-33254-aida-Chest_S10.kallisto_out \
ref/11-33221-naimii-SP_S11.kallisto_out \
ref/12-33221-naimii-Chest_S12.kallisto_out \
ref/14-33225-naimii-Chest_S13.kallisto_out \
ref/1-47631-lorentzi-Chest_S1.kallisto_out \
ref/15-36126-moretoni-SP_S14.kallisto_out \
ref/16-36126-moretoni-Chest_S15.kallisto_out \
ref/17-36182-moretoni-Chest_S16.kallisto_out \
ref/18-47717-moretoni-Crown_S17.kallisto_out \
ref/19-47717-moretoni-SP_S18.kallisto_out \
ref/20-47745-moretoni-Crown_S19.kallisto_out \
ref/21-47745-moretoni-Chest_S20.kallisto_out \
ref/22-47815-moretoni-Crown_S21.kallisto_out \
ref/23-47815-moretoni-SP_S22.kallisto_out \
ref/24-36016-moretoni-M-Chest_S23.kallisto_out \
ref/2-47760-moretoni-M-SP_S2.kallisto_out \
ref/25-36071-moretoni-M-SP_S24.kallisto_out \
ref/26-36071-moretoni-M-Chest_S25.kallisto_out \
ref/27-47816-moretoni-M-Chest_S26.kallisto_out \
ref/28-47816-moretoni-M-SP_S27.kallisto_out \
ref/29-33297-lorentzi-Chest-before_S28.kallisto_out \
ref/30-33297-lorentzi-Crown-before_S29.kallisto_out \
ref/31-33287-lorentzi-SP-after_S30.kallisto_out \
ref/32-33297-lorentzi-SP-after_S31.kallisto_out \
ref/3-33230-naimii-Chest_S3.kallisto_out \
ref/33-33297-lorentzi-SP-before_S32.kallisto_out \
ref/34-97513-lorentzi-SP-before_S33.kallisto_out \
ref/35-97513-lorentzi-Crown-before_S34.kallisto_out \
ref/36-97513-lorentzi-SP-after_S35.kallisto_out \
ref/37-97528-lorentzi-Crown-before_S36.kallisto_out \
ref/38-97528-lorentzi-SP-before_S37.kallisto_out \
ref/39-97528-lorentzi-Chest-before_S38.kallisto_out \
ref/40-97528-lorentzi-SP-after_S39.kallisto_out \
ref/41-47745-moretoni-SP_S40.kallisto_out \
ref/42-33225-naimii-SP_S41.kallisto_out \
ref/4-33230-naimii-SP_S4.kallisto_out \
ref/5-33253-aida-Chest_S5.kallisto_out \
ref/6-33253-aida-SP_S6.kallisto_out \
ref/7-33248-aida-SP_S7.kallisto_out \
ref/8-33248-aida-Chest_S8.kallisto_out \
ref/9-33254-aida-SP_S9.kallisto_out
