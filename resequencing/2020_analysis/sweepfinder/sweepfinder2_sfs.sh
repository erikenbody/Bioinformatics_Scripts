#!/bin/bash
#SBATCH -N 1
#SBATCH -n 20
#SBATCH -e sfs_%j.err            # File to which STDERR will be written
#SBATCH -o sfs_%j.out           # File to which STDOUT will be written
#SBATCH -J sfs           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=128000
#SBATCH --time=6-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=erik.enbody@gmail.com # Email to send notifications to

module load zlib/1.2.8
module load xz/5.2.2
module load gcc/6.3.0
module load samtools
module load R/3.4.1-intel
export R_LIBS_USER=/home/eenbody/BI_software/R/Library:$R_LIBS_USER

WORK_D=/home/eenbody/reseq_WD/angsd/2020_analysis/sweepfinder
cd $WORK_D

#variables
ANC=/home/eenbody/reseq_WD/phylotree/Results/rbfw_correct.fasta
RUN=autosome_scaffolds
REGIONS=$HOME_D/${RUN}.txt


HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
ANC=/home/eenbody/reseq_WD/Preprocessing_fixed/RBFW_outgroup/merged_realigned_bams/RBFW_220bp_GCTCAT_realigned.sorted.bam
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta

ANGSD=/lustre/project/jk/Enbody_WD/BI_software/angsd_20Feb20/angsd

#choose a 5 Mbp scaff
SCAFF=scaffold_34

samtools view -b -o rbfw_${SCAFF}.bam $ANC $SCAFF
samtools faidx $REFGENOME $SCAFF > WSFW_scaffold_${SCAFF}.fasta
$ANGSD/angsd -i rbfw_${SCAFF}.bam -doFasta 1 -doCounts 1
mv angsdput.fa.gz rbfw_${SCAFF}.fa.gz


ANCGENOME=rbfw_${SCAFF}.fa.gz
REFGENOME=WSFW_scaffold_${SCAFF}.fasta

samtools faidx $ANCGENOME
samtools faidx $REFGENOME

for POP in aida moretoni lorentzi naimii
do
  echo $POP
  BAMLIST=$HOME_D/${POP}_bamlist_NR.txt
  $ANGSD/angsd -ref $REFGENOME -anc $ANCGENOME -r $SCAFF \
                -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 0 -trim 0 \
                -nThreads 20 -doMajorMinor 5 -doMaf 2 -bam $BAMLIST -GL 1 -out ${POP}_${SCAFF}
done

for POP in aida moretoni lorentzi naimii
do
  ./SF2/SweepFinder2 -f ${POP}_sf_input.txt ${POP}.sfs
done
