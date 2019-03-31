## Notes from EDE's RBFW annotation

### RNAseq input fastqc review

5x samples
different individuals choose:
Feather: highest quality (good round peak) with highest number of reads (60M)
Liver: highest quality (ok shape...not great) with highest number of reads (~50M)
all three brain regions from B10 (only individual we have)


### Misc notes on input data

For TopHat, I ran the following processing steps after running Tophat

```
module load bowtie2/2.3.3 tophat/2.1.1
cd /home/eenbody/RBFW_RNAseq/Genome_annotation/tophat_sj
awk '{if($5 >= 5) print $0}' junctions.bed > high_quality_junctions.bed
tophat2gff3 high_quality_junctions.bed > high_quality_junctions.gff
```

For formatting the mapped files I had to setup the GAAS (Uppsala annotation tools) environment. Directions here:
https://github.com/NBISweden/GAAS
Directions on running the gtf convertor here:
https://scilifelab.github.io/courses/annotation/2017/practical_session/ExcerciseEvidence
They actually use the tophat output rather than hisat for generating bam files for stringtie. Not sure what advantages if any this offers.

```
did this in uppmax
source /crex/proj/uppstore2017195/users/erik/ruff/ruff_software/GAAS/profiles/activate_rackham_env
module load perl  
module load perl_modules  
module load BioPerl/1.6.924_Perl5.18.4
gxf_to_gff3.pl -g RBFW_stringtie_merged.gtf -o RBFW_stringtie_merged.gff3 --gff_version 2
gff3_sp_alignment_output_style.pl -g RBFW_stringtie_merged.gff3 -o match
```

##### Sum of all evidence for use in Maker
* Trinity denovo transcriptome (from 1 individual + brains)
* Splice junctions from bowtie2/tophat
* Custom repeat library made from repeatmodeler
* RNAseq reads mapped to the reference genome using HiSat/Stringtie
* Protein evidence from a bunch of species (same input as for WSFW)

### Maker Round 1: Run 1 RBFW stats

Completed after ~24 hours

```
grep "FINISHED" *index.log | wc -l #10635
grep ">" RBFW.final.assembly.fasta | wc -l #10635
```

### Post maker run 1 (evidence based)

Now need to train gene predictors. First check output:

Generally following assemblage pipeline still:
https://github.com/sujaikumar/assemblage/blob/master/README-annotation.md

This time ran this in scripts from folder 02_train_augustus

AED score ideally is 95% > AED 0.5. This isn't quite there, but is still quite good.

```
AED_cdf_generator.pl -b 0.025 RBFW.final.assembly.all.gf

AED	RBFW.final.assembly.all.gff
0.000	0.006
0.025	0.024
0.050	0.066
0.075	0.102
0.100	0.164
0.125	0.208
0.150	0.280
0.175	0.325
0.200	0.393
0.225	0.437
0.250	0.503
0.275	0.547
0.300	0.606
0.325	0.644
0.350	0.703
0.375	0.741
0.400	0.792
0.425	0.822
0.450	0.860
0.475	0.886
0.500	0.913
0.525	0.919
0.550	0.926
0.575	0.931
0.600	0.936
0.625	0.940
0.650	0.945
0.675	0.949
0.700	0.953
0.725	0.956
0.750	0.960
0.775	0.963
0.800	0.967
0.825	0.970
0.850	0.975
0.875	0.978
0.900	0.983
0.925	0.986
0.950	0.992
0.975	0.995
1.000	1.000
```

### Gene predictors

After running optimize augustus for 2 weeks, the gene specificity and sensitivity are still very low (should be > 0.2). Running round 2 despite this.

Only option I can think to do would be to filter this to only include highest quality gene models.

```
*******      Evaluation of gene prediction     *******

---------------------------------------------\
                 | sensitivity | specificity |
---------------------------------------------|
nucleotide level |       0.907 |       0.882 |
---------------------------------------------/

----------------------------------------------------------------------------------------------------------\
           |  #pred |  #anno |      |    FP = false pos. |    FN = false neg. |             |             |
           | total/ | total/ |   TP |--------------------|--------------------| sensitivity | specificity |
           | unique | unique |      | part | ovlp | wrng | part | ovlp | wrng |             |             |
----------------------------------------------------------------------------------------------------------|
           |        |        |      |                487 |                487 |             |             |
exon level |   2289 |   2289 | 1802 | ------------------ | ------------------ |       0.787 |       0.787 |
           |   2289 |   2289 |      |  214 |   14 |  259 |  215 |   15 |  257 |             |             |
----------------------------------------------------------------------------------------------------------/

----------------------------------------------------------------------------\
transcript | #pred | #anno |   TP |   FP |   FN | sensitivity | specificity |
----------------------------------------------------------------------------|
gene level |   230 |   200 |   30 |  200 |  170 |        0.15 |        0.13 |
----------------------------------------------------------------------------/

------------------------------------------------------------------------\
            UTR | total pred | CDS bnd. corr. |   meanDiff | medianDiff |
------------------------------------------------------------------------|
            TSS |         40 |              0 |         -1 |         -1 |
            TTS |         14 |              0 |         -1 |         -1 |
------------------------------------------------------------------------|
            UTR | uniq. pred |    unique anno |      sens. |      spec. |
------------------------------------------------------------------------|
                |  true positive = 1 bound. exact, 1 bound. <= 20bp off |
 UTR exon level |          0 |              0 |       -nan |       -nan |
------------------------------------------------------------------------|
 UTR base level |          0 |              0 |       -nan |       -nan |
------------------------------------------------------------------------/
```

## Run maker round 2

Despite poor sensitivity, going to try maker run. Adjusted opts file like so:

```
snaphmm=/home/eenbody/RBFW_RNAseq/Genome_annotation/maker/snap.hmm #SNAP HMM file
augustus_species=RBFW #Augustus gene prediction species model
trna=1 #find tRNAs with tRNAscan, 1 = yes, 0 = no
keep_preds=1 #Concordance threshold to add unsupported gene prediction (bound by 0 and 1)
```

## Check maker round 2

Way to many genes found and very poor gene models

```
cat RBFW_2.all.gff | awk '{ if ($3 == "gene") print $0 }' | awk '{ sum += ($5 - $4) } END { print NR, sum / NR }'
>42213 30628.7

AED_cdf_generator.pl -b 0.025 RBFW_2.all.gff

 AED	RBFW_2.all.gff
 0.000	0.004
 0.025	0.014
 0.050	0.037
 0.075	0.058
 0.100	0.093
 0.125	0.118
 0.150	0.157
 0.175	0.182
 0.200	0.220
 0.225	0.244
 0.250	0.281
 0.275	0.306
 0.300	0.340
 0.325	0.361
 0.350	0.394
 0.375	0.417
 0.400	0.447
 0.425	0.463
 0.450	0.485
 0.475	0.499
 0.500	0.516
 0.525	0.519
 0.550	0.523
 0.575	0.526
 0.600	0.530
 0.625	0.532
 0.650	0.535
 0.675	0.537
 0.700	0.540
 0.725	0.541
 0.750	0.544
 0.775	0.546
 0.800	0.548
 0.825	0.550
 0.850	0.553
 0.875	0.555
 0.900	0.559
 0.925	0.561
 0.950	0.565
 0.975	0.567
 1.000	1.000
```

Ok, this definitely did not work well. Presumably because the augustus gene models were rubbish.

Things to try?
* Try another set of genes to inform Augutus (could be a qucik check)

### Revisit Maker round 1
It looked pretty good so lets do some more QC

####inspect quality trimming
```
grep -cP '\tgene\t' RBFW.final.assembly.all.gff
>19178

quality_filter.pl -d RBFW.final.assembly.all.gff  > RBFW.final.assembly.all.default.gff

grep -cP '\tgene\t' RBFW.final.assembly.all.default.gff
>19170

AED_cdf_generator.pl -b 0.025 RBFW.final.assembly.all.default.gff
AED	RBFW.final.assembly.all.default.gff
0.000	0.006
0.025	0.024
0.050	0.066
0.075	0.103
0.100	0.165
0.125	0.209
0.150	0.280
0.175	0.326
0.200	0.393
0.225	0.438
0.250	0.504
0.275	0.548
0.300	0.607
0.325	0.645
0.350	0.704
0.375	0.742
0.400	0.793
0.425	0.824
0.450	0.861
0.475	0.887
0.500	0.914
0.525	0.920
0.550	0.928
0.575	0.932
0.600	0.937
0.625	0.941
0.650	0.947
0.675	0.950
0.700	0.954
0.725	0.957
0.750	0.961
0.775	0.964
0.800	0.968
0.825	0.971
0.850	0.976
0.875	0.979
0.900	0.984
0.925	0.988
0.950	0.993
0.975	0.996
1.000	1.000
```
Default filter didn't do that much, I think its pretty similar to the default output

Once functional annotation finishes (submitted 190331), I can do one more layer of filtering using information from pfam:

```
ipr_update_gff RBFW.final.assembly.all.default.gff RBFW.final.assembly.all.maker.proteins.fasta.tsv > RBFW.final.assembly.all.default_ipr.gff

quality_filter.pl -s RBFW.final.assembly.all.default_ipr.gff  > RBFW.final.assembly.all.standard_ipr.gff
grep -cP '\tgene\t' RBFW.final.assembly.all.standard_ipr.gff

AED_cdf_generator.pl -b 0.025 RBFW.final.assembly.all.standard_ipr.gff

```
