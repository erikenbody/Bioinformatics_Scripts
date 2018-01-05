#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=20
#SBATCH --mem=64000                     # Memory requested
#SBATCH --qos=long
#SBATCH --time=1-24:00:00
#SBATCH -e ./logs/signal_tm.err    # File to which STDERR will be written
#SBATCH -o ./logs/signal_tm.out    # File to which STDOUT will be written
#SBATCH -J signal_tm    # Job name
#SBATCH --mail-type=ALL  # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

module load anaconda/2.5.0
source activate ede_py

export TRINOTATE_HOME=/home/eenbody/BI_software/Trinotate-Trinotate-v3.1.1
TRANS_DATA=/home/eenbody/Enbody_WD/WSFW_DDIG/RNAseq_WD/Guided_Trinity/trinity_gg/Trinity-GG.fasta
WORK_D=/home/eenbody/RNAseq_WD/Trinotate
cd $WORK_D
if [ -d "signalip_tmhmm_output" ]; then echo "output dir exists" ; else mkdir signalip_tmhmm_output; fi
cd signalip_tmhmm_output

signalp -f short -n signalp.out $WORK_D/Trinity-GG.fasta.transdecoder.pep

tmhmm --short < $WORK_D/Trinity-GG.fasta.transdecoder.pep > tmhmm.out
