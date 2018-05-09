#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e treemix2.err            # File to which STDERR will be written
#SBATCH -o treemix2.out           # File to which STDOUT will be written
#SBATCH -J treemix           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load anaconda
source activate ede_py

module load R/3.4.1-intel
export R_LIBS_USER=/home/eenbody/BI_software/R/Library:$R_LIBS_USER

HOME_D=/home/eenbody/reseq_WD/phylotree/for_plink/
WORK_D=/home/eenbody/reseq_WD/phylotree/for_plink/Results_treemix
cd $WORK_D

#run with boostrap
for i in 1 2 3 4 5
do
  cd $WORK_D
  mkdir ${i}m_outgroup_windows_jk
  cd ${i}m_outgroup_windows_jk
  treemix -i $HOME_D/treemix.frq.gz -root melanocephalus -se -k 1000 -m $i -o out_stem
  Rscript ~/Bioinformatics_Scripts/resequencing/snapp_treemix/treemix_plot.R
  echo $i
done

# for i in 1 2 3 4 5
# do
#   cd $WORK_D
#   mkdir ${i}m_outgroup_windows_bs
#   cd ${i}m_outgroup_windows_bs
#   treemix -i $HOME_D/treemix.frq.gz -root melanocephalus -bootstrap -k 1000 -m $i -o out_stem
#   Rscript ~/Bioinformatics_Scripts/resequencing/snapp_treemix/treemix_plot.R
#   echo $i
# done

#mkdir default
#cd default
#treemix -i $HOME_D/treemix.frq.gz -o out_stem
#Rscript ~/Bioinformatics_Scripts/resequencing/snapp_treemix/treemix_plot.R
#
# mkdir outgroup_windows_1000
# cd outgroup_windows_1000
# treemix -i $HOME_D/treemix.frq.gz -root melanocephalus -k 1000 -o out_stem
# Rscript ~/Bioinformatics_Scripts/resequencing/snapp_treemix/treemix_plot.R
#
# cd $WORK_D
# mkdir outgroup_windows_500
# cd outgroup_windows_500
# treemix -i $HOME_D/treemix.frq.gz -root melanocephalus -k 500 -o out_stem
# Rscript ~/Bioinformatics_Scripts/resequencing/snapp_treemix/treemix_plot.R
#
# cd $WORK_D
# mkdir 1m_outgroup_windows
# cd 1m_outgroup_windows
# treemix -i $HOME_D/treemix.frq.gz -root melanocephalus -k 1000 -m 1 -o out_stem
# Rscript ~/Bioinformatics_Scripts/resequencing/snapp_treemix/treemix_plot.R
#
# cd $WORK_D
# mkdir 2m_outgroup_windows
# cd 2m_outgroup_windows
# treemix -i $HOME_D/treemix.frq.gz -root melanocephalus -k 1000 -m 2 -o out_stem
# Rscript ~/Bioinformatics_Scripts/resequencing/snapp_treemix/treemix_plot.R
#
# cd $WORK_D
# mkdir 3m_outgroup_windows
# cd 3m_outgroup_windows
# treemix -i $HOME_D/treemix.frq.gz -root melanocephalus -k 1000 -m 3 -o out_stem
# Rscript ~/Bioinformatics_Scripts/resequencing/snapp_treemix/treemix_plot.R
#
# cd $WORK_D
# mkdir 4m_outgroup_windows
# cd 4m_outgroup_windows
# treemix -i $HOME_D/treemix.frq.gz -root melanocephalus -k 1000 -m 4 -o out_stem
# Rscript ~/Bioinformatics_Scripts/resequencing/snapp_treemix/treemix_plot.R
#
# cd $WORK_D
# mkdir 5m_outgroup_windows
# cd 5m_outgroup_windows
# treemix -i $HOME_D/treemix.frq.gz -root melanocephalus -k 1000 -m 5 -o out_stem
# Rscript ~/Bioinformatics_Scripts/resequencing/snapp_treemix/treemix_plot.R
