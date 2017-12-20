#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=23:00:00
#SBATCH -e gzip.err            # File to which STDERR will be written
#SBATCH -o gzip.out           # File to which STDOUT will be written
#SBATCH -J gziptabix           # Job name
#SBATCH --mem=64000
#SBATCH --qos=normal
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load zlib/1.2.8
module load xz/5.2.2

WORK_D=/home/eenbody/reseq_WD/GATK_Haplotype_Caller/all_individuals/01_haplotype_caller

END=37

cd $WORK_D
for i in $(seq 1 $END)
do
  FILENAME=`ls -1 *raw.g.vcf | awk -v line=$i '{if (NR == line) print $0}'`
  echo $FILENAME
  bgzip -c $FILENAME > ${FILENAME}.gz
done
