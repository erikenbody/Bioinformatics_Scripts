#### Running maker with EST=1 and protein=1

I noted that my annotation included what appeared to be only genes located in my RNAseq data (all 17,999 of them). One possible reason for this is that my MAKER run didnt include options to ID genes directly from EST and protein evidence (in the opts file). So, I decided to re run and see what that is like.

I experienced the same repeated crashing as before, where I ran with 18 cores, it crashed in 23rd, then I ran with 4 cores, 2, and 1, etc. Presumably it relates to the number of scaffolds remaining.

Unfortunately, nearly 400 scaffolds failed, including most of the very long ones (i.e. scaffold_100 and below).

This is similar to a problem on the MAKER devel forum here:
https://groups.google.com/forum/#!searchin/maker-devel/failed$20while$20annotating$20transcript%7Csort:date/maker-devel/at8neEnjbYk/EO9fKgkuBwAJ

However, these folks were using GFF3 input (I am using fasta EST/protein input), so its not entirely clear what the problem is. I do not really have the time to dive into this right now, and it probably isn't worthwhile anyway, but there are ways to retry failed scaffolds only:
https://groups.google.com/forum/#!topic/maker-devel/6N15qo6Z9kk

I could cat together all the fasta failed contigs and re run with more tries (bc I can see some long scaffolds worked), but I doubt this would actually succeed. It seems more likely this is a real bug or my input EST file is incorrect. Some info:

Note that up until this point maker had only identifeid ~5000 gene models, probably because all the long scaffolds failed.

Version:
```
MAKER version 3.01.02
```

```
grep "FINISHED" *index.log | wc -l
>4559
```

Example of error:

```
substr outside of string at /lustre/project/jk/Enbody_WD/BI_software/maker-mpich/maker/bin/../lib/PhatHit_utils.pm line 850.
--> rank=NA, hostname=cypress01-017
ERROR: Failed while annotating transcripts
ERROR: Chunk failed at level:1, tier_type:4
FAILED CONTIG:scaffold_2
```
