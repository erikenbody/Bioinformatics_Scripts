#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e angsd_sfs_a_02.err            # File to which STDERR will be written
#SBATCH -o angsd_sfs_a_02.out           # File to which STDOUT will be written
#SBATCH -J angsd_sfs_a           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=256000
#SBATCH --cpus-per-task=20
#SBATCH --time=6-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

#exceeded memory when set to 64gb
#remove coverage, add skipTriallelic

module load zlib/1.2.8
module load xz/5.2.2

HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/fst_angsd/auto/nocov_skiptri/

cd $WORK_D

if [ -d "Results" ]; then echo "Results file exists" ; else mkdir Results; fi

#variables
#POP=`cat $HOME_D/pop_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
RUN=autosome_scaffolds
REGIONS=$HOME_D/${RUN}.txt
#MINCOV=40 #.info file is 0.01 percentile here at global coverage
#MAXCOV=400 #well after last value, as in example

for POP in aida naimii lorentzi moretoni
do
 echo $POP
 MININD=$(if [[ "$POP"  == "aida" ]]; then echo 4; else echo 5; fi)
 BAMLIST=$HOME_D/${POP}_bamlist.txt
 angsd -b $BAMLIST -ref $REFGENOME -anc $REFGENOME -out Results/${POP}.${RUN}.ref -rf $REGIONS -P 20\
               -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 0 -trim 0 \
               -minMapQ 20 -minQ 20 -minInd $MININD -doCounts 1 \
               -GL 1 -doSaf 1
 realSFS Results/${POP}.${RUN}.ref.saf.idx -P 20 > Results/${POP}.${RUN}.ref.sfs
done

POP1=aida
POP2=naimii
POP3=lorentzi
POP4=moretoni

realSFS -P 20 Results/${POP1}.${RUN}.ref.saf.idx Results/${POP2}.${RUN}.ref.saf.idx > Results/${POP1}_${POP2}.sfs
realSFS -P 20 Results/${POP1}.${RUN}.ref.saf.idx Results/${POP3}.${RUN}.ref.saf.idx > Results/${POP1}_${POP3}.sfs
realSFS -P 20 Results/${POP1}.${RUN}.ref.saf.idx Results/${POP4}.${RUN}.ref.saf.idx > Results/${POP1}_${POP4}.sfs
realSFS -P 20 Results/${POP2}.${RUN}.ref.saf.idx Results/${POP3}.${RUN}.ref.saf.idx > Results/${POP2}_${POP3}.sfs
realSFS -P 20 Results/${POP2}.${RUN}.ref.saf.idx Results/${POP4}.${RUN}.ref.saf.idx > Results/${POP2}_${POP4}.sfs
realSFS -P 20 Results/${POP3}.${RUN}.ref.saf.idx Results/${POP4}.${RUN}.ref.saf.idx > Results/${POP3}_${POP4}.sfs

realSFS fst index Results/${POP1}.${RUN}.ref.saf.idx Results/${POP2}.${RUN}.ref.saf.idx -sfs Results/${POP1}_${POP2}.sfs -fstout Results/${POP1}_${POP2}.pbs -whichFST 0
realSFS fst index Results/${POP1}.${RUN}.ref.saf.idx Results/${POP3}.${RUN}.ref.saf.idx -sfs Results/${POP1}_${POP3}.sfs -fstout Results/${POP1}_${POP3}.pbs -whichFST 0
realSFS fst index Results/${POP1}.${RUN}.ref.saf.idx Results/${POP4}.${RUN}.ref.saf.idx -sfs Results/${POP1}_${POP4}.sfs -fstout Results/${POP1}_${POP4}.pbs -whichFST 0
realSFS fst index Results/${POP2}.${RUN}.ref.saf.idx Results/${POP3}.${RUN}.ref.saf.idx -sfs Results/${POP2}_${POP3}.sfs -fstout Results/${POP2}_${POP3}.pbs -whichFST 0
realSFS fst index Results/${POP2}.${RUN}.ref.saf.idx Results/${POP4}.${RUN}.ref.saf.idx -sfs Results/${POP2}_${POP4}.sfs -fstout Results/${POP2}_${POP4}.pbs -whichFST 0
realSFS fst index Results/${POP3}.${RUN}.ref.saf.idx Results/${POP4}.${RUN}.ref.saf.idx -sfs Results/${POP3}_${POP4}.sfs -fstout Results/${POP3}_${POP4}.pbs -whichFST 0

realSFS fst stats2 Results/${POP1}_${POP2}.pbs.fst.idx -win 50000 -step 10000 -whichFST 0 > Results/${POP1}_${POP2}_a.pbs.txt
realSFS fst stats2 Results/${POP1}_${POP3}.pbs.fst.idx -win 50000 -step 10000 -whichFST 0 > Results/${POP1}_${POP3}_a.pbs.txt
realSFS fst stats2 Results/${POP1}_${POP4}.pbs.fst.idx -win 50000 -step 10000 -whichFST 0 > Results/${POP1}_${POP4}_a.pbs.txt
realSFS fst stats2 Results/${POP2}_${POP3}.pbs.fst.idx -win 50000 -step 10000 -whichFST 0 > Results/${POP2}_${POP3}_a.pbs.txt
realSFS fst stats2 Results/${POP2}_${POP4}.pbs.fst.idx -win 50000 -step 10000 -whichFST 0 > Results/${POP2}_${POP4}_a.pbs.txt
realSFS fst stats2 Results/${POP3}_${POP4}.pbs.fst.idx -win 50000 -step 10000 -whichFST 0 > Results/${POP3}_${POP4}_a.pbs.txt

#no step - ran seperately 9mar18
realSFS fst stats2 Results/${POP1}_${POP2}.pbs.fst.idx -win 50000 -step 50000 -whichFST 0 > Results/NoStep/${POP1}_${POP2}_a.pbs_NS.txt
realSFS fst stats2 Results/${POP1}_${POP3}.pbs.fst.idx -win 50000 -step 50000 -whichFST 0 > Results/NoStep/${POP1}_${POP3}_a.pbs_NS.txt
realSFS fst stats2 Results/${POP1}_${POP4}.pbs.fst.idx -win 50000 -step 50000 -whichFST 0 > Results/NoStep/${POP1}_${POP4}_a.pbs_NS.txt
realSFS fst stats2 Results/${POP2}_${POP3}.pbs.fst.idx -win 50000 -step 50000 -whichFST 0 > Results/NoStep/${POP2}_${POP3}_a.pbs_NS.txt
realSFS fst stats2 Results/${POP2}_${POP4}.pbs.fst.idx -win 50000 -step 50000 -whichFST 0 > Results/NoStep/${POP2}_${POP4}_a.pbs_NS.txt
realSFS fst stats2 Results/${POP3}_${POP4}.pbs.fst.idx -win 50000 -step 50000 -whichFST 0 > Results/NoStep/${POP3}_${POP4}_a.pbs_NS.txt


if [ -d "Results_whichFST1" ]; then echo "Results file exists" ; else mkdir Results_whichFST1; fi
realSFS fst index Results_whichFST1/${POP1}.${RUN}.ref.saf.idx Results_whichFST1/${POP2}.${RUN}.ref.saf.idx -sfs Results_whichFST1/${POP1}_${POP2}.sfs -fstout Results_whichFST1/${POP1}_${POP2}.pbs -whichFST 1
realSFS fst index Results_whichFST1/${POP1}.${RUN}.ref.saf.idx Results_whichFST1/${POP3}.${RUN}.ref.saf.idx -sfs Results_whichFST1/${POP1}_${POP3}.sfs -fstout Results_whichFST1/${POP1}_${POP3}.pbs -whichFST 1
realSFS fst index Results_whichFST1/${POP1}.${RUN}.ref.saf.idx Results_whichFST1/${POP4}.${RUN}.ref.saf.idx -sfs Results_whichFST1/${POP1}_${POP4}.sfs -fstout Results_whichFST1/${POP1}_${POP4}.pbs -whichFST 1
realSFS fst index Results_whichFST1/${POP2}.${RUN}.ref.saf.idx Results_whichFST1/${POP3}.${RUN}.ref.saf.idx -sfs Results_whichFST1/${POP2}_${POP3}.sfs -fstout Results_whichFST1/${POP2}_${POP3}.pbs -whichFST 1
realSFS fst index Results_whichFST1/${POP2}.${RUN}.ref.saf.idx Results_whichFST1/${POP4}.${RUN}.ref.saf.idx -sfs Results_whichFST1/${POP2}_${POP4}.sfs -fstout Results_whichFST1/${POP2}_${POP4}.pbs -whichFST 1
realSFS fst index Results_whichFST1/${POP3}.${RUN}.ref.saf.idx Results_whichFST1/${POP4}.${RUN}.ref.saf.idx -sfs Results_whichFST1/${POP3}_${POP4}.sfs -fstout Results_whichFST1/${POP3}_${POP4}.pbs -whichFST 1

realSFS fst stats2 Results_whichFST1/${POP1}_${POP2}.pbs.fst.idx -win 50000 -step 10000 -whichFST 1 > Results_whichFST1/${POP1}_${POP2}_a.pbs.txt
realSFS fst stats2 Results_whichFST1/${POP1}_${POP3}.pbs.fst.idx -win 50000 -step 10000 -whichFST 1 > Results_whichFST1/${POP1}_${POP3}_a.pbs.txt
realSFS fst stats2 Results_whichFST1/${POP1}_${POP4}.pbs.fst.idx -win 50000 -step 10000 -whichFST 1 > Results_whichFST1/${POP1}_${POP4}_a.pbs.txt
realSFS fst stats2 Results_whichFST1/${POP2}_${POP3}.pbs.fst.idx -win 50000 -step 10000 -whichFST 1 > Results_whichFST1/${POP2}_${POP3}_a.pbs.txt
realSFS fst stats2 Results_whichFST1/${POP2}_${POP4}.pbs.fst.idx -win 50000 -step 10000 -whichFST 1 > Results_whichFST1/${POP2}_${POP4}_a.pbs.txt
realSFS fst stats2 Results_whichFST1/${POP3}_${POP4}.pbs.fst.idx -win 50000 -step 10000 -whichFST 1 > Results_whichFST1/${POP3}_${POP4}_a.pbs.txt

#workspace
realSFS fst index Results/${POP1}.${RUN}.ref.saf.idx Results/${POP2}.${RUN}.ref.saf.idx -sfs Results/${POP1}_${POP2}.sfs -fstout Results/test1.pbs -whichFST 0
realSFS fst stats2 Results/${POP1}_${POP2}.pbs.fst.idx -win 50000 -whichFST 0 > Results/TEST1_a.pbs.txt
