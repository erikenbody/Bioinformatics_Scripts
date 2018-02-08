#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=20
#SBATCH -e proteinortho.err           # File to which STDERR will be written
#SBATCH -o proteinortho.out         # File to which STDOUT will be written
#SBATCH -J proteinortho      # Job name
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

#proteinortho5.pl -project=wsfw.proteinortho -cpus=20 -verbose -clean $MAKER_HOME/WSFW_assembly_maker2.all.maker.proteins.fasta uniprot_sprot.fasta

mkdir cofl_proteinortho
proteinortho5.pl -project=wsfw.cofl.proteinortho -cpus=20 -verbose -clean $MAKER_HOME/WSFW_assembly_maker2.all.maker.proteins.fasta COLF_3AUP000016665.fasta
