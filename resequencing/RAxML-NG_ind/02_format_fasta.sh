#!/bin/bash
#SBATCH -N 1
#SBATCH -n 20
#SBATCH -e format_fasta.err            # File to which STDERR will be written
#SBATCH -o format_fasta.out           # File to which STDOUT will be written
#SBATCH -J format_fasta           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

#gunzip *.fa.gz

#for filename in ./*.fa; do
#  cat $filename | sed '1!{/^>.*/d;}' > ${filename}_conc.fasta
#done

for filename in *_conc.fasta
do
  SAMPLE=$(echo $filename | cut -c -13)
  sed -i "1s/.*/>${SAMPLE}/" $filename
done

cat *_conc.fasta > wsfw_phylo_input_16ind.fasta
