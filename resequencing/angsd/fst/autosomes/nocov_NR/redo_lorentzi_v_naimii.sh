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
#
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

realSFS -P 20 Results/${POP2}.${RUN}.ref.saf.idx Results/${POP3}.${RUN}.ref.saf.idx > Results/${POP2}_${POP3}.sfs
