### Annotating the WSFW reference genome using MAKER


#### Pre Maker software

#### RepeatModuler
`rm_db.sh`

This is ridiculously difficult to install with a ton of dependencies.
http://www.repeatmasker.org/RepeatModeler/
hopefully it works...
rgem is the most likely source IMO if not

This took for ever to get right. I could not install on macbook, because nseg is linux only. Next, on the cluster, I could not install rmblastn for some reason. The Anaconda distribution did not work (it returned 0 libraries). So, in the end, I installed all dependencies mannually, but installed rmblastn using anaconda. So I had to load the conda python environ to run this. But that worked fine! See script `rm_db.sh` for details on settings I ran.

Masked a bunch of stuff. Was unclear how to unmask transposons, so proceeding just with the basic output of repeatmodeler.

**Note that SS and the ratite project did not do this, but it came highly reccomended in the Maker tutorial so I ran it.It does take quite a bit of time to run**


##### Trinity with jaccard_clip
`trinity_47816.sh`

All the google groups tips suggest that I should re run trinity with jaccard_clip. This is taking forever and generates tons of  files. It failed on 10/27 with something called parafly bailing. I found a possible solution here:
https://groups.google.com/forum/#!searchin/trinityrnaseq-users/parafly$20failed%7Csort:date/trinityrnaseq-users/Hs8ACKJyZi4/jSjtGM5nBwAJ

so I deleted the output folder and resubmitted the same command.

Then, SS pointed out that I shouldnt use trinity results from all individuals, I should just use one. So I canceled this and can pick it up again if necessary (although later I deleted these files to save space). Re running just 487816 chest and sp, because its a male (like the ref). See `trinity_47816.sh` for detials on how I ran this.

##### TopHat
`tophat_sj.sh`

SS also ran tophat to get splice junctions. TopHat reports a quality index for splice junctions and I'm not sure that STAR does. So I will run TopHat for the 47816 individual I am running with trinity. After running tophat, I used this command from Simon/ratite folks (work dir is the tophat output)
`awk '{if($5 >= 5) print $0}' junctions.bed > ../../maker/high_quality_junctions.bed`

then, to make input compatible for Maker
`tophat2gff3 high_quality_junctions.bed > high_quality_junctions.gff`

##### BUSCO
`ref_busco_long.sh`

Initially, I trained augustus on my reference following the "Assemblage pipeline." I ran BUSCO with --long, this will train with Augustus. This will be an informative gene model for input to Maker. I ran `ref_busco_long.sh` for this.

I did not use this data and instead used training data from the ratite project (chicken.hmm) as per SS's suggestion.

##### GeneMark
Super difficult to install. Had to learn how to install perl modules locally. I was able to run this, but did not use in my Maker run when I started following the ratite protocol.

##### Proteins and EST data

See the appendix of this document for the proteins I downloaded. I also downloaded all EST's on ncbi for Zebra Finch and included in my maker input.

#### MAKER
I started installing MAKER, which is quite involved. I ran `perl5 Build.pl`, then ran ./Build installdeps and ./Build installexes.

There was one package in installdeps that didnt work. DBG::Pg. There is an issue with a file pg_config, which according to google means that needed some other dependency (which I couldnt install without root). This is called optional, so skipping for now. If you try to fix google: MAKER software bd pg path to pg_config. I never got this to work, running without.

I got prompted to install repbase, but didnt have an account at the time. (this was installexes). I have an account now so can install this, but re running installexes didnt work. I downloaded the .tar file from repbase later, and put it in the repeatmasker bin folder (according to directions the first time I ran installexes). I placed maker/bin in my path in .bash_profile. **Later this was all for naught, because I installed 3 versions of maker (different mpis), so I have to used a hard link to the maker software to run.** Futhermore, the repeatmasker install that comes with Maker appears to not correctly install repbase, so I add a path in my maker_exe.ctl to a self-installed version of repeatmasker.

**Note that installing maker with the conda bioconda version did not work! Seems to be issues with all the dependencies, but I did not spend time on it**

Some of the exe dependencies in maker did not set up automatically in the `maker_exe.ctl` and I had to set them manually. For some software (e.g. augustus) I had to link to a conda installed version. See the `maker_exe.ctl` to see which software I used from the maker install, versus installing myself, versus installing through anaconda. I had to use a mix of all these approaches, because different software had different issues installing.

One issue I found when trying to set up OpenMPI is that openmpi was installed in my conda env and it was trying to call it from this. So I uninstalled openmpi from the conda env, then added the full path to the mpirun or mpiexec command (after loading intel-pxse, I typed `which mpirun` to find this path, or do this for mpiexec with mpich/OpenMPI) to the slurm script `run_maker.sh`. This seems to have worked out ok.

###### MPI in maker
This has to be installed during maker installation (during the `perl Build.PL`). However, I did it wrong, and was able to just rerun this command later to set up the correct MPI paths. Maker is built around using OpenMPI or MPICH, which all the forum posts are about (and the INSTALL file). However, Tulane's Cypress is built around using intel-pxse, so I set it up to run using this instead. This means during install I used this two paths in the MPI install:
```
/share/apps/intel_parallel_studio_xe/2015_update1/impi/5.0.2.044/intel64/bin/mpicc
/share/apps/intel_parallel_studio_xe/2015_update1/impi/5.0.2.044/intel64/include/mpi.h
```

Nov 15 - seems like maybe intel mpi isnt playing well with maker. Trying again with open mpicc
```
/share/apps/openmpi/1.8.4/bin/mpicc
/share/apps/openmpi/1.8.4/include/mpi.h
```

Openmpi also hangs after a few days when running across multiple nodes. It was able to run on one node with 20 tasks, but this would take forever.

**I SET UP A FRESH INSTALL WITH MPICH2** This is located in `~/BI_software/maker_mpich/bin/maker`

This is the only mpi software that I was able to run successfully with maker. A key component of running this successfully was discovering that qos=long on Cypress is limited to one node. Therefore, to use multiple nodes you must set qos=normal and run using the following settings in the sbatch scripts. I grabbed 128gb memory nodes, because it failed several times using the standard 64gb nodes. You can also see this in my /mpich/run_maker_mpich.sh script, but I have additionally adjusted this to re run at the end. Maker hung on its last step, which was super annoying and alarming, but I reran it with -N 1 and -n 20 and it finished in 10minutes after that. But from my experience so far, if you re run, you should set it to run on 18 nodes, despite the long que time, as it may finish within a day. It is fine if it does not as it restarts from where it left off.

```
#!/bin/bash
#SBATCH -N 18
#SBATCH -n 360
#SBATCH --cpus-per-task=1
#SBATCH -e mpich_maker_128_360_norm.err           # File to which STDERR will be written
#SBATCH -o mpich_maker_128_360_norm.out         # File to which STDOUT will be written
#SBATCH -J mpich_maker_128_360_norm      # Job name
#SBATCH --mem=128000                     # Memory requested
#SBATCH --qos=normal
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

module load mpich/3.1.4
module load anaconda
source activate ede_py
WORK_D=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/Annotation/maker_mpich
cd $WORK_D

/share/apps/mpich/3.1.4/bin/mpiexec -n 360 /home/eenbody/BI_software/maker-mpich/maker/bin/maker -fix_nucleotides
```


#### Running maker
See above for notes on troubleshooting. This took several days when I was running only 20 tasks or only one one node (and never finished). When I grabbed 18 nodes, it seems to have finished within a day (although had already run for awhile on one node), but hung at the end. So if you can get this to run on 360 tasks, it might take only one day.

One helpful tip was to make sure the out log was continuously having information added to it. It was obvious when it hung, because the file as not being modified for hours or days.

#### Check maker output
From SS's document:

```
cd /home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/Annotation/maker_mpich/*output
grep 'FINISHED'  WSFW_ref_final_assembly_master_datastore_index.log | wc -l
#number of scaffolds that finished without error
>4903
#Check number of scaffolds in ref
cd ..
grep '>' WSFW_ref_final_assembly.fasta | wc -l
>4903
#Start interactive session
iDev
cd *output
find . -type f -name "scaffold*gff" -printf '%p\n' | xargs ls -lSh > scaffold_check
#This will output file called 'scaffold_check' that lists all of the scaffold gffs output by maker, with their file size in human readable format, and they will be listed in decreasing order by file size.
wc -l scaffold_check
>4903
#check to make sure smallest output file is nonzero
tail scaffold_check
```

Now merge output gffs and fasta (run in idev)
```
/home/eenbody/BI_software/maker-mpich/maker/bin/fasta_merge -d WSFW_ref_final_assembly_master_datastore_index.log
/home/eenbody/BI_software/maker-mpich/maker/bin/gff3_merge -d WSFW_ref_final_assembly_master_datastore_index.log
```

Next for some QC and pre retraining. Following directions from both SS's document and the assemblage pipeline:
https://github.com/sujaikumar/assemblage/blob/master/README-annotation.md

##### SNAP retraining
```
cd .. #maker wd
mkdir trainsnap
cd trainsnap/
cp ../*output/*.gff .

#convert to zff
/home/eenbody/BI_software/maker-mpich/maker/bin/maker2zff WSFW_ref_final_assembly.all.gff

module load Anaconda
source activate ede_py
#fathom is part of SNAP package
#check Quality of zff files
fathom genome.ann genome.dna -gene-stats > gene-stats.log 2>&1

cat gene-stats.log
#output below. Why errors? Less genes than SS.
MODEL6387 skipped due to errors
MODEL6388 skipped due to errors
MODEL6386 skipped due to errors
MODEL6908 skipped due to errors
MODEL9442 skipped due to errors
757 sequences
0.459199 avg GC fraction (min=0.353200 max=0.704835)
9057 genes (plus=4546 minus=4511)
18 (0.001987) single-exon
9039 (0.998013) multi-exon

#Some issues with SS's specific commands, so followed Assemblage pipeline below.
#Commented out part is what SS had used to make log files?

fathom genome.ann genome.dna -validate > validate.log 2>&1
fathom genome.ann genome.dna -categorize 1000 #> categorize.log 2>&1
fathom -export 1000 -plus uni.ann uni.dna #> uni-plus.log 2>&1
forge export.ann export.dna #> forge.log 2>&1

hmm-assembler.pl WSFW .> WSFW1.hmm
```

Setup for retraining in augustus

```
cd ..
mkdir train_augustus
cd train_augustus/
cp ../trainsnap/genome* .

module load anaconda
source activate ede_py

zff2gff3.pl ./genome.ann | perl -plne 's/\t(\S+)$/\t\.\t$1/' > WSFW.gff3

#augustus config path looks okay, test with
echo $AUGUSTUS_CONFIG_PATH
>Will create parameters for a EUKARYOTIC species!
>creating directory /home/eenbody/.conda/envs/ede_py/config/species/wsfw/ ...
>creating /home/eenbody/.conda/envs/ede_py/config/species/wsfw/wsfw_parameters.cfg ...
>creating /home/eenbody/.conda/envs/ede_py/config/species/wsfw/wsfw_weightmatrix.txt ...
>creating /home/eenbody/.conda/envs/ede_py/config/species/wsfw/wsfw_metapars.cfg ...
>The necessary files for training wsfw have been created.
>Now, either run etraining or optimize_parameters.pl with --species=wsfw.
>etraining quickly estimates the parameters from a file with training genes.
>optimize_augustus.pl alternates running etraining and augustus to find optimal >metaparameters.

new_species.pl --species=wsfw

#make genbank
gff2gbSmallDNA.pl WSFW.gff3 ./genome.dna 1000 WSFW.gb

#Randomly split the set of annotated sequences in a training and a test set
randomSplit.pl WSFW.gb 200

#This generates a file myspecies.gb.test with 100 randomly chosen loci and a disjoint file myspecies.gb.train with the rest of the loci from genes.gb:
>WSFW.gb:6707
>WSFW.gb.test:200
>WSFW.gb.train:6507

#initial etraining
etraining --species=wsfw WSFW.gb.train

#check contents of species
ls -ort $AUGUSTUS_CONFIG_PATH/species/wsfw/

#Now we make a first try and predict the genes in genes.gb.train ab initio.
augustus --species=wsfw WSFW.gb.test | tee firsttest.out # takes ~1m

#OUTPUT:
*******      Evaluation of gene prediction     *******

---------------------------------------------\
                 | sensitivity | specificity |
---------------------------------------------|
nucleotide level |       0.893 |       0.913 |
---------------------------------------------/

----------------------------------------------------------------------------------------------------------\
           |  #pred |  #anno |      |    FP = false pos. |    FN = false neg. |             |             |
           | total/ | total/ |   TP |--------------------|--------------------| sensitivity | specificity |
           | unique | unique |      | part | ovlp | wrng | part | ovlp | wrng |             |             |
----------------------------------------------------------------------------------------------------------|
           |        |        |      |                422 |                463 |             |             |
exon level |   2220 |   2261 | 1798 | ------------------ | ------------------ |       0.795 |        0.81 |
           |   2220 |   2261 |      |  202 |    7 |  213 |  200 |    6 |  257 |             |             |
----------------------------------------------------------------------------------------------------------/

----------------------------------------------------------------------------\
transcript | #pred | #anno |   TP |   FP |   FN | sensitivity | specificity |
----------------------------------------------------------------------------|
gene level |   217 |   200 |   36 |  181 |  164 |        0.18 |       0.166 |
----------------------------------------------------------------------------/

------------------------------------------------------------------------\
            UTR | total pred | CDS bnd. corr. |   meanDiff | medianDiff |
------------------------------------------------------------------------|
            TSS |         34 |              0 |         -1 |         -1 |
            TTS |          7 |              0 |         -1 |         -1 |
------------------------------------------------------------------------|
            UTR | uniq. pred |    unique anno |      sens. |      spec. |
------------------------------------------------------------------------|
                |  true positive = 1 bound. exact, 1 bound. <= 20bp off |
 UTR exon level |          0 |              0 |       -nan |       -nan |
------------------------------------------------------------------------|
 UTR base level |          0 |              0 |       -nan |       -nan |
------------------------------------------------------------------------/
nucUTP= 0 nucUFP=0 nucUFPinside= 0 nucUFN=0
# total time: 226
# command line:
# augustus --species=wsfw WSFW.gb.test
```

Now, actually running augustus. First have to optimize run

```
#make sbatch
#this would run in background during idev. set up as script
optimize_augustus.pl --species=wsfw WSFW.gb.train --cpus=20 1>wsfw.stdout 2>wsfw.stderr &

```

**THIS TOOK 8.5 DAYS TO RUN ON ONE NODE WITH 128gb MEM. Restarted once**

Run etraining - I am not sure the purpose of this, because optimize runs this repeatedly, but seems to do a final Augustus training with the metaparameters identified in the optimize step

```
etraining --species=wsfw WSFW.gb.train
```

Check accuracy of gene predictions, first need to make test

```
randomSplit.pl WSFW.gb.train 200
augustus --species=wsfw WSFW.gb.train.test | tee secondtest.out
```
Output is below. You can see that the gene sensitivity has risen from 0.18 to 0.245. The augustus documentation suggests you want >20% here.
```
*******      Evaluation of gene prediction     *******

---------------------------------------------\
                 | sensitivity | specificity |
---------------------------------------------|
nucleotide level |       0.935 |       0.927 |
---------------------------------------------/

----------------------------------------------------------------------------------------------------------\
           |  #pred |  #anno |      |    FP = false pos. |    FN = false neg. |             |             |
           | total/ | total/ |   TP |--------------------|--------------------| sensitivity | specificity |
           | unique | unique |      | part | ovlp | wrng | part | ovlp | wrng |             |             |
----------------------------------------------------------------------------------------------------------|
           |        |        |      |                357 |                362 |             |             |
exon level |   2424 |   2429 | 2067 | ------------------ | ------------------ |       0.851 |       0.853 |
           |   2424 |   2429 |      |  161 |    6 |  190 |  158 |    7 |  197 |             |             |
----------------------------------------------------------------------------------------------------------/

----------------------------------------------------------------------------\
transcript | #pred | #anno |   TP |   FP |   FN | sensitivity | specificity |
----------------------------------------------------------------------------|
gene level |   213 |   200 |   49 |  164 |  151 |       0.245 |        0.23 |
----------------------------------------------------------------------------/

------------------------------------------------------------------------\
            UTR | total pred | CDS bnd. corr. |   meanDiff | medianDiff |
------------------------------------------------------------------------|
            TSS |         31 |              0 |         -1 |         -1 |
            TTS |         11 |              0 |         -1 |         -1 |
------------------------------------------------------------------------|
            UTR | uniq. pred |    unique anno |      sens. |      spec. |
------------------------------------------------------------------------|
                |  true positive = 1 bound. exact, 1 bound. <= 20bp off |
 UTR exon level |          0 |              0 |       -nan |       -nan |
------------------------------------------------------------------------|
 UTR base level |          0 |              0 |       -nan |       -nan |
------------------------------------------------------------------------/
nucUTP= 0 nucUFP=0 nucUFPinside= 0 nucUFN=0
# total time: 257
# command line:
# augustus --species=wsfw WSFW.gb.train.test
```

##### Maker Second Run

Run maker a second time with the SNAP and Augustus retraining parameters. I also added in the tRNAscan, which I could have included in the first run. I made a copy of the reference genome for this run and called it `WSFW_assembly_maker2.fasta`. This allows me to run maker in the same folder and it generates a second output folder with a different name than the first one. It looks like I could have also done `maker -base Maker_run2`, or similar, to make it run with a different name. I ran this in the same working directory, but I created a second opts file named `maker_opts_run2.ctl` and ran maker with the following command (in the slurm script `part2/run_maker_mpich.sh`):

```
/share/apps/mpich/3.1.4/bin/mpiexec -n 20 /home/eenbody/BI_software/maker-mpich/maker/bin/maker maker_opts_run2.ctl maker_bopts.ctl maker_exe.ctl maker_evm.ctl -fix_nucleotides
```

Here are the options I changed in the opts ctl file when I ran maker a second times

```
genome=WSFW_assembly_maker2.fasta #genome sequence (fasta file or fasta embeded in GFF3 file)
snaphmm=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/Annotation/maker_mpich/trainsnap/WSFW1.hmm #SNAP HMM file
augustus_species=wsfw #Augustus gene prediction species model
trna=1 #find tRNAs with tRNAscan, 1 = yes, 0 = no
```

###### Run time
The second Maker run ran on 18 cores using MPICH MPI and failed after 23:33, which is strangely close to the 24 hour limit. I then ran it again, and it failed after 12 minutes. I ran on one node with 20 processors and it failed in 1hr 22min. The error code was strange, but with the Cypress admin helped I found it was related to MPICH. I ran on one core without multiple processors (-N 1 -n 1) and Maker finished in 1 day, 15hours.

###### Checking Maker run 2 output
Output of log file says Maker finished. 4903 scaffolds listed as 'FINISHED'

```
grep 'FINISHED' WSFW_assembly_maker2_master_datastore_index.log | wc -l
find . -type f -name "scaffold*gff" -printf '%p\n' | xargs ls -lSh > scaffold_check
wc -l scaffold_check
tail scaffold_check
/home/eenbody/BI_software/maker-mpich/maker/bin/fasta_merge -d *index.log
/home/eenbody/BI_software/maker-mpich/maker/bin/gff3_merge -d *index.log
mkdir QC_Using_Snap
cd QC_Using_Snap/
ln -s  ../*.gff .
home/eenbody/BI_software/maker-mpich/maker/bin/maker2zff WSFW_assembly_maker2.all.gff
```

Surprisingly, this second run resulted in less genes...

```
module load anaconda
source activate ede_py
fathom genome.ann genome.dna -gene-stats > gene-stats.log
cat gene-stats.log

###OUTPUT BELOW####
750 sequences
0.459000 avg GC fraction (min=0.353200 max=0.704835)
8759 genes (plus=4341 minus=4418)
18 (0.002055) single-exon
8741 (0.997945) multi-exon
142.731354 mean exon (min=1 max=10830)
1512.504395 mean intron (min=4 max=270836)
```

But I found another way to count number of gene models here:
https://gist.github.com/darencard/bb1001ac1532dd4225b030cf0cd61ce2

```
cat WSFW_assembly_maker2.all.gff | awk '{ if ($3 == "gene") print $0 }' | awk '{ sum += ($5 - $4) } END { print NR, sum / NR }'
>17999 19389.3
```

Does this mean I got 17999 genes? I checked first run and it was: `17690 20001.6`

Check quality scores (AED)

```
perl ~/Bioinformatics_Scripts/Genome_Annotation/maker/AED_cdf_generator.pl -b 0.025 WSFW_assembly_maker2.all.gff
```
output suggests 94% of genes with AED<0.5 (lower is good). That website says 95% should be AED<0.5, so this seems pretty good.
```
AED	WSFW_assembly_maker2.all.gff
0.000	0.010
0.025	0.034
0.050	0.090
0.075	0.141
0.100	0.252
0.125	0.335
0.150	0.464
0.175	0.539
0.200	0.639
0.225	0.692
0.250	0.755
0.275	0.787
0.300	0.825
0.325	0.844
0.350	0.869
0.375	0.884
0.400	0.902
0.425	0.912
0.450	0.925
0.475	0.933
0.500	0.939
0.525	0.942
0.550	0.947
0.575	0.949
0.600	0.953
0.625	0.955
0.650	0.959
0.675	0.961
0.700	0.964
0.725	0.966
0.750	0.969
0.775	0.971
0.800	0.974
0.825	0.977
0.850	0.981
0.875	0.984
0.900	0.988
0.925	0.990
0.950	0.994
0.975	0.997
1.000	1.000
```

#### JBrowse

Installing JBrowse was extremely confusing and I wont get into detail here. But, I cannot find a way to run it on the cluster so run it locally only. **The key was to find the directory on your OS where documents can be hosted on the network**. On macOS this is `/Library/WebServer/Documents`. This is where you will install your apache web sever and jgbrowse.

First, set up Apache web server basically following advice here:
https://jason.pureconcepts.net/2016/09/install-apache-php-mysql-mac-os-x-sierra/

Then use general JBrowse installation instructions.

Good tips from here, however I could no get his `gff2jbrowse.pl` script to work.
https://gist.github.com/darencard/4db3be0c396dd24a5dbdec649ca4adf9

End goal: use `maker2jbrowse.pl` (as provided within the JBrowse installation) to add tracks to the reference genome from maker .gff.

First, needed to get reference genome into Jbrowse:

```
 bin/prepare-refseqs.pl --out data/json/wsfw_maker --fasta /Users/erikenbody/Google_Drive/Tulane/WSFW_Data/Genomics_DNA_RNA/Reference_Genome_Annotation/WSFW_ref_final_assembly.fasta
 ```

Then, copy the 'all.gff' file to my local directories and run maker2jbrowse. **I think the key problem here is that this command and the last command need to both have the same -output dir, otherwise it wasnt working, or something**

```
bin/maker2jbrowse /Users/erikenbody/Google_Drive/Tulane/WSFW_Data/Genomics_DNA_RNA/Reference_Genome_Annotation/WSFW_assembly_maker2.all.gff -o data/json/wsfw_maker
```
This ran for many hours and at the end spit out these errors:
```
WARNING: No matching features found for expressed_sequence_match:tblastx
Too many open files opening bucket log data/json/wsfw_maker/names/000/3a.json.log at /Library/WebServer/Documents/jbrowse/JBrowse-1.12.3rc2/bin/../src/perl5/Bio/JBrowse/HashStore.pm line 197.
```

However, the genome with annotations are now viewable at this location:
```
http://localhost/jbrowse/JBrowse-1.12.3rc2/index.html?data=data/json/wsfw_maker
```

Make sure to run:
```
bin/generate-names.pl --verbose --out data/json/wsfw_maker
```

##### Functional annotation

Useful starting point:
https://scilifelab.github.io/courses/annotation/2016/practical_session/ExerciseFuncAnnotInterp

Maker can add functional annotations after running the software InterProScan 5 or blast.

I spent several hours installing InterProScan (mostly downloading the enormous install files) and found an error when running test data. After checking the github issues page (https://github.com/ebi-pf-team/interproscan/issues/40) this seems to be an issue with rblastp. They have some fixes, but these require c++ 4.8 or above, and the Cypress version is 4.4.7. So I have a problem. May be able to run a local install of c++, but I should probably check with cluster folks.

Next step - try the tips for running Blast

##### Appendix: Proteins
SS downloaded proteins from a ton of species. Guess I will do that. He didn't use EST from ZEFI, but I cant imagine it would hurt to include those. Here are the commands I ran:

```
1008  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/002/315/GCF_000002315.4_Gallus_gallus-5.0/GCF_000002315.4_Gallus_gallus-5.0_protein.faa.gz
 1009  gunzip GCF_000002315.4_Gallus_gallus-5.0_protein.faa.gz
 1010  ls
 1011  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/151/805/GCF_000151805.1_Taeniopygia_guttata-3.2.4/GCF_000151805.1_Taeniopygia_guttata-3.2.4_protein.faa.gz
 1012  gunzip GCF_000151805.1_Taeniopygia_guttata-3.2.4_protein.faa.gz
 1013  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/331/425/GCF_000331425.1_PseHum1.0/GCF_000331425.1_PseHum1.0_protein.faa.gz
 1014  gunzip GCF_000331425.1_PseHum1.0_protein.faa.gz
 1015  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/766/835/GCF_000766835.1_Aquila_chrysaetos-1.0.2/GCF_000766835.1_Aquila_chrysaetos-1.0.2_protein.faa.gz
 1016  gunzip GCF_000766835.1_Aquila_chrysaetos-1.0.2_protein.faa.gz
 1017  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/238/935/GCF_000238935.1_Melopsittacus_undulatus_6.3/GCF_000238935.1_Melopsittacus_undulatus_6.3_protein.faa.gz
 1018  gunzip GCF_000238935.1_Melopsittacus_undulatus_6.3_protein.faa.gz
 1019  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/699/145/GCF_000699145.1_ASM69914v1/GCF_000699145.1_ASM69914v1_protein.faa.gz
 1020  gunzip GCF_000699145.1_ASM69914v1_protein.faa.gz
 1021  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/708/025/GCF_000708025.1_ASM70802v2/GCF_000708025.1_ASM70802v2_protein.faa.gz
 1022  gunzip GCF_000708025.1_ASM70802v2_protein.faa.gz
 1023  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/355/885/GCF_000355885.1_BGI_duck_1.0/GCF_000355885.1_BGI_duck_1.0_protein.faa.gz
 1024  gunzip GCF_000355885.1_BGI_duck_1.0_protein.faa.gz
 1025  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/385/455/GCF_000385455.1_Zonotrichia_albicollis-1.0.1/GCF_000385455.1_Zonotrichia_albicollis-1.0.1_protein.faa.gz
 1026  gunzip GCF_000385455.1_Zonotrichia_albicollis-1.0.1_protein.faa.gz
 1027  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/708/225/GCF_000708225.1_ASM70822v1/GCF_000708225.1_ASM70822v1_protein.faa.gz
 1028  gunzip GCF_000708225.1_ASM70822v1_protein.faa.gz
 1029  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/090/745/GCF_000090745.1_AnoCar2.0/GCF_000090745.1_AnoCar2.0_protein.faa.gz
 1030  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/001/723/895/GCF_001723895.1_CroPor_comp1/GCF_001723895.1_CroPor_comp1_protein.faa.gz
 1031  gunzip GCF_001723895.1_CroPor_comp1_protein.faa.gz
 1032  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/241/765/GCF_000241765.3_Chrysemys_picta_bellii-3.0.3/GCF_000241765.3_Chrysemys_picta_bellii-3.0.3_protein.faa.gz
 1033  gunzip GCF_000241765.3_Chrysemys_picta_bellii-3.0.3_protein.faa.gz
 1034  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.35_GRCh38.p9/GCF_000001405.35_GRCh38.p9_protein.faa.gz
 1035  gunzip GCF_000001405.35_GRCh38.p9_protein.faa.gz
 1036  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/635/GCF_000001635.25_GRCm38.p5/GCF_000001635.25_GRCm38.p5_protein.faa.gz
 1037  gunzip GCF_000001635.25_GRCm38.p5_protein.faa.gz
 1038  wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/002/035/GCF_000002035.5_GRCz10/GCF_000002035.5_GRCz10_protein.faa.gz
 1039  gunzip GCF_000002035.5_GRCz10_protein.faa.gz
 1040  ls
 1041  gunzip GCF_000090745.1_AnoCar2.0_protein.faa.gz
```

Then, cat all together:
`cat *protein.faa > all_protein_multiple_organisms.faa`

Species list:
* Gallus gallus
* Taeniopygia guttata
* Tibetan ground-tit
* Aquila chrysaetos
* Melopsittacus undulatus
* Aptenodytes forsteri
* Charadrius vociferus
* Anas platyrhynchos
* Zonotrichia albicollis
* Nipponia nippon
* Anolis carolinensis
* Crocodylus porosus
* Chrysemys picta
* Homo sapiens
* Mus musculus
* Danio rerio
