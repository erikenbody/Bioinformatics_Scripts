#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=20
#SBATCH -e blastp.err           # File to which STDERR will be written
#SBATCH -o blastp.out         # File to which STDOUT will be written
#SBATCH -J blastp      # Job name
#SBATCH --mem=64000                     # Memory requested
#SBATCH --qos=long
#SBATCH --time=7-00:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

module load anaconda/2.5.0
source activate ede_py

MAKER_HOME=/home/eenbody/maker_mpich/WSFW_assembly_maker2.maker.output
WORK_D=/home/eenbody/maker_mpich/WSFW_assembly_maker2.maker.output/functional_annotation

cd $WORK_D

RELEASE=2017_11
makeblastdb -in uniprot_${RELEASE}.fasta -out db/uniprot_${RELEASE} -dbtype prot -parse_seqids -title uniprot_${RELEASE}

blastp -db $WORK_D/db/uniprot_2017_11 -query $MAKER_HOME/WSFW_assembly_maker2.all.maker.proteins.fasta -outfmt 6 -out WSFW_maker_blast.out -num_threads 20

#blastp -db $WORK_D/uniprot_sprot -query $MAKER_HOME/WSFW_assembly_maker2.all.maker.proteins.fasta -outfmt 6 -out WSFW_blast.out -num_threads 20
