#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=20
#SBATCH -e star_i2.err           # File to which STDERR will be written
#SBATCH -o star_i2.out         # File to which STDOUT will be written
#SBATCH -J star_index                # Job name
#SBATCH --mem=64000                     # Memory requested
#SBATCH --time=23:00:00                # Runtime in HH:MM:SS
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

module load star/2.5.2a

WORK_D=/home/eenbody/RNAseq_WD/Star/Star_annot_gene_names
cd $WORK_D

GDIR=/lustre/project/jk/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/STAR_sj_annot_gene_names
REF=/lustre/project/jk/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
SJTAB=/lustre/project/jk/Enbody_WD/WSFW_DDIG/RNAseq_WD/Star/No_annot_Star/star_ref2_SJ.out.tab
ANNOT=/home/eenbody/WSFW_assembly_maker2.maker.output/functional_annotation/maker_functional_final_output/STAR_wsfw_maker_renamed_nosemi_blast_ipr.gff

#after adding on "Name" as gene name attribute
STAR --runThreadN 20 --runMode genomeGenerate --genomeDir $GDIR --genomeFastaFiles $REF --sjdbFileChrStartEnd $SJTAB --sjdbGTFfile $ANNOT --sjdbGTFtagExonParentTranscript Parent --sjdbGTFtagExonParentGene Name --sjdbGTFfeatureExon exon
