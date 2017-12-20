#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e cscff.err            # File to which STDERR will be written
#SBATCH -o cscff.out           # File to which STDOUT will be written
#SBATCH -J collapse_scaffold          # Job name
#SBATCH --mem=128000
#SBATCH --time=1-00:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL

module load python/2.7.11
module load anaconda/2.5.0
source activate ede_py #required for custom packages apparently (e.g. numpy)

WORK_D=/home/eenbody/reseq_WD/angsd/do_counts/Results
cd $WORK_D

python ~/Bioinformatics_Scripts/resequencing/angsd/do_counts/collapse_scaffold_coverage_interval_indiv_filter.py -i allpops_Counts.txt -o All_WSFW_Scaffold_Indiv_Coverage_Stats_Int.txt -b bam_sample_list.txt -u 6.9 -l 0.5
