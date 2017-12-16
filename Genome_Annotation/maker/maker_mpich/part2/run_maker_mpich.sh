#!/bin/bash
#SBATCH -N 18
#SBATCH -n 360
#SBATCH --cpus-per-task=1
#SBATCH -e mpich_maker_20_R2.err           # File to which STDERR will be written
#SBATCH -o mpich_maker_20_R2.out         # File to which STDOUT will be written
#SBATCH -J mpich_maker_360_R2      # Job name
#SBATCH --mem=128000                     # Memory requested
#SBATCH --qos=long
#SBATCH --time=7-00:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

#run part2 after augustus retraining

module load mpich/3.1.4
module load anaconda/2.5.0

source activate ede_py

WORK_D=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/Annotation/maker_mpich

cd $WORK_D

/share/apps/mpich/3.1.4/bin/mpiexec -n 360 /home/eenbody/BI_software/maker-mpich/maker/bin/maker maker_opts_run2.ctl maker_bopts.ctl maker_exe.ctl maker_evm.ctl -fix_nucleotides
