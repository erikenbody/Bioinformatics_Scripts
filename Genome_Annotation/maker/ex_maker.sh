#!/bin/bash
#!/bin/bash
#SBATCH -N 1
#SBATCH -n 20
#SBATCH --cpus-per-task=1
#SBATCH -e maker_ex_ompi.err           # File to which STDERR will be written
#SBATCH -o maker_ex_ompi.out         # File to which STDOUT will be written
#SBATCH -J maker_ex_ompi               # Job name
#SBATCH --mem-per-cpu=3200                     # Memory requested
#SBATCH --qos=normal
#SBATCH --time=0-23:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

#reinstalled maker with openmpi

module load openmpi/1.8.4
module load anaconda

source activate ede_py

WORK_D=/home/eenbody/BI_software/maker-openmpi/maker/data

cd $WORK_D

export LD_PRELOAD=/share/apps/openmpi/1.8.4/lib/libmpi.so:$LD_PRELOAD

/share/apps/openmpi/1.8.4/bin/mpiexec -mca btl ^openib -np 20 /home/eenbody/BI_software/maker-openmpi/maker/bin/maker
