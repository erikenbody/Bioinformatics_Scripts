#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=20
#SBATCH --mem=64000                     # Memory requested
#SBATCH --qos=long
#SBATCH --time=1-24:00:00
#SBATCH -e ./logs/hmmer.err    # File to which STDERR will be written
#SBATCH -o ./logs/hmmer.out    # File to which STDOUT will be written
#SBATCH -J hmmer    # Job name
#SBATCH --mail-type=ALL  # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

module load anaconda/2.5.0
source activate ede_py

export TRINOTATE_HOME=/home/eenbody/BI_software/Trinotate-Trinotate-v3.1.1
TRANS_DATA=/home/eenbody/Enbody_WD/WSFW_DDIG/RNAseq_WD/Guided_Trinity/trinity_gg/Trinity-GG.fasta
WORK_D=/home/eenbody/RNAseq_WD/Trinotate
cd $WORK_D
if [ -d "hmmer_output" ]; then echo "output dir exists" ; else mkdir hmmer_output; fi
cd hmmer_output

hmmscan --cpu 20 --domtblout TrinotatePFAM.out $TRINOTATE_HOME/Pfam-A.hmm $WORK_D/Trinity-GG.fasta.transdecoder.pep > pfam.log
