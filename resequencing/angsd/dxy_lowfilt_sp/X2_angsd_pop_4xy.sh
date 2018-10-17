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
WORK_D=/home/eenbody/reseq_WD/angsd/dxy_lowfilt
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
ANC=/home/eenbody/reseq_WD/phylotree/Results/rbfw_correct.fasta
RUN=autosome_scaffolds
REGIONS=$HOME_D/${RUN}.txt
N_samp=32


cd $WORK_D

#originally ran with -doMaf 2 -doMajorMinor 4

echo "done with part1"

#1
POP=aida
COMP=aida_naimii
MININD=3
angsd -bam $HOME_D/${POP}_bamlist_NR.txt -ref $REFGENOME -anc $ANC -rf $REGIONS -uniqueOnly 1 -P 20 -sites ${COMP}_NH_cut.mafs \
-remove_bads 1 -trim 0 -minMapQ 20 -minQ 20 -only_proper_pairs 0 -minInd $MININD \
-out ${COMP}_4dxy -doCounts 1 -doMaf 1 -doMajorMinor 1 \
-GL 1 -skipTriallelic 1

gunzip -c ${COMP}_4dxy.mafs.gz > ${COMP}_4dxy.mafs

#2
POP=aida
COMP=aida_lorentzi
MININD=3
angsd -bam $HOME_D/${POP}_bamlist_NR.txt -ref $REFGENOME -anc $ANC -rf $REGIONS -uniqueOnly 1 -P 20 -sites ${COMP}_NH_cut.mafs \
-remove_bads 1 -trim 0 -minMapQ 20 -minQ 20 -only_proper_pairs 0 -minInd $MININD \
-out ${COMP}_4dxy -doCounts 1 -doMaf 1 -doMajorMinor 1 \
-GL 1 -skipTriallelic 1

gunzip -c ${COMP}_4dxy.mafs.gz > ${COMP}_4dxy.mafs

#3
POP=aida
COMP=aida_moretoni
MININD=3
angsd -bam $HOME_D/${POP}_bamlist_NR.txt -ref $REFGENOME -anc $ANC -rf $REGIONS -uniqueOnly 1 -P 20 -sites ${COMP}_NH_cut.mafs \
-remove_bads 1 -trim 0 -minMapQ 20 -minQ 20 -only_proper_pairs 0 -minInd $MININD \
-out ${COMP}_4dxy -doCounts 1 -doMaf 1 -doMajorMinor 1 \
-GL 1 -skipTriallelic 1

gunzip -c ${COMP}_4dxy.mafs.gz > ${COMP}_4dxy.mafs

#4
POP=moretoni
COMP=aida_moretoni
MININD=5
angsd -bam $HOME_D/${POP}_bamlist_NR.txt -ref $REFGENOME -anc $ANC -rf $REGIONS -uniqueOnly 1 -P 20 -sites ${COMP}_NH_cut.mafs \
-remove_bads 1 -trim 0 -minMapQ 20 -minQ 20 -only_proper_pairs 0 -minInd $MININD \
-out ${COMP}_4dxy -doCounts 1 -doMaf 1 -doMajorMinor 1 \
-GL 1 -skipTriallelic 1

gunzip -c ${COMP}_4dxy.mafs.gz > ${COMP}_4dxy.mafs

#5
POP=moretoni
COMP=lorentzi_moretoni
MININD=5
angsd -bam $HOME_D/${POP}_bamlist_NR.txt -ref $REFGENOME -anc $ANC -rf $REGIONS -uniqueOnly 1 -P 20 -sites ${COMP}_NH_cut.mafs \
-remove_bads 1 -trim 0 -minMapQ 20 -minQ 20 -only_proper_pairs 0 -minInd $MININD \
-out ${COMP}_4dxy -doCounts 1 -doMaf 1 -doMajorMinor 1 \
-GL 1 -skipTriallelic 1

gunzip -c ${COMP}_4dxy.mafs.gz > ${COMP}_4dxy.mafs

#6
POP=moretoni
COMP=moretoni_naimii
MININD=5
angsd -bam $HOME_D/${POP}_bamlist_NR.txt -ref $REFGENOME -anc $ANC -rf $REGIONS -uniqueOnly 1 -P 20 -sites ${COMP}_NH_cut.mafs \
-remove_bads 1 -trim 0 -minMapQ 20 -minQ 20 -only_proper_pairs 0 -minInd $MININD \
-out ${COMP}_4dxy -doCounts 1 -doMaf 1 -doMajorMinor 1 \
-GL 1 -skipTriallelic 1

gunzip -c ${COMP}_4dxy.mafs.gz > ${COMP}_4dxy.mafs


#7
POP=lorentzi
COMP=aida_lorentzi
MININD=5
angsd -bam $HOME_D/${POP}_bamlist_NR.txt -ref $REFGENOME -anc $ANC -rf $REGIONS -uniqueOnly 1 -P 20 -sites ${COMP}_NH_cut.mafs \
-remove_bads 1 -trim 0 -minMapQ 20 -minQ 20 -only_proper_pairs 0 -minInd $MININD \
-out ${COMP}_4dxy -doCounts 1 -doMaf 1 -doMajorMinor 1 \
-GL 1 -skipTriallelic 1

gunzip -c ${COMP}_4dxy.mafs.gz > ${COMP}_4dxy.mafs

#8
POP=lorentzi
COMP=lorentzi_moretoni
MININD=5
angsd -bam $HOME_D/${POP}_bamlist_NR.txt -ref $REFGENOME -anc $ANC -rf $REGIONS -uniqueOnly 1 -P 20 -sites ${COMP}_NH_cut.mafs \
-remove_bads 1 -trim 0 -minMapQ 20 -minQ 20 -only_proper_pairs 0 -minInd $MININD \
-out ${COMP}_4dxy -doCounts 1 -doMaf 1 -doMajorMinor 1 \
-GL 1 -skipTriallelic 1

gunzip -c ${COMP}_4dxy.mafs.gz > ${COMP}_4dxy.mafs
