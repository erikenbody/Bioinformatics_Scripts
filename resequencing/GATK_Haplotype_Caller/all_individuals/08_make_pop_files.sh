#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=0-23:00:00
#SBATCH -e make_pop_vcf.err            # File to which STDERR will be written
#SBATCH -o make_pop_vcf.out           # File to which STDOUT will be written
#SBATCH -J make_pop_vcf           # Job name
#SBATCH --mem=64000
#SBATCH --qos=normal
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load anaconda/2.5.0
module load zlib/1.2.8

source activate ede_py

WORK_D=/home/eenbody/reseq_WD/GATK_Haplotype_Caller/all_individuals/filtered_vcfs

CHR=autosomes

#####RUN HIGHEST FILTER#####
DESCRIPTION=all_ind_HighestFilt
SUBSET=all
BAMLIST=/home/eenbody/reseq_WD/GATK_Haplotype_Caller/fst_vcftools/bamlists/$SUBSET
cd $WORK_D/$CHR
if [ -d "pops_subset" ]; then echo "dir exists" ; else mkdir pops_subset; fi
cd pops_subset

mkdir $DESCRIPTION

POP1=aida
POP2=naimii
POP3=lorentzi
POP4=moretoni

parallel vcftools --gzvcf $WORK_D/$CHR/autosomes_WSFW_CovFil_2.26_9.04.vcf.gz --keep $BAMLIST/{1}_bamlist.txt --recode --recode-INFO-all --stdout '|' gzip -c '>' $DESCRIPTION/{1}_autosomes_WSFW_CovFil_2.26_9.04.vcf.gz ::: $POP1 $POP2 $POP3 $POP4


java -Xmx60g -XX:ParallelGCThreads=1 -jar ~/BI_software/picard.jar SortVcf \
        I=aida_autosomes_WSFW_CovFil_2.26_9.04.vcf.gz \
        O=aida_autosomes_WSFW_CovFil_2.26_9.04_s.vcf.gz

######RUN HIGH FILTER####

#HAVENT SET THIS UP YET

DESCRIPTION=all_ind_HighFilt
SUBSET=all
BAMLIST=/home/eenbody/reseq_WD/GATK_Haplotype_Caller/fst_vcftools/bamlists/$SUBSET
cd $WORK_D/$CHR
if [ -d "pops_subset" ]; then echo "dir exists" ; else mkdir pops_subset; fi
cd pops_subset

mkdir $DESCRIPTION

POP1=aida
POP2=naimii
POP3=lorentzi
POP4=moretoni

parallel vcftools --gzvcf $WORK_D/$CHR/autosomes_WSFW_CovFil_2.26_9.04.vcf.gz --keep $BAMLIST/{1}_bamlist.txt --recode --recode-INFO-all --stdout '|' gzip -c '>' $DESCRIPTION/{1}_autosomes_WSFW_CovFil_2.26_9.04.vcf.gz ::: $POP1 $POP2 $POP3 $POP4
