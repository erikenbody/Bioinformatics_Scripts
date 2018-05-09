


Figured this out from here:
https://www.biostars.org/p/260217/

First run 01_fasta_from_bam.sh to create consensus fasta from all pop bam files in ANGSD.

Then remove lines with scaffold information, because IQTREE just requires one big sequence.

```
cat aida.autosome_scaffolds_consensus.fa | sed '1!{/^>.*/d;}' > aida_concatenated.fasta
cat naimii.autosome_scaffolds_consensus.fa | sed '1!{/^>.*/d;}' > naimii_concatenated.fasta
cat moretoni.autosome_scaffolds_consensus.fa | sed '1!{/^>.*/d;}' > moretoni_concatenated.fasta
cat lorentzi.autosome_scaffolds_consensus.fa | sed '1!{/^>.*/d;}' > loretnzi_concatenated.fasta
cat rbfw_correct.fasta | sed '1!{/^>.*/d;}' > rbfw_concatenated.fasta
```
Use `nano` to edit header (i.e. make it aida, naimii, lorentzi, or moretoni)

Cat them all
`cat *_concatenated.fasta > wsfw_concatenated.fasta`

Run IQTREE (only took ~15 min in iDev)
-t PARS from here: https://groups.google.com/forum/#!searchin/iqtree/sequences$20failed$20composition$20chi2$20test%7Csort:date/iqtree/l3wQ2i-JKNg/CH3qmOeLBgAJ

```
iqtree -s wsfw_concatenated.fasta -nt 20 -t PARS
```


MAKE PHYLIP FILE
THIS WAS REALLY FING ANNOYING
```
Guidelines for PHYLIP input files for programs Neighborand Fitch (tree-building from distance matrices)

1) File must be text-only (ASCII)!!  It must be in same directory with the program and must be called infile.  
2) 1st line has number of OTUs (taxa, pops.)
3) Next line has first OTU name (padded to at least 10 characters with spaces, if necessary)
4) Easiest is upper diagonal matrix (note that it doesn't have to be aligned).  Separators are spaces.

Example

4
LS1        0.083  0.25 0.458
LS2        0.167  0.392
LS3        0.392
LS4        

Notes: last line still pads out 10 spaces, but has no "distance" (implied zero from LS4 to itself).  
```
See file called "infile" as what worked. I edited this in text wrangler. SPACES ONLY. ONLY TEN AFTER SSP NAME


#### BELOW IS BAD OUTGROUP STUFF

Ok now need to make an outgroup. I first used BWA to align the RBFW ref to the WSFW ref. I dont know if this is the best way to do it, but I did it using the `0.5` script.

Then next convert to fasta:
https://www.biostars.org/p/129763/

```
samtools bam2fq rbfw_aligned.sam | seqtk seq -A > rbfw_aligned.fasta
```

```
sed '/>scaffold_4903/,$d' rbfw_aligned.fasta > rbfw_aligned_fil.fasta
```

```
cat rbfw_aligned_fil.fasta | sed '1!{/^>.*/d;}' > rbfw_concatenated.fasta
```

```
cat rbfw_concatenated.fasta aida_concatenated.fasta naimii_concatenated.fasta moretoni_concatenated.fasta lorentzi_concatenated.fasta > wsfw_rbfw_concatenated.fasta
```
```
iqtree -s wsfw_rbfw_concatenated.fasta -nt 20 -t PARS -o melanocephalus
```

etc
This doesnt work:
(from: https://www.biostars.org/p/85188/)
```
#load z libs modules
REF=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
samtools mpileup -uf $REF rbfw_aligned.sort.bam | bcftools view -cg - | ~/BI_software/bcftools/misc/vcfutils.pl vcf2fq > rbfw_consensus.fastq
```
See: https://github.com/samtools/bcftools/issues/50

This does run:
samtools mpileup -uf $REF Results/rbfw_aligned.sort.bam | bcftools call -c | ~/BI_software/bcftools/misc/vcfutils.pl vcf2fq > rbfw_consensus.fastq
