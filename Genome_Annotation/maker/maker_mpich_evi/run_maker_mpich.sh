#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=1
#SBATCH -e mpich_maker_360_05.err           # File to which STDERR will be written
#SBATCH -o mpich_maker_360_05.out         # File to which STDOUT will be written
#SBATCH -J mpich_maker_360       # Job name
#SBATCH --mem=128000                     # Memory requested
#SBATCH --qos=long
#SBATCH --time=7-00:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

#ran with 18 cores and 360 tasks first
#failed at 23:47
#running with 4 and 80
#running with 2 and 40
#running with 1 and 20
#running with 1 and 1


module load mpich/3.1.4
module load anaconda

source activate ede_py

WORK_D=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/Annotation/maker_mpich_evi
cd $WORK_D

#/share/apps/mpich/3.1.4/bin/mpiexec -n 20 /home/eenbody/BI_software/maker-mpich/maker/bin/maker -fix_nucleotides
/home/eenbody/BI_software/maker-mpich/maker/bin/maker -fix_nucleotides
