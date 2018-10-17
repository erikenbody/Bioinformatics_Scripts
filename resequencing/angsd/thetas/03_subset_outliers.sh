#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e thetas_%j.err            # File to which STDERR will be written
#SBATCH -o thetas_%j.out           # File to which STDOUT will be written
#SBATCH -J thetas           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=128000
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to
#

for FILE in naimii_Theta_persite
do
  awk '$1 == "scaffold_142"' $FILE > ${FILE}_s142.txt
  awk '$1 == "scaffold_239"' $FILE > ${FILE}_s239.txt
  awk '$1 == "scaffold_278"' $FILE > ${FILE}_s278.txt
  cat ${FILE}_s142.txt ${FILE}_s239.txt ${FILE}_s278.txt > ${FILE}_subset.txt
done
