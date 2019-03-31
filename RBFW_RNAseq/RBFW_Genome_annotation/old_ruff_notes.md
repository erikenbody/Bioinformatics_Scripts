```
###RUFF BELOW###
AED     sn180416_satscaf.all.standard_ipr.gff
0.000   0.009
0.025   0.021
0.050   0.067
0.075   0.107
0.100   0.178
0.125   0.247
0.150   0.330
0.175   0.375
0.200   0.451
0.225   0.491
0.250   0.549
0.275   0.614
0.300   0.672
0.325   0.708
0.350   0.751
0.375   0.792
0.400   0.841
0.425   0.873
0.450   0.904
0.475   0.914
0.500   0.931
0.525   0.940
0.550   0.953
0.575   0.959
0.600   0.963
0.625   0.963
0.650   0.963
0.675   0.963
0.700   0.964
0.725   0.966
0.750   0.972
0.775   0.974
0.800   0.974
0.825   0.976
0.850   0.978
0.875   0.978
0.900   0.987
0.925   0.993
0.950   0.993
0.975   0.993
1.000   1.000

iprscan2gff3 sn180416_satscaf.all.maker.proteins.fasta.tsv sn180416_satscaf.all.standard_ipr.gff > visible_iprscan_domains.gff

```

Put in jbrowse:

```
cd /Library/WebServer/Documents/jbrowse/JBrowse-1.12.3rc2
mkdir data/json/ruff_sat
bin/prepare-refseqs.pl --out data/json/ruff_sat/ --fasta /Users/erikenbody/Google_Drive/Uppsala/Projects/inProgress/Ruff/output/maker/sn180416_satscaf.fasta

bin/maker2jbrowse /Users/erikenbody/Google_Drive/Uppsala/Projects/inProgress/Ruff/output/maker/sn180416_satscaf.all.gff -o data/json/ruff_sat/

bin/generate-names.pl --verbose --out data/json/ruff_sat
```
available here:

http://localhost/jbrowse/JBrowse-1.12.3rc2/index.html?data=data/json/ruff_sat

Make a filtered by AED and pfam (IPR)
```
cd /Library/WebServer/Documents/jbrowse/JBrowse-1.12.3rc2
mkdir data/json/ruff_sat_filt
bin/prepare-refseqs.pl --out data/json/ruff_sat_filt/ --fasta /Users/erikenbody/Google_Drive/Uppsala/Projects/inProgress/Ruff/output/maker/sn180416_satscaf.fasta

bin/maker2jbrowse /Users/erikenbody/Google_Drive/Uppsala/Projects/inProgress/Ruff/output/maker/sn180416_satscaf.all.standard_ipr.gff -o data/json/ruff_sat_filt/

bin/maker2jbrowse /Users/erikenbody/Google_Drive/Uppsala/Projects/inProgress/Ruff/output/maker/visible_iprscan_domains.gff  -o data/json/ruff_sat_filt/

bin/generate-names.pl --verbose --out data/json/ruff_sat_filt
```
http://localhost/jbrowse/JBrowse-1.12.3rc2/index.html?data=data/json/ruff_sat_filt




### Prepare some summaries

```
module load BEDTools/2.27.1
#nano regions.bed #then add sat 5543082 9660324
bedtools intersect -a regions.bed -b sn180416_satscaf.all.standard_ipr.gff -wa -wb > sn180416_satscaf.all.standard_ipr_INV.gff
grep -cP '\tgene\t' sn180416_satscaf.all.standard_ipr_INV.gff
>94
grep -cP '\tmRNA\t' sn180416_satscaf.all.standard_ipr_INV.gff
>201

AED_cdf_generator.pl -b 0.025 sn180416_satscaf.all.standard_ipr_INV.gff
>96% AED > 0.5

##Original
grep -cP '\tmRNA\t' /home/eenbody/data_ruff/annotation/liftover/Ruff_scafSeq_scaf28_GalGeneNames_invOnly.gff
>102

grep -cP '\tmRNA\t' /home/eenbody/data_ruff/annotation/liftover/Ruff_scafSeq.genenames.gff
>102
grep -cP '\tmRNA\t' /home/eenbody/data_ruff/annotation/liftover/indInv.gff
>93

```

check Illumina

```
cd /home/eenbody/ruff/Genome_annotation
bedtools intersect -a regions.bed -b ref_ASM143184v1_scaffolds.gff3 -wa -wb >  ref_ASM143184v1_scaffolds_INV.gff3
grep -cP '\tgene\t' ref_ASM143184v1_scaffolds_INV.gff3
>108


```

```
for FILENAME in *.bam
  do
  samtools flagstat $FILENAME > ${FILENAME}.stats
  done
```


## Functional annotation

```
wget ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz
```

### Functional annotation problems

The key proteins from the Ruff paper aren't in this functional annotation so clearly something is off. How to rectify this? Checking MC1R that I downloaded from Uniprot Swissprot

```
#testing just MC1R

MAKER_HOME=/home/eenbody/ruff/Genome_annotation/02_maker_ab_initio_partial_sat/sn180416_satscaf.maker.output
WORK_D=/home/eenbody/ruff/Genome_annotation/02_maker_ab_initio_partial_sat/sn180416_satscaf.maker.output/functional_annotation

module load bioinfo-tools blast/2.7.1+
makeblastdb -in uniprot_MC1R.fasta -out sp_db_np/uniprot_MC1R -dbtype prot -title uniprot_MC1R
blastp -db $WORK_D/sp_db_np/uniprot_MC1R -query $MAKER_HOME/sn180416_satscaf.all.maker.proteins.fasta -out MC1R.out -outfmt 6 -seg yes -soft_masking true -lcase_masking -num_threads 4

#hard to know what to make of this. try less strict?

blastp -db $WORK_D/sp_db_np/uniprot_sprot -query $MAKER_HOME/sn180416_satscaf.all.maker.proteins.fasta -out sn180416_satscaf_blast_sprot_np_LAX.out -evalue .001 -outfmt 6 -num_alignments 1 -seg yes -soft_masking true -lcase_masking -max_hsps 1 -num_threads 4

blastp -db $WORK_D/sp_db_np/uniprot_sprot -query $MAKER_HOME/sn180416_satscaf.all.maker.proteins.fasta -out sn180416_satscaf_blast_sprot_np_SUPERLAX.out -evalue .1 -outfmt 6 -num_alignments 1 -seg yes -soft_masking true -lcase_masking -max_hsps 1 -num_threads 4

#nope. try chicken only?

makeblastdb -in galgal_UP000000539_9031.fasta -out sp_db_np/galgal_UP000000539_9031 -dbtype prot -title galgal_UP000000539_9031
blastp -db $WORK_D/sp_db_np/galgal_UP000000539_9031 -query $MAKER_HOME/sn180416_satscaf.all.maker.proteins.fasta -out galgal_functional_annotation.out -evalue .000001 -outfmt 6 -num_alignments 1 -seg yes -soft_masking true -lcase_masking -max_hsps 1 -num_threads 4

blastp -db $WORK_D/sp_db_np/galgal_UP000000539_9031 -query $MAKER_HOME/sn180416_satscaf.all.maker.proteins.fasta -out galgal_functional_annotation_LAX.out -outfmt 6 -num_alignments 1 -seg yes -soft_masking true -lcase_masking -max_hsps 1 -num_threads 4


makeblastdb -in killdeer_UP000053858_50402.fasta -out sp_db_np/killdeer_UP000053858_50402 -dbtype prot -title killdeer_UP000053858_50402
blastp -db $WORK_D/sp_db_np/killdeer_UP000053858_50402 -query $MAKER_HOME/sn180416_satscaf.all.maker.proteins.fasta -out killdeer_functional_annotation.out -evalue .000001 -outfmt 6 -num_alignments 1 -seg yes -soft_masking true -lcase_masking -max_hsps 1 -num_threads 4
```

Found HSD and SDR genes and CYB after finding alternative indexs in the uniprot database, but sitll cant find MC1R. Will run Annie see if I can figure it out from that detailed info.

```
#format for Annie:
sed 's/;$//' sn180416_satscaf.all.gff > sn180416_satscaf.all_renamed_nosemi.gff

/home/eenbody/ruff/ruff_software/Annie/annie.py -b sn180416_satscaf_blast_sprot_np_STRICT.out -db sp_db_np/uniprot_sprot_20180928.fasta -g ../sn180416_satscaf.all_renamed_nosemi.gff -o sn180416_satscaf_STRICT_blast_only.annie

``
