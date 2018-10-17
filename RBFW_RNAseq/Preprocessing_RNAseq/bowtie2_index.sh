#!/bin/bash
#SBATCH --qos=normal            # Quality of Service
#SBATCH --job-name=bt2_index           # Job Name
#SBATCH --time=03:00:00         # WallTime
#SBATCH --nodes=1               # Number of Nodes
#SBATCH --ntasks-per-node=1     # Number of tasks (MPI processes)
#SBATCH --cpus-per-task=12       # Number of threads per task (OMP threads)
#SBATCH -o rmunfix_%A.o
#SBATCH -e rmunfix_%A.e
#SBATCH --mail-type=ALL
#SBATCH --mail-user=eenbody@tulane.edu

module load bowtie2

bowtie2-build --threads 12 zefi_rRNA.fasta zefi_rRNA
