#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e angsdvcf3.err            # File to which STDERR will be written
#SBATCH -o angsdvcf3.out           # File to which STDOUT will be written
#SBATCH -J angsdvcf3           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load zlib/1.2.8
module load xz/5.2.2

BAMLIST=/home/eenbody/reseq_WD/phylotree/allpops_bamlist_NR_outg.txt
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
REGIONS=/home/eenbody/reseq_WD/angsd/fst_angsd/autosome_scaffolds.txt
WORK_D=/home/eenbody/reseq_WD/phylotree/for_plink
ANC=/home/eenbody/reseq_WD/phylotree/Results/rbfw_correct.fasta

cd $WORK_D

#-minInd $MININD this was not used

angsd -b $BAMLIST -ref $REFGENOME -anc $ANC -out tree_input -rf $REGIONS -P 20 \
              -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 0 -trim 0 \
              -minMapQ 20 -minQ 20 -SNP_pval 1e-6 -minMaf 0.01 \
              -doCounts 1 -dumpCounts 2 \
              -doGeno 3 -doPost 1 -GL 1 -doMaf 2 -doMajorMinor 5

module load R/3.4.1-intel
export R_LIBS_USER=/home/eenbody/BI_software/R/Library:$R_LIBS_USER

Rscript ~/Bioinformatics_Scripts/resequencing/snapp_treemix/angsd2vcf.R --bam=/home/eenbody/reseq_WD/phylotree/allpops_bamlist_NR_outg.txt --geno=tree_input.geno.gz --counts=tree_input.counts.gz --out=./tree_input.vcf
