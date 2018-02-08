#!/bin/bash
#SBATCH -N 18
#SBATCH -n 360
#SBATCH --cpus-per-task=1
#SBATCH -e mpich_maker_360.err           # File to which STDERR will be written
#SBATCH -o mpich_maker_360.out         # File to which STDOUT will be written
#SBATCH -J mpich_maker_360       # Job name
#SBATCH --mem=128000                     # Memory requested
#SBATCH --qos=normal
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

#reinstalled maker with mpich##

module load mpich/3.1.4
module load anaconda

source activate ede_py

WORK_D=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/Annotation/maker_mpich_evi

cd $WORK_D

/share/apps/mpich/3.1.4/bin/mpiexec -n 360 /home/eenbody/BI_software/maker-mpich/maker/bin/maker -fix_nucleotides
