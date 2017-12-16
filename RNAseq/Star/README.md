### STAR alignments


SHOULD I BE USING UNPAIRED READS POST TRIM GALORE????



```
#testing in idev
STAR --runThreadN 20 --genomeDir /lustre/project/jk/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/STAR \
--readFilesIn 38-97528-lorentzi-SP-before_S37_clp.fq.1.gz 38-97528-lorentzi-SP-before_S37_clp.fq.2.gz \
--readFilesCommand zcat \
--outSAMstrandField intronMotif \
--outFilterType BySJout \
--outFilterIntronMotifs RemoveNoncanonical \
--outSAMtype BAM SortedByCoordinate \
--twopassMode Basic \
--genomeLoad NoSharedMemory \
--outFileNamePrefix 38-97528-lorentzi-SP-before_S37 \
--quantMode TranscriptomeSAM GeneCounts

```
This doesnt work. Turns out you cannot run quantmode (neccessary for DEseq etc) without annotations!
Time to decide if I need to annotate my genome or what. I am trying trinity guided alignment now.
