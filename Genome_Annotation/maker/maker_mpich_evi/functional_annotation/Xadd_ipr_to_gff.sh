#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e addipr.err           # File to which STDERR will be written
#SBATCH -o addipr.out         # File to which STDOUT will be written
#SBATCH -J addipr      # Job name
#SBATCH --mem=6400                     # Memory requested
#SBATCH --qos=normal
#SBATCH --time=0-23:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

ipr_update_gff WSFW_assembly_maker2.all.gff ../interproscan_all/WSFW_assembly_maker2.all.maker.proteins.fasta.tsv > WSFW_annot_renamed_ipr.gff

iprscan2gff3 ../interproscan_all/WSFW_assembly_maker2.all.maker.proteins.fasta.tsv WSFW_assembly_maker2.all.gff > visible_iprscan_domains.gff 
