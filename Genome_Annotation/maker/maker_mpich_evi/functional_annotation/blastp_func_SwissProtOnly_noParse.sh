#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=20
#SBATCH -e blastp_np2.err           # File to which STDERR will be written
#SBATCH -o blastp_np2.out         # File to which STDOUT will be written
#SBATCH -J blastp_np      # Job name
#SBATCH --mem=64000                     # Memory requested
#SBATCH --qos=normal
#SBATCH --time=0-6:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

module load anaconda/2.5.0
source activate ede_py

MAKER_HOME=/home/eenbody/maker_mpich/WSFW_assembly_maker2.maker.output
WORK_D=/home/eenbody/maker_mpich/WSFW_assembly_maker2.maker.output/functional_annotation

cd $WORK_D

RELEASE=sprot
#makeblastdb -in uniprot_sprot.fasta -out sp_db_np/uniprot_sprot -dbtype prot -title uniprot_sprot

#ORIGINAL RUN:
#blastp -db $WORK_D/sp_db_np/uniprot_sprot -query $MAKER_HOME/WSFW_assembly_maker2.all.maker.proteins.fasta -outfmt 6 -out WSFW_maker_blast_sprot_np.out -num_threads 20

#FOLLWING YANDELL:http://www.yandell-lab.org/publications/pdf/maker_current_protocols.pdf
blastp -db $WORK_D/sp_db_np/uniprot_sprot -query $MAKER_HOME/WSFW_assembly_maker2.all.maker.proteins.fasta -out WSFW_maker_blast_sprot_np_STRICT.out -evalue .000001 -outfmt 6 -num_alignments 1 -seg yes -soft_masking true -lcase_masking -max_hsps 1 -num_threads 20
