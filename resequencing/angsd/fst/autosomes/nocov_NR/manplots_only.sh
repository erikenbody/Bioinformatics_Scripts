#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e angsd_man.err            # File to which STDERR will be written
#SBATCH -o angsd_man.out           # File to which STDOUT will be written
#SBATCH -J angsd_man           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

#had type in last script so running these here

module load zlib/1.2.8
module load xz/5.2.2
module load R/3.4.1-intel
export R_LIBS_USER=/home/eenbody/BI_software/R/Library:$R_LIBS_USER

POP1=aida
POP2=naimii
POP3=lorentzi
POP4=moretoni
CHR=autosomes

#run sliding window analysis
if [ -d "Results/ManPlots" ]; then echo "ManPlot dir exists" ; else mkdir Results/ManPlots; fi
SUBSET=NR50kb
WINDOW=50000
STEP=10000

#make manhattan plots - fst, zfst, filtered fst, filtered zfst
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP1}_${POP2}_${SUBSET}.pbs.txt -c ${POP1}_${POP2}_${CHR}_${SUBSET} -o Results/ManPlots/${POP1}_${POP2}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP1}_${POP3}_${SUBSET}.pbs.txt -c ${POP1}_${POP3}_${CHR}_${SUBSET} -o Results/ManPlots/${POP1}_${POP3}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP1}_${POP4}_${SUBSET}.pbs.txt -c ${POP1}_${POP4}_${CHR}_${SUBSET} -o Results/ManPlots/${POP1}_${POP4}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP2}_${POP3}_${SUBSET}.pbs.txt -c ${POP2}_${POP3}_${CHR}_${SUBSET} -o Results/ManPlots/${POP2}_${POP3}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP2}_${POP4}_${SUBSET}.pbs.txt -c ${POP2}_${POP4}_${CHR}_${SUBSET} -o Results/ManPlots/${POP2}_${POP4}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP3}_${POP4}_${SUBSET}.pbs.txt -c ${POP3}_${POP4}_${CHR}_${SUBSET} -o Results/ManPlots/${POP3}_${POP4}_${CHR}_${SUBSET}.pdf

#run with different presents
SUBSET=NR25kb
WINDOW=25000
STEP=5000

Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP1}_${POP2}_${SUBSET}.pbs.txt -c ${POP1}_${POP2}_${CHR}_${SUBSET} -o Results/ManPlots/${POP1}_${POP2}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP1}_${POP3}_${SUBSET}.pbs.txt -c ${POP1}_${POP3}_${CHR}_${SUBSET} -o Results/ManPlots/${POP1}_${POP3}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP1}_${POP4}_${SUBSET}.pbs.txt -c ${POP1}_${POP4}_${CHR}_${SUBSET} -o Results/ManPlots/${POP1}_${POP4}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP2}_${POP3}_${SUBSET}.pbs.txt -c ${POP2}_${POP3}_${CHR}_${SUBSET} -o Results/ManPlots/${POP2}_${POP3}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP3}_${POP4}_${SUBSET}.pbs.txt -c ${POP3}_${POP4}_${CHR}_${SUBSET} -o Results/ManPlots/${POP3}_${POP4}_${CHR}_${SUBSET}.pdf
