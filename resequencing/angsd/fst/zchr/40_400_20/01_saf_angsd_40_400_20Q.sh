#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e angsd_sfs_z_%A_%a.err            # File to which STDERR will be written
#SBATCH -o angsd_sfs_z_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J angsd_sfs_z           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

#this will be submitted as an array for all pops in pop.list.text
#sbatch --array=1-4 fst_angsd.sh

module load zlib/1.2.8
module load xz/5.2.2

HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/fst_angsd/zchr/cov_40_400_20Q/

cd $WORK_D

if [ -d "Results" ]; then echo "Results file exists" ; else mkdir Results; fi

#variables
POP=`cat $HOME_D/pop_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
BAMLIST=$HOME_D/${POP}_bamlist.txt
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
RUN=zchr_scaffolds
REGIONS=$HOME_D/${RUN}.txt
MINCOV=40 #.info file is 0.01 percentile here at global coverage
MAXCOV=400 #well after last value, as in example
MININD=$(if [[ "$POP"  == "aida" ]]; then echo 4; else echo 5; fi)

angsd -b $BAMLIST -ref $REFGENOME -anc $REFGENOME -out Results/${POP}.${RUN}.ref -rf $REGIONS \
                -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 \
                -minMapQ 20 -minQ 20 -minInd $MININD -setMinDepth $MINCOV -setMaxDepth $MAXCOV -doCounts 1 \
                -GL 1 -doSaf 1
realSFS Results/${POP}.${RUN}.ref.saf.idx -P 20 > Results/${POP}.${RUN}.ref.sfs
