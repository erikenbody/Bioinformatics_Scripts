#!/bin/bash
#SBATCH -N 18
#SBATCH -n 360
#SBATCH --cpus-per-task=1
#SBATCH -e mpich_maker_%A_%a.err           # File to which STDERR will be written
#SBATCH -o mpich_maker_%A_%a.out         # File to which STDOUT will be written
#SBATCH -J mpich_maker       # Job name
#SBATCH --mem=128000                     # Memory requested
#SBATCH --qos=normal
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

#reinstalled maker with mpich
#changing to just mem=128000

module load mpich/3.1.4
module load bzip2/1.0.6 #added 2019
module load anaconda

#source activate /home/eenbody/BI_software/conda_environments/ede_py2
#export PERL5LIB=/home/eenbody/BI_software/conda_environments/ede_py2/lib/site_perl/5.26.2/ #required to get repeatmasker working
source activate maker_depends #this way key - fresh environ with augustus, rmblastn, snoscan, trnascan

WORK_D=/home/eenbody/RBFW_RNAseq/Genome_annotation/maker
cd $WORK_D

#/home/eenbody/BI_software/maker-mpich/maker/bin/maker -C

rm maker_opts.ctl
scp ~/Bioinformatics_Scripts/RBFW_RNAseq/RBFW_Genome_annotation/run_Maker/01_evidence_based/maker_opts.ctl .

/share/apps/mpich/3.1.4/bin/mpiexec -n 360 /home/eenbody/BI_software/maker-mpich/maker/bin/maker -fix_nucleotides
