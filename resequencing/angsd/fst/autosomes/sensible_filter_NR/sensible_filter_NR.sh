#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e sensible_filter_NR.err            # File to which STDERR will be written
#SBATCH -o sensible_filter_NR.out           # File to which STDOUT will be written
#SBATCH -J sensible_filter_NR        # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load zlib/1.2.8
module load xz/5.2.2

#For this run, I removed -minMaf 0.1, dropped snp pvalue to 1e-3, and added skipTriallelic.


HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/fst_angsd/auto/sensible_filter_NR

cd $WORK_D

if [ -d "Results" ]; then echo "Results file exists" ; else mkdir Results; fi

#variables#
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
RUN=autosome_scaffolds
REGIONS=$HOME_D/${RUN}.txt
DESCRIPTION=NR_sensible
ANC=/home/eenbody/reseq_WD/phylotree/Results/rbfw_correct.fasta

for POP in aida naimii lorentzi moretoni
do
 echo $POP
 MININD=$(if [[ "$POP" == "aida-more" ]]; then echo 8; elif [[ "$POP" == "lorentzi" ]]; then echo 5; elif [[ "$POP" == "naimii" ]]; then echo 4; elif [[ "$POP" == "aida" ]]; then echo 3; elif [[ "$POP" == "moretoni" ]]; then echo 5; fi)
 BAMLIST=$HOME_D/${POP}_bamlist_NR.txt
 angsd -b $BAMLIST -ref $REFGENOME -anc $ANC -out Results/${POP}.${RUN}_${DESCRIPTION}.ref -rf $REGIONS -P 20 \
               -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 0 -trim 0 \
               -minMapQ 20 -minQ 20 -SNP_pval 1e-3 -skipTriallelic -minInd $MININD \
               -doCounts 1 \
               -doMaf 1 -doMajorMinor 1 -GL 1 -doSaf 1
done

POP1=aida
POP2=naimii
POP3=lorentzi
POP4=moretoni

realSFS -P 20 Results/${POP1}.${RUN}_${DESCRIPTION}.ref.saf.idx Results/${POP2}.${RUN}_${DESCRIPTION}.ref.saf.idx > Results/${POP1}_${POP2}_${DESCRIPTION}.sfs
realSFS -P 20 Results/${POP3}.${RUN}_${DESCRIPTION}.ref.saf.idx Results/${POP4}.${RUN}_${DESCRIPTION}.ref.saf.idx > Results/${POP3}_${POP4}_${DESCRIPTION}.sfs
