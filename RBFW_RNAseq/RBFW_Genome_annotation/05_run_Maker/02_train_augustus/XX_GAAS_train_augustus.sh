#!/bin/bash
#SBATCH -A snic2018-8-57
#SBATCH -p node -n 15
#SBATCH -t 0-23:00:00
#SBATCH -J augustus1
#SBATCH -e augustus1_%A.err            # File to which STDERR will be written
#SBATCH -o augustus1_%A.out
#SBATCH -M snowy
#SBATCH --mail-type=all
#SBATCH --mail-user=erik.enbody@gmail.com

#following: https://scilifelab.github.io/courses/annotation/2017/practical_session/TrainingAbInitionpredictor.html

GFF=RBFW.final.assembly.all.gff
SPECIES=RBFW
REF=/crex/proj/uppstore2017195/users/erik/ruff/test_augustus/RBFW.final.assembly.fasta
WORK_D=/crex/proj/uppstore2017195/users/erik/ruff/test_augustus

source /crex/proj/uppstore2017195/users/erik/ruff/ruff_software/GAAS/profiles/activate_rackham_env

module load bioinfo-tools
module load perl
module load perl_modules
module load BioPerl/1.6.924_Perl5.18.4
module load cufflinks/2.2.1

maker_gff3manager_JD_v8.pl -f $GFF -o ${GFF}_clean
cd ${GFF}_clean

mkdir filter
mkdir protein
mkdir nonredundant
mkdir blast_recursive
mkdir gff2genbank

filter_sort.pl -file codingGeneFeatures.gff -F $REF -o filter/codingGeneFeatures.filter.gff -c -r -d 500 -a 0.3
find_longest_CDS.pl -f filter/codingGeneFeatures.filter.gff -o codingGeneFeatures.filter.longest_cds.gff
gffread -y codingGeneFeatures.filter.longest_cds.tmp -g $REF codingGeneFeatures.filter.longest_cds.gff
fix_fasta.sh codingGeneFeatures.filter.longest_cds.tmp > protein/codingGeneFeatures.filter.longest_cds.proteins.fa

rm codingGeneFeatures.filter.longest_cds.tmp

module load blast

makeblastdb -in protein/codingGeneFeatures.filter.longest_cds.proteins.fa -dbtype prot
blastp -query protein/codingGeneFeatures.filter.longest_cds.proteins.fa -db protein/codingGeneFeatures.filter.longest_cds.proteins.fa -outfmt 6 -out blast_recursive/codingGeneFeatures.filter.longest_cds.proteins.fa.blast_recursive
gff_filter_by_mrna_id.pl --gff codingGeneFeatures.filter.longest_cds.gff --blast blast_recursive/codingGeneFeatures.filter.longest_cds.proteins.fa.blast_recursive --outfile nonredundant/codingGeneFeatures.nr.gff
module load augustus/3.2.3

gff2gbSmallDNA.pl nonredundant/codingGeneFeatures.nr.gff $REF 500 gff2genbank/codingGeneFeatures.nr.gbk
randomSplit.pl gff2genbank/codingGeneFeatures.nr.gbk 100

##do the below on cypress (uncomment for uppmax)
# new_species.pl --AUGUSTUS_CONFIG_PATH=augustus_path --species=$SPECIES
# AUGUSTUS_CONFIG_PATH=augustus_path
#
# etraining --species=$SPECIES gff2genbank/codingGeneFeatures.nr.gbk.train
# augustus --species=$SPECIES gff2genbank/codingGeneFeatures.nr.gbk.test | tee run.log
