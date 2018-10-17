#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e genes_win.err            # File to which STDERR will be written
#SBATCH -o genes_win.out           # File to which STDOUT will be written
#SBATCH -J genes_win           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --time=0-2:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to
#
#if [ -d "/home/eenbody/reseq_WD/angsd/fst_angsd/fst_actual_analysis/logs" ]; then echo "dir exists" ; else mkdir /home/eenbody/reseq_WD/angsd/fst_angsd/fst_actual_analysis/logs; fi


###RUN BY COLOR####

module load R/3.4.1-intel
export R_LIBS_USER=/home/eenbody/BI_software/R/Library:$R_LIBS_USER

###NOW RUN SENSIBLE FILT ####
CHR=autosome
EXT=nocov_NR_bycolor
#all or NR
SUBSET=NR
DESCRIPTION=nocov_NR_bycolor


HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/fst_angsd/fst_actual_analysis/no_relatives/$CHR
SAMPLEDIR=/home/eenbody/reseq_WD/angsd/fst_angsd/auto/$EXT
cd ${WORK_D}/${DESCRIPTION}

GENEFILE="/home/eenbody/WSFW_assembly_maker2.maker.output/functional_annotation/maker_functional_final_output/gene_only.db"
FILTERFILE="/home/eenbody/reseq_WD/angsd/fst_angsd/autosome_scaffolds_gr_50000_head.txt"

if [ -d "GenesInWin" ]; then echo "GenesInWin exists" ; else mkdir GenesInWin; fi

for f in *50000*; do
  Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/fst_info_func.R -g $GENEFILE -d ${WORK_D}/${DESCRIPTION} -i $f -o "GenesInWin" -t "ANGSD" -f $FILTERFILE
done
