#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e angsd_sfs_a3.err            # File to which STDERR will be written
#SBATCH -o angsd_sfs_a3.out           # File to which STDOUT will be written
#SBATCH -J angsd_sfs_a          # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=256000
#SBATCH --cpus-per-task=20
#SBATCH --time=6-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

#exceeded memory when set to 64gb
#remove coverage, remove relatives
#already ran lorentzi and naimii sfs elsewhere, so only run moretoni and aida (they were run combined before with relatives)

module load zlib/1.2.8
module load xz/5.2.2

HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/fst_angsd/auto/nocov_NR_bycolor/

cd $WORK_D

if [ -d "Results" ]; then echo "Results file exists" ; else mkdir Results; fi

#variables
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
RUN=autosome_scaffolds
REGIONS=$HOME_D/${RUN}.txt

CHR=autosomes

POP=blackchest
echo $POP
MININD=$(if [[ "$POP" == "blackchest" ]]; then echo 7; elif [[ "$POP" == "whitechest" ]]; then echo 8; elif [[ "$POP" == "whitesp" ]]; then echo 11; fi)
BAMLIST=$HOME_D/${POP}_bamlist_NR.txt
#test with original install
angsd -b $BAMLIST -ref $REFGENOME -anc $REFGENOME -out Results/${POP}.${RUN}.918.ref -rf $REGIONS -P 20 \
              -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 0 -trim 0 \
              -minMapQ 20 -minQ 20 -minInd $MININD -doCounts 1 \
              -GL 1 -doSaf 1
realSFS Results/${POP}.${RUN}.ref.saf.idx -P 20 > Results/${POP}.${RUN}.ref.sfs
