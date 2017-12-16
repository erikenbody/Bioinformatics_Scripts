#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --qos=long
#SBATCH -e trinity_47816.err            # File to which STDERR will be written
#SBATCH -o trinity_47816.out           # File to which STDOUT will be written
#SBATCH -J trinity_47816               # Job name
#SBATCH --mem=256000
#SBATCH --cpus-per-task=20
#SBATCH --time=6-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load trinity/2.4.0
module load bowtie2/2.3.3
# $1 = comma-separated list of R1 files
# $2 = comma-separated list of R2 files
# $3 = name of output directory Trinity will create to store results. This must include Trinity in the name, otherwise the job will terminate

WORK_D=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/Annotation/trinity_47816
cd $WORK_D

Trinity --seqType fq --jaccard_clip --SS_lib_type FR --max_memory 225G --min_kmer_cov 1 --CPU 20 --left 27-47816-moretoni-M-Chest_S26_clp.fq.1.gz,28-47816-moretoni-M-SP_S27_clp.fq.1.gz --right 27-47816-moretoni-M-Chest_S26_clp.fq.2.gz,28-47816-moretoni-M-SP_S27_clp.fq.2.gz --output trinity_47816_denovo
