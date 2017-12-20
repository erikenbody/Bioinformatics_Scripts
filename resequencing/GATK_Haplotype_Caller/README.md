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
