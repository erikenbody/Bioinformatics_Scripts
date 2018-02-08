#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e ./logs/call_fst_gatk_angsd.err            # File to which STDERR will be written
#SBATCH -o ./logs/call_fst_gatk_angsd.out           # File to which STDOUT will be written
#SBATCH -J call_fst_gatk_angsd           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=0-3:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to


#HAVENT RUN THIS BC PROBLEM WITH SFS

module load zlib/1.2.8
module load xz/5.2.2
module load R/3.4.1-intel
export R_LIBS_USER=/home/eenbody/BI_software/R/Library:$R_LIBS_USER

CHR=autosomes
SUBSET=all_individuals
RUN=autosome_scaffolds
DESCRIPTION=highest_filter_allInd

HOME_D=/home/eenbody/reseq_WD/angsd/gatk_filtered/fst_angsd
SAMPLEDIR=$HOME_D/$SUBSET/$CHR/Results
WORK_D=$SAMPLEDIR/fst_actual_analysis
cd $WORK_D

if [ -d "ManPlots" ]; then echo "ManPlot dir exists" ; else mkdir ManPlots; fi

#variables
POP1=aida
POP2=naimii
POP3=lorentzi
POP4=moretoni

WIN1=50000
WIN2=25000

parallel --dryrun --link realSFS fst index $SAMPLEDIR/{1}.${CHR}_scaffolds_${DESCRIPTION}.ref.saf.idx $SAMPLEDIR/{2}.${CHR}_scaffolds_${DESCRIPTION}.ref.saf.idx -sfs $SAMPLEDIR/{1}_{2}_${DESCRIPTION}.sfs -fstout {1}_{2}_${CHR}_${DESCRIPTION} -whichFST 0 ::: $POP1 $POP1 $POP1 $POP3 $POP2 $POP2 ::: $POP2 $POP3 $POP4 $POP4 $POP3 $POP4

#quotes neccessary because of special character ">"
parallel --link realSFS fst stats2 {1}_{2}_${CHR}_${DESCRIPTION}.fst.idx -win {3} -step {3} -whichFST 0 '>' {1}_{2}_${CHR}_${DESCRIPTION}_{3}-Win.fst.txt ::: $POP1 $POP1 $POP1 $POP3 $POP2 $POP2 ::: $POP2 $POP3 $POP4 $POP4 $POP3 $POP4 ::: $WIN1 $WIN1 $WIN1 $WIN1 $WIN1 $WIN1 $WIN2 $WIN2 $WIN2 $WIN2 $WIN2 $WIN2

parallel --link Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i {1}_{2}_${CHR}_${DESCRIPTION}_{3}-Win.fst.txt -c {1}_{2}_${CHR}_${DESCRIPTION} -o ManPlots/{1}_{2}_${CHR}_{3}_${DESCRIPTION}.pdf -t ANGSD ::: $POP1 $POP1 $POP1 $POP3 $POP2 $POP2 ::: $POP2 $POP3 $POP4 $POP4 $POP3 $POP4 ::: $WIN1 $WIN1 $WIN1 $WIN1 $WIN1 $WIN1 $WIN2 $WIN2 $WIN2 $WIN2 $WIN2 $WIN2
