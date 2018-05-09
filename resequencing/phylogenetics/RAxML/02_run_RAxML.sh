#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e run_RAxML.err            # File to which STDERR will be written
#SBATCH -o run_RAxML.out           # File to which STDOUT will be written
#SBATCH -J run_RAxML           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=6-23:59:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load anaconda
source activate ede_py

#doing 18 threads just in case it needs 1-2 helper threads
#raxmlHPC-PTHREADS -T 18 -f a -m GTRGAMMA -p 12345 -x 12345 -# 100 -s RAxML_input.phy -o RBFW_220bp_GCTCAT_realigned -n T1

raxmlHPC-PTHREADS -s RAxML_input.phy -n SNP.ASCGTRCAT -m ASC_GTRCAT -x 12320 -p 12320 -# 50 -o RBFW_220bp_GCTCAT_realigned -T 20 -f a --asc-corr=lewis


#from helpfile: https://sco.h-its.org/exelixis/web/software/raxml/hands_on.html
#used to decide what I run
#raxmlHPC -m GTRGAMMA -p 12345 -s RAxML_input.phy -# 20 -n T6

#raxmlHPC-PTHREADS -T 2 -p 12345 -m PROTGAMMAWAG -s protein.phy -n T27

#raxmlHPC -f a -m GTRGAMMA -p 12345 -x 12345 -# 100 -s dna.phy -n T20
