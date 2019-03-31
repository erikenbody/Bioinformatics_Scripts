#!/bin/bash -l
#SBATCH -A snic2018-8-57
#SBATCH -p core -n 20
#SBATCH -t 6-24:00:00
#SBATCH -J repeatmod
#SBATCH -e repeatmod.err            # File to which STDERR will be written
#SBATCH -o repeatmod.out
#SBATCH --mail-type=all
#SBATCH --mail-user=erik.enbody@gmail.com

module load anaconda
source activate ~/BI_software/conda_environments/ede_py2/

WORK_D=/home/eenbody/RBFW_RNAseq/Genome_annotation/repeatmodeler

cd $WORK_D

RepeatModeler -engine ncbi -pa 20 -database RBFW.final.assembly >& RBFW.final.assembly_out
