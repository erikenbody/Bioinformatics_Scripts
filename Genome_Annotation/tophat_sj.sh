#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=23:00:00
#SBATCH -e tophat.err            # File to which STDERR will be written
#SBATCH -o tophat.out           # File to which STDOUT will be written
#SBATCH -J tophat             # Job name
#SBATCH --mem=64000
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

module load tophat/2.1.1
module load bowtie2/2.3.3
REF=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW

tophat --library-type fr-secondstrand --gcbias -p 20 --no-sort-bam --no-convert-bam $REF/WSFW_ref_noIUB 27-47816-moretoni-M-Chest_S26_clp.fq.1.gz,28-47816-moretoni-M-SP_S27_clp.fq.1.gz 27-47816-moretoni-M-Chest_S26_clp.fq.2.gz,28-47816-moretoni-M-SP_S27_clp.fq.2.gz
