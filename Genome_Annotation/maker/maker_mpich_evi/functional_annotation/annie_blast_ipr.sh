#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=20
#SBATCH --mem=64000                     # Memory requested
#SBATCH --qos=normal
#SBATCH --time=0-10:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu
#SBATCH -e annie.err           # File to which STDERR will be written
#SBATCH -o annie.out         # File to which STDOUT will be written
#SBATCH -J annie      # Job name

module load anaconda3

WORK_D=/home/eenbody/WSFW_assembly_maker2.maker.output/functional_annotation
cd $WORK_D

#using file with trailing semi colon removed (see README)
#Using file with correct blast database (i.e. no parse-seq)

~/BI_software/Annie/annie.py -b WSFW_maker_blast_sprot_np.out -db sp_db_np/uniprot_sprot.fasta -ipr interproscan_all/WSFW_assembly_maker2.all.maker.proteins.fasta.tsv -g ../WSFW.maker2_renamed_nosemi.gff -o maker_functional_final_output/WSFW_maker_ipr_blast.annie

#change cutoff for blast
awk '$11<0.01' WSFW_maker_blast_sprot_np.out > WSFW_maker_blast_sprot_np_0.01.out

~/BI_software/Annie/annie.py -b WSFW_maker_blast_sprot_np_0.01.out -db sp_db_np/uniprot_sprot.fasta -g ../WSFW.maker2_renamed_nosemi.gff -o maker_functional_final_output/WSFW_maker_blast_0.01.annie

awk '$11<1e-6' WSFW_maker_blast_sprot_np.out > WSFW_maker_blast_sprot_np_1e-6.out

~/BI_software/Annie/annie.py -b WSFW_maker_blast_sprot_np_1e-6.out -db sp_db_np/uniprot_sprot.fasta -g ../WSFW.maker2_renamed_nosemi.gff -o maker_functional_final_output/WSFW_maker_blast_1e-6.annie

#after re running blast with more strict params

~/BI_software/Annie/annie.py -b WSFW_maker_blast_sprot_np_STRICT.out -db sp_db_np/uniprot_sprot.fasta -g ../WSFW.maker2_renamed_nosemi.gff -o maker_functional_final_output/WSFW_maker_blast_sprot_np_STRICT.annie 
