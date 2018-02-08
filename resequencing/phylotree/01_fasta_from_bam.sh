#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e bam_to_fasta.err            # File to which STDERR will be written
#SBATCH -o bam_to_fasta.out           # File to which STDOUT will be written
#SBATCH -J bam_to_fasta           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load zlib/1.2.8
module load xz/5.2.2

HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/phylotree
cd $WORK_D

REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
RUN=autosome_scaffolds
REGIONS=$HOME_D/${RUN}.txt
DESCRIPTION=consensus

mkdir Results

# for POP in aida naimii lorentzi moretoni
# do
#  echo $POP
#  BAMLIST=$HOME_D/${POP}_bamlist_NR.txt
#  angsd -b $BAMLIST -ref $REFGENOME -out Results/${POP}.${RUN}_${DESCRIPTION} -rf $REGIONS -P 20 \
#                -doFasta 2 -doCounts 1 -minQ 20 \
#                -setminDepth 10
# done

#note: need to make a txt file that has this path, cant just put the filename...
OUTGROUP=/home/eenbody/reseq_WD/Preprocessing_fixed/RBFW_outgroup/merged_realigned_bams/RBFW_220bp_GCTCAT_realigned.sorted.bam

angsd -b rbfw_bamlist.txt -ref $REFGENOME -out Results/rbfw_correct.fasta -rf $REGIONS -P 20 \
              -doFasta 2 -doCounts 1 -minQ 20 -setminDepth 10
