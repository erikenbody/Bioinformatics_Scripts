#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e ./logs/angsd_auto_fst_allind.err            # File to which STDERR will be written
#SBATCH -o ./logs/angsd_auto_fst_allind.out           # File to which STDOUT will be written
#SBATCH -J angsd_auto_fst_allind           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

if [ -d "/home/eenbody/reseq_WD/angsd/fst_angsd/fst_actual_analysis/logs" ]; then echo "dir exists" ; else mkdir /home/eenbody/reseq_WD/angsd/fst_angsd/fst_actual_analysis/logs; fi

module load zlib/1.2.8
module load xz/5.2.2
module load R/3.4.1-intel
export R_LIBS_USER=/home/eenbody/BI_software/R/Library:$R_LIBS_USER

CHR=autosome
#aida_more_combined ; aid_more_combined_NR ; cov_40_300_20Q ; nocov_NR ; nocov_skiptri
EXT=nocov_skiptri
#all or NR
SUBSET=all
DESCRIPTION=All-Ind-MidFilt

HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/fst_angsd/fst_actual_analysis/all_individuals/$CHR
SAMPLEDIR=/home/eenbody/reseq_WD/angsd/fst_angsd/auto/$EXT
cd $WORK_D
mkdir $DESCRIPTION
cd $DESCRIPTION

if [ -d "ManPlots" ]; then echo "ManPlot dir exists" ; else mkdir ManPlots; fi

#variables
POP1=aida
POP2=naimii
POP3=lorentzi
POP4=moretoni

WIN1=50000
WIN2=25000

# parallel --link realSFS fst index $SAMPLEDIR/Results/{1}.${CHR}_scaffolds.ref.saf.idx $SAMPLEDIR/Results/{2}.${CHR}_scaffolds.ref.saf.idx -sfs $SAMPLEDIR/Results/{1}_{2}.sfs -fstout {1}_{2}_${CHR}_${DESCRIPTION}.pbs -whichFST 0 ::: $POP1 $POP1 $POP1 $POP4 $POP4 $POP2 ::: $POP2 $POP3 $POP4 $POP2 $POP3 $POP3

#quotes neccessary because of special character ">"
parallel --link realSFS fst stats2 {1}_{2}_${CHR}_${DESCRIPTION}.pbs.fst.idx -win {3} -step {3} -whichFST 0 '>' {1}_{2}_${CHR}_${DESCRIPTION}_{3}-Win.pbs.txt ::: $POP1 $POP1 $POP1 $POP4 $POP4 $POP2 ::: $POP2 $POP3 $POP4 $POP2 $POP3 $POP3 ::: $WIN1 $WIN1 $WIN1 $WIN1 $WIN1 $WIN1 $WIN2 $WIN2 $WIN2 $WIN2 $WIN2 $WIN2

#testing
#realSFS fst stats2 ${POP1}_${POP2}_${CHR}_${DESCRIPTION}.pbs.fst.idx -win $WIN1 -step $WIN1 -whichFST 0 -out ${POP1}_${POP2}_${CHR}_${DESCRIPTION}_${WIN1}-Win.fst.txt

#parallel --dryrun --link 'realSFS fst stats2 {1}_{2}_${CHR}_${DESCRIPTION}.pbs.fst.idx -win {3} -step {3} -whichFST 0 > {1}_{2}_${CHR}_${DESCRIPTION}_{3}-Win.pbs.txt' ::: $POP1 $POP1 $POP1 $POP2 ::: $POP2 $POP3 $POP4 $POP3 ::: $WIN1 $WIN2

#parallel --dryrun --link 'realSFS fst stats2 {1}_{2}_${CHR}_${DESCRIPTION}.pbs.fst.idx -win 50000 -step 50000 -whichFST 0 > test.ou' ::: $POP1 $POP1 $POP1 $POP2 ::: $POP2 $POP3 $POP4 $POP3

# parallel --dryrun --link realSFS fst stats2 {1}_{2}_${CHR}_${DESCRIPTION}.pbs.fst.idx -win 50000 -step 50000 -whichFST 0 '>' out.txt ::: $POP1 $POP1 $POP1 $POP2 ::: $POP2 $POP3 $POP4 $POP3

###

parallel --link Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i {1}_{2}_${CHR}_${DESCRIPTION}_{3}-Win.pbs.txt -c {1}_{2}_${CHR}_${DESCRIPTION} -o ManPlots/{1}_{2}_${CHR}_{3}_${DESCRIPTION}.pdf -t ANGSD ::: $POP1 $POP1 $POP1 $POP4 $POP4 $POP2 ::: $POP2 $POP3 $POP4 $POP2 $POP3 $POP3 ::: $WIN1 $WIN1 $WIN1 $WIN1 $WIN1 $WIN1 $WIN2 $WIN2 $WIN2 $WIN2 $WIN2 $WIN2

CHR=autosome
#aida_more_combined ; aid_more_combined_NR ; cov_40_300_20Q ; nocov_NR ; nocov_skiptri
EXT=cov_40_400_20Q
#all or NR
SUBSET=all
DESCRIPTION=All-Ind-HighFilt

HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/fst_angsd/fst_actual_analysis/all_individuals/$CHR
SAMPLEDIR=/home/eenbody/reseq_WD/angsd/fst_angsd/auto/$EXT
cd $WORK_D
mkdir $DESCRIPTION
cd $DESCRIPTION

if [ -d "ManPlots" ]; then echo "ManPlot dir exists" ; else mkdir ManPlots; fi

# parallel --link realSFS fst index $SAMPLEDIR/Results/{1}.${CHR}_scaffolds.ref.saf.idx $SAMPLEDIR/Results/{2}.${CHR}_scaffolds.ref.saf.idx -sfs $SAMPLEDIR/Results/{1}_{2}.sfs -fstout {1}_{2}_${CHR}_${DESCRIPTION}.pbs -whichFST 0 ::: $POP1 $POP1 $POP1 $POP4 $POP4 $POP2 ::: $POP2 $POP3 $POP4 $POP2 $POP3 $POP3

parallel --link realSFS fst stats2 {1}_{2}_${CHR}_${DESCRIPTION}.pbs.fst.idx -win {3} -step {3} -whichFST 0 '>' {1}_{2}_${CHR}_${DESCRIPTION}_{3}-Win.pbs.txt ::: $POP1 $POP1 $POP1 $POP4 $POP4 $POP2 ::: $POP2 $POP3 $POP4 $POP2 $POP3 $POP3 ::: $WIN1 $WIN1 $WIN1 $WIN1 $WIN1 $WIN1 $WIN2 $WIN2 $WIN2 $WIN2 $WIN2 $WIN2

parallel --link Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i {1}_{2}_${CHR}_${DESCRIPTION}_{3}-Win.pbs.txt -c {1}_{2}_${CHR}_${DESCRIPTION} -o ManPlots/{1}_{2}_${CHR}_{3}_${DESCRIPTION}.pdf -t ANGSD ::: $POP1 $POP1 $POP1 $POP4 $POP4 $POP2 ::: $POP2 $POP3 $POP4 $POP2 $POP3 $POP3 ::: $WIN1 $WIN1 $WIN1 $WIN1 $WIN1 $WIN1 $WIN2 $WIN2 $WIN2 $WIN2 $WIN2 $WIN2
