#!/bin/bash
#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=1
#SBATCH -e maker_nompi.err           # File to which STDERR will be written
#SBATCH -o maker_nompi.out         # File to which STDOUT will be written
#SBATCH -J maker_nompi              # Job name
#SBATCH --mem-per-cpu=64000                   # Memory requested
#SBATCH --qos=long
#SBATCH --time=6-23:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

#running without mpi

module load anaconda

source activate ede_py

WORK_D=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/Annotation/maker_nompi

cd $WORK_D

/home/eenbody/BI_software/maker-openmpi/maker/bin/maker -fix_nucleotides
