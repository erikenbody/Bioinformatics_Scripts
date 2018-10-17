Originally ran with MAF 2 and -doMajorMinor 4
Results are located in dxy_maf4

Re running with maf 1 and doMajorMinor 1

May 26

In TEST folder, I ran first job just new folder new files see if it wont hang, then second job is same but with more mem, last job is using most up to date angsd. These all hung also.

#### Filters used
```
-uniqueOnly [int]=0
Remove reads that have multiple best hits. 0 no (default), 1 remove.
```
I use this because if a read maps multiple places (in BWA earlier) its probably not a high confidence map

```
remove_bads [int]=1
Same as the samtools flags -x which removes read with a flag above 255 (not primary, failure and duplicate reads). 0 no , 1 remove (default).
```
seems to be a good default. 255 means mapping quality could not be assessed


```
-trim [int]=0
Number of bases to remove from both ends of the read.
```
I see no reason to do this. Maybe if quality really dropped off?

```
-minMapQ [int]=0
Minimum mapQ quality.
```
I wonder if this is really too conservative. It seems like a common cutoff. This is how well BWA mapped to the Reference

```
-minQ [int]=0
Minimum base quality score.
```
Angsd doesnt list this under the BAM example tutorial. Maybe not necessary? It also might be somewhat conservative, although the vast majority of sites are above this (see fastqc reports)

```
-only_proper_pairs [int]=1
Include only proper pairs (pairs of read with both mates mapped correctly). 1: include only proper (default), 0: use all reads. Only relevant for paired end data.
```
It is difficult for me to evaluate if this matters. In this case, I changed from the default which feels OK


####02 script - for per pop
doMajorMinor 3 with doMaf 1 uses the major/minor decisions from the previous step. No reason to recalculate these and it makes sense to use both pops data in previous step.

MININD results in there being a different number of sites per population that gets input into the Rscript. I think this is OK, because it makes sense to do per population filtering of number of individuals
