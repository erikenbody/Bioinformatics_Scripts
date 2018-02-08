#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e angsds4dxy.1.err            # File to which STDERR will be written
#SBATCH -o angsds4dxy.1.out           # File to which STDOUT will be written
#SBATCH -J angsds4dxy           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to
#
module load zlib/1.2.8
module load xz/5.2.2
#

#variables
HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/dxy
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
ANC=/home/eenbody/reseq_WD/phylotree/Results/rbfw_correct.fasta
RUN=autosome_scaffolds
REGIONS=$HOME_D/${RUN}.txt
N_samp=32

cd $WORK_D

angsd -bam $HOME_D/lorentzi_moretoni_bamlist_NR.txt -ref $REFGENOME -anc $ANC -rf $REGIONS -uniqueOnly 1 -P 20 \
-remove_bads 1 -trim 0 -minMapQ 20 -minQ 20 -minMaf 0.01 -only_proper_pairs 0 -minInd 9 \
-out lorentzi_moretoni -doCounts 1 -doMaf 2 -doMajorMinor 4 \
-GL 1 -skipTriallelic 1 -SNP_pval 1e-6

gunzip -c lorentzi_moretoni.mafs.gz > lorentzi_moretoni.mafs
sed '1d' lorentzi_moretoni.mafs > lorentzi_moretoni_NH.mafs
cut -f 1-4 lorentzi_moretoni_NH.mafs > lorentzi_moretoni_NH_cut.mafs
angsd sites index lorentzi_moretoni_NH_cut.mafs
