#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e ngstoolsfst.err            # File to which STDERR will be written
#SBATCH -o ngstoolsfst.out           # File to which STDOUT will be written
#SBATCH -J ngstoolsfst           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=128000
#SBATCH --cpus-per-task=20
#SBATCH --time=6-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

#exceeded memory when set to 64gb
#remove coverage, remove relatives
#already ran lorentzi and naimii sfs elsewhere, so only run moretoni and aida (they were run combined before with relatives)

module load zlib/1.2.8
module load xz/5.2.2
module load R/3.4.1-intel
export R_LIBS_USER=/home/eenbody/BI_software/R/Library:$R_LIBS_USER

HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/fst_angsd/workbench
OTHER_D=/home/eenbody/reseq_WD/angsd/fst_angsd/auto/aida_more_combined_NR/

cd $WORK_D

if [ -d "Results" ]; then echo "Results file exists" ; else mkdir Results; fi
if [ -d "Data" ]; then echo "Results file exists" ; else mkdir Data; fi

#variables
#POP=`cat $HOME_D/pop_list.txt | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
RUN=autosome_scaffolds
REGIONS=$HOME_D/${RUN}.txt
SAMPLEDIR=/home/eenbody/reseq_WD/angsd/fst_angsd/auto/nocov_skiptri/Results
#MINCOV=40 #.info file is 0.01 percentile here at global coverage
#MAXCOV=400 #well after last value, as in example

POP1=aida
POP2=naimii
POP3=lorentzi
POP4=moretoni
CHR=autosomes

for POP in aida naimii
do
        MININD=$(if [[ "$POP" == "aida-more" ]]; then echo 8; elif [[ "$POP" == "lorentzi" ]]; then echo 5; elif [[ "$POP" == "naimii" ]]; then echo 5; elif [[ "$POP" == "aida" ]]; then echo 4; elif [[ "$POP" == "moretoni" ]]; then echo 5; fi)
        BAMLIST=$HOME_D/${POP}_bamlist_NR.txt
        echo $POP
        angsd -b $BAMLIST -ref $REFGENOME -anc $REFGENOME -out Results/${POP}.${RUN}.ref -rf $REGIONS -P 20\
                -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 \
                -minMapQ 20 -minQ 20 -minInd $MININD -setMinDepth 20 -setMaxDepth 200 -doCounts 1 \
                -GL 1 -doSaf 1
done


realSFS print -P 20 Results/aida.autosome_scaffolds.ref.saf.idx Results/naimii.autosome_scaffolds.ref.saf.idx | cut -f 1-2 > Data/intersect.txt

for POP in aida naimii
do
        MININD=$(if [[ "$POP" == "aida-more" ]]; then echo 8; elif [[ "$POP" == "lorentzi" ]]; then echo 5; elif [[ "$POP" == "naimii" ]]; then echo 5; elif [[ "$POP" == "aida" ]]; then echo 4; elif [[ "$POP" == "moretoni" ]]; then echo 5; fi)
        BAMLIST=$HOME_D/${POP}_bamlist_NR.txt
        echo $POP
        angsd -b $BAMLIST -ref $REFGENOME -anc $REFGENOME -out Results/${POP}.${RUN}.ref -rf $REGIONS -P 20\
                -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 -C 50 -baq 1 \
                -minMapQ 20 -minQ 20 -minInd $MININD -setMinDepth 20 -setMaxDepth 200 -doCounts 1 \
                -GL 1 -doSaf 1 \
		            -sites Data/intersect.txt
done

NSITES=`wc -l Data/intersect.txt | cut -f 1 -d " "` # if not already done

zcat Results/${POP1}.saf.gz > Results/${POP1}.saf
zcat Results/${POP2}.saf.gz > Results/${POP2}.saf

ngs2dSFS -postfiles Results/${POP1}.saf Results/${POP2}.saf -outfile Results/${POP1}.${POP2}.2dsfs -nind 7 10 -nsites $NSITES -maxlike 1 -relative 1

realSFS -P 4 Results/${POP1}.saf.idx Results/${POP1}.saf.idx -sites Data/intersect.txt > Results/${POP1}.${POP2}.sfs

Rscript /home/eenbody/BI_software/ngsTools/Scripts/SFSangsd2tools.R Results/${POP1}.${POP2}.sfs 7 10 > Results/${POP1}.${POP2}.angsd.2dsfs

ngsFST -postfiles Results/${POP1}.saf Results/${POP2}.saf -priorfile Results/${POP1}.${POP2}.angsd.2dsfs -nind 7 10 -nsites $NSITES -outfile Results/${POP1}.${POP2}.fst
