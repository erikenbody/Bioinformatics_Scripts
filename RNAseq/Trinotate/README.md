### Trinotate

Just following this workflow:
https://informatics.fas.harvard.edu/trinotate-workflow-example-on-odyssey.html

#### Dependencies

TransDecoder
Simple install - does not require compiling
https://github.com/TransDecoder/TransDecoder

Hmmer - installed with bioconda previously. Just activate ede_py environment
Blast - also on ede_py
SQLite - also on ede_py

#### Databases
Better to follow specific Trinotate instructions than the ones on the Harvard FAS site.
https://trinotate.github.io

Note: This failed when I had my conda environ active. Presumably because I had a version of sqlite installed on there (it is preloaded on the cluster)

```
export TRINOTATE_HOME=/home/eenbody/BI_software/Trinotate-Trinotate-v3.1.1
cd $TRINOTATE_HOME

$TRINOTATE_HOME/admin/Build_Trinotate_Boilerplate_SQLite_db.pl  Trinotate
#and once it completes, it will provide to you:

Trinotate.sqlite
uniprot_sprot.pep
Pfam-A.hmm.gz
#Prepare the protein database for blast searches by:

makeblastdb -in uniprot_sprot.pep -dbtype prot
#Uncompress and prepare the Pfam database for use with hmmscan like so:

gunzip Pfam-A.hmm.gz
hmmpress Pfam-A.hmm
```

#### 01 TransDecoder
`01_TransDecoder`
*34 min run time*

#### 02 Split Fasta
Goes really fast - dont need to do it as a script

##### The following three scripts can be run at the same time

#### 03.1 Blastx
`03.1_blast.sh`
*~20min per array (x40)*

#### 03.2 Blastp
`03.2_blast_pep.sh`

#### 03.3 Hmmer
`03.3_hmmer.sh`

#### 03.4 signal ip and tmhmm
`03.4_signalip_tmhmm.sh`

#### Make trinotate database

Can do in idev
```
export TRINOTATE_HOME=/home/eenbody/BI_software/Trinotate-Trinotate-v3.1.1
TRANS_DATA=/home/eenbody/Enbody_WD/WSFW_DDIG/RNAseq_WD/Guided_Trinity/trinity_gg/
WORK_D=/home/eenbody/RNAseq_WD/Trinotate

cd /home/eenbody/RNAseq_WD/Trinotate
cd blast_output
cat blastx.vol.*.outfmt6 > blastx.wsfw.sprot.outfmt6
cd blastp_output
cat blastp.vol.*.outfmt6 > blastp.wsfw.sprot.outfmt6

#working dir has to be the trinotate directory (or wherever you saved the sqlite database)
#I probably should have put it in my trinotate wd..
cd $TRINOTATE_HOME

$TRINOTATE_HOME/Trinotate Trinotate.sqlite init --gene_trans_map $TRANS_DATA/Trinity_gg_map.txt --transcript_fasta $TRANS_DATA/Trinity-GG.fasta --transdecoder_pep $WORK_D/Trinity-GG.fasta.transdecoder.pep

$TRINOTATE_HOME/Trinotate Trinotate.sqlite LOAD_swissprot_blastx  $WORK_D/blast_output/blastx.wsfw.sprot.outfmt6

$TRINOTATE_HOME/Trinotate Trinotate.sqlite LOAD_swissprot_blastp  $WORK_D/blastp_output/blastp.wsfw.sprot.outfmt6

$TRINOTATE_HOME/Trinotate Trinotate.sqlite LOAD_pfam $WORK_D/hmmer_output/TrinotatePFAM.out

$TRINOTATE_HOME/Trinotate Trinotate.sqlite LOAD_tmhmm  $WORK_D/signalip_tmhmm_output/tmhmm.out

$TRINOTATE_HOME/Trinotate Trinotate.sqlite LOAD_signalp  $WORK_D/signalip_tmhmm_output/signalp.out

#Next step takes 20-30 minutes

$TRINOTATE_HOME/Trinotate Trinotate.sqlite report -E 0.00001 > $WORK_D/trinotate_annotation_report.xls
```

This file can be added to an expression matrix for RSEM analysis using this:
https://github.com/trinityrnaseq/trinityrnaseq/wiki/Functional-Annotation-of-Transcripts

Or, it could be pulled into TrinotateWeb, which may be worth exploring.
