#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=20
#SBATCH -e star_i.err           # File to which STDERR will be written
#SBATCH -o star_i.out         # File to which STDOUT will be written
#SBATCH -J star_index                # Job name
#SBATCH --mem=50000                     # Memory requested
#SBATCH --time=23:00:00                # Runtime in HH:MM:SS
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

module load star/2.5.2a

#command for first time I ran it, no knowledge of splice junctions:
#STAR --runThreadN 20 --runMode genomeGenerate --genomeDir /lustre/project/jk/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/STAR --genomeFastaFiles /lustre/project/jk/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta

#running a second time, using splice junctions I made after mapping all samples together:
STAR --runThreadN 20 --runMode genomeGenerate --genomeDir /lustre/project/jk/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/STAR_sj --genomeFastaFiles /lustre/project/jk/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta --sjdbFileChrStartEnd /lustre/project/jk/Enbody_WD/WSFW_DDIG/RNAseq_WD/STAR/star_ref2_SJ.out.tab
