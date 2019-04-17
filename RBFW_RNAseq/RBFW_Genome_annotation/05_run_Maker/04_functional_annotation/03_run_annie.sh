#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=1
#SBATCH -e annie_%A_%a.err           # File to which STDERR will be written
#SBATCH -o annie_%A_%a.out         # File to which STDOUT will be written
#SBATCH -J annie    # Job name
#SBATCH --qos=normal
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

module load anaconda3

MAKER_HOME=/home/eenbody/RBFW_RNAseq/Genome_annotation/maker/RBFW.final.assembly.maker.output
WORK_D=/home/eenbody/RBFW_RNAseq/Genome_annotation/maker/RBFW.final.assembly.maker.output/functional_annotation
cd $WORK_D

sed 's/;$//' $MAKER_HOME/RBFW.final.assembly.all.gff > $MAKER_HOME/RBFW.final.assembly.all_nosemi.gff

~/BI_software/Annie/annie.py -b RBFW.final.assembly.all.maker_blast_sprot_np_STRICT.out -db uniprot_sprot_20190329.fasta -g $MAKER_HOME/RBFW.final.assembly.all_nosemi.gff -o RBFW_maker_blast_sprot_np_STRICT.annie
