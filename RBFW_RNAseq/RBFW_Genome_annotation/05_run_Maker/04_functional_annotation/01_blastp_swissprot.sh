#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=1
#SBATCH -e cleanup_%A_%a.err           # File to which STDERR will be written
#SBATCH -o cleanup_%A_%a.out         # File to which STDOUT will be written
#SBATCH -J cleanup       # Job name
#SBATCH --time=0-01:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

module load mpich/3.1.4
module load bzip2/1.0.6 #added 2019
module load anaconda

#source activate /home/eenbody/BI_software/conda_environments/ede_py2
#export PERL5LIB=/home/eenbody/BI_software/conda_environments/ede_py2/lib/site_perl/5.26.2/ #required to get repeatmasker working
source activate maker_depends #this way key - fresh environ with augustus, rmblastn, snoscan, trnascan

MAKER_HOME=/home/eenbody/RBFW_RNAseq/Genome_annotation/maker/RBFW.final.assembly.maker.output
WORK_D=/home/eenbody/RBFW_RNAseq/Genome_annotation/maker/RBFW.final.assembly.maker.output/functional_annotation

cd $WORK_D
mkdir sp_db_np

RELEASE=sprot
#makeblastdb -in uniprot_sprot_20190329.fasta -out sp_db_np/uniprot_sprot -dbtype prot -title uniprot_sprot

#FOLLWING YANDELL:http://www.yandell-lab.org/publications/pdf/maker_current_protocols.pdf
#blastp -db $WORK_D/sp_db_np/uniprot_sprot -query $MAKER_HOME/RBFW.final.assembly.all.maker.proteins.fasta -out RBFW.final.assembly.all.maker_blast_sprot_np_STRICT.out -evalue .000001 -outfmt 6 -num_alignments 1 -seg yes -soft_masking true -lcase_masking -max_hsps 1 -num_threads 20

maker_functional_gff uniprot_sprot_20190329.fasta RBFW.final.assembly.all.maker_blast_sprot_np_STRICT.out RBFW.final.assembly.all.default_ipr.gff > RBFW.final.assembly.all.default_ipr_blast.gff
maker_functional_fasta uniprot_sprot_20190329.fasta RBFW.final.assembly.all.maker_blast_sprot_np_STRICT.out ../RBFW.final.assembly.all.maker.proteins.fasta > RBFW.final.assembly.all.maker.proteins_blast.fasta
maker_functional_fasta uniprot_sprot_20190329.fasta RBFW.final.assembly.all.maker_blast_sprot_np_STRICT.out ../RBFW.final.assembly.all.maker.transcripts.fasta > RBFW.final.assembly.all.maker.transcripts_blast.fasta
