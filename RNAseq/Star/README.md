### STAR alignments


SHOULD I BE USING UNPAIRED READS POST TRIM GALORE????

I ran some iterations of star early on before I had annotated my genome. I ran it once, for each individual separately, and again merging them all together to generate an sj junctions file.

Once I annotated the reference genome, I revisited this approach and I am running using the sj junctions created before and the gff from maker. This gff I use had ipr information on it, but I think it will only use the ID column for the purposes of this approach (i.e. the renamed WSFW001 or similar).

### Genome index
`01_star_index.sh`

First, had to convert MAKER gff file to gtf using gffread:
https://github.com/gpertea/gffread
```
~/BI_software/gffread/gffread /home/eenbody/WSFW_assembly_maker2.maker.output/functional_annotation/maker_functional_final_output/WSFW_annot_renamed_ipr.gff -T -o WSFW_annot_renamed_ipr.gtf
```

But, this command just hangs and I am not sure why. Instead, I followed the advice here:
https://github.com/alexdobin/STAR/issues/341

And correctly called the GFF parser within STAR. I had also tried installing a package called GenomeTools, which didnt install cleanly and I didnt feel like sorting out.

### Comparisons to make

I find 23 different pairwise comparisons I can make. Maybe set it up as two batches of scripts?

One script per body part (runs code for all pairwise pops) = 3 scripts

One script per pop (runs code for all pairwise body parts) = 5 scripts

Another method used by Poelstra (ME 2015) was to identify which genes were commonly different between two body parts (e.g. between head and torso) and subtract these ('color patterning genes') to find which ones are associated with color specifically.

#### Between populations

*Crown*

moretoni_lorentzi

*Chest*

aida - naimii
aida - moretoni
aida - lorentzi
moretoni - naimii
moretoni - lorentzi
moretoni - moretoni-M

*SP*

aida - naimii
aida - moretoni
aida - lorentzi
moretoni - naimii
moretoni_lorentzi
lorentzi_before - lorentzi_after
moretoni - moretoni-M

#### Between body parts

*aida*

chest - sp

*naimii*

chest - sp

*moretoni*

chest - sp
chest - crown
crown - sp

*lorentzi*

chest - sp
chest - crown
crown - sp

*moretoni-M*

chest - sp
