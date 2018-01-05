#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=20
#SBATCH --mem=64000                     # Memory requested
#SBATCH --qos=normal
#SBATCH --time=0-24:00:00
#SBATCH -e ./logs/blastp_%A_%a.err           # File to which STDERR will be written
#SBATCH -o ./logs/blastp_%A_%a.out         # File to which STDOUT will be written
#SBATCH -J blastp    # Job name
#SBATCH --array=1-7

module load anaconda/2.5.0
source activate ede_py

export TRINOTATE_HOME=/home/eenbody/BI_software/Trinotate-Trinotate-v3.1.1
TRANS_DATA=/home/eenbody/Enbody_WD/WSFW_DDIG/RNAseq_WD/Guided_Trinity/trinity_gg/Trinity-GG.fasta
WORK_D=/home/eenbody/RNAseq_WD/Trinotate
cd $WORK_D
if [ -d "blastp_output" ]; then echo "output dir exists" ; else mkdir blastp_output; fi
cd blastp_output

blastp -query $WORK_D/split_fasta/Trinity-GG_pep.vol.${SLURM_ARRAY_TASK_ID}.fasta -db $TRINOTATE_HOME/uniprot_sprot.pep -num_threads 20 -max_target_seqs 1 -outfmt 6 > blastp.vol.${SLURM_ARRAY_TASK_ID}.outfmt6
