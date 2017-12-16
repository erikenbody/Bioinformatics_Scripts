####Resequencing preprocessing overview
*following GATK best practices generally*

####Create indexes
Necessary for running all preprocessing steps. Can do in iDev

First, I created a BWA index of the reference genome using default parameters.
```
#bwa index -a bwtsw WSFW_ref_noIUB.fasta
#when I re-ran, used normal index with IUB codes
bwa index -a bwtsw WSFW_ref_final_assembly.fasta
```

Next, I used samtools faidx
```
#samtools faidx WSFW_ref_noIUB.fasta
samtools faidx WSFW_ref_final_assembly.fasta
```

Requires loading java 1.8 (idev or batch file onle on Cypress)

```
export PATH=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre
#java -jar ~/BI_software/picard.jar CreateSequenceDictionary \
#    REFERENCE=WSFW_ref_noIUB.fasta \
#    OUTPUT=WSFW_ref_noIUB.dict

java -jar ~/BI_software/picard.jar CreateSequenceDictionary \
    REFERENCE=WSFW_ref_final_assembly.fasta \
    OUTPUT=WSFW_ref_final_assembly.dict
```

####01 Initial mapping
`sbatch --array=1-37 01_1piped_fq_clean.sh`
`sbatch --array=1=37 01_2piped_fq_clean.sh`
`sbatch --array=1=37 01_3piped_fq_clean.sh`
Runtime: ~3 hours total (but often queue time)

GATK suggests retaining flow cell info and those not using cat to merge all reads prior to running the pipeline. I adapted AS's scripts and added the pipes suggests by GATK in the piped_fq_clean.sh.

This ran cleanly after some trouble shooting. I am running it now for all three lanes of sequencing separately. Accidentally didn't put the replicate number correctly (put 1 for all three runs) in the filenames. This didnt effect metadata in the files. I used the command `rename _1_ _2_ *` within the subdirectory to fix this.

####02 Mark duplicates
`02_jacard_dedup.sh`
This appears to be the next step. This will merge the three runs into one and mark duplicates reads (without removing them). This ran smoothly, but for this step and all below I had to reduce the memory used by java (i.e. java -Xmx16g) to 16gb (was trying 60gb and several in between). This is consistent with issues reported by others on the GATK website.

####03 sort,index,summary
Time elapsed: 22-35min per sample

Sort the dedup files, index them, and provide some summary information and Validate.

03.2
Folowup should be to check all the metrics files, but I cannot get the python script to run. Says there are no metrics files. Issue with input I assume.

####Indel realignment
No longer recommended by GATK, but appears to be necessary before doing ANGSD. Need to compare these two options. ANGSD looks complicated.

It appears the workflow is:
* Create an interval list from a split .fai file. Need to find why/how this functions. I ran AS's script `split_fastaindex.py` which generated 20 files that contain a various number of scaffolds each.
```
#python ~/Bioinformatics_Scripts/resequencing/Preprocessing/split_fastaindex.py -f WSFW_ref_noIUB.fasta.fai -n 20 -p 1 -o split_fai

cp /home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta.fai . #had to do this rather than link path
python ~/Bioinformatics_Scripts/resequencing/Preprocessing_fixed/split_fastaindex.py -f WSFW_ref_final_assembly.fasta.fai -n 20 -p 1 -o split_fai
#output to folder doesnt seem to work
```
* Run indel target creator using an array of 1-20. Why 1-20?

Error relating to not being able to open indel file.

* Run indel realignment using these metrics and the same 1-20 array
