### WSFW: RNAseq de novo assembly overview

#### Running Trinity

First, to make a comma seperated list of files I ran:

```
#read 1
ls -p *.1* | grep -v / | tr '\n' ','
#read 2
ls -p *.2* | grep -v / | tr '\n' ','
```
I was able to run trinity.sh without any problems. This took 1-09:47:26 to complete. This took 253.74GB of RAM to run. This is a bit strange, as I selected a 256GB node, but in the code for trinity I set 225 as the max memory.

I ran the first perl script (still following FAS recs) using the command below. However, first I had to find this perl script. It was not obvious how to find it via the cypress module. So, I downloaded Trinity locally, moved the folder to the cluster, then sent the util folder to $TRINITY_HOME. This only took a few minutes in idev.

```
$TRINITY_HOME/TrinityStats.pl Trinity.fasta > Trinity_assembly.metrics
```

Here is the output for N50. I am not entirely sure how to interpret this.

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
