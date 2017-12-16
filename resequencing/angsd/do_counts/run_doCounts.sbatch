#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e do_counts.err            # File to which STDERR will be written
#SBATCH -o do_counts.out           # File to which STDOUT will be written
#SBATCH -J do_counts           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=6-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load zlib/1.2.8
module load xz/5.2.2

HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/do_counts

cd $WORK_D

if [ -d "Results" ]; then echo "Results file exists" ; else mkdir Results; fi

SAMPLES=allpops

#do counts to get metrics for scaffold specific coverage data

angsd -bam $HOME_D/${SAMPLES}_bamlist.txt -out Results/${SAMPLES}_Counts.txt -uniqueOnly 1 -remove_bads 1 -trim 0 -minMapQ 20 -only_proper_pairs 0 -minQ 20 -doCounts 1 -dumpCounts 2 -nThreads 20
