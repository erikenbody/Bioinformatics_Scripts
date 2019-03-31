#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=20
#SBATCH -e cleanup2_%A_%a.err           # File to which STDERR will be written
#SBATCH -o cleanup2_%A_%a.out         # File to which STDOUT will be written
#SBATCH --mem=256000                     # Memory requested
#SBATCH -J cleanup2       # Job name
#SBATCH --qos=long
#SBATCH --time=7-00:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

export PATH=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre
module load python/2.7.11
module load mpich/3.1.4
module load bzip2/1.0.6 #added 2019
module load anaconda
source activate maker_depends #this way key - fresh environ with augustus, rmblastn, snoscan, trnascan

MAKER_HOME=/home/eenbody/RBFW_RNAseq/Genome_annotation/maker/RBFW.final.assembly.maker.output
WORK_D=/home/eenbody/RBFW_RNAseq/Genome_annotation/maker/RBFW.final.assembly.maker.output/functional_annotation
cd $WORK_D
#
interproscan.sh -i $MAKER_HOME/RBFW.final.assembly.all.maker.proteins.fasta -t p -dp -pa --goterms --iprlookup
#
ipr_update_gff RBFW.final.assembly.all.default.gff RBFW.final.assembly.all.maker.proteins.fasta.tsv > RBFW.final.assembly.all.default_ipr.gff

quality_filter.pl -s RBFW.final.assembly.all.default_ipr.gff  > RBFW.final.assembly.all.standard_ipr.gff
grep -cP '\tgene\t' RBFW.final.assembly.all.standard_ipr.gff

AED_cdf_generator.pl -b 0.025 RBFW.final.assembly.all.standard_ipr.gff
