#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e angsd_high_filt2.err            # File to which STDERR will be written
#SBATCH -o angsd_high_filt2.out           # File to which STDOUT will be written
#SBATCH -J angsd_high_filt          # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=6-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

#exceeded memory when set to 64gb

module load zlib/1.2.8
module load xz/5.2.2

HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/fst_angsd/auto/high_filter_allInd/

cd $WORK_D

if [ -d "Results" ]; then echo "Results file exists" ; else mkdir Results; fi

#variables
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
RUN=autosome_scaffolds
REGIONS=$HOME_D/${RUN}.txt
DESCRIPTION=all_HighFilt

for POP in aida naimii lorentzi moretoni
do
 echo $POP
 MININD=$(if [[ "$POP"  == "aida" ]]; then echo 4; else echo 5; fi)
 BAMLIST=$HOME_D/${POP}_bamlist.txt
 angsd -b $BAMLIST -ref $REFGENOME -anc $REFGENOME -out Results/${POP}.${RUN}_${DESCRIPTION}.ref -rf $REGIONS -P 20 \
               -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 0 -trim 0 \
               -minMapQ 20 -minQ 20 -setMinDepth 2.26 -setMaxDepth 9.04 -SNP_pval 1e-6 -minInd $MININD -minMaf 0.01 \
               -doCounts 1 \
               -doMaf 1 -doMajorMinor 1 -GL 1 -doSaf 1
done

POP1=aida
POP2=naimii
POP3=lorentzi
POP4=moretoni

realSFS -P 20 Results/${POP1}.${RUN}_${DESCRIPTION}.ref.saf.idx Results/${POP2}.${RUN}_${DESCRIPTION}.ref.saf.idx > Results/${POP1}_${POP2}_${DESCRIPTION}.sfs
realSFS -P 20 Results/${POP1}.${RUN}_${DESCRIPTION}.ref.saf.idx Results/${POP3}.${RUN}_${DESCRIPTION}.ref.saf.idx > Results/${POP1}_${POP3}_${DESCRIPTION}.sfs
realSFS -P 20 Results/${POP1}.${RUN}_${DESCRIPTION}.ref.saf.idx Results/${POP4}.${RUN}_${DESCRIPTION}.ref.saf.idx > Results/${POP1}_${POP4}_${DESCRIPTION}.sfs
realSFS -P 20 Results/${POP2}.${RUN}_${DESCRIPTION}.ref.saf.idx Results/${POP3}.${RUN}_${DESCRIPTION}.ref.saf.idx > Results/${POP2}_${POP3}_${DESCRIPTION}.sfs
realSFS -P 20 Results/${POP2}.${RUN}_${DESCRIPTION}.ref.saf.idx Results/${POP4}.${RUN}_${DESCRIPTION}.ref.saf.idx > Results/${POP2}_${POP4}_${DESCRIPTION}.sfs
realSFS -P 20 Results/${POP3}.${RUN}_${DESCRIPTION}.ref.saf.idx Results/${POP4}.${RUN}_${DESCRIPTION}.ref.saf.idx > Results/${POP3}_${POP4}_${DESCRIPTION}.sfs
