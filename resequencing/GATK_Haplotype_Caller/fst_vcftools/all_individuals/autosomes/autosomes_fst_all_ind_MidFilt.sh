#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=23:00:00
#SBATCH -e ./logs/fstvcf2.err            # File to which STDERR will be written
#SBATCH -o ./logs/fstvcf2.out           # File to which STDOUT will be written
#SBATCH -J fstvcf           # Job name
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --qos=normal
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

#SUBMIT FROM $TOP

if [ -d "logs" ]; then echo "dir exists" ; else mkdir logs; fi

module load anaconda/2.5.0
module load zlib/1.2.8
module load xz

source activate ede_py

#can be zchr or autosomes
CHR=autosomes
#WSFW_passed.vcf or WSFW_passed_CovFil_2_320.vcf
EXT=WSFW_passed.vcf
#all or NR
SUBSET=all
DESCRIPTION=All-Ind-MidFilt

WORK_D=/home/eenbody/reseq_WD/GATK_Haplotype_Caller/fst_vcftools/${SUBSET}_individuals/$CHR/
cd $WORK_D

mkdir $DESCRIPTION
cd $DESCRIPTION

TOP=/home/eenbody/reseq_WD/GATK_Haplotype_Caller/fst_vcftools/
HOME_D=/home/eenbody/reseq_WD/GATK_Haplotype_Caller/all_individuals/filtered_vcfs
VDIR=$HOME_D/$CHR
VCF=$VDIR/${CHR}_${EXT}
POP1=aida
POP2=naimii
POP3=lorentzi
POP4=moretoni
BAMLIST=$TOP/bamlists/$SUBSET
WIN1=50000
WIN2=25000

#if [ -d "Results" ]; then echo "dir exists" ; else mkdir Results; fi
if [ -d "ManPlots" ]; then echo "dir exists" ; else mkdir ManPlots; fi

#add --dryrun to check if this does what you want
#parallel --link vcftools --vcf $VCF --weir-fst-pop $BAMLIST/{1}_bamlist.txt --weir-fst-pop $BAMLIST/{2}_bamlist.txt --fst-window-size $WINDOW --out WSFW_{1}_{2} ::: aida aida aida moretoni moretoni naimii ::: naimii lorentzi moretoni naimii lorentzi lorentzi

parallel --link vcftools --vcf $VCF --weir-fst-pop $BAMLIST/{1}_bamlist.txt --weir-fst-pop $BAMLIST/{2}_bamlist.txt --fst-window-size {3} --out {1}_{2}_{3}-Win ::: $POP1 $POP1 $POP1 $POP4 $POP4 $POP2 ::: $POP2 $POP3 $POP4 $POP2 $POP3 $POP3 ::: $WIN1 $WIN1 $WIN1 $WIN1 $WIN1 $WIN1 $WIN2 $WIN2 $WIN2 $WIN2 $WIN2 $WIN2

source deactivate
module load R/3.4.1-intel
export R_LIBS_USER=/home/eenbody/BI_software/R/Library:$R_LIBS_USER

parallel --link Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i {1}_{2}_{3}-Win.windowed.weir.fst -c {1}_{2}_${CHR}_${DESCRIPTION} -o ManPlots/{1}_{2}_${CHR}_{3}_${DESCRIPTION}.pdf -t VCFTOOLS ::: $POP1 $POP1 $POP1 $POP4 $POP4 $POP2 ::: $POP2 $POP3 $POP4 $POP2 $POP3 $POP3 ::: $WIN1 $WIN1 $WIN1 $WIN1 $WIN1 $WIN1 $WIN2 $WIN2 $WIN2 $WIN2 $WIN2 $WIN2
