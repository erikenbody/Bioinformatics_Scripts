#!/bin/bash
#
#sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/02_run_angsd_pop_4dxy.sh aida aida_naimii 3
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/02_run_angsd_pop_4dxy.sh aida aida_lorentzi 3
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/02_run_angsd_pop_4dxy.sh aida aida_moretoni 3
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/02_run_angsd_pop_4dxy.sh aida aida_naimii 3
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/02_run_angsd_pop_4dxy.sh moretoni aida_moretoni 5
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/02_run_angsd_pop_4dxy.sh moretoni lorentzi_moretoni 5
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/02_run_angsd_pop_4dxy.sh moretoni moretoni_naimii 5
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/02_run_angsd_pop_4dxy.sh lorentzi aida_lorentzi 5
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/02_run_angsd_pop_4dxy.sh lorentzi lorentzi_moretoni 5
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/02_run_angsd_pop_4dxy.sh lorentzi lorentzi_naimii 5
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/02_run_angsd_pop_4dxy.sh naimii aida_naimii 4
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/02_run_angsd_pop_4dxy.sh naimii lorentzi_naimii 4
sleep 1
sbatch ~/Bioinformatics_Scripts/resequencing/angsd/dxy_lowfilt_sp/02_run_angsd_pop_4dxy.sh naimii moretoni_naimii 4
