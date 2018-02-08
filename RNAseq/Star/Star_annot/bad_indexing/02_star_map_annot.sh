#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e ./logs/star_map_%A_%a.err            # File to which STDERR will be written
#SBATCH -o ./logs/star_map_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J star_map              # Job name
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=23:00:00              # Runtime in D-HH:MM:SS

module load star/2.5.2a

SAMPLEDIR=/home/eenbody/RNAseq_WD/QC_RNAseq/rRNA_removal/silva_full_ref
WORK_D=/home/eenbody/RNAseq_WD/Star/Star_annot
STARREF=/lustre/project/jk/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/STAR_sj_annot2

cd $SAMPLEDIR
FILENAME=`ls -1 *clp.fq.1* | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
READ=$(echo $FILENAME | rev | cut -c 13- | rev)
cd $WORK_D

STAR --runThreadN 20 --genomeDir $STARREF \
--readFilesIn $SAMPLEDIR/${READ}_clp.fq.1.gz $SAMPLEDIR/${READ}_clp.fq.2.gz \
--readFilesCommand zcat \
--outSAMstrandField intronMotif \
--outFilterType BySJout \
--outFilterIntronMotifs RemoveNoncanonical \
--outSAMtype BAM SortedByCoordinate \
--twopassMode Basic \
--genomeLoad NoSharedMemory \
--outFileNamePrefix Results/${READ} \
--quantMode TranscriptomeSAM GeneCounts

#just Testing

ANNOT=/home/eenbody/WSFW_assembly_maker2.maker.output/functional_annotation/maker_functional_final_output/wsfw_maker_renamed_nosemi_blast_ipr.gff
STARREF=/lustre/project/jk/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/STAR_sj

STAR --runThreadN 20 --genomeDir $STARREF \
--readFilesIn $SAMPLEDIR/${READ}_clp.fq.1.gz $SAMPLEDIR/${READ}_clp.fq.2.gz \
--sjdbGTFfile $ANNOT \
--sjdbGTFtagExonParentGene Parent \
--sjdbGTFtagExonParentTranscript ID \
--sjdbGTFfeatureExon exon \
--readFilesCommand zcat \
--outSAMstrandField intronMotif \
--outFilterType BySJout \
--outFilterIntronMotifs RemoveNoncanonical \
--outSAMtype BAM SortedByCoordinate \
--twopassMode Basic \
--genomeLoad NoSharedMemory \
--outFileNamePrefix ${READ} \
--quantMode TranscriptomeSAM GeneCounts
