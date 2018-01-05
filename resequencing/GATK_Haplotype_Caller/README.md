###Variant Calling with GATK

####Summary
The GATK pipeline is well documented and frequently updated. However, variant calling using their haplotype caller is widely accepted to not be appropriate for low coverage data (such as mine). Software such as ANGSD that incorporates genotype likelihoods is better equipped, but for comparison purposes I will also call variant sites using GATKs pipeline. This also allows for additional filtering of variant sites that may be necessary on my data.

My understanding is that GATK will include genotype likelihoods in the VCF output, which can then be brought into ANGSD for downstream analysis.

####Workflow
I am following Allison Shultz's excellent tutorial here:
https://github.com/ajshultz/pop-gen-pipeline

I am running without intervals, which seems to be running plenty fast for me. It may be worthwhile to run intervals to improve speed at some point if you re run this.

####Haplotype Caller
`01_haplotype_caller.sh`
*4-6 hours per sample. Ran overnight*

Calls haplotypes against the reference for every sample. Should be run as an array, e.g. `sbatch --array=1-37 01_haplotype_caller.sh`

Using these parameters. Min pruning and minDangling are specific for low coverage data. -nct 20 will use 20 threads, but I am not entirely clear how this performed on Cypress. I did not try to run it without.
```
-minPruning 1 \
-minDanglingBranchLength 1 \
-nct 20 \
```

####Joint Genotype
`02_joint_genotype.sh`

Early error on this one on storage space. Key may have been adding `-Djava.io.tmpdir=tmp` to the java command. Apparently default java tmp is somewhere in root, which doesnt sound ideal.


### Seperate SNPs and Indels
`03`

For visualizing purposes

###Use vcfTools to get parameters
`04_vcfinfo.sh`

Visualize these in R

### Add Filter labels to VCFs
`05_vcf_filters.sh`

*Note that VariantFiltration should work with -nt 20 (for multithreading), but it would crash when I ran it with this flag (ERR: stack track).*

This is a beast of a chunk of code. Basically running all the filters in one GATK command using JAXL. Then can selectively filter after. Notes:
* Would not run with:
* -filterExpression "!vc.hasAttribute('DP')"
* --filterName "noCoverage"

DESCRIPTION OF FILTERS:
* MinCov = Filters out sites that fall below mean depth/2 (5.68/2=2.84) - determined after averaging depth of all samples (see Rscript from ANGSD output)
* MaxCov = Filters out sites that fall above mean depth*2 (5.68*2=11.36) - determined after averaging depth of all samples (see Rscript from ANGSD output)
* badSeq = For SNPs: Filter RPRS<-8.0 | For Indels or sites with Indels/SNPs: RPRS<-20 and QD <20
* badStrand = For SNPs: filter out FS > 60.0 and SOR >3.0 | For Indels or sites with Indels/SNPs: FS >200, SOR >10
* badMap = For SNPs: filter out MQ < 40.0 and MQRS <-12.5

THESE ARE THE DEFAULT VALUES. However, I checked the INFO files output from VCFINFO and they seem pretty much fine for my dataset. At least, no glaring differences.

#### QC VCF filters

Next is to quality control these filters. Something like this looks good:
From: https://qcb.ucla.edu/wp-content/uploads/sites/14/2017/08/gatkDay3.pdf
```
vcftools --vcf $OUT/All_WSFW_fil.vcf --FILTER-summary --out $OUT/WSFW_AllFilters
```

The output of this is as follows (using `column -t`):
```
FILTER                          N_VARIANTS  N_Ts      N_Tv      Ts/Tv
MaxCov                          943538391   21819720  12145522  1.79652
PASS                            24318795    20303     15594     1.30198
LowQual;MaxCov                  5089903     0         0         -nan
LowQual                         3412059     0         0         -nan
MaxCov;badMap                   3031530     1143799   926006    1.2352
MaxCov;badStrand                938760      400236    292617    1.36778
LowQual;MinCov                  920335      0         0         -nan
MaxCov;badSeq                   240498      106666    71920     1.48312
MaxCov;badMap;badStrand         117629      44389     38549     1.1515
badMap                          17525       8751      7305      1.19795
MinCov                          15844       3018      2519      1.19809
MaxCov;badSeq;badStrand         15177       6146      7837      0.784229
MaxCov;badMap;badSeq            13576       5062      3108      1.6287
badStrand                       4426        715       598       1.19565
MinCov;badMap                   1415        876       527       1.66224
badMap;badStrand                1283        761       414       1.83816
MaxCov;badMap;badSeq;badStrand  585         164       123       1.33333
```

I had already suspected this, but I used incorrect values for min and max coverage in my gatk -selectVariants call. I used per sample coverage (between ~2 and 11), not global coverage, which the DP variable codes for. I am still shaky on this, but when I ran VCFINFO on DP I got a file called `All_WSFW_DP.INFO`. In idev R I did (this took long time because .INFO file is very large):
```
x<-read_tsv("All_WSFW_DP.INFO",col_names=TRUE) ; x$DP <- as.numeric(x$DP) ; xc<-x[complete.cases(x$DP),]
mean(xc$DP)
>163.0236
```

So I should be using filter out < (163.0236/2 = 81.5118) and filter out > (163.0236*2 = 326.0472) as my limits in this filtration. I think I will just perform this filtration using VCFtools, as others seem to have done.

Otherwise the filters look OK. I dont know why there were no Ts or Tvs for some category, but these had to do with coverage so I think I can forget. Other categories had relatively few variants. The filter of low quality seems really high, possibly incorrect? Not clear this filters origin.

After some looking around at these output files, it looks like using SelectVariants to selectively choose filters is either unwieldy or bugged (probably the former). It seems like VCFtools is well suited to filter by filter name, so I think I'm just going to use these. No obvious downsides. This is step 06.

Next:
Make a script to run Fst for all population comparisons. Make an R script for the VCFtools output format. Include this script in the big script. Consider running with different filters? Either with or without depth filtering. And with or without the vcf specific maf filters and depth filters.

These files are HUGE. Should have output as .gz
can use

```
bgzip -c file.vcf > file.vcf.gz
tabix -p vcf file.vcf.gz
```
### Filter using vcfTools
`06.1_vcftools_filters.sh`
`06.2_vcftools_filters.sh`

These take the file that I added filter names to and will filter out those that got flagged. Importantly, I wont be using the depth filtering flag I made. Instead, will filter directly in vcftools for depth (in 06.2).

Following published suggestions of MAF<0.1, global depth,
Here, using 20% missing individuals (as in ANGSD). Do this in ANGSD? But that was per population, this is across the whole dataset. May not be directly comparable.

#output for first run that doesnt include VCFtools depth filtering:
```
VCFtools - 0.1.15
(C) Adam Auton and Anthony Marcketta 2009

Parameters as interpreted:
	--vcf filtered_vcfs/All_WSFW_fil.vcf
	--recode-INFO-all
	--maf 0.1
	--max-alleles 2
	--min-alleles 2
	--max-missing 0.2
	--recode
	--stdout
	--remove-filtered badMap
	--remove-filtered badSeq
	--remove-filtered badStramd

After filtering, kept 37 out of 37 Individuals
Outputting VCF file...
After filtering, kept 16149683 out of a possible 981677731 Sites
Run Time = 9071.00 seconds
```
Result is only 1.6% of total number of variable sites! 16,149,683

When I filtered with the reccomended coverage of between 81 and 326, I only got ~9000 variable sites. I re ran with 2-326, with the assumption that I should include as many low coverage individuals as possible. Results here:

```
VCFtools - 0.1.15
(C) Adam Auton and Anthony Marcketta 2009

Parameters as interpreted:
	--vcf filtered_vcfs/All_WSFW_fil.vcf
	--recode-INFO-all
	--maf 0.1
	--max-alleles 2
	--max-meanDP 326
	--min-alleles 2
	--min-meanDP 2
	--max-missing 0.2
	--recode
	--stdout
	--remove-filtered badMap
	--remove-filtered badSeq
	--remove-filtered badStramd

After filtering, kept 37 out of 37 Individuals
Outputting VCF file...
After filtering, kept 15158456 out of a possible 981677731 Sites
Run Time = 9156.00 seconds
```

### Subset ZChrom and autosome scaffolds from VCF
This was seriously annoying to figure out how to do. I am not sure if others just subset out sex chromosomes earlier? Or what. But here is the only way I could reliably figured this out. I tried several methods using bedtools, tabix, vcftools, and bcftools. The last was the only one that worked for this purpose.

Commands for bcftools:
https://samtools.github.io/bcftools/bcftools.html

First, need to make a bed file
```
module load Anaconda
source activate ede_py
conda install faidx
faidx --transform bed WSFW_ref_final_assembly.fasta > all_scaffolds.bed
```
Then, in R, I used `merge` to merge with scaffolds I had already identified with each chromosome to make a bed file with z and with autos.

Next was tricky, but here is the only way I found to subset vcf by a bunch of scaffolds. Install bcftools locally, make sure tabix works. Process is:

* unzip the gzipped version of vcf I had made previously. In the future, maybe just output a bgzipped from vcftools (is possible?)
* zip with bgzip
* use tabix to make an index
* bcftools to filter by scaffolds

```
module load zlib
module load xz
gunzip All_WSFW_passed_CovFil.vcf.gz
bgzip All_WSFW_passed_CovFil.vcf.gz
tabix All_WSFW_passed_CovFil.vcf.gz
bcftools view -R z_scaffolds.bed -o zchrtest3.vcf.gz -O z All_WSFW_passed_CovFil.vcf.gz
bcftools view -R autosome_scaffolds.bed -o achrtest.vcf.gz All_WSFW_passed_CovFil.vcf.gz

gunzip All_WSFW_passed_CovFil_2_320.vcf.gz
bgzip All_WSFW_passed_CovFil_2_320.vcf
bcftools view -R z_scaffolds.bed -o zchr/Z_WSFW_passed_CovFil_2_320.vcf All_WSFW_passed_CovFil_2_320.vcf.gz
bcftools view -R autosome_scaffolds.bed -o autosomes/autosomes_WSFW_passed_CovFil_2_320.vcf All_WSFW_passed_CovFil_2_320.vcf.gz

gunzip All_WSFW_passed.vcf.gz ;
bgzip All_WSFW_passed.vcf ;
bcftools view -R z_scaffolds.bed -o zchr/Z_WSFW_passed.vcf ; All_WSFW_passed_CovFil_2_320.vcf.gz

bcftools view -R autosome_scaffolds.bed -o zchr/Z_WSFW_passed.vcf All_WSFW_passed_CovFil_2_320.vcf.gz

```

Here is an example of something that did not work:
```
#failed subsetting of chromosomes
vcftools --gzvcf All_WSFW_passed_CovFil.vcf.gz --exclude-positions autosome_scaffolds.bed --recode --recode-INFO-all --stdout | gzip -c > zchrtest.vcf.gz

vcftools --gzvcf All_WSFW_passed.vcf.gz --exclude-positions autosome_scaffolds.bed --recode --recode-INFO-all --stdout | gzip -c > zchrtest.vcf.gz
```

Notes 20 dec. Graphs are much more sparse, noisier than ANGSD. Similar peaks in general. Overall higher FST? Can quantify this. Consider checking angsd output when you dont include step. Also figure out what step means. Could influence somehow. Need to investiage scaffold #s in the thousands on the ANGSD plots. Why arent these in the GATK plots?

#### Coverage Calculated by GATK
`gatk_coverage.sh`
*run time = 2-11:00:00*

Finding the appropriate cutoff for filtering on depth has been difficult. I used the GATK tool to calculate per sample coverage, which took a very long time. Furthermore, I had already calculated global coverage on my own much faster (elsewhere in this document?). However, the per sample coverage was helpful, and was lower than when I calculated it with ANGSD. I'm not sure why.

Summary is located here: `/home/eenbody/reseq_WD/GATK_Haplotype_Caller/coverage`

```
sample_id                 total         mean    granular_third_quartile  granular_median  granular_first_quartile  %_bases_above_15
20_36126_moretoni_AGACCA  4147892848    4.20    6                        5                3                        0.2
34_47745_moretoni_CGATGT  4757262483    4.81    7                        5                4                        0.3
22_36149_moretoni_ACGGTC  4272724943    4.32    7                        5                3                        0.3
18_33297_lorentzi_ATGACT  4576120590    4.63    7                        5                4                        0.3
17_33257_aida_GACTCA      4012304452    4.06    6                        5                3                        0.3
26_47623_lorentzi_CCATGT  4003934802    4.05    6                        5                3                        0.3
28_47653_lorentzi_TTAGCT  4484490583    4.54    7                        5                4                        0.3
15_33254_aida_CAGTGT      4447098984    4.50    7                        5                3                        0.3
24_36188_moretoni_AGGTAC  4789419535    4.85    7                        5                4                        0.3
1_33221_naimii_CTCACG     3711194906    3.76    6                        4                3                        0.2
29_47657_lorentzi_GCCATA  4003566118    4.05    6                        5                3                        0.2
30_47672_lorentzi_AGTGCC  4544008494    4.60    7                        5                4                        0.3
10_33240_naimii_CTGAAA    4885208625    4.94    7                        5                4                        0.4
31_47683_lorentzi_CTTGAC  4541558429    4.60    7                        5                4                        0.3
37_97528_lorentzi_CTTGTA  4606927034    4.66    7                        5                4                        0.3
35_47815_moretoni_TGACCA  4798268472    4.86    7                        5                4                        0.3
6_33232_naimii_AGATCC     4512590045    4.57    7                        5                4                        0.3
16_33256_aida_ATCACG      4071462433    4.12    6                        5                3                        0.3
3_33225_naimii_CGCTAC     4549017553    4.60    7                        5                4                        0.3
25_47617_lorentzi_TATCAG  4691456007    4.75    7                        5                4                        0.3
19_47720_moretoni_GTAGGC  4007473904    4.06    6                        5                3                        0.3
36_97513_lorentzi_GCCAAT  4628882001    4.68    7                        5                4                        0.3
14_33253_aida_TGTACG      4629049428    4.68    7                        5                4                        0.4
5_33230_naimii_TCCTAG     4488378780    4.54    7                        5                4                        0.3
27_47631_lorentzi_ATGCGC  4561014385    4.62    7                        5                4                        0.3
9_33235_naimii_ATCCGC     5981974051    6.05    8                        6                5                        0.7
23_36182_moretoni_TTCGAA  4218897079    4.27    6                        5                3                        0.3
8_33234_naimii_AGCTTT     4514087298    4.57    7                        5                4                        0.3
7_33233_naimii_TTGTCA     4383840902    4.44    7                        5                3                        0.3
13_33252_aida_ATTTCG      4651460819    4.71    7                        5                4                        0.4
11_33248_aida_CTGGCC      4628670991    4.68    7                        5                4                        0.3
21_36148_moretoni_TCAGCC  4047654147    4.10    6                        5                3                        0.2
12_33249_aida_TAATGT      4252492085    4.30    6                        5                3                        0.3
33_47717_moretoni_TCGGAT  4367718082    4.42    7                        5                3                        0.3
32_47707_moretoni_CATTAG  4693910063    4.75    7                        5                4                        0.3
2_33223_naimii_CAGCTT     4324085746    4.38    7                        5                3                        0.3
4_33228_naimii_ATTGTA     4547301736    4.60    7                        5                4                        0.3
Total                     165333398833  167.33  N/A                      N/A              N/A
```
