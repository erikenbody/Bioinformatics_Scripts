#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e perpopangsd_%j.err            # File to which STDERR will be written
#SBATCH -o perpopangsd_%j.out           # File to which STDOUT will be written
#SBATCH -J perpopangsd          # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to
#
module load zlib/1.2.8
module load xz/5.2.2

#variables
HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/dxy_lowfilt/outlier_scaff_chest
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
ANC=/home/eenbody/reseq_WD/phylotree/Results/rbfw_correct.fasta
RUN=autosome_scaffolds
REGIONS=chest_scaff.txt

cd $WORK_D

#1
POP=$1
COMP=$2
MININD=$3
#removed skip tri and anc on jul 3. and domaf from 1 o 2 and domajorminor from 1 to 3.
#doMajorMinor 3 uses the major/minor decisions from the previous step. No reason to recalculate these and it makes sense to use both pops data in previous step.
angsd -bam $HOME_D/${POP}_bamlist_NR.txt -ref $REFGENOME -anc $REFGENOME -rf $REGIONS -uniqueOnly 1 -P 20 -sites ${COMP}_NH_cut.mafs \
-remove_bads 1 -trim 0 -minMapQ 20 -minQ 20 -only_proper_pairs 0 -minInd $MININD \
-out ${POP}_${COMP}_4dxy -doCounts 1 -doMaf 1 -doMajorMinor 3 \
-GL 1

gunzip -c ${POP}_${COMP}_4dxy.mafs.gz > ${POP}_${COMP}_4dxy.mafs
