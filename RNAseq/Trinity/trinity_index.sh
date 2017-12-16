#!/bin/bash
#SBATCH --qos=normal            # Quality of Service
#SBATCH --mem=8000  #Memory per node in MB
#SBATCH --job-name=bt2_index           # Job Name
#SBATCH --time=03:00:00         # WallTime
#SBATCH --nodes=1               # Number of Nodes
#SBATCH --ntasks-per-node=1     # Number of tasks (MPI processes)
#SBATCH --cpus-per-task=20       # Number of threads per task (OMP threads)
#SBATCH -o b2build.o
#SBATCH -e b2build.e
#SBATCH --mail-type=ALL
#SBATCH --mail-user=eenbody@tulane.edu

assembly_prefix=$(basename $1 |sed 's/.fasta//g')

module load bowtie2

bowtie2-build $1 $assembly_prefix –-threads 20
