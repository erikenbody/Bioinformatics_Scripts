#!/bin/bash
module load zlib/1.2.8
module load xz/5.2.2

HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/fst_angsd/auto/nocov_NR/Results
OTHER_D=/home/eenbody/reseq_WD/angsd/fst_angsd/auto/aida_more_combined_NR/

cd $WORK_D

#variables
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
RUN=scaff_test
REGIONS=$HOME_D/${RUN}.txt

POP1=aida
POP2=naimii
POP3=lorentzi
POP4=moretoni
CHR=autosomes

for POP in aida naimii
do
  echo $POP
  MININD=$(if [[ "$POP" == "aida-more" ]]; then echo 8; elif [[ "$POP" == "lorentzi" ]]; then echo 5; elif [[ "$POP" == "naimii" ]]; then echo 4; elif [[ "$POP" == "aida" ]]; then echo 3; elif [[ "$POP" == "moretoni" ]]; then echo 5; fi)
  BAMLIST=$HOME_D/${POP}_bamlist_NR.txt
  angsd -b $BAMLIST -ref $REFGENOME -anc $REFGENOME -out test/${POP}.${RUN}.ref -rf $REGIONS -P 20\
                -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 0 -trim 0 \
                -minMapQ 20 -minQ 20 -minInd $MININD -doCounts 1 \
                -GL 1 -doSaf 1
done

realSFS -P 20 test/${POP1}.${RUN}.ref.saf.idx test/${POP2}.${RUN}.ref.saf.idx > test/${POP1}_${POP2}.sfs

realSFS fst index test/${POP1}.${RUN}.ref.saf.idx test/${POP2}.${RUN}.ref.saf.idx -sfs test/${POP1}_${POP2}.sfs -fstout test/${POP1}_${POP2}.pbs -whichFST 0

realSFS fst stats2 test/${POP1}_${POP2}.pbs.fst.idx -win 50000 -step 50000 -whichFST 0 > test/${POP1}_${POP2}_${SUBSET}.fst.txt
