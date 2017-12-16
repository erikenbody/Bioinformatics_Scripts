####Resequencing preprocessing overview
*following GATK best practices generally*

####Create indexes
Necessary for running all preprocessing steps. Can do in iDev

First, I created a BWA index of the reference genome using default parameters.
```
bwa index -a bwtsw WSFW_ref_noIUB.fasta
```

Next, I used samtools faidx
```
samtools faidx WSFW_ref_noIUB.fasta
```

Requires loading java 1.8 (idev or batch file onle on Cypress)

```
java -jar ~/BI_software/picard.jar CreateSequenceDictionary \
    REFERENCE=WSFW_ref_noIUB.fasta \
    OUTPUT=WSFW_ref_noIUB.dict
```

####01 Initial mapping
`01_1piped_fq_clean.sh`
`01_2piped_fq_clean.sh`
`01_3piped_fq_clean.sh`

GATK suggests retaining flow cell info and those not using cat to merge all reads prior to running the pipeline. I adapted AS's scripts and added the pipes suggests by GATK in the piped_fq_clean.sh.

This ran cleanly after some trouble shooting. I am running it now for all three lanes of sequencing separately. Accidentally didnt put the replicate number correctly (put 1 for all three runs) in teh filenames. This didnt effect metadata in the files. I used the command `rename _1_ _2_ *` within the subdirectory to fix this.

####02 Mark duplicates
`02_jacard_dedup.sh`
This appears to be the next step. This will merge the three runs into one and mark duplicates reads (without removing them).

####03 sort,index,summary
Sort the dedup files, index them, and provide some summary information and Validate.

03.2
Folowup should be to check all the metrics files, but I cannot get the python script to run. Says there are no metrics files. Issue with input I assume. 

####Indel realignment
No longer reccomended by GATK, but appears to be neccessary before doing ANGSD. Need to compare these two options. ANSD looks complicated.

It appears the workflow is:
* Create an interval list from a split .fai file. Need to find why/how this functions. I ran AS's script `split_fastaindex.py` which generated 20 files that contain a various number of scaffolds each.
`python ~/Bioinformatics_Scripts/resequencing/Preprocessing/split_fastaindex.py -f WSFW_ref_noIUB.fasta.fai -n 20 -p 1 -o split_fai`

* Run indel target creator using an array of 1-20. Why 1-20?

Error relating to not beign able to open indel file.

* Run indel realignment using these metrics and the same 1-20 array
