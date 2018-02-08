#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e perpopangsd1.err            # File to which STDERR will be written
#SBATCH -o perpopangsd1.out           # File to which STDOUT will be written
#SBATCH -J perpopangsd1           # Job name
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
WORK_D=/home/eenbody/reseq_WD/angsd/dxy
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
ANC=/home/eenbody/reseq_WD/phylotree/Results/rbfw_correct.fasta
RUN=autosome_scaffolds
REGIONS=$HOME_D/${RUN}.txt
N_samp=32

cd $WORK_D

#originally ran with -doMaf 2 -doMajorMinor 4

for POP in aida naimii
do
 echo $POP
 MININD=$(if [[ "$POP" == "aida-more" ]]; then echo 8; elif [[ "$POP" == "lorentzi" ]]; then echo 5; elif [[ "$POP" == "naimii" ]]; then echo 4; elif [[ "$POP" == "aida" ]]; then echo 3; elif [[ "$POP" == "moretoni" ]]; then echo 5; fi)
 BAMLIST=$HOME_D/${POP}_bamlist_NR.txt
 angsd -bam $BAMLIST -ref $REFGENOME -anc $ANC -rf $REGIONS -uniqueOnly 1 -P 20 -sites aida_naimii_NH_cut.mafs \
 -remove_bads 1 -trim 0 -minMapQ 20 -minQ 20 -minMaf 0.01 -only_proper_pairs 0 -minInd $MININD \
 -out $POP -doCounts 1 -doMaf 1 -doMajorMinor 1 \
 -GL 1 -skipTriallelic 1
 gunzip -c ${POP}.mafs.gz > ${POP}.mafs
done
