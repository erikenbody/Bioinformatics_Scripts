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

###Use vcfTools to get parameters
`03_vcfinfo.sh`
