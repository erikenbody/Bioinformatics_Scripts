#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --qos=long
#SBATCH --time=6-23:00:00
#SBATCH -e Satsuma_%A_%a.err            # File to which STDERR will be written
#SBATCH -o Satsuma_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J Satsuma             # Job name
#SBATCH --cpus-per-task=20

WORK_D=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/satsuma_chr_map
cd $WORK_D

~/BI_software/satsuma-code/Chromosemble -n 20 -t Taeniopygia_guttata.taeGut3.2.4.dna.toplevel.fa -q WSFW_ref_final_assembly.fasta -o WSFW_ref_final_assembly_taeGut3.2.4 -pseudochr 1
