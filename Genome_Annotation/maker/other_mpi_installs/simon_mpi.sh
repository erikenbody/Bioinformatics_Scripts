#!/bin/bash
#SBATCH -p general
#SBATCH --mem-per-cpu 6000
#SBATCH -n 256
#SBATCH -t 7-00:00:00
#SBATCH --contiguous    # Ensure that all of the cores are on the same Infiniband network
#SBATCH -o maker_LESP_mpi1_%A.out
#SBATCH -e maker_LESP_mpi1_%A.err
#SBATCH -J makerLESPMPI1


source new-modules.sh
module load gcc/5.2.0-fasrc01 openmpi/2.0.1-fasrc01 maker/2.31.8-fasrc01

export LD_PRELOAD=/n/sw/fasrcsw/apps/Comp/gcc/5.2.0-fasrc02/openmpi/2.0.1-fasrc01/lib64/libmpi.so
mpiexec -mca btl ^openib -np 256 maker -fix_nucleotides
