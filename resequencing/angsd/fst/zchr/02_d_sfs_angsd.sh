#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e angsd_2d_sfs.err            # File to which STDERR will be written
#SBATCH -o angsd_2d_sfs.out           # File to which STDOUT will be written
#SBATCH -J angsd_2d_sfs    # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load zlib/1.2.8
module load xz/5.2.2

HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/fst_angsd/zchr/cov_40_400_20Q/

cd $WORK_D

#easier to just write this custom then make it repeatable.

realSFS -P 20 Results/aida.zchr_scaffolds.ref.saf.idx Results/lorentzi.zchr_scaffolds.ref.saf.idx > Results/aida_lorentzi.sfs

realSFS -P 20 Results/aida.zchr_scaffolds.ref.saf.idx Results/moretoni.zchr_scaffolds.ref.saf.idx > Results/aida_moretoni.sfs

realSFS -P 20 Results/aida.zchr_scaffolds.ref.saf.idx Results/naimii.zchr_scaffolds.ref.saf.idx > Results/aida_naimii.sfs

realSFS -P 20 Results/moretoni.zchr_scaffolds.ref.saf.idx Results/lorentzi.zchr_scaffolds.ref.saf.idx > Results/moretoni_lorentzi.sfs

realSFS -P 20 Results/moretoni.zchr_scaffolds.ref.saf.idx Results/naimii.zchr_scaffolds.ref.saf.idx > Results/moretoni_naimii.sfs

realSFS -P 20 Results/naimii.zchr_scaffolds.ref.saf.idx Results/lorentzi.zchr_scaffolds.ref.saf.idx > Results/naimii_lorentzi.sfs

#just didnt work
#realSFS fst index Results/moretoni.zchr_scaffolds.ref.saf.idx Results/lorentzi.zchr_scaffolds.ref.saf.idx Results/naimii.zchr_scaffolds.ref.saf.idx Results/aida.zchr_scaffolds.ref.saf.idx -sfs Results/aida_lorentzi.sfs -sfs Results/aida_moretoni.sfs -sfs Results/aida_naimii.sfs -sfs Results/moretoni_lorentzi.sfs -sfs Results/naimii_lorentzi.sfs -fstout Results/WSFW.pbs -whichFST 1

#remove naimii, issue with nsites? confused
#realSFS fst index Results/moretoni.zchr_scaffolds.ref.saf.idx Results/lorentzi.zchr_scaffolds.ref.saf.idx Results/aida.zchr_scaffolds.ref.saf.idx -sfs Results/aida_lorentzi.sfs -sfs Results/aida_moretoni.sfs -sfs Results/moretoni_lorentzi.sfs -fstout Results/WSFW.pbs -whichFST 1

realSFS fst index Results/aida.zchr_scaffolds.ref.saf.idx Results/lorentzi.zchr_scaffolds.ref.saf.idx -sfs Results/aida_lorentzi.sfs -fstout Results/aida_lore.pbs -whichFST 1

realSFS fst index Results/aida.zchr_scaffolds.ref.saf.idx Results/moretoni.zchr_scaffolds.ref.saf.idx -sfs Results/aida_moretoni.sfs -fstout Results/aida_more.pbs -whichFST 1

realSFS fst index Results/aida.zchr_scaffolds.ref.saf.idx Results/naimii.zchr_scaffolds.ref.saf.idx -sfs Results/aida_naimii.sfs -fstout Results/aida_naimi.pbs -whichFST 1

#also ran without whichFST
#realSFS fst index Results/aida.zchr_scaffolds.ref.saf.idx Results/naimii.zchr_scaffolds.ref.saf.idx -sfs Results/aida_naimii.sfs -fstout Results/aida_naimi2.pbs

realSFS fst index Results/moretoni.zchr_scaffolds.ref.saf.idx Results/lorentzi.zchr_scaffolds.ref.saf.idx -sfs Results/moretoni_lorentzi.sfs -fstout Results/more_lore.pbs -whichFST 1

realSFS fst index Results/moretoni.zchr_scaffolds.ref.saf.idx Results/naimii.zchr_scaffolds.ref.saf.idx -sfs Results/moretoni_naimii.sfs -fstout Results/more_naimi.pbs -whichFST 1

realSFS fst index Results/naimii.zchr_scaffolds.ref.saf.idx Results/lorentzi.zchr_scaffolds.ref.saf.idx -sfs Results/naimii_lorentzi.sfs -fstout Results/naimi_lore.pbs -whichFST 1

#sliding window

realSFS fst stats2 Results/aida_lore.pbs.fst.idx -win 50000 -step 10000 -whichFST 1 > Results/aida_lore.pbs.txt

realSFS fst stats2 Results/aida_more.pbs.fst.idx -win 50000 -step 10000 -whichFST 1 > Results/aida_more.pbs.txt

realSFS fst stats2 Results/aida_naimi.pbs.fst.idx -win 50000 -step 10000 -whichFST 1 > Results/aida_naimi.pbs.txt

realSFS fst stats2 Results/more_lore.pbs.fst.idx -win 50000 -step 10000 -whichFST 1 > Results/more_lore.pbs.txt

realSFS fst stats2 Results/more_naimi.pbs.fst.idx -win 50000 -step 10000 -whichFST 1 > Results/more_naimi.pbs.txt

realSFS fst stats2 Results/naimi_lore.pbs.fst.idx -win 50000 -step 10000 -whichFST 1 > Results/naimi_lore.pbs.txt

realSFS fst stats2 Results/aida_lore.pbs.fst.idx -win 25000 -step 5000 -whichFST 1 > Results/aida_lore25.pbs.txt

realSFS fst stats2 Results/aida_lore.pbs.fst.idx -win 5000 -step 1000 -whichFST 1 > Results/aida_lore5.pbs.txt

realSFS fst stats2 Results/aida_naimi.pbs.fst.idx -win 5000 -step 1000 -whichFST 1 > Results/aida_naimi5.pbs.txt

realSFS fst stats2 Results/aida_naimi.pbs.fst.idx -win 1000 -step 100 -whichFST 1 > Results/aida_naimi1.pbs.txt

realSFS fst stats2 Results/aida_naimi.pbs.fst.idx -win 100000 -step 100000 -whichFST 1 > Results/aida_naimi100.pbs.txt

realSFS fst stats2 Results/aida_naimi.pbs.fst.idx -win 25000 -step 25000 -whichFST 1 > Results/aida_naimi25.pbs.txt

#run without whichFST
realSFS fst stats2 Results/aida_naimi2.pbs.fst.idx -win 25000 -step 10000 -whichFST 1 > Results/aida_naimi_v2.pbs.txt
