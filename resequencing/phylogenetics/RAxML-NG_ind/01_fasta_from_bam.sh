#!/bin/bash
#SBATCH -N 1
#SBATCH -n 20
#SBATCH -e bam2fasta_%A_%a.err            # File to which STDERR will be written
#SBATCH -o bam2fasta_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J bam2fasta_%A_%a           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load zlib/1.2.8
module load xz/5.2.2

HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/lustre/project/jk/Enbody_WD/WSFW_DDIG/reseq_WD/phylotree/RAxML-NG_ind/doFasta
cd $WORK_D

REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
RUN=autosome_scaffolds
REGIONS=$HOME_D/${RUN}.txt

FILENAME=`ls -1 *realigned.sorted.bam | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`

angsd -i $FILENAME -ref $REFGENOME -out $FILENAME -rf $REGIONS -P 20 \
          -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 0 -trim 0 \
          -minMapQ 20 -minQ 20 -setminDepth 10 \
          -doFasta 3 -doCounts 1
