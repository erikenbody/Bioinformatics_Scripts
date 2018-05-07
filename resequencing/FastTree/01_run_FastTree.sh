#!/bin/bash
#SBATCH -N 1
#SBATCH -n 20
#SBATCH -e run_FastTree.err            # File to which STDERR will be written
#SBATCH -o run_FastTree.out           # File to which STDOUT will be written
#SBATCH -J run_FastTree           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --time=6-23:59:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

FastTree -nt  wsfw_concatenated.fasta > wsfw.fastree.nwk
