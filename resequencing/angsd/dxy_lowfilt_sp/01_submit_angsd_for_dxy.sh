#!/bin/bash

#
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/01_run_angsd_for_dxy.sh lorentzi_naimii sp_scaff.txt
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/01_run_angsd_for_dxy.sh aida_moretoni sp_scaff.txt
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/01_run_angsd_for_dxy.sh moretoni_naimii sp_scaff.txt
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/01_run_angsd_for_dxy.sh aida_lorentzi sp_scaff.txt
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/01_run_angsd_for_dxy.sh lorentzi_moretoni sp_scaff.txt
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/01_run_angsd_for_dxy.sh aida_naimii sp_scaff.txt
