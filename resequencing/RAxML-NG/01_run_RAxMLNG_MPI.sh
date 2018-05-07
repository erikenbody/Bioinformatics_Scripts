#!/bin/bash
#SBATCH -N 1
#SBATCH -n 20
#SBATCH --cpus-per-task=1
#SBATCH -e run_RAxMLNG2.err            # File to which STDERR will be written
#SBATCH -o run_RAxMLNG2.out           # File to which STDOUT will be written
#SBATCH -J run_RAxMLNG           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=128000
#SBATCH --time=0-23:59:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load  mpich/3.1.4
module load gcc/4.9.4
/share/apps/mpich/3.1.4/bin/mpiexec -n 20 raxml-ng-mpi --msa wsfw_concatenated.fasta --model GTR+G --threads 20 --prefix concat_fasta2--bs-trees 100

raxml-ng-mpi --msa RAxML_input.vcf --model GTR+G+ASC_LEWIS --threads 20 --prefix concat_fasta2--bs-trees 100
