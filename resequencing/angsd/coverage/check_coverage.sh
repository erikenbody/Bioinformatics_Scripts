#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e angsd_cov.err            # File to which STDERR will be written
#SBATCH -o angsd_cov.out           # File to which STDOUT will be written
#SBATCH -J angsd_cov           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --cpus-per-task=20
#SBATCH --time=6-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mem=64000
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load zlib/1.2.8
module load xz/5.2.2

REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
WORK_D=/home/eenbody/reseq_WD/angsd/coverage
cd $WORK_D

#Output distribution of quality scores and per-site depths  (global and per-sample), with some quality filtering - only keep unique hits, remove "bad" reads, no trimming, (didn't use filter for reads where mates could be mapped because many reads may span different scaffolds due to fragmented nature of reference), only keep reads with a minimum mapping quality of 20.

#Notes above from AS. EDE following this.

angsd -P 20 -b bam_list.txt -ref $REFGENOME -out ALL.qc \
        -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 0 -trim 0 \
        -minMapQ 20 \
        -doQsDist 1 -doDepth 1 -doCounts 1 -maxDepth 2000
