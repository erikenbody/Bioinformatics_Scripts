#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e proc_maker_%A.err            # File to which STDERR will be written
#SBATCH -o proc_maker_%A.out           # File to which STDOUT will be written
#SBATCH -J proc_maker               # Job name
#SBATCH --cpus-per-task=15
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

##RUN ON CYPRESS
MAKER=/home/eenbody/RBFW_RNAseq/Genome_annotation/maker/RBFW.final.assembly.maker.output
LOGMAKER=RBFW.final.assembly_master_datastore_index.log
cd $MAKER

#fasta_merge -d $LOGMAKER
#gff3_merge -d $LOGMAKER
##

#train SNAP
cd .. #maker wd
mkdir trainsnap
cd trainsnap/
#cp ../*output/*.gff .

#maker2zff *gff
fathom genome.ann genome.dna -gene-stats > gene-stats.log 2>&1
cat gene-stats.log

fathom genome.ann genome.dna -validate > validate.log 2>&1
fathom genome.ann genome.dna -categorize 1000 #> categorize.log 2>&1
fathom -export 1000 -plus uni.ann uni.dna #> uni-plus.log 2>&1
forge export.ann export.dna #> forge.log 2>&1

hmm-assembler.pl snap .> snap.hmm
