#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e dxy1.err            # File to which STDERR will be written
#SBATCH -o dxy1.out           # File to which STDOUT will be written
#SBATCH -J dxy1           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=256000
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

#
module load R/3.4.1-intel
export R_LIBS_USER=/home/eenbody/BI_software/R/Library:$R_LIBS_USER

POP1=aida
POP2=naimii
POP3=lorentzi
POP4=moretoni

#Rscript ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_chest/calcDxy_knownEM_win.R -p naimii_4dxy.mafs -q aida_4dxy.mafs -o aida_naimii_dxy

Rscript ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/calcDxy_knownEM_win.R -p ${POP1}_${POP1}_${POP2}_4dxy.mafs -q ${POP2}_${POP1}_${POP2}_4dxy.mafs -o ${POP1}_${POP2}_dxy

Rscript ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/calcDxy_knownEM_win.R -p ${POP1}_${POP1}_${POP3}_4dxy.mafs -q ${POP3}_${POP1}_${POP3}_4dxy.mafs -o ${POP1}_${POP3}_dxy

Rscript ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/calcDxy_knownEM_win.R -p ${POP1}_${POP1}_${POP4}_4dxy.mafs -q ${POP4}_${POP1}_${POP4}_4dxy.mafs -o ${POP1}_${POP4}_dxy

Rscript ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/calcDxy_knownEM_win.R -p ${POP2}_${POP3}_${POP2}_4dxy.mafs -q ${POP3}_${POP3}_${POP2}_4dxy.mafs -o ${POP2}_${POP3}_dxy #

Rscript ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/calcDxy_knownEM_win.R -p ${POP2}_${POP4}_${POP2}_4dxy.mafs -q ${POP4}_${POP4}_${POP2}_4dxy.mafs -o ${POP2}_${POP4}_dxy #

Rscript ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/calcDxy_knownEM_win.R -p ${POP3}_${POP3}_${POP4}_4dxy.mafs -q ${POP4}_${POP3}_${POP4}_4dxy.mafs -o ${POP3}_${POP4}_dxy
