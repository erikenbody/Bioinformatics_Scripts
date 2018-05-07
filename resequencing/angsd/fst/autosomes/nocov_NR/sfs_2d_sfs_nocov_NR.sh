#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e angsd_sfs_a_03.err            # File to which STDERR will be written
#SBATCH -o angsd_sfs_a_03.out           # File to which STDOUT will be written
#SBATCH -J angsd_sfs_a           # Job name
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
module load R/3.4.1-intel
export R_LIBS_USER=/home/eenbody/BI_software/R/Library:$R_LIBS_USER

HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/fst_angsd/auto/nocov_NR/
OTHER_D=/home/eenbody/reseq_WD/angsd/fst_angsd/auto/aida_more_combined_NR/

cd $WORK_D

if [ -d "Results" ]; then echo "Results file exists" ; else mkdir Results; fi

#variables
#POP=`cat $HOME_D/pop_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
RUN=autosome_scaffolds
REGIONS=$HOME_D/${RUN}.txt
#MINCOV=40 #.info file is 0.01 percentile here at global coverage
#MAXCOV=400 #well after last value, as in example

POP1=aida
POP2=naimii
POP3=lorentzi
POP4=moretoni
CHR=autosomes

#make soft link for lorentzi and naimii
cd Results
ln -s $OTHER_D/Results/${POP2}.${RUN}.ref.saf.idx .
ln -s $OTHER_D/Results/${POP2}.${RUN}.ref.saf.gz .
ln -s $OTHER_D/Results/${POP2}.${RUN}.ref.saf.pos.gz .
ln -s $OTHER_D/Results/${POP3}.${RUN}.ref.saf.idx .
ln -s $OTHER_D/Results/${POP3}.${RUN}.ref.saf.gz .
ln -s $OTHER_D/Results/${POP3}.${RUN}.ref.saf.pos.gz .
ln -s $OTHER_D/Results/${POP2}_${POP3}.sfs .
ln -s $OTHER_D/Results/${POP2}_${POP3}.pbs* .
cd ..

for POP in aida moretoni
do
  echo $POP
  MININD=$(if [[ "$POP" == "aida-more" ]]; then echo 8; elif [[ "$POP" == "lorentzi" ]]; then echo 5; elif [[ "$POP" == "naimii" ]]; then echo 4; elif [[ "$POP" == "aida" ]]; then echo 3; elif [[ "$POP" == "moretoni" ]]; then echo 5; fi)
  BAMLIST=$HOME_D/${POP}_bamlist_NR.txt
  angsd -b $BAMLIST -ref $REFGENOME -anc $REFGENOME -out Results/${POP}.${RUN}.ref -rf $REGIONS -P 20\
                -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 0 -trim 0 \
                -minMapQ 20 -minQ 20 -minInd $MININD -doCounts 1 \
                -GL 1 -doSaf 1
  realSFS Results/${POP}.${RUN}.ref.saf.idx -P 20 > Results/${POP}.${RUN}.ref.sfs
done

#SFS for all between pop comparisons
realSFS -P 20 Results/${POP1}.${RUN}.ref.saf.idx Results/${POP2}.${RUN}.ref.saf.idx > Results/${POP1}_${POP2}.sfs
realSFS -P 20 Results/${POP1}.${RUN}.ref.saf.idx Results/${POP3}.${RUN}.ref.saf.idx > Results/${POP1}_${POP3}.sfs
realSFS -P 20 Results/${POP1}.${RUN}.ref.saf.idx Results/${POP4}.${RUN}.ref.saf.idx > Results/${POP1}_${POP4}.sfs
#realSFS -P 20 Results/${POP2}.${RUN}.ref.saf.idx Results/${POP3}.${RUN}.ref.saf.idx > Results/${POP2}_${POP3}.sfs
realSFS -P 20 Results/${POP2}.${RUN}.ref.saf.idx Results/${POP4}.${RUN}.ref.saf.idx > Results/${POP2}_${POP4}.sfs
realSFS -P 20 Results/${POP3}.${RUN}.ref.saf.idx Results/${POP4}.${RUN}.ref.saf.idx > Results/${POP3}_${POP4}.sfs

#fst for all between pop comparions
realSFS fst index Results/${POP1}.${RUN}.ref.saf.idx Results/${POP2}.${RUN}.ref.saf.idx -sfs Results/${POP1}_${POP2}.sfs -fstout Results/${POP1}_${POP2}.pbs -whichFST 0
realSFS fst index Results/${POP1}.${RUN}.ref.saf.idx Results/${POP3}.${RUN}.ref.saf.idx -sfs Results/${POP1}_${POP3}.sfs -fstout Results/${POP1}_${POP3}.pbs -whichFST 0
realSFS fst index Results/${POP1}.${RUN}.ref.saf.idx Results/${POP4}.${RUN}.ref.saf.idx -sfs Results/${POP1}_${POP4}.sfs -fstout Results/${POP1}_${POP4}.pbs -whichFST 0
#realSFS fst index Results/${POP2}.${RUN}.ref.saf.idx Results/${POP3}.${RUN}.ref.saf.idx -sfs Results/${POP2}_${POP3}.sfs -fstout Results/${POP2}_${POP3}.pbs -whichFST 0
realSFS fst index Results/${POP2}.${RUN}.ref.saf.idx Results/${POP4}.${RUN}.ref.saf.idx -sfs Results/${POP2}_${POP4}.sfs -fstout Results/${POP2}_${POP4}.pbs -whichFST 0
realSFS fst index Results/${POP3}.${RUN}.ref.saf.idx Results/${POP4}.${RUN}.ref.saf.idx -sfs Results/${POP3}_${POP4}.sfs -fstout Results/${POP3}_${POP4}.pbs -whichFST 0

#run sliding window analysis
if [ -d "Results/ManPlots" ]; then echo "ManPlot dir exists" ; else mkdir Results/ManPlots; fi
SUBSET=NR50kb
WINDOW=50000
STEP=10000

#calc Fst per window
realSFS fst stats2 Results/${POP1}_${POP2}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/${POP1}_${POP2}_${SUBSET}.pbs.txt
realSFS fst stats2 Results/${POP1}_${POP3}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/${POP1}_${POP3}_${SUBSET}.pbs.txt
realSFS fst stats2 Results/${POP1}_${POP4}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/${POP1}_${POP4}_${SUBSET}.pbs.txt
realSFS fst stats2 Results/${POP2}_${POP3}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/${POP2}_${POP3}_${SUBSET}.pbs.txt
realSFS fst stats2 Results/${POP2}_${POP4}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/${POP2}_${POP4}_${SUBSET}.pbs.txt
realSFS fst stats2 Results/${POP3}_${POP4}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/${POP3}_${POP4}_${SUBSET}.pbs.txt

#no step - Mar9
STEP=50000

realSFS fst stats2 Results/${POP1}_${POP2}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/NoStep/${POP1}_${POP2}_${SUBSET}.pbs_NS.txt
realSFS fst stats2 Results/${POP1}_${POP3}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/NoStep/${POP1}_${POP3}_${SUBSET}.pbs_NS.txt
realSFS fst stats2 Results/${POP1}_${POP4}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/NoStep/${POP1}_${POP4}_${SUBSET}.pbs_NS.txt
realSFS fst stats2 Results/${POP2}_${POP3}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/NoStep/${POP2}_${POP3}_${SUBSET}.pbs_NS.txt
realSFS fst stats2 Results/${POP2}_${POP4}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/NoStep/${POP2}_${POP4}_${SUBSET}.pbs_NS.txt
realSFS fst stats2 Results/${POP3}_${POP4}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/NoStep/${POP3}_${POP4}_${SUBSET}.pbs_NS.txt

WINDOW=15000
STEP=15000
SUBSET=NR15kb
realSFS fst stats2 Results/${POP1}_${POP2}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/NoStep/${POP1}_${POP2}_${SUBSET}.pbs_NS.txt
realSFS fst stats2 Results/${POP1}_${POP3}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/NoStep/${POP1}_${POP3}_${SUBSET}.pbs_NS.txt
realSFS fst stats2 Results/${POP1}_${POP4}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/NoStep/${POP1}_${POP4}_${SUBSET}.pbs_NS.txt
realSFS fst stats2 Results/${POP2}_${POP3}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/NoStep/${POP2}_${POP3}_${SUBSET}.pbs_NS.txt
realSFS fst stats2 Results/${POP2}_${POP4}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/NoStep/${POP2}_${POP4}_${SUBSET}.pbs_NS.txt
realSFS fst stats2 Results/${POP3}_${POP4}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/NoStep/${POP3}_${POP4}_${SUBSET}.pbs_NS.txt


#make manhattan plots - fst, zfst, filtered fst, filtered zfst
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP1}_${POP2}_${SUBSET}.pbs.txt -c ${POP1}_${POP2}_${CHR}_${SUBSET} -o Results/ManPlots/${POP1}_${POP2}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP1}_${POP3}_${SUBSET}.pbs.txt -c ${POP1}_${POP3}_${CHR}_${SUBSET} -o Results/ManPlots/${POP1}_${POP3}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP1}_${POP4}_${SUBSET}.pbs.txt -c ${POP1}_${POP4}_${CHR}_${SUBSET} -o Results/ManPlots/${POP1}_${POP4}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP2}_${POP3}_${SUBSET}.pbs.txt -c ${POP2}_${POP3}_${CHR}_${SUBSET} -o Results/ManPlots/${POP2}_${POP3}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP3}_${POP4}_${SUBSET}.pbs.txt -c ${POP3}_${POP4}_${CHR}_${SUBSET} -o Results/ManPlots/${POP3}_${POP4}_${CHR}_${SUBSET}.pdf

#run with different presents
SUBSET=NR25kb
WINDOW=25000
STEP=5000

realSFS fst stats2 Results/${POP1}_${POP2}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/${POP1}_${POP2}_${SUBSET}.pbs.txt
realSFS fst stats2 Results/${POP1}_${POP3}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/${POP1}_${POP3}_${SUBSET}.pbs.txt
realSFS fst stats2 Results/${POP1}_${POP4}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/${POP1}_${POP4}_${SUBSET}.pbs.txt
realSFS fst stats2 Results/${POP2}_${POP3}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/${POP2}_${POP3}_${SUBSET}.pbs.txt
realSFS fst stats2 Results/${POP2}_${POP4}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/${POP2}_${POP4}_${SUBSET}.pbs.txt
realSFS fst stats2 Results/${POP3}_${POP4}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 0 > Results/${POP3}_${POP4}_${SUBSET}.pbs.txt

Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP1}_${POP2}_${SUBSET}.pbs.txt -c ${POP1}_${POP2}_${CHR}_${SUBSET} -o Results/ManPlots/${POP1}_${POP2}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP1}_${POP3}_${SUBSET}.pbs.txt -c ${POP1}_${POP3}_${CHR}_${SUBSET} -o Results/ManPlots/${POP1}_${POP3}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP1}_${POP4}_${SUBSET}.pbs.txt -c ${POP1}_${POP4}_${CHR}_${SUBSET} -o Results/ManPlots/${POP1}_${POP4}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP2}_${POP3}_${SUBSET}.pbs.txt -c ${POP2}_${POP3}_${CHR}_${SUBSET} -o Results/ManPlots/${POP2}_${POP3}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP3}_${POP4}_${SUBSET}.pbs.txt -c ${POP3}_${POP4}_${CHR}_${SUBSET} -o Results/ManPlots/${POP3}_${POP4}_${CHR}_${SUBSET}.pdf


# if [ -d "Results_whichFST1" ]; then echo "Results file exists" ; else mkdir Results_whichFST1; fi
# cd Results_whichFST1
# ln -s $OTHER_D/Results_whichFST1/${POP2}_${POP3}.pbs .
# cd ..
#
# SUBSET=Which1.NR50kb
# WINDOW=50000
# STEP=10000
#
# realSFS fst index Results/${POP1}.${RUN}.ref.saf.idx Results/${POP2}.${RUN}.ref.saf.idx -sfs Results/${POP1}_${POP2}.sfs -fstout Results_whichFST1/${POP1}_${POP2}.pbs -whichFST 1
# realSFS fst index Results/${POP1}.${RUN}.ref.saf.idx Results/${POP3}.${RUN}.ref.saf.idx -sfs Results/${POP1}_${POP3}.sfs -fstout Results_whichFST1/${POP1}_${POP3}.pbs -whichFST 1
# realSFS fst index Results/${POP1}.${RUN}.ref.saf.idx Results/${POP4}.${RUN}.ref.saf.idx -sfs Results/${POP1}_${POP4}.sfs -fstout Results_whichFST1/${POP1}_${POP4}.pbs -whichFST 1
# #realSFS fst index Results/${POP2}.${RUN}.ref.saf.idx Results/${POP3}.${RUN}.ref.saf.idx -sfs Results/${POP2}_${POP3}.sfs -fstout Results_whichFST1/${POP2}_${POP3}.pbs -whichFST 1
# realSFS fst index Results/${POP2}.${RUN}.ref.saf.idx Results/${POP4}.${RUN}.ref.saf.idx -sfs Results/${POP2}_${POP4}.sfs -fstout Results_whichFST1/${POP2}_${POP4}.pbs -whichFST 1
# realSFS fst index Results/${POP3}.${RUN}.ref.saf.idx Results/${POP4}.${RUN}.ref.saf.idx -sfs Results/${POP3}_${POP4}.sfs -fstout Results_whichFST1/${POP3}_${POP4}.pbs -whichFST 1
#
# realSFS fst stats2 Results_whichFST1/${POP1}_${POP2}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 1 > Results_whichFST1/${POP1}_${POP2}_${SUBSET}pbs.txt
# realSFS fst stats2 Results_whichFST1/${POP1}_${POP3}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 1 > Results_whichFST1/${POP1}_${POP3}_${SUBSET}pbs.txt
# realSFS fst stats2 Results_whichFST1/${POP1}_${POP4}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 1 > Results_whichFST1/${POP1}_${POP4}_${SUBSET}pbs.txt
# realSFS fst stats2 Results_whichFST1/${POP2}_${POP3}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 1 > Results_whichFST1/${POP2}_${POP3}_${SUBSET}pbs.txt
# realSFS fst stats2 Results_whichFST1/${POP2}_${POP4}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 1 > Results_whichFST1/${POP2}_${POP4}_${SUBSET}pbs.txt
# realSFS fst stats2 Results_whichFST1/${POP3}_${POP4}.pbs.fst.idx -win $WINDOW -step $STEP -whichFST 1 > Results_whichFST1/${POP3}_${POP4}_${SUBSET}pbs.txt
#
# if [ -d "Results_whichFST1/ManPlots" ]; then echo "ManPlot dir exists" ; else mkdir Results_whichFST1/ManPlots; fi
#
# Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results_whichFST1/${POP1}_${POP2}_${SUBSET}pbs.txt -c ${POP1}_${POP2}_${CHR}_${SUBSET} -o Results_whichFST1/ManPlots/${POP1}_${POP2}_${CHR}_${SUBSET}.pdf
# Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results_whichFST1/${POP1}_${POP3}_${SUBSET}pbs.txt -c ${POP1}_${POP3}_${CHR}_${SUBSET} -o Results_whichFST1/ManPlots/${POP1}_${POP3}_${CHR}_${SUBSET}.pdf
# Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results_whichFST1/${POP1}_${POP4}_${SUBSET}pbs.txt -c ${POP1}_${POP4}_${CHR}_${SUBSET} -o Results_whichFST1/ManPlots/${POP1}_${POP4}_${CHR}_${SUBSET}.pdf
# Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results_whichFST1/${POP2}_${POP3}_${SUBSET}pbs.txt -c ${POP2}_${POP3}_${CHR}_${SUBSET} -o Results_whichFST1/ManPlots/${POP2}_${POP3}_${CHR}_${SUBSET}.pdf
# Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results_whichFST1/${POP3}_${POP4}_${SUBSET}pbs.txt -c ${POP3}_${POP4}_${CHR}_${SUBSET} -o Results_whichFST1/ManPlots/${POP3}_${POP4}_${CHR}_${SUBSET}.pdf
