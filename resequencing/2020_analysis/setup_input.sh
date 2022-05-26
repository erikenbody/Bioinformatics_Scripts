#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e angsd2020.err            # File to which STDERR will be written
#SBATCH -o angsd2020.out           # File to which STDOUT will be written
#SBATCH -J angsd2020           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=128000 #originally 256000 for full thing
#SBATCH --cpus-per-task=20
#SBATCH --time=7-00:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load zlib/1.2.8
module load xz/5.2.2
module load gcc/6.3.0
HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/2020_analysis/
RUN=upd

cd $WORK_D

#basically dont remove not relatives, use new angsd, fold spectra correctly before 2dsfs, and setup for beagle

REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta

for POP in aida moretoni lorentzi naimii
do
  echo $POP
  MININD=$(if [[ "$POP"  == "aida" ]]; then echo 4; else echo 5; fi)
  BAMLIST=$HOME_D/${POP}_bamlist.txt

  /lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/angsd -ref $REFGENOME -anc $REFGENOME \
                -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 0 -trim 0 \
                -GL 2 -out ${POP}_4pca -nThreads 20 -doGlf 2 -doMajorMinor 1 -doMaf 1 -SNP_pval 1e-6 -bam $BAMLIST
  echo done $POP beagle
  /lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/angsd -b $BAMLIST -ref $REFGENOME -anc $REFGENOME \
                -out ${POP}.${RUN}.ref -P 20 \
                -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 0 -trim 0 \
                -minMapQ 20 -minQ 20 -minInd $MININD -doCounts 1 \
                -GL 1 -doSaf 1

done

POP1=aida
POP2=naimii
POP3=lorentzi
POP4=moretoni

#SFS for all between pop comparisons
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS -P 20 ${POP1}.${RUN}.ref.saf.idx ${POP2}.${RUN}.ref.saf.idx -fold 1 > ${POP1}_${POP2}.sfs
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS -P 20 ${POP1}.${RUN}.ref.saf.idx ${POP3}.${RUN}.ref.saf.idx -fold 1 > ${POP1}_${POP3}.sfs
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS -P 20 ${POP1}.${RUN}.ref.saf.idx ${POP4}.${RUN}.ref.saf.idx -fold 1 > ${POP1}_${POP4}.sfs
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS -P 20 ${POP2}.${RUN}.ref.saf.idx ${POP3}.${RUN}.ref.saf.idx -fold 1 > ${POP2}_${POP3}.sfs
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS -P 20 ${POP2}.${RUN}.ref.saf.idx ${POP4}.${RUN}.ref.saf.idx -fold 1 > ${POP2}_${POP4}.sfs
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS -P 20 ${POP3}.${RUN}.ref.saf.idx ${POP4}.${RUN}.ref.saf.idx -fold 1 > ${POP3}_${POP4}.sfs

#fst for all between pop comparions
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS fst index ${POP1}.${RUN}.ref.saf.idx ${POP2}.${RUN}.ref.saf.idx -sfs ${POP1}_${POP2}.sfs -fstout ${POP1}_${POP2} -whichFST 0
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS fst index ${POP1}.${RUN}.ref.saf.idx ${POP3}.${RUN}.ref.saf.idx -sfs ${POP1}_${POP3}.sfs -fstout ${POP1}_${POP3} -whichFST 0
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS fst index ${POP1}.${RUN}.ref.saf.idx ${POP4}.${RUN}.ref.saf.idx -sfs ${POP1}_${POP4}.sfs -fstout ${POP1}_${POP4} -whichFST 0
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS fst index ${POP2}.${RUN}.ref.saf.idx ${POP3}.${RUN}.ref.saf.idx -sfs ${POP2}_${POP3}.sfs -fstout ${POP2}_${POP3} -whichFST 0
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS fst index ${POP2}.${RUN}.ref.saf.idx ${POP4}.${RUN}.ref.saf.idx -sfs ${POP2}_${POP4}.sfs -fstout ${POP2}_${POP4} -whichFST 0
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS fst index ${POP3}.${RUN}.ref.saf.idx ${POP4}.${RUN}.ref.saf.idx -sfs ${POP3}_${POP4}.sfs -fstout ${POP3}_${POP4} -whichFST 0

#run sliding window analysis
SUBSET=50kb
WINDOW=50000
STEP=10000

#calc Fst per window
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS fst stats2 ${POP1}_${POP2}.fst.idx -win $WINDOW -step $STEP -whichFST 0 > ${POP1}_${POP2}_${SUBSET}.txt
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS fst stats2 ${POP1}_${POP3}.fst.idx -win $WINDOW -step $STEP -whichFST 0 > ${POP1}_${POP3}_${SUBSET}.txt
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS fst stats2 ${POP1}_${POP4}.fst.idx -win $WINDOW -step $STEP -whichFST 0 > ${POP1}_${POP4}_${SUBSET}.txt
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS fst stats2 ${POP2}_${POP3}.fst.idx -win $WINDOW -step $STEP -whichFST 0 > ${POP2}_${POP3}_${SUBSET}.txt
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS fst stats2 ${POP2}_${POP4}.fst.idx -win $WINDOW -step $STEP -whichFST 0 > ${POP2}_${POP4}_${SUBSET}.txt
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS fst stats2 ${POP3}_${POP4}.fst.idx -win $WINDOW -step $STEP -whichFST 0 > ${POP3}_${POP4}_${SUBSET}.txt

#no step
STEP=50000

/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS fst stats2 ${POP1}_${POP2}.fst.idx -win $WINDOW -step $STEP -whichFST 0 > ${POP1}_${POP2}_${SUBSET}_NS.txt
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS fst stats2 ${POP1}_${POP3}.fst.idx -win $WINDOW -step $STEP -whichFST 0 > ${POP1}_${POP3}_${SUBSET}_NS.txt
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS fst stats2 ${POP1}_${POP4}.fst.idx -win $WINDOW -step $STEP -whichFST 0 > ${POP1}_${POP4}_${SUBSET}_NS.txt
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS fst stats2 ${POP2}_${POP3}.fst.idx -win $WINDOW -step $STEP -whichFST 0 > ${POP2}_${POP3}_${SUBSET}_NS.txt
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS fst stats2 ${POP2}_${POP4}.fst.idx -win $WINDOW -step $STEP -whichFST 0 > ${POP2}_${POP4}_${SUBSET}_NS.txt
/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/misc/realSFS fst stats2 ${POP3}_${POP4}.fst.idx -win $WINDOW -step $STEP -whichFST 0 > ${POP3}_${POP4}_${SUBSET}_NS.txt
