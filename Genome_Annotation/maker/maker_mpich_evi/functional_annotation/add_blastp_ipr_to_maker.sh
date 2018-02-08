#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e ./logs/addblastipr.err           # File to which STDERR will be written
#SBATCH -o ./logs/addblastipr.out         # File to which STDOUT will be written
#SBATCH -J addblast    # Job name
#SBATCH --mem=3200                     # Memory requested
#SBATCH --qos=normal
#SBATCH --time=0-2:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

#before fixing blast output and gff
#maker_functional_gff sp_db/ WSFW_maker_blast_sprot.out maker_functional_final_output/WSFW_annot_renamed_ipr.gff > maker_functional_final_output/WSFW_annot_renamed_ipr_blast2.gff
#maker_functional_fasta sp_db/ WSFW_maker_blast_sprot.out ../WSFW_assembly_maker2.all.maker.augustus_masked.proteins.fasta > maker_functional_final_output/WSFW_maker_proteins_putative.function.fasta
#maker_functional_fasta sp_db/ WSFW_maker_blast_sprot.out ../WSFW_assembly_maker2.all.maker.transcripts.fasta > maker_functional_final_output/WSFW_maker_transcripts_putative.function.fasta

WORK_D=/home/eenbody/WSFW_assembly_maker2.maker.output/functional_annotation
cd $WORK_D

maker_functional_gff sp_db_np/uniprot_sprot.fasta WSFW_maker_blast_sprot_np.out ../WSFW.maker2_renamed_nosemi.gff > maker_functional_final_output/wsfw_maker_renamed_nosemi_blast.gff

maker_functional_fasta sp_db_np/uniprot_sprot.fasta WSFW_maker_blast_sprot_np.out ../WSFW_assembly_maker2.all.maker.proteins.fasta > maker_functional_final_output/wsfw_maker_proteins_blast.fasta

maker_functional_fasta sp_db_np/uniprot_sprot.fasta WSFW_maker_blast_sprot_np.out ../WSFW_assembly_maker2.all.maker.transcripts.fasta > maker_functional_final_output/wsfw_maker_transcripts_blast.fasta

ipr_update_gff maker_functional_final_output/wsfw_maker_renamed_nosemi_blast.gff interproscan_all/WSFW_assembly_maker2.all.maker.proteins.fasta.tsv > maker_functional_final_output/wsfw_maker_renamed_nosemi_blast_ipr.gff

#already did this so maybe not neccessary.
#iprscan2gff3 ../interproscan_all/WSFW_assembly_maker2.all.maker.proteins.fasta.tsv maker_functional_final_output/WSFW.maker2_renamed_nosemi.gff > visible_iprscan_domains.gff
