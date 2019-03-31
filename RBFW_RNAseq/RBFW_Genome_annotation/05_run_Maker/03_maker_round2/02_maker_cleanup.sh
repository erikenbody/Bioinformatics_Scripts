#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=1
#SBATCH -e cleanup_%A_%a.err           # File to which STDERR will be written
#SBATCH -o cleanup_%A_%a.out         # File to which STDOUT will be written
#SBATCH -J cleanup       # Job name
#SBATCH --qos=normal
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

GENE=RBFW
SP=RBFW
MPRE=RBFW_2

cd /lustre/project/jk/Khalil_WD/RBFW_RNAseq/Genome_annotation/maker/RBFW_2.maker.output

module load mpich/3.1.4
module load bzip2/1.0.6 #added 2019
module load anaconda
source activate maker_depends #this way key - fresh environ with augustus, rmblastn, snoscan, trnascan

fasta_merge -d *index.log
gff3_merge -d *index.log

maker_map_ids --prefix ${GENE} --justify 6 ${MPRE}.all.gff > ${SP}.id.map
cp ${MPRE}.all.gff ${SP}.genome.orig.gff
cp ${MPRE}.all.maker.proteins.fasta ${MPRE}.all.maker.proteins.orig.fasta
cp ${MPRE}.all.maker.transcripts.fasta ${MPRE}.all.maker.transcripts.orig.fasta

map_fasta_ids ${SP}.id.map ${MPRE}.all.maker.proteins.fasta
map_fasta_ids ${SP}.id.map ${MPRE}.all.maker.transcripts.fasta
map_gff_ids ${SP}.id.map ${MPRE}.all.gff

#map_data_ids ${SP}.id.map ${SP}.renamed.iprscan
