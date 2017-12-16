#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e star_map_%A_%a.err            # File to which STDERR will be written
#SBATCH -o star_map_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J star_map              # Job name
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load star/2.5.2a

FILENAME=`ls -1 *clp* | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
READ=$(echo $FILENAME | rev | cut -c 13- | rev)
NEWNAME=${READ:6}

#apparently set this up as an array! This is for running alignments for each sample individually. Without annotations though, I cannot run as is for quantmode

STAR --runThreadN 20 --genomeDir /lustre/project/jk/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/STAR \
--readFilesIn ${READ}_clp.fq.1.gz ${READ}_clp.fq.2.gz \
--readFilesCommand zcat \
--outSAMstrandField intronMotif \
--outFilterType BySJout \
--outFilterIntronMotifs RemoveNoncanonical \
--outSAMtype BAM SortedByCoordinate \
--twopassMode Basic \
--genomeLoad NoSharedMemory \
--outFileNamePrefix ${READ}_ \
--quantMode TranscriptomeSAM GeneCounts
