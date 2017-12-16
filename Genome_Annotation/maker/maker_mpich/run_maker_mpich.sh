#!/bin/bash
#SBATCH -N 18
#SBATCH -n 20
#SBATCH --cpus-per-task=1
#SBATCH -e mpich_maker_20_finish.err           # File to which STDERR will be written
#SBATCH -o mpich_maker_20_finish.out         # File to which STDOUT will be written
#SBATCH -J mpich_maker_20_finish       # Job name
#SBATCH --mem=128000                     # Memory requested
#SBATCH --qos=normal
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

#reinstalled maker with mpich
#changing to just mem=128000
#Nov20 - changing to -N=6,-n=120, --qos=normal, --time=1-0:0:0

module load mpich/3.1.4
module load anaconda

source activate ede_py

WORK_D=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/Annotation/maker_mpich

cd $WORK_D

/share/apps/mpich/3.1.4/bin/mpiexec -n 360 /home/eenbody/BI_software/maker-mpich/maker/bin/maker -fix_nucleotides
