#!/bin/bash -l
#SBATCH -A snic2018-8-57
#SBATCH -p node -n 20
#SBATCH -t 6-23:00:00
#SBATCH -J augustus1
#SBATCH -e augustus1_%A.err            # File to which STDERR will be written
#SBATCH -o augustus1_%A.out
#SBATCH --mail-type=all
#SBATCH --mail-user=erik.enbody@gmail.com

module load mpich/3.1.4
module load bzip2/1.0.6 #added 2019
module load anaconda

#source activate /home/eenbody/BI_software/conda_environments/ede_py2
#export PERL5LIB=/home/eenbody/BI_software/conda_environments/ede_py2/lib/site_perl/5.26.2/ #required to get repeatmasker working
source activate maker_depends #this way key - fresh environ with augustus, rmblastn, snoscan, trnascan


new_species.pl --AUGUSTUS_CONFIG_PATH=augustus_path --species=$SPECIES
AUGUSTUS_CONFIG_PATH=augustus_path

etraining --species=$SPECIES gff2genbank/codingGeneFeatures.nr.gbk.train
augustus --species=$SPECIES gff2genbank/codingGeneFeatures.nr.gbk.test | tee run.log
