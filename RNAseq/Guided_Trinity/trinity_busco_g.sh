#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=20
#SBATCH -e BUSCO.err           # File to which STDERR will be written
#SBATCH -o BUSCO.out         # File to which STDOUT will be written
#SBATCH -J BUSCO                # Job name
#SBATCH --mem=6000                     # Memory requested
#SBATCH --time=04:00:00                # Runtime in HH:MM:SS
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

module load anaconda
source activate ede_py

#working directory
#cd /lustre/project/jk/Enbody_WD/WSFW_DDIG/RNAseq_WD/Trinity/trinity_denovo
WORK_D=/home/eenbody/RNAseq_WD/Guided_Trinity/trinity_gg
BUSCO=/home/eenbody/RNAseq_WD/BUSCO_database/vertebrata_odb9/
cd $WORK_D


busco -c 20 -o trinity_BUSCO -i Trinity-GG.fasta -l $BUSCO -m tran -f -sp chicken
