#### General steps for running SNAP or Treemix with my data

##### Generate input files for Treemix
`angsd_to_vcf.sh`

Then run Rscript that converts these angsd files to vcf.
The vcf convert function written in the ANGSD software seem to be buggy, or at least doesnt play well with plink.
Script written by author here: https://github.com/rcristofari/RAD-Scripts/blob/master/angsd2vcf.R
I ran this in `01_angsd_to_vcf.sh` but here is the code:
```
Rscript ~/Bioinformatics_Scripts/resequencing/snapp_treemix/angsd2vcf.R --bam=/home/eenbody/reseq_WD/phylotree/allpops_bamlist_NR_outg.txt --geno=tree_input.geno.gz --counts=tree_input.counts.gz --out=./tree_input.vcf
```

Next, I had to convert this VCF to a format that Treemix or SNAPP could use. Plink seems to be the most useful intermediary here, but I had a lot of trial/error to get this to manipulate the files for downstream use. Directions are from here:
https://bitbucket.org/nygcresearch/treemix/wiki/Home
Here are the directions from Treemix devs:

```
plink --bfile data --freq --missing --within data.clust
gzip plink.frq
plink2treemix.py plink.frq.gz treemix.frq.gz
```

It was important to format a cluster file correctly for plink (i.e. identify pops). It should look like this:
```
0 11_33248_aida_CTGGCC_realigned  aida
0 12_33249_aida_TAATGT_realigned  aida
0 13_33252_aida_ATTTCG_realigned  aida
0 14_33253_aida_TGTACG_realigned  aida
...
```

Now run plink:

```
plink --vcf tree_input.vcf --allow-extra-chr --freq --missing --within wsfw_clst.txt --const-fid 0 -out wsfw_plink
gzip wsfw_link.frq.strat
```

The conversion from angsd -> VCF left the column blank for SNP ID. Usually this is rsXXXX, but for one reason or another, there is no value for my samples. This is not a column that I can link to external databases, so I just generated a dummy column that gave the same name for a SNP per population using R. Run this using:

```
Rscript ~/BI_software/resequencing/snapp_treemix/reformat_plink.R
```

Then run the script `02_plink2treemix.sh` which runs the following command:

```
python ~/Bioinformatics_Scripts/resequencing/snapp_treemix/plink2treemix.py wsfw_plink.frq.strat.gz treemix.frq.gz
```

##### Run treemix

Two papers in my mendeley had some suggestions:
Winger 2017 Evolution
Vijay et al. 2016 Nature comm.

In the script, `03_treemix.sh`, I run several iterations of treemix and the R plotting commands that come with the software. I make tree topologies using different windows to account for linkage disequilibrium (-k 1000, -k 500) and test for different migration events.

##### SNAPP

I've tried a couple of ways to make input files for SNAPP. One perl script is recommended by the devs for VCF to Nexus conversion (`vcf2nexus.pl`), but this just hangs when I run it. I've tried to bring in the concatenated fasta file to beauti (locally) to make the xml input file there, but it just hangs. I suspect that some subsetting is needed, or setting up a file format I dont realize. In theory, I should be able to use the distance matrix from plink as nexus input, but I haven't spent the time to figure out how to do this. 

##### Unused code

```
#plink --vcf tree_input.vcf --allow-extra-chr --freq --missing --within wsfw_clst.txt --const-fid 0 --out out2 --snps-only -make-bed
#plink --bfile out2 --freq --missing --within wsfw_clst.txt --allow-extra-chr
#python ~/Bioinformatics_Scripts/resequencing/snapp_treemix/plink2treemix.py test1_ren.fq.gz treemix.frq.gz
```
