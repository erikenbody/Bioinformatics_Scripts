module load R/3.4.1-intel
export R_LIBS_USER=/home/eenbody/BI_software/R/Library:$R_LIBS_USER

POP1=aida
POP2=naimii
POP3=lorentzi
POP4=moretoni
CHR=autosomes
SUBSET=NoCov50kb

if [ -d "Results/ManPlots" ]; then echo "ManPlot dir exists" ; else mkdir Results/ManPlots; fi

Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP1}_${POP2}_a.pbs.txt -c ${POP1}_${POP2}_${CHR}_${SUBSET} -o Results/ManPlots/${POP1}_${POP2}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP1}_${POP3}_a.pbs.txt -c ${POP1}_${POP3}_${CHR}_${SUBSET} -o Results/ManPlots/${POP1}_${POP3}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP1}_${POP4}_a.pbs.txt -c ${POP1}_${POP4}_${CHR}_${SUBSET} -o Results/ManPlots/${POP1}_${POP4}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP2}_${POP3}_a.pbs.txt -c ${POP2}_${POP3}_${CHR}_${SUBSET} -o Results/ManPlots/${POP2}_${POP3}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP2}_${POP4}_a.pbs.txt -c ${POP2}_${POP4}_${CHR}_${SUBSET} -o Results/ManPlots/${POP2}_${POP4}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP3}_${POP4}_a.pbs.txt -c ${POP3}_${POP4}_${CHR}_${SUBSET} -o Results/ManPlots/${POP3}_${POP4}_${CHR}_${SUBSET}.pdf

SUBSET=NoCov25kb

# realSFS fst stats2 Results/${POP1}_${POP2}.pbs.fst.idx -win 25000 -step 5000 -whichFST 0 > Results/${POP1}_${POP2}_${SUBSET}.pbs.txt
# realSFS fst stats2 Results/${POP1}_${POP3}.pbs.fst.idx -win 25000 -step 5000 -whichFST 0 > Results/${POP1}_${POP3}_${SUBSET}.pbs.txt
# realSFS fst stats2 Results/${POP1}_${POP4}.pbs.fst.idx -win 25000 -step 5000 -whichFST 0 > Results/${POP1}_${POP4}_${SUBSET}.pbs.txt
# realSFS fst stats2 Results/${POP2}_${POP3}.pbs.fst.idx -win 25000 -step 5000 -whichFST 0 > Results/${POP2}_${POP3}_${SUBSET}.pbs.txt
# realSFS fst stats2 Results/${POP2}_${POP4}.pbs.fst.idx -win 25000 -step 5000 -whichFST 0 > Results/${POP2}_${POP4}_${SUBSET}.pbs.txt
# realSFS fst stats2 Results/${POP3}_${POP4}.pbs.fst.idx -win 25000 -step 5000 -whichFST 0 > Results/${POP3}_${POP4}_${SUBSET}.pbs.txt

Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP1}_${POP2}_${SUBSET}.pbs.txt -c ${POP1}_${POP2}_${CHR}_${SUBSET} -o Results/ManPlots/${POP1}_${POP2}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP1}_${POP3}_${SUBSET}.pbs.txt -c ${POP1}_${POP3}_${CHR}_${SUBSET} -o Results/ManPlots/${POP1}_${POP3}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP1}_${POP4}_${SUBSET}.pbs.txt -c ${POP1}_${POP4}_${CHR}_${SUBSET} -o Results/ManPlots/${POP1}_${POP4}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP2}_${POP3}_${SUBSET}.pbs.txt -c ${POP2}_${POP3}_${CHR}_${SUBSET} -o Results/ManPlots/${POP2}_${POP3}_${CHR}_${SUBSET}.pdf
Rscript ~/Bioinformatics_Scripts/resequencing/angsd/fst/angsd_manhattan.R -i Results/${POP3}_${POP4}_${SUBSET}.pbs.txt -c ${POP3}_${POP4}_${CHR}_${SUBSET} -o Results/ManPlots/${POP3}_${POP4}_${CHR}_${SUBSET}.pdf
