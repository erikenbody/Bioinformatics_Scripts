#### 01 Running MITObim

Following SS's advice, trying this software.

Using only R1 fastq.gz as input, it pumped out one contig of length ~17kb, which blasts very well to the RBFW mtDNA genome. So this seems like a very good option. I next made interleaved fastq files from the bam out put in the preprocessing directories and used the paired option. For sample 10, this didn't improve much (added a few basepair), but might be helpful for some low coverage samples.

This software requires a reference mtDNA genome, so I used a previously published one. I used Tutorial II from the MITObim github page and used default params.

RBFW ref from:
https://www.ncbi.nlm.nih.gov/nucleotide/KJ909199?report=genbank&log$=nuclalign&blast_rank=1&RID=EHGBSSWX015


try this? for getting filename to first line of fasta
https://www.unix.com/unix-for-dummies-questions-and-answers/157521-replacing-first-line-file-filename.html
```
awk '{if( NR==1)print ">"FILENAME;else print}' S5_SK1.chr01
```

#### 02 Formatting
The formatting kind of sucks in the output if you have multiple samples, or I'm missing something. Regardless, need to replace the first line in the fasta file with the name of the sample. Dont need to run script 02, its pretty easy to extract from the log files.

```
for filename in *.out; do
  FPATH=$(tac $filename | awk 'NR==10' | cut -c 48-)
  cp $FPATH final_mt_assemblies
done

cd final_mt_assemblies

for filename in *.fasta; do  

  sed -i "1s/.*/>${SAMPLE}/" $FPATH
done

#dump
#SAMPLE=$(echo $FPATH | cut -c 111- | rev | cut -c 24- | rev )
```
