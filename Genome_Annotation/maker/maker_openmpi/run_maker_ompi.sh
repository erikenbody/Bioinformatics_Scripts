#!/bin/bash
#!/bin/bash
#SBATCH -N 1
#SBATCH -n 20
#SBATCH --cpus-per-task=1
#SBATCH -e maker_20_ompi3.err           # File to which STDERR will be written
#SBATCH -o maker_20_ompi3.out         # File to which STDOUT will be written
#SBATCH -J maker_20_ompi3               # Job name
#SBATCH --mem=64000                     # Memory requested
#SBATCH --qos=long
#SBATCH --time=6-23:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

#reinstalled maker with openmpi
#changing to --mem=64000 (from --mem-per-cpu=3200) to see if it changes anything

module load openmpi/1.8.4
module load anaconda

source activate ede_py

WORK_D=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/Annotation/maker_openmpi

cd $WORK_D

export LD_PRELOAD=/share/apps/openmpi/1.8.4/lib/libmpi.so:$LD_PRELOAD

/share/apps/openmpi/1.8.4/bin/mpiexec -mca btl ^openib -np 20 /home/eenbody/BI_software/maker-openmpi/maker/bin/maker -fix_nucleotides
