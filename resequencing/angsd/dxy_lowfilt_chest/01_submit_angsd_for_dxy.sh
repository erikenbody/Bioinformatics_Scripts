#!/bin/bash

#not working when running for all scaffolds (below commented commands)
#sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt/01_run_angsd_for_dxy.sh lorentzi_naimii
#sleep 1
#sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt/01_run_angsd_for_dxy.sh moretoni_naimii
#sleep 1
#sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt/01_run_angsd_for_dxy.sh aida_lorentzi
#sleep 1
#sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt/01_run_angsd_for_dxy.sh aida_moretoni
#sleep 1
#sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt/01_run_angsd_for_dxy.sh lorentzi_moretoni
#sleep 1
#sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt/01_run_angsd_for_dxy.sh aida_naimii

#try running only for scaffolds with divergent Fst regions
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_chest/01_run_angsd_for_dxy.sh moretoni_naimii chest_scaff.txt
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_chest/01_run_angsd_for_dxy.sh aida_lorentzi chest_scaff.txt
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_chest/01_run_angsd_for_dxy.sh lorentzi_moretoni chest_scaff.txt
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_chest/01_run_angsd_for_dxy.sh aida_naimii chest_scaff.txt
sleep 1
#
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_chest/01_run_angsd_for_dxy.sh lorentzi_naimii chest_scaff.txt
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_chest/01_run_angsd_for_dxy.sh aida_moretoni chest_scaff.txt
