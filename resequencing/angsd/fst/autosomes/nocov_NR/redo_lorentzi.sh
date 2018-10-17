#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e redo_%j.err            # File to which STDERR will be written
#SBATCH -o redo_%j.out           # File to which STDOUT will be written
#SBATCH -J redo_%j           # Job name
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
CHR=autosomes


for POP in lorentzi
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
