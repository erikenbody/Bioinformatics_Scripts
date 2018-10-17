#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e dxy2.err            # File to which STDERR will be written
#SBATCH -o dxy2.out           # File to which STDOUT will be written
#SBATCH -J dxy2          # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=10000
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to
#

module load R/3.4.1-intel
export R_LIBS_USER=/home/eenbody/BI_software/R/Library:$R_LIBS_USER


#Rscript ~/Bioinformatics_Scripts/resequencing/angsd/dxy/calcDxy.R -p moretoni.mafs -q lorentzi.mafs
#Rscript ~/Bioinformatics_Scripts/resequencing/angsd/dxy/calcDxy_unknownEM.R -p moretoni.mafs -q lorentzi.mafs -o moretoni_lorentzi_dxy.txt
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/dxy/calcDxy_knownEM.R -p moretoni.mafs -q lorentzi.mafs -o moretoni_lorentzi_dxy.txt
