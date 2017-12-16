### Running ANGSD
*Downstream analysis of processed resequencing data*


#### Helpful references

Generally following workflow of ngsTools
https://github.com/mfumagalli/ngsTools/blob/master/TUTORIAL.md

And the information from the ANGSD manual
http://www.popgen.dk/angsd/index.php/Main_Page#Overview

And Allison Shultz's helpful scripts:
https://github.com/ajshultz/whole-genome-reseq/tree/master/ANGSD

Bioawk: for getting scaffold lengths:
https://github.com/lh3/bioawk
https://www.biostars.org/p/118954/
```
bioawk -c fastx '{ print $name, length($seq) }'<WSFW_ref_final_assembly.fasta
```

#### Chromosome identity
`satsuma_run_zchr.sh`
http://satsuma.sourceforge.net/manual.html

It is sensible to run these downstream analyses separately for sex chromosomes and autosomes. Eventually, it will be worth mapping the W chromosome and running these analyses for those.

I am using SatsumaSynteny to map scaffolds to the ZEFI Z chromosome. See script `satsuma_run_zchr.sh` for details on this. I then setup separate folders for running autosomes and z chromosome.

After running this script I wrote this grep command to find scaffolds located in the refined output.
```
grep -E -o ".{0,5}scaffold.{0,5}" *refined* | sort| uniq
#still needs to be sorted by hand in excel (split on _, then sort)
```

#### Estimating coverage of variable sites
`check_coverage.sh`

Following ngsTools advice and runnign the script `check_coverage.sh`. I can use the information from this run to inform min and max coverage of later ANGSD runs.

#### Site Frequency Spectrum (SFS) in ANGSD
Calculate proportions of sites at different allele frequencies. First, need to calculate Sample Allele Frequency for each site (and per chromosome region), then run the SFS software; both in ANGSD.

* Run separately for each population (moretoni, lorentzi, naimii, aida)
* Run separately for autosomes and sex chromosomes

Looks like I'll the code chunk below:
* unclear if I should set -fold 1 or just leave as -anc $REFGENOME. -fold is listed as deprecated.
* unclear if it is -r or -rf to set which chromosomes I run
* Will run 8 total scripts: two for each pop

```
module load zlib/1.2.8
module load xz/5.2.2

POP=$1 #from list of naimii, moretoni, lorentzi, or aida
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
CHR=
MINCOV=40 #.info file is 0.01 percentile here at global coverage
MAXCOV=400 #well after last value, as in example
MININD=5 #3 or 4 for aida, because 7 samples

mkdir Results

angsd -P 20 -b $POP_bamlist.txt -ref $REFGENOME -anc $REFGENOME -out Results/${POP}.${CHR}.ref -rf $CHR \
                -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 1 -trim 0 \
                -minMapQ 20 -minQ 20 -minInd $MININD -setMinDepth $MINCOV -setMaxDepth $MAXCOV -doCounts 1 \
                -GL 1 -doSaf 1
realSFS Results/${POP}.${CHR}.ref.saf.idx -P 20 > Results/${POP}.${CHR}.ref.sfs
```

```
module load R

Rscript $NGSTOOLS/Scripts/plotSFS.R Results/moretoni.zchr_scaffolds.ref.sfs-Results/naimii.zchr_scaffolds.ref.sfs-Results/lorentzi.zchr_scaffolds.ref.sfs-Results/aida.zchr_scaffolds.ref.sfs moretoni-naimii-lorentzi-aida 1 Results/ALL.ref.sfs.pdf

Results/LWK.ref.sfs-Results/TSI.ref.sfs-Results/PEL.ref.sfs LWK-TSI-PEL 1 Results/ALL.ref.sfs.pdf


```


For comparison, AS's script
```

angsd -bam ${BAMLISTDIR}/${SAMPLES}_BamList.txt -anc ${ANC} -uniqueOnly 1 -remove_bads 1 -trim 0 -minMapQ 20 -minQ 20 -sites ${SITES} -only_proper_pairs 0 -nThreads 8 -out results_saf/${SAMPLES}_ZChr -doSaf 1 -GL 1 -skipTriallelic 1 -rf z_chr_cov_scaffs.angsdrf

realSFS results_saf/${SAMPLES}_ZChr.saf.idx -P 8 > results_saf/${SAMPLES}_ZChr.sfs
```


#### Call FST in sliding windows

Can also be done in ANGSD. Follow suggestions from ngsTools. This will use SFS from previous section.

```
$ANGSD/misc/realSFS fst index Results/moretoni.zchr_scaffolds.ref.saf.idx Results/lorentzi.zchr_scaffolds.ref.saf.idx Results/naimii.zchr_scaffolds.ref.saf.idx Results/aida.zchr_scaffolds.ref.saf.idx -sfs Results/moretoni.zchr_scaffolds.ref.sfs -sfs Results/lorentzi.zchr_scaffolds.ref.sfs -sfs Results/naimii.zchr_scaffolds.ref.sfs -sfs Results/aida.zchr_scaffolds.ref.sfs -fstout Results/WSFW.pbs -whichFST
```


| Populations        | Fst Unweighted    | Fst Weighted  |
| ------------- |:-------------:| -----:|
| aida vs naimii     | 0.030212 |   0.087849 |
| aida vs lorentzi   | 0.025447 |   0.225410 |
| aida vs moretoni   | 0.039581 |   0.224028 |
| moretoni vs lorentzi | 0.033237 | 0.310823 |
| moretoni vs naimii |  0.031570     |  0.233177   |
| naimii vs lorentzi | 0.032364      |  0.257469   |


#### Simple PCA

This is very simple PCA, without separating chromosomes

Following Simon's quick run to visualize possible issues with samples 24 and 35.

First I made a txt file that includes all the .bam files generated after doing indel realignment in preprocessing folder.

```
cd /path/to/bam/files
ls -d -1 $PWD/*.bam* >> bam_list.txt
```
Next I ran `angsd_pca_input.sh` which closely follows `simon_simple_pca.sh`, but I dont split apart by z and autosomes (I only only have females).

After this was done I ran gunzip in the working folder to unzip .geno.gz and .mafs.gz output files from angsd. I should have done this in iDev, it took some time.

```
gunzip *.gz
```

Next, to get number of sites I ran (following Simon)

```
N_SITES=`cat /home/eenbody/reseq_WD/angsd/angsd_pca/WSFW_F_angsd1.mafs | tail -n+2 | wc -l`
echo $N_SITES
```

run `02_ngsCovar_run.sh`

##### Plot the PCA using R
first need to make a comma seperated string of file names. Nice solution here:
https://stackoverflow.com/questions/24884851/converting-a-list-to-double-quoted-comma-separated-strings

```
cd /home/eenbody/reseq_WD/Preprocessing_fixed/04_indel_realign/merged_realigned_bams/
ls -1 *.bam >> bam_list_file.txt #make list of files (without path)
cat bam_list_file.txt | cut -d "_" -f 1,2 >> bam_list_file_ID.txt #only ID and band number
#sed -i -e 's/_realigned.sorted.bam//g' bam_list_file.txt #get rid of file extensions (no longer needed)
awk -v RS='' -v OFS='","' 'NF { $1 = $1; print "\"" $0 "\"" }' bam_list_file_ID.txt >> bam_list_file_ID_c.txt #from link, make csv
cp *ID_c.txt ~/reseq_WD/angsd/angsd_pca/
```

Also need subspecies file in same same order
```
cat bam_list_file.txt | cut -d "_" -f 3 >> ssp_bam_list.txt #only keep ssp
awk -v RS='' -v OFS='","' 'NF { $1 = $1; print "\"" $0 "\"" }' ssp_bam_list.txt >> ssp_bam_list_c.txt
cp ssp_bam_list_c.txt ~/reseq_WD/angsd/angsd_pca/
cd ~/reseq_WD/angsd/angsd_pca/
```
