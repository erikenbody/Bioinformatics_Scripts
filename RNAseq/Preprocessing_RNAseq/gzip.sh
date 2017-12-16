#!/bin/bash

#SBATCH --qos=normal
#SBATCH -n 1 # one core
#SBATCH -N 1 # on one node
#SBATCH -t 0-12:00 # Running time of 2 hours
#SBATCH -o arraytest_%A_%a.out # Standard output
#SBATCH -e arraytest_%A_%a.err # Standard error
#SBATCH --mail-type=ALL
#SBATCH --mail-user=eenbody@tulane.edu

gzip *.fq
