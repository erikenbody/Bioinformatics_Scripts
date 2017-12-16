#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e ngs_relate_%A_%a.err            # File to which STDERR will be written
#SBATCH -o ngs_relate_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J ngs_relate           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=6-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

#submit as --array=1-4

module load zlib/1.2.8
module load xz/5.2.2

HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/ngsRelate

export alias ngsrelate2=ngsRelate

cd $WORK_D

#if [ -d "Results" ]; then echo "Results file exists" ; else mkdir Results; fi

#variables
POP=`cat $HOME_D/pop_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
BAMLIST=$HOME_D/${POP}_bamlist.txt
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
RUN=autosome_scaffolds
NUMIND=$(if [[ "$POP"  == "aida" ]]; then echo 7; else echo 10; fi)
REGIONS=$HOME_D/${RUN}.txt

angsd -b $BAMLIST -gl 1 -domajorminor 1 -snp_pval 1e-6 -domaf 1 -minmaf 0.05 -doGlf 3 -rf $REGIONS -out ${POP}

zcat ${POP}.mafs.gz | cut -f5 |sed 1d >${POP}.freq

~/BI_software/ngsRelate -g ${POP}.glf.gz -n $NUMIND -f ${POP}.freq -z ${POP}_names.txt >${POP}.gl.res

#I had initially typo-ed ngsRelat, so ran the below code in iDev instead, but above code is correct now
#for POP in lorentzi aida moretoni naimii
#do
#  echo $POP
#  NUMIND=$(if [[ "$POP"  == "aida" ]]; then echo 7; else echo 10; fi)
#  ~/BI_software/ngsRelate -g ${POP}.glf.gz -n $NUMIND -f ${POP}.freq -z ${POP}_names.txt >${POP}.gl.res
#done
