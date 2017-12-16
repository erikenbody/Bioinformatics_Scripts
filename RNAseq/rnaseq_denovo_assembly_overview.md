###WSFW: RNAseq de novo assembly overview

###Running Trinity: De Novo
De novo assembly with no genome guiding

First, to make a comma seperated list of files I ran:

```
#read 1
ls -p *.1* | grep -v / | tr '\n' ','
#read 2
ls -p *.2* | grep -v / | tr '\n' ','
```
I was able to run trinity.sh without any problems. This took 1-09:47:26 to complete. This took 253.74GB of RAM to run. This is a bit strange, as I selected a 256GB node, but in the code for trinity I set 225 as the max memory.

###Quality Check

####N50

I ran the first perl script (still following FAS recs) using the command below. However, first I had to find this perl script. It was not obvious how to find it via the cypress module. So, I downloaded Trinity locally, moved the folder to the cluster, then sent the util folder to $TRINITY_HOME. This only took a few minutes in idev.

```
TrinityStats.pl Trinity.fasta > Trinity_assembly.metrics
```

Here is the output for N50. I am not entirely sure how to interpret this. Large number of N50 is good though.

```
################################
## Counts of transcripts, etc.
################################
Total trinity 'genes':	289998
Total trinity transcripts:	549053
Percent GC: 46.04

########################################
Stats based on ALL transcript contigs:
########################################

	Contig N10: 3054
	Contig N20: 2055
	Contig N30: 1470
	Contig N40: 1070
	Contig N50: 778

	Median contig length: 348
	Average contig: 578.45
	Total assembled bases: 317602418


#####################################################
## Stats based on ONLY LONGEST ISOFORM per 'GENE':
#####################################################

	Contig N10: 3037
	Contig N20: 1923
	Contig N30: 1224
	Contig N40: 812
	Contig N50: 575

	Median contig length: 306
	Average contig: 495.04
	Total assembled bases: 143560408
```

####Mapping original reads to assembly_prefix
Using bowtie to map all reads to the assembly. From Trinity documentation:

A typical Trinity transcriptome assembly will have the vast majority of all reads mapping back to the assembly, and ~70-80% of the mapped fragments found mapped as proper pairs (yielding concordant alignments 1 or more times to the reconstructed transcriptome).

Run scripts:
`trinity_index.sh`
`trinity_map.sh`
`trinity_stats.sh`

```
328850931 reads; of these:
  328850931 (100.00%) were paired; of these:
    27877964 (8.48%) aligned concordantly 0 times
    57359738 (17.44%) aligned concordantly exactly 1 time
    243613229 (74.08%) aligned concordantly >1 times
    ----
    27877964 pairs aligned concordantly 0 times; of these:
      1193022 (4.28%) aligned discordantly 1 time
    ----
    26684942 pairs aligned 0 times concordantly or discordantly; of these:
      53369884 mates make up the pairs; of these:
        19369956 (36.29%) aligned 0 times
        4066197 (7.62%) aligned exactly 1 time
        29933731 (56.09%) aligned >1 times
97.05% overall alignment rate
```


####BUSCO database

Short table output. Missing buscos should be low, complete should be high. These are conserved transcription

Run script:
`trinity_busco.sh`

```
  # BUSCO version is: 2.0
  # The lineage dataset is: vertebrata_odb9 (Creation date: 2016-02-13, number of species: 65, number of BUSCOs: 2586)
  # To reproduce this run: python /home/eenbody/.conda/envs/ede_py/bin/busco -i Trinity.fasta -o trinity_BUSCO -l /home/eenbody/RNAseq_WD/BUSCO_database/vertebrata_odb9/ -m tran -c 20 -sp chicken
  #
  # Summarized benchmarking in BUSCO notation for file Trinity.fasta
  # BUSCO was run in mode: tran

  	C:73.4%[S:23.6%,D:49.8%],F:21.2%,M:5.4%,n:2586

  	1897	Complete BUSCOs (C)
  	610	Complete and single-copy BUSCOs (S)
  	1287	Complete and duplicated BUSCOs (D)
  	549	Fragmented BUSCOs (F)
  	140	Missing BUSCOs (M)
  	2586	Total BUSCO groups searched
```

###Trinity: Genome guided
I am not sure if I am doing this correctly. I ran the script `star_map_ref.sh` to generate one bam file that contains alignments of all my reads to my reference fasta WSFW genome. Then I used my `samtools_sort.sh` to sort these reads (it would crap out in STAR doing this because of memory problems). Now I have an aseembly that I guess I can use in my Trinity De Novo alignment? Time to test out!

star: this ran at 2.99gb for 2h 9min. I had allocated 256gb memory with 20 threads, so I guess that was overkill.
samtools sort: this took 12gb memory (I assigned 20 threads, 4gb each) and took 39minutes.q

First attempt in Trinity I got this error `Error, cannot have FR library type with unpaired reads` after running for 8 hours.

It looks like what I should be doing is mapping each file to the genome separately in STAR, then merging them all together using samtools merge. This will be my input file for genome guided assembly. Using: `sbatch --array=1-3 ~/Bioinformatics_scripts/RNAseq/Star/star_map_noan.sh`

When I ran this as an array, I ran into memory problems again `STAR EXITING because of FATAL ERROR: number of bytes expected from the BAM bin does not agree with the actual size on disk`. So instead I am running it again without sorting the bam file (I'll do that later with `samtools_sort.sh`).

I also generated a new genome reference using the sj tab file from the first star run where I mapped all reads at once. I compared it on S9 between three modes. See output in compare_SJ.md file. Not sure what to take away from this. Kind of looks like adding the SJ data to the reference genome reduced the number of uniquely mapped reads. More accurate or less accurate? *shrug emojii*

I ran Trinity the exact same way, but with the parameters set in:
`trinity_g.sh`

###QC for guided assembly

Using scripts `trinity_busco_g.sh`, `trinity_map_g.sh`, and the perl script for N50 in idev.

####N50

First, running trinity perl script for N50. N50 is higher in genome guided approach (good?). But, stats for adjusted N50 is just about the exact same.

```
################################
## Counts of transcripts, etc.
################################
Total trinity 'genes':	282083
Total trinity transcripts:	392080
Percent GC: 44.92

########################################
Stats based on ALL transcript contigs:
########################################

	Contig N10: 4870
	Contig N20: 3193
	Contig N30: 2079
	Contig N40: 1297
	Contig N50: 821

	Median contig length: 320
	Average contig: 589.72
	Total assembled bases: 231216681


#####################################################
## Stats based on ONLY LONGEST ISOFORM per 'GENE':
#####################################################

	Contig N10: 4373
	Contig N20: 2526
	Contig N30: 1401
	Contig N40: 837
	Contig N50: 574

	Median contig length: 301
	Average contig: 503.08
	Total assembled bases: 141909955
```

After running the bowtie2 scripts to re align reads, here are my results. I am confused by 0 aligned concordantly > 1 time?

```
313320836 aligned fragments; of these:
  313320836 were paired; of these:
    18712915 aligned concordantly 0 times
    294607921 aligned concordantly exactly 1 time
    0 aligned concordantly >1 times
    ----
    18712915 pairs aligned concordantly 0 times; of these:
    14171586 aligned as improper pairs
    4541329 pairs had only one fragment end align to one or more contigs; of these:
       3770122 fragments had only the left /1 read aligned; of these:
            3770122 left reads mapped uniquely
            0 left reads mapped >1 times
       771207 fragments had only the right /2 read aligned; of these:
            771207 right reads mapped uniquely
            0 right reads mapped >1 times
Overall,  94.03% of aligned fragments aligned as proper pairs
```
