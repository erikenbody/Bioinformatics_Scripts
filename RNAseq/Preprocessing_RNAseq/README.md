### WSFW: RNAseq preprocessing overview

Mostly following:
https://informatics.fas.harvard.edu/best-practices-for-de-novo-transcriptome-assembly-with-trinity.html

#### Merge fastq
I ran one lane of nextseq, then adjusted volume of each sample based on the read depth for each sample. Then I ran the second lane of nextseq.

This resulted in two folders each with a set of fastq files with identical names. It took me some time to come up with an easy way to do this. I made soft links into a directory 1lane/ and 2lane/ then ran the script `merge_lanes.sh` that I adapted from helpfiles online:

found at: https://superuser.com/questions/947008/concatenate-csv-files-with-the-same-name-from-subdirectories


### Rcorrector
*run time <1hr all files*

Array overview:
grab out filename from the array exported from our 'parent' shell
get size of array
now subtract 1 as we have to use zero-based indexing (first cell is 0)

Various testing commands
```
#testing with one file, this works
#perl /home/eenbody/Enbody_WD/BI_software/rcorrector/run_rcorrector.pl -t 12 -1 ../10-33254-aida-Chest_S10.R1.fastq.gz -2 ../10-33254-aida-Chest_S10.R2.fastq.gz

#a bunch of testing that didnt really work
#perl /home/eenbody/Enbody_WD/BI_software/rcorrector/run_rcorrector.pl -t 12 -1 $FILE1.R1.fastq.gz -2 $FILE1.R2.fastq.gz
#export FILES=`for i in *; do echo "${i%.R*.fastq.gz}"; done | sort | uniq`
#export FILES=`for i in *; do echo "${i%.fastq.gz}"; done | sort | uniq`
```

Here are the in shell commands I ran to run rnaseq_rcorr_test.sh
```
export FILES=($(ls -1 | sed -e 's/\..*$//')) #this was crucial, because it strips .R*.fastq.gz, I could use it for R1 and R2 in the job script
NUMFASTQ=${#FILES[@]}
ZBNUMFASTQ=$(($NUMFASTQ - 1))

#to submit
if [ $ZBNUMFASTQ -ge 0 ]; then
sbatch --array=0-$ZBNUMFASTQ ~/Bioinformatics_Scripts/RNAseq/QC_RNAseq/rnaseq_rcorr_test.sh
fi

#I had some trouble initially, so had to run three times
sbatch --array=0-37 ~/Bioinformatics_Scripts/RNAseq/QC_RNAseq/rnaseq_rcorr_test.sh
sbatch --array=38-41 ~/Bioinformatics_Scripts/RNAseq/QC_RNAseq/rnaseq_rcorr_test.sh
sbatch --array=9-9 ~/Bioinformatics_Scripts/RNAseq/QC_RNAseq/rnaseq_rcorr_test.sh
```

The seemed to be in the syntax of the job script and not including the "S".
`./fq/*S${SLURM_ARRAY_TASK_ID}.R1.fastq.gz`
not
`./fq/*${SLURM_ARRAY_TASK_ID}.R1.fastq.gz`

### remove unfixable kmers
*run time <5min for two samples and <20min for all*

Here are the in shell commands I ran to run kmer_fix_array.h
```
export FILES=($(ls -1 ./fq | sed -e 's/\..*$//')) #this was crucial, because it strips .R*.fastq.gz, I could use it for R1 and R2 in the job script
NUMFASTQ=${#FILES[@]}
ZBNUMFASTQ=$(($NUMFASTQ - 1))

#to submit
if [ $ZBNUMFASTQ -ge 0 ]; then
sbatch --array=1-42 ~/Bioinformatics_Scripts/RNAseq/QC_RNAseq/kmer_fix_array.sh
fi

#shouldnt have done to 42, because 13 is missing

#test
sbatch --array=11-12 ~/Bioinformatics_Scripts/RNAseq/QC_RNAseq/kmer_fix_array.sh

```

### run trim galore
*about an hour with standard settings and 1 node*
Using the FAS recommendations for denovo assembly on Trinity

```
#testing first
sbatch --array=10 ~/Bioinformatics_Scripts/RNAseq/QC_RNAseq/trim_galore_test.sh

#to run
sbatch --array=1-41 ~/Bioinformatics_Scripts/RNAseq/QC_RNAseq/trim_galore_array.sh
```
I then ran fastqc (see command below) on these files and found that adapter contamination was still pretty high. Following again the FAS recommendations, I ran with a specific wafergen illumina adapter sequence specified in my `*_wafer.sh`.

```
#later running with wafergen specific settings
sbatch --array=1-41 ~/Bioinformatics_Scripts/RNAseq/QC_RNAseq/trim_galore_array_wafer.sh
```
### fastqc
*this is pretty quick*
```
sbatch --array=3 ~/Bioinformatics_Scripts/RNAseq/QC_RNAseq/fastqc_array.sh
```

### Bowtie2 for rRNA contamination

First, I had to download rRNA data from the silva database. I did this by downloading a fasta file after searching for zebra finch. I assume this was the best approach. I then ran a job submission (bowtie2_index) to make an index for this reference.

Directions from the FAS site
```
module load bowtie2
bowtie2 --very-sensitive-local --phred33  -x $1 -1 $2  -2 $3 --threads 12 --met-file $4 --al-conc-gz $5 --un-conc-gz $6 --al-gz $7 --un-gz $8
```
This initially failed because I tried to include unpaired reads that came from trimming. After some review and reading, it looks like I should just be discarding the unpaired reads. These were a small percentage of the overall number of reads, but I did qualitatively check this.

```
#Failed output:

[eenbody@cypress01-021 test]$ bowtie2 --very-sensitive-local --phred33 -x ../zefi_rRNA -1 ../fq/fixed_5-33253-aida-Chest_S5.R1.cor_unpaired_1.fq.gz, ../fq/fixed_5-33253-aida-Chest_S5.R1.cor_val_1.fq.gz -2 ../fq/fixed_5-33253-aida-Chest_S5.R2.cor_unpaired_2.fq.gz, ../fq/fixed_5-33253-aida-Chest_S5.R2.cor_val_2.fq.gz --threads 20 --met-file testsum --al-conc-gz testmapped --un-conc-gz testunmapped --al-gz testsinglemapped --un-gz testsingleunmapped
Warning: Output file '../fq/fixed_5-33253-aida-Chest_S5.R1.cor_val_1.fq.gz' was specified without -S.  This will not work in future Bowtie 2 versions.  Please use -S instead.
Extra parameter(s) specified: "../fq/fixed_5-33253-aida-Chest_S5.R2.cor_val_2.fq.gz"
Note that if <mates> files are specified using -1/-2, a <singles> file cannot
also be specified.  Please run bowtie separately for mates and singles.
Error: Encountered internal Bowtie 2 exception (#1)
Command: /share/apps/bowtie2/2.3.3/bowtie2-align-s --wrapper basic-0 --very-sensitive-local --phred33 -x ../zefi_rRNA --threads 20 --met-file testsum --passthrough -1 ../fq/fixed_5-33253-aida-Chest_S5.R1.cor_unpaired_1.fq.gz -2 ../fq/fixed_5-33253-aida-Chest_S5.R2.cor_unpaired_2.fq.gz ../fq/fixed_5-33253-aida-Chest_S5.R1.cor_val_1.fq.gz ../fq/fixed_5-33253-aida-Chest_S5.R2.cor_val_2.fq.gz
(ERR): bowtie2-align exited with value 1
```

I tested several scipts and an entire day trying to figure out the best way to run this part.

```
#one example I tried
bowtie2 --very-sensitive-local --phred33 -x ../zefi_rRNA -1 ../fq/fixed_5-33253-aida-Chest_S5.R1.cor_val_1.fq.gz -2 ../fq/fixed_5-33253-aida-Chest_S5.R2.cor_val_2.fq.gz --threads 20 --norc --met-file testsum.txt --al-conc-gz testmapped.fastq.gz --un-conc-gz testunmapped.fastq.gz --al-gz testsinglemapped.fastq.gz --un-gz testsingleunmapped.fastq.gz -S fullout.sam
```

The bottleneck was running a job array and renaming files accordingly, because you make a ton of them in this process. These two websites are how I figured out the best way to do it.

Second, this random website had the only solution for running nonsequentially named files as a job array that I could find. The FAS suggestion did not work for me at all! And I could not get it to work.
https://www.accre.vanderbilt.edu/wp-content/uploads/2016/04/UsingArrayJobs.pdf

This line (added to jobscript) was key, but I do not fully understand it.
```
arrayfile=`ls | awk -v line=$SLURM_ARRAY_TASK_ID '{if (NR == line) print $0}'`
```

Second, the comments from Ram provided the only efficient way I could find to trim off the end of the variable name
https://www.biostars.org/p/98222/

Third, I got a helpful tip on removing the beginning of the name of a variable (i.e. "fixed") from here:
http://wiki.bash-hackers.org/syntax/pe

All of these solutions culminated in the bowtie2.rRNA_removal.array.sh script.

At the end of the day on September 25th, I was not able to run this because the step generates a HUGE amount of data and I filled up my quota.

I explored a little more and can see that when I blast over representative sequences in sample 32, they are rRNA. It looks like I did not correctly build an rRNA reference. I found a thread where I downloaded one from some random dudes google drive...
https://www.biostars.org/p/159959/

This seems to be the way to go! Ok...Simon helped me actually navigate the SILVA database. I found SSU and LLU reference files that I could download and concatanate like such. I am going to see if this works better than the one I downloaded before. Note, I used the SSU Nr99 database (rather than just SSU) because SILVA seems to reecomend it


```
#doing it on the harvard cluster

srun -p interact --pty --mem 4000 -t 0-06:00 /bin/bash

source new-modules.sh
module load fastx_toolkit/0.0.14-fasrc01

### Change file to single line first
fasta_formatter -h
fasta_formatter -i SILVA_128_LSURef_tax_silva_trunc.fasta -o SILVA_128_LSURef_tax_silva_trunc_singleline.fasta -w 0

### Use this command instead —> sed '/^[^>]/ y/uU/tT/' uracil.fasta > thymine.fasta
sed '/^[^>]/ y/uU/tT/' SILVA_128_LSURef_tax_silva_trunc_singleline.fasta  > SILVA_128_LSURef_tax_silva_trunc_singleline_DNA.fasta



### Also do small subunit of rRNA

fasta_formatter -i SILVA_128_SSURef_Nr99_tax_silva_trunc.fasta -o SILVA_128_SSURef_Nr99_tax_silva_trunc_singleline.fasta -w 0

sed '/^[^>]/ y/uU/tT/' SILVA_128_SSURef_Nr99_tax_silva_trunc_singleline.fasta > SILVA_128_SSURef_Nr99_tax_silva_trunc_singleline_DNA.fasta



### Concatenate LSU and SSU in one file
cat SILVA_128_LSURef_tax_silva_trunc_singleline_DNA.fasta SILVA_128_SSURef_Nr99_tax_silva_trunc_singleline_DNA.fasta > SILVA_128_LSURef_SSURef_Nr99_tax_silva_trunc_singleline_DNA.fasta

#gzip SILVA_128_LSURef_tax_silva_trunc_singleline_DNA.fasta
#gzip SILVA_128_SSURef_Nr99_tax_silva_trunc_singleline_DNA.fasta

```
