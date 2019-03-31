#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=20
#SBATCH -e aug_opt2_%A.err           # File to which STDERR will be written
#SBATCH -o aug_opt2_%A.out         # File to which STDOUT will be written
#SBATCH -J aug_opt       # Job name
#SBATCH --mem=128000                     # Memory requested
#SBATCH --qos=long
#SBATCH --time=7-00:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

module load mpich/3.1.4
module load bzip2/1.0.6 #added 2019
module load anaconda

source activate maker_depends #this way key - fresh environ with augustus, rmblastn, snoscan, trnascan

SPECIES=RBFW
WORK_D=/lustre/project/jk/Khalil_WD/RBFW_RNAseq/Genome_annotation/maker/train_augustus
cd $WORK_D
# cp ../trainsnap/genome* .
#
# zff2gff3.pl ./genome.ann | perl -plne 's/\t(\S+)$/\t\.\t$1/' > ${SPECIES}.gff3
#
# #augustus config path looks okay, test with
# echo $AUGUSTUS_CONFIG_PATH
#
# new_species.pl --species=${SPECIES}
#
# #make genbank
# gff2gbSmallDNA.pl ${SPECIES}.gff3 ./genome.dna 1000 ${SPECIES}.gb
#
# #Randomly split the set of annotated sequences in a training and a test set
# randomSplit.pl ${SPECIES}.gb 200
#
# #This generates a file myspecies.gb.test with 100 randomly chosen loci and a disjoint file myspecies.gb.train with the rest of the loci from genes.gb:
# >${SPECIES}.gb:6707
# >${SPECIES}.gb.test:200
# >${SPECIES}.gb.train:6507
#
# #initial etraining
# etraining --species=${SPECIES} ${SPECIES}.gb.train
#
# #check contents of species
# ls -ort $AUGUSTUS_CONFIG_PATH/species/${SPECIES}/
#
# #Now we make a first try and predict the genes in genes.gb.train ab initio.
# augustus --species=${SPECIES} ${SPECIES}.gb.test | tee firsttest.out # takes ~1m

optimize_augustus.pl --species=${SPECIES} ${SPECIES}.gb.train --cpus=20
