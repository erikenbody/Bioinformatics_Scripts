#!/bin/bash
#!/bin/bash
#SBATCH -N 6
#SBATCH -n 20
#SBATCH --cpus-per-task=1
#SBATCH -e maker_120_rs.err           # File to which STDERR will be written
#SBATCH -o maker_120_rs.out         # File to which STDOUT will be written
#SBATCH -J maker_120_rs                # Job name
#SBATCH --mem-per-cpu=3200                     # Memory requested
#SBATCH --qos=long
#SBATCH --time=6-23:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu
#restarting on nov 14 after it seems to be hung up
module load intel-psxe/2015-update1
module load anaconda

source activate ede_py

WORK_D=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/Annotation/maker

cd $WORK_D

#export LD_PRELOAD=/cm/shared/apps/openmpi/gcc/64/1.8.1/lib64/libmpi.so
/share/apps/intel_parallel_studio_xe/2015_update1/impi/5.0.2.044/intel64/bin/mpirun /home/eenbody/BI_software/maker/bin/maker -fix_nucleotides

#testing openmpi
#module load openmpi/gcc/64/1.8.1
#export LD_PRELOAD=/cm/shared/apps/openmpi/gcc/64/1.8.1/lib64/libmpi.so
#mpiexec -mca btl ^openib -np 20 /home/eenbody/BI_software/maker/bin/maker -fix_nucleotides

#test

#mpiexec -mca btl ^openib -n 20 /home/eenbody/BI_software/maker/bin/maker --help

#mpirun -n 20 /home/eenbody/BI_software/maker/bin/maker --help

#/share/apps/intel_parallel_studio_xe/2015_update1/impi/5.0.2.044/intel64/bin/mpicc
#/share/apps/intel_parallel_studio_xe/2015_update1/impi/5.0.2.044/intel64/include/mpi.h

#/cm/shared/apps/openmpi/gcc/64/1.8.1/include/mpi.h

#/cm/shared/apps/openmpi/gcc/64/1.8.1/bin/mpicc
