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

#### Filtering in ANGSD

Trying to filter as strictly as I do in GATK, but having some troubles. Here is what I'm running:

```
angsd -b $BAMLIST -ref $REFGENOME -anc $REFGENOME -out Results/${POP}.${RUN}_${DESCRIPTION}.ref -rf $REGIONS -P 20 \
              -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 0 -trim 0 \
              -minMapQ 20 -minQ 20 -setMinDepth 83.66 -setMaxDepth 334.64 -SNP_pval 1e-6 -minInd $MININD -minMaf 0.01 \
              -doCounts 1 \
              -doMaf 1 -doMajorMinor 1 -GL 1 -doSaf 1
```

Originally I ran with depth as per individual (3-11). Both the command above and that one lead to very few sites at the end. It makes me think I am not understanding the depth filter command correctly, which is frustrating. Maybe I should just filter out excessively high coverage and leave it at that.

* uniqueOnly - Remove reads that have multiple best hits. 0 no (default), 1 remove.
* remove_bads - Same as the samtools flags -x which removes read with a flag above 255 (not primary, failure and duplicate reads). 0 no , 1 remove (default).
* only_proper_pairs - Include only proper pairs (pairs of read with both mates mapped correctly). 1: include only proper (default), 0: use all reads. Only relevant for paired end data.
* trim - Number of bases to remove from both ends of the read.
* minMapQ - remove sites <20 map Quality
* minQ - low quality base calls
* depth - still having issues with this
* SNP_pval - sets it to biallelic sites? Still somewhat unclear on this
* minInd - remove sites not called for less individuals than this
* minMaf - remove sites with <0.01 minimuma allele frequency


#### Call FST in sliding windows

Can also be done in ANGSD. Follow suggestions from ngsTools. This will use SFS from previous section.

```
$ANGSD/misc/realSFS fst index Results/moretoni.zchr_scaffolds.ref.saf.idx Results/lorentzi.zchr_scaffolds.ref.saf.idx Results/naimii.zchr_scaffolds.ref.saf.idx Results/aida.zchr_scaffolds.ref.saf.idx -sfs Results/moretoni.zchr_scaffolds.ref.sfs -sfs Results/lorentzi.zchr_scaffolds.ref.sfs -sfs Results/naimii.zchr_scaffolds.ref.sfs -sfs Results/aida.zchr_scaffolds.ref.sfs -fstout Results/WSFW.pbs -whichFST
```

Get global estimate
```
realSFS fst stats aida_naimii.pbs.fst.idx > aida_naimii.pbs.fst.idx.global_fst
```

Not sure what filtering these values are from:
| Populations        | Fst Unweighted    | Fst Weighted  |
| ------------- |:-------------:| -----:|
| aida vs naimii     | 0.030212 |   0.087849 |
| aida vs lorentzi   | 0.025447 |   0.225410 |
| aida vs moretoni   | 0.039581 |   0.224028 |
| moretoni vs lorentzi | 0.033237 | 0.310823 |
| moretoni vs naimii |  0.031570     |  0.233177   |
| naimii vs lorentzi | 0.032364      |  0.257469   |

From no relatives, sensible:

```
cd /lustre/project/jk/Enbody_WD/WSFW_DDIG/reseq_WD/angsd/fst_angsd/fst_actual_analysis/no_relatives/autosome/NR_sensible
realSFS fst stats aida_naimii_autosome_NR_sensible.fst.idx > aida_naimii.global_fst.txt
-> FST.Unweight[nObs:5284777]:0.052722 Fst.Weight:0.069410
realSFS fst stats lorentzi_moretoni_autosome_NR_sensible.fst.idx > lorentzi_moretoni.globla_fst.txt
-> FST.Unweight[nObs:4939876]:0.153434 Fst.Weight:0.201952
```

#### Possible sliding window bug

A number of scaffolds that are shorter than the window input appear in the pbs/fst file output. These appear in the manhattan plot on the far right. On close inspection, they have Fst calculations for long stretches of regions.

E.g. scaffold 2414 is only 4419bp long, but has many windows recorded. Here are the first 4 lines of the .pbs file out, but there are many windows for this scaffold. Other scaffolds of similar length do not have any output for them.
```
(4494,54464)(10000,59999)(10000,60000)	scaffold_2414	35000	49972	0.092939
(14494,64396)(20000,69999)(20000,70000)	scaffold_2414	45000	49904	0.053504
(24482,74334)(30000,79999)(30000,80000)	scaffold_2414	55000	49854	0.052940
(34474,84305)(40000,89999)(40000,90000)	scaffold_2414	65000	49833	0.054498
```

It does not look like they are grouping with scaffold 241, for example and getting the length. Instead, I can see that the values for 2414 are the same as scaffold_0. The results for 2498 correspond to scaffold 1. So for some reason, when it gets to this scaffold, it calculates Fst for the first scaffold in the list, then the same for the next, iteratively. But it is not clear why this would happen starting at scaffold 2414 and not earlier. There are many scaffolds in the list that have shorter lengths before it.

To do and solutions:
* Can just filter out scaffolds with length < window length in R after the fact. Or, could include these as -rf? I made scaffolds that could be used as -rf with realSFS (in the r project output folder)
* Run fst window in terminal to see output. See if you can identify what output says in the scaffold of interest (e.g. 2414). Can also try running just for scaffold 2414 and see what output is.  

Now I am trying to look at each output to see how many sites it finds on scaffold_2414. Already know that the window .pbs output has too many regions calculated, so going back from there.

Good visualization of the fst file from ANGSD has too many sites at 2414, but correct for 2415


```
realSFS fst print aida_naimii.pbs.fst.idx -r scaffold_2414
>scaffold_2414	101	0.000011	0.000209
>scaffold_2414	102	0.000011	0.000206
>scaffold_2414	103	0.000011	0.000203
>scaffold_2414	104	0.000011	0.000206
```

```
realSFS fst print aida_naimii.pbs.fst.idx -r scaffold_1
>scaffold_1	101	0.000011	0.000209
>scaffold_1	102	0.000011	0.000206
>scaffold_1	103	0.000011	0.000203
>scaffold_1	104	0.000011	0.000206
```

Checking the bam file (I checked the ref fasta earlier to confirm scaffold length is correct)
```
samtools view 10_33240_naimii_CTGAAA_realigned.sorted.bam scaffold_2414 | less -S
#looks about the right number of positions
samtools view 10_33240_naimii_CTGAAA_realigned.sorted.bam scaffold_1 | less -S
#has many more, checks out with length
samtools view 10_33240_naimii_CTGAAA_realigned.sorted.bam scaffold_2415 | less -S
#looks about like 2414
```

So raw input looks fine.

Looking at the SAF output from ANGSD, it looks OK for these scaffolds. Many of them had far fewer sites than the reference genome (e.g. maybe 1000/5000), whereas other scaffolds that later got omitted by the realSF fst caller generally had more reads. Probably nothing to do with it.

```
realSFS print aida.autosome_scaffolds.ref.saf.idx -r scaffold_2414 | less -S
realSFS print aida.autosome_scaffolds.ref.saf.idx -r scaffold_2497 | less -S
```

The 2d SFS file doesn't really have enough information to evaluate (just a string of numbers)

*Here's my takeaway*
When plotting in R, just remove all scaffolds <50kb in length

#### WHAT FILES TO USE

I've run:
* autosomes and z chromosome
* with (allInd) and without relatives (NR)
* mid filter (nocov_skiptri is a typo, did not actually use skiptri) and high filter (which includes -maf and snp pvalue)
* higher filter were depth coverages: `-setMinDepth 2.26 -setMaxDepth 9.04` and `-setMinDepth 83.66 -setMaxDepth 334.64` resulted in almost no sites
* combined aida-more, which didnt really show anything informative.

**Note that there are some man plots labeled as HighFilt for autosomes allindividuals that are just coverage filtered**

In the end:
Try just running the high filter (if I can get it right) and only do no relatives.

jan 13:
ANGSD:
ALL INDIVIDUALS:
* run 01.1_autosomes_fst_allInd_highFilt.sh DONE
* run 02.2 genes in windows (autosomes high filt (angsd)) DONE

NR:
* run 01.2_autosomes_fst_HighFilt_NR.sh DONE
* run 02.2 genes in windows DONE

THEN SET UP NO RELATIVES FOR VCFTOOLS. Maybe only if time.

Study gene network analyses

To get this rysnc:
```
cd /Users/erikenbody/Google_Drive/Tulane/WSFW_Data/Genomics_DNA_RNA/DNA/angsd_cluster_output/fst_angsd
rsync -zarvm --include="*/" --include="*.pdf" --exclude="*" cyp:/home/eenbody/reseq_WD/angsd/fst_angsd/fst_actual_analysis .
```

### Simple calculations

use realSFS fst print to cat into an output. Then use this to find maximum Fst value.
```
awk 'BEGIN {max = 0} {if ($4>max) max=$4} END {print max}' aida_naimii_fst_OUT.txt
```

Summaries high vs mid for no relatives:
```
cat aida_naimii_fst_OUT.txt | wc -l
>923749897
cat ../NR-HighFilt/aida_naimii_autosome_NR-HighFilt_OUT.txt | wc -l
>5734542
```

Why so many more from high filter?

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

for no relatives
```
cd /home/eenbody/reseq_WD/angsd/angsd_pca_NR_auto/working_list
cat allpops_bamlist_NR_file.txt | cut -d "_" -f 1,2 >> bam_list_file_ID.txt #only ID and band number
awk -v RS='' -v OFS='","' 'NF { $1 = $1; print "\"" $0 "\"" }' bam_list_file_ID.txt >> bam_list_file_ID_c.txt #from link, make csv
```

Also need subspecies file in same same order
```
cat allpops_bamlist_NR_file.txt | cut -d "_" -f 3 >> ssp_bamlist_NR.txt #only keep ssp
awk -v RS='' -v OFS='","' 'NF { $1 = $1; print "\"" $0 "\"" }' ssp_bamlist_NR.txt >> ssp_bamlist_NR_c.txt
```
