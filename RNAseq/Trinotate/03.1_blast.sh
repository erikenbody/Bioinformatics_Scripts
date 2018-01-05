#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=20
#SBATCH --mem=64000                     # Memory requested
#SBATCH --qos=normal
#SBATCH --time=0-24:00:00
#SBATCH -e ./logs/blastx_%A_%a.err           # File to which STDERR will be written
#SBATCH -o ./logs/blastx_%A_%a.out         # File to which STDOUT will be written
#SBATCH -J blastx    # Job name
#SBATCH --array=1-40

module load anaconda/2.5.0
source activate ede_py

export TRINOTATE_HOME=/home/eenbody/BI_software/Trinotate-Trinotate-v3.1.1
TRANS_DATA=/home/eenbody/Enbody_WD/WSFW_DDIG/RNAseq_WD/Guided_Trinity/trinity_gg/Trinity-GG.fasta
WORK_D=/home/eenbody/RNAseq_WD/Trinotate
cd $WORK_D
mkdir blast_output
cd blast_output


blastx -query $WORK_D/split_fasta/Trinity-GG_cdna.vol.${SLURM_ARRAY_TASK_ID}.fasta -db $TRINOTATE_HOME/uniprot_sprot.pep -num_threads 20 -max_target_seqs 1 -outfmt 6 > blastx.vol.${SLURM_ARRAY_TASK_ID}.outfmt6
