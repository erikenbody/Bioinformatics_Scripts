#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --qos=long
#SBATCH -e trinity_%A.err            # File to which STDERR will be written
#SBATCH -o trinity_%A.out           # File to which STDOUT will be written
#SBATCH -J trinity_%A               # Job name
#SBATCH --mem=256000
#SBATCH --cpus-per-task=20
#SBATCH --time=1-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load trinity/2.4.0
module load bowtie2/2.3.3
# $1 = comma-separated list of R1 files
# $2 = comma-separated list of R2 files
# $3 = name of output directory Trinity will create to store results. This must include Trinity in the name, otherwise the job will terminate

WORK_D=/home/eenbody/RNAseq_WD/Jac_Trinity
cd $WORK_D

Trinity --seqType fq --jaccard_clip --SS_lib_type FR --max_memory 225G --min_kmer_cov 1 --CPU 20 --left 10-33254-aida-Chest_S10_clp.fq.1.gz,11-33221-naimii-SP_S11_clp.fq.1.gz,12-33221-naimii-Chest_S12_clp.fq.1.gz,14-33225-naimii-Chest_S13_clp.fq.1.gz,1-47631-lorentzi-Chest_S1_clp.fq.1.gz,15-36126-moretoni-SP_S14_clp.fq.1.gz,16-36126-moretoni-Chest_S15_clp.fq.1.gz,17-36182-moretoni-Chest_S16_clp.fq.1.gz,18-47717-moretoni-Crown_S17_clp.fq.1.gz,19-47717-moretoni-SP_S18_clp.fq.1.gz,20-47745-moretoni-Crown_S19_clp.fq.1.gz,21-47745-moretoni-Chest_S20_clp.fq.1.gz,22-47815-moretoni-Crown_S21_clp.fq.1.gz,23-47815-moretoni-SP_S22_clp.fq.1.gz,24-36016-moretoni-M-Chest_S23_clp.fq.1.gz,2-47760-moretoni-M-SP_S2_clp.fq.1.gz,25-36071-moretoni-M-SP_S24_clp.fq.1.gz,26-36071-moretoni-M-Chest_S25_clp.fq.1.gz,27-47816-moretoni-M-Chest_S26_clp.fq.1.gz,28-47816-moretoni-M-SP_S27_clp.fq.1.gz,29-33297-lorentzi-Chest-before_S28_clp.fq.1.gz,30-33297-lorentzi-Crown-before_S29_clp.fq.1.gz,31-33287-lorentzi-SP-after_S30_clp.fq.1.gz,32-33297-lorentzi-SP-after_S31_clp.fq.1.gz,3-33230-naimii-Chest_S3_clp.fq.1.gz,33-33297-lorentzi-SP-before_S32_clp.fq.1.gz,34-97513-lorentzi-SP-before_S33_clp.fq.1.gz,35-97513-lorentzi-Crown-before_S34_clp.fq.1.gz,36-97513-lorentzi-SP-after_S35_clp.fq.1.gz,37-97528-lorentzi-Crown-before_S36_clp.fq.1.gz,38-97528-lorentzi-SP-before_S37_clp.fq.1.gz,39-97528-lorentzi-Chest-before_S38_clp.fq.1.gz,40-97528-lorentzi-SP-after_S39_clp.fq.1.gz,41-47745-moretoni-SP_S40_clp.fq.1.gz,42-33225-naimii-SP_S41_clp.fq.1.gz,4-33230-naimii-SP_S4_clp.fq.1.gz,5-33253-aida-Chest_S5_clp.fq.1.gz,6-33253-aida-SP_S6_clp.fq.1.gz,7-33248-aida-SP_S7_clp.fq.1.gz,8-33248-aida-Chest_S8_clp.fq.1.gz,9-33254-aida-SP_S9_clp.fq.1.gz --right 10-33254-aida-Chest_S10_clp.fq.2.gz,11-33221-naimii-SP_S11_clp.fq.2.gz,12-33221-naimii-Chest_S12_clp.fq.2.gz,14-33225-naimii-Chest_S13_clp.fq.2.gz,1-47631-lorentzi-Chest_S1_clp.fq.2.gz,15-36126-moretoni-SP_S14_clp.fq.2.gz,16-36126-moretoni-Chest_S15_clp.fq.2.gz,17-36182-moretoni-Chest_S16_clp.fq.2.gz,18-47717-moretoni-Crown_S17_clp.fq.2.gz,19-47717-moretoni-SP_S18_clp.fq.2.gz,20-47745-moretoni-Crown_S19_clp.fq.2.gz,21-47745-moretoni-Chest_S20_clp.fq.2.gz,22-47815-moretoni-Crown_S21_clp.fq.2.gz,23-47815-moretoni-SP_S22_clp.fq.2.gz,24-36016-moretoni-M-Chest_S23_clp.fq.2.gz,2-47760-moretoni-M-SP_S2_clp.fq.2.gz,25-36071-moretoni-M-SP_S24_clp.fq.2.gz,26-36071-moretoni-M-Chest_S25_clp.fq.2.gz,27-47816-moretoni-M-Chest_S26_clp.fq.2.gz,28-47816-moretoni-M-SP_S27_clp.fq.2.gz,29-33297-lorentzi-Chest-before_S28_clp.fq.2.gz,30-33297-lorentzi-Crown-before_S29_clp.fq.2.gz,31-33287-lorentzi-SP-after_S30_clp.fq.2.gz,32-33297-lorentzi-SP-after_S31_clp.fq.2.gz,3-33230-naimii-Chest_S3_clp.fq.2.gz,33-33297-lorentzi-SP-before_S32_clp.fq.2.gz,34-97513-lorentzi-SP-before_S33_clp.fq.2.gz,35-97513-lorentzi-Crown-before_S34_clp.fq.2.gz,36-97513-lorentzi-SP-after_S35_clp.fq.2.gz,37-97528-lorentzi-Crown-before_S36_clp.fq.2.gz,38-97528-lorentzi-SP-before_S37_clp.fq.2.gz,39-97528-lorentzi-Chest-before_S38_clp.fq.2.gz,40-97528-lorentzi-SP-after_S39_clp.fq.2.gz,41-47745-moretoni-SP_S40_clp.fq.2.gz,42-33225-naimii-SP_S41_clp.fq.2.gz,4-33230-naimii-SP_S4_clp.fq.2.gz,5-33253-aida-Chest_S5_clp.fq.2.gz,6-33253-aida-SP_S6_clp.fq.2.gz,7-33248-aida-SP_S7_clp.fq.2.gz,8-33248-aida-Chest_S8_clp.fq.2.gz,9-33254-aida-SP_S9_clp.fq.2.gz --output trinity_jc_denovo
