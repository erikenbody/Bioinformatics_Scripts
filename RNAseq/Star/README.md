### STAR alignments


SHOULD I BE USING UNPAIRED READS POST TRIM GALORE????

I ran some iterations of star early on before I had annotated my genome. I ran it once, for each individual separately, and again merging them all together to generate an sj junctions file.

Once I annotated the reference genome, I revisited this approach and I am running using the sj junctions created before and the gff from maker. This gff I use had ipr information on it, but I think it will only use the ID column for the purposes of this approach (i.e. the renamed WSFW001 or similar).

### Genome index
`01_star_index.sh`

First, had to convert MAKER gff file to gtf using gffread:
https://github.com/gpertea/gffread
```
~/BI_software/gffread/gffread /home/eenbody/WSFW_assembly_maker2.maker.output/functional_annotation/maker_functional_final_output/wsfw_maker_renamed_nosemi_blast_ipr.gff -T -o GTFwsfw_maker_renamed_nosemi_blast_ipr.gtf
```

```
~/BI_software/gffread/gffread /home/eenbody/WSFW_assembly_maker2.maker.output/functional_annotation/maker_functional_final_output/WSFW_annot_renamed_ipr.gff -T -o WSFW_annot_renamed_ipr.gtf
```

But, this command just hangs and I am not sure why. Instead, I followed the advice here:
https://github.com/alexdobin/STAR/issues/341

And correctly called the GFF parser within STAR. I had also tried installing a package called GenomeTools, which didnt install cleanly and I didnt feel like sorting out.

*NOTE ON JAN 8*
Looks like maybe I indexed the genome wrong. Should be?
```
--sjdbGTFfile $ANNOT \
--sjdbGTFtagExonParentGene Parent \
--sjdbGTFtagExonParentTranscript ID \
--sjdbGTFfeatureExon exon \
```


**BIG NOTE**

Looks like I was doing this wrong. I counted exons, not genes. In addition, Star only looks at column 3 = exon:
`scaffold_252    maker   exon    29144   29162   .       +       .       ID=WSFW012016-RA:1;Parent=WSFW012016-RA`

So there is no way to indicate gene ID (as WSFW012016-RA = Transcript ID). Therefore, cannot use my GFF as input. This might be why gffread isnt working as well. It is tempting to just use Transcripts here rather than Genes. However, all the Star documentation warns against doing this. One of the reasons this would be tricky is lines like this:
`scaffold_252    maker   exon    29144   29162   .       +       .       ID=WSFW012016-RA:1;Parent=WSFW012016-RA`
`scaffold_252    maker   exon    29163   29165   .       +       .       ID=WSFW012016-RA:1;Parent=WSFW012016-RA,WSFW012016-RB`

Where you'd wind up with three transcripts, when you really have two.

**SOLUTION**
Use gffutils (install with bioconda) to make a gff that has the Gene ID in it. I have failed to convert to a .gft, which might be in part due to the weird indexing in my gff, so I am relying on doing this manually.
Example to work from: https://github.com/daler/gffutils/issues/75
First note was that I have duplicate IDs for the cds, so had to import with:
```
module load anaconda
source activate ede_py
python
import gffutils
db = gffutils.create_db('xaa.gff', ':memory:',merge_strategy="create_unique")


with open('tmp.gff', 'w') as fout:
    for d in db.directives:
        fout.write('##{0}\n'.format(d))

    for feature in db.all_features():
        if feature.featuretype == 'exon':

            # If level=1 not specified, it will also return gene "grandparent"
            # which you don't care about
            parent = list(db.parents(feature, level=1))

            # sanity checking
            assert len(parent) == 1
            parent = parent[0]

            feature.attributes['Name'] = parent.attributes['Name']
        fout.write(str(feature) + '\n')
```
Which I found the solution on the example page:http://daler.github.io/gffutils/examples.html#examples




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
