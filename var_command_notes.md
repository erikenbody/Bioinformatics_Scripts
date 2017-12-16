###Basic UNIX commands, file transfer, and software installation
#####*And related first steps, including software installation for running RNAseq resequencing pipelines*

####Useful unix commands
```bash
cd .. 	#goes back to the previous directory
mv 	#use this command to rename a file, you must include the name of the file followed by the new name
rm –r [folder] 	#to delete folders with contents, MUST GIVE A FOLDER, be careful! Can delete important folders, like root!
zcat 		#takes a compressed file to decompress .gz and run through cat
grep 	#searches gnu regular expressions, will have to use ^ to find something at beginning of line and $ to find at the end of the line – very powerful – you can use this to find all the reads that didn’t work
zgrep   #can use this to also look up things – for example look up a barcode in a fastq file
control z #then type# bg 	#use this when you want to push a command into the back ground – it will eventually pop out a number when the command is finished
du #checks size of files use -b for byte calcs (more accurate?) and -h for human readable
ln -s #make a soft link to a file or folder. I did this in my cypress home folder to my lustre working directory
chmod +x #for giving yourself permission for a .sh file to run it
tar xopf <file>#for unpacking a .tar file with verbose output
sudo chown -R erikenbody /usr/local #random but very helpful when I was installing things locally and using Homebrew on latest oxs
```

To run something in the background, run it, then click `ctrl-z` then type `bg`, to check active jobs type `jobs`

####Change file extensions
I kinda messed them up at one point, so it is helpful to change extensions to simplify.
```
for file in *.clp.fq.1_fastqc.zip
do
mv "$file" "${file%.clp.fq.1_fastqc.zip}.R1_fastqc.zip"
done

for file in *.clp.fq.2_fastqc.zip
do
mv "$file" "${file%.clp.fq.2_fastqc.zip}.R2_fastqc.zip"
done

for file in *.clp.fq.1_fastqc.html
do
mv "$file" "${file%.clp.fq.1_fastqc.html}.R1_fastqc.html"
done

for file in *.clp.fq.2_fastqc.html
do
mv "$file" "${file%.clp.fq.2_fastqc.html}.R2_fastqc.html"
done

```
####Copying files from Odyssey

I was not able to transfer files using BBCP from Harvard Oddyssey to Tulane Cypress. This may be because Harvard is not setup to run it? It is installed there however. When running just SCP, it timed out after 40min. So I set up an interactive session using:

```bash
idev -N 1 -t 10:00:00
```

This requested ten hours on one node. I had to do idev, because I couldnt figure out how to log in to odyssey when submitting a job submission file for transferring files. This way, I can enter my ssh key info and run it. I used rsync at this point, because I had transferred ~ half the files.

```bash
rsync -a --ignore-existing eenbody@odyssey.rc.fas.harvard.edu:/n/ngsdata/170728_NB502063_0023_AH7HFWBGX3/ .
```

Because scp had been cut off earlier, I noticed that it had stopped mid way through transferring a file (21 R1). So, I had to replace the partial file with the full file using the command below.

```bash
scp eenbody@odyssey.rc.fas.harvard.edu:/n/ngsdata/170728_NB502063_0023_AH7HFWBGX3/Lane1.indexlength_6/Fastq/21-47745-moretoni-Chest_S20.R1.fastq.gz .
```

I was still worried that the file sizes seemed off using `du -s` or `du -b` between the original files and on cypress. So, I decided to check the md5sum.txt that they provide with the sequencing data. Unfortunately, the columns were switched (should be checksum space space filename), so I downloaded the md5sum.txt, opened in excel, moved columns, saved as .txt (tab delimited) then opened in textwrangler, clicked 'text' dropdown then detab and 2 for lines. Then saved as unix format. Uploaded to cluster using scp. There was probably an easier way to do this and it took several file format attempts. Once this was correct and on Cypress, I ran:
```bash
md5sum -c updated3_md5sum.txt
```

When the second lane was available, I used this to copy

```bash
scp -rp eenbody@odyssey.rc.fas.harvard.edu:/n/ngsdata/170824_NS500422_0539_AHWGYJBGX2/ .
```

For the WGS

```bash
scp -rp eenbody@odyssey.rc.fas.harvard.edu:/n/ngsdata/170918_D00742_0189_ACBC90ANXX/Lane7.indexlength_6 .
scp -rp eenbody@odyssey.rc.fas.harvard.edu:/n/ngsdata/170918_D00742_0189_ACBC90ANXX/Lane8.indexlength_6 .

```

Later I accidentally deleted all lane 1 WGS fastq files. I pulled these from Simon's folder (thankfully backed up here!) and copied them. But kept getting errors, so used rsync then had to mannually copy number 11 like below. I used md5sum using the above directions to make sure all files were there.

```bash
scp -p eenbody@odyssey.rc.fas.harvard.edu:/n/holylfs/LABS/edwards_lab/ywsin/WSFW_Erikproject/resequencing/1stdata_170818_D00742_0186_BCB29KANXX/Lane5.indexlength_6/Fastq/11_33248_aida_CTGGCC.R1.fastq.gz .
```

Later, transferring renamed files to simon
```
rsync -a --ignore-existing Raw_WSFW_WGS_name_fixed eenbody@odyssey.rc.fas.harvard.edu:/n/holylfs/LABS/edwards_lab/eenbody
```

####Maintaining scripts
I write scripts locally, then use rsync to keep them synced with my cypress directory. I made this an alias in my bash file `syncscripts`
```
rsync -aP ~/Google_Drive/Tulane/WSFW_Data/Genomics_DNA_RNA/Bioinformatics_Scripts cyp:/home/eenbody/Enbody_WD
```

Trying for data output
```
rsync -aP cyp:/home/eenbody/Data_output /Users/erikenbody/Google_Drive/Tulane/WSFW_Data/Genomics_DNA_RNA/WSFW_DDIG_RNAseq_WGRS
```

####Downloading perl modules
Many software below requite certain modules that I am no able to install without root access. For some reason some software (like genemark) cant work within the conda environment.

I am trying the top answer from here.
https://stackoverflow.com/questions/2980297/how-can-i-use-cpan-as-a-non-root-user

```
wget -O- http://cpanmin.us | perl - -l ~/perl5 App::cpanminus local::lib
eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib`
echo 'eval `perl -I ~/perl5/lib/perl5 -Mlocal::lib`' >> ~/.bash_profile
echo 'export MANPATH=$HOME/perl5/man:$MANPATH' >> ~/.bash_profile

#to install:
cpanm Module::Name
```

####Create txt file for links to fileSplit
It is often helpful to have a text file that includes links to all files you will be processing by some command. For example, to make a bam_list.txt files

```
cd /path/to/bam/files
ls -d -1 $PWD/*.bam* >> bam_list.txt
```

####Find large file

```
du -a . | sort -n -r | head -n 10
```

####Count files within subdirectories

Just a few subdirectories deep

```
find . -type d -print0 | while read -d '' -r dir; do
    files=("$dir"/*)
    printf "%5d files in directory %s\n" "${#files[@]}" "$dir"
done
```

For looking across all my folders:
https://www.unix.com/shell-programming-and-scripting/130139-number-files-per-directory-2.html
```
currdir=$PWD
for dir in $(find .  -type d)
do
       cd $currdir/$dir
       files=$( find .  -type f | wc -l )
       echo "$files $dir"
done | sort -k 1,1nr
```

####Installing packages

*Simon reccomended software*

FastQC **I added software to cypress**
Rcorrector **make based install**
TrimGalore! **I added software to cypress**
cutadept **needed for trimgalore. python based install**
Bowtie2 **module exists on cypress 2.2.4, latest is 2.3.3**
Trinity **python based install**

*from Newhouse et al. 2017*
in addition to above:
TopHat **module exists on cypress 2.0.13, 2.1.1 is latest**
SAMtools View **module exists on cypress 1.1, 1.5 is latest**
HTSeq **requires python based install**


#####FastQc
Downloaded linux zip folder and used `scp` to copy to cluster. I can run it from the FastQC in my WD using ./fastqc. I was able to add it to my .bash_profile (which sources on startup) on cypress by adding it to my path

helpful related link: https://www.ccs.uky.edu/docs/cluster/env.html

```bash
nano .bash_profile
#add the following line
PATH=$PATH:$HOME/bin:/home/eenbody/Enbody_WD/FastQC
source #only neccessary this time when I hadnt restarted
fastqc --help #to check
```

#####Trinity
Note: Trinity is a module, but I made this path to access scripts available to Trinity.

```bash
PATH=$PATH:$HOME/bin:/home/eenbody/BI_software/trinityrnaseq-Trinity-v2.4.0/util
```

#####multiqc
This is a helpful little software package that compiles all of the fastqc files into a readable report. I installed locally using pip (its python based) and copied files from cypress locally. Harvard generated fastqc files during processing.

To run on the cluster:
```
cd /path/to/fastqc/files
module load anaconda
source activate ede_py
multiqc .
```

#####rcorrector
I scp repo from github that I downloaded locally to /BI_software and ran `make` within that directory. This pumped out an error code relating to kmercode, but I am still able to run the software. Some digging and the problem could be jellyfish, but Im not even sure of this. Was a bit unclear.

Maybe fixed September 19
First, had to successfully install jellyfish independently of the rcorrector install
Followed github directions and installed from here:
https://github.com/gmarcais/Jellyfish/releases

```
./configure --prefix=$HOME
make -j 4
make install
```

But got error at make -j, found stackoverflow solution:
https://stackoverflow.com/questions/33278928/how-to-overcome-aclocal-1-15-is-missing-on-your-system-warning-when-compilin

```
touch aclocal.m4 configure
touch Makefile.am
touch Makefile.in
```

Then I was able to run the two make commands. I added jellyfish/bin to my .bash_profile PATH
Now I can run with ```jellyfish --help``` from anywhere.

Now I had to delete the original version of rcorrector that I installed (because it had tried and failed to install jellyfihs, was now looking for it in rcorrector folder). This time, it did not download and try to install jellyfish files, becuase it found jellyfish in path.

```
module load git
git clone https://github.com/mourisl/rcorrector.git
make
```
This seems to have worked, but I can't run it from path for some reason. Here is path:
/home/eenbody/Enbody_WD/BI_software/rcorrector/run_rcorrector.pl

So to run:
```
perl /home/eenbody/Enbody_WD/BI_software/rcorrector/run_rcorrector.pl
```

#####cutadapt
Details here: https://wiki.hpc.tulane.edu/trac/wiki/cypress/AnacondaInstallPackage

```
module load anaconda
conda install -c bioconda cutadapt
```
this cant finish install, so then I run (as suggested)
conda create -n ede_py --clone=/share/apps/anaconda/2/2.5.0
now i made the root ede_py
```
conda install -c bioconda cutadapt
```
but this gave me an error, so ran the below
```
conda remove conda-build
conda remove conda-env
```
finally:
```
conda install -c bioconda cutadapt
```
In a script, I will have to include:
```
module load anaconda
source activate ede_py
```

#####fastx toolkit
Was suggested by simon to use to make rRNA reference. But could not get it to compile. I instead used it on odyssey

#####BUSCO
This is used to evaluate the quality of assembled transcripts. It is a python based software so I used anaconda to install. It should now run when I load anaconda and activate ede_py.

```bash
module load anaconda
source activate ede_py
conda install -c bioconda busco
```

####Sambamba
This is a faster version of samtools apparently, basically.

first need to install ldc. As per sambamba github:
```bash
wget https://github.com/ldc-developers/ldc/releases/download/v0.17.5/ldc2-0.17.5-linux-x86_64.tar.xz
tar xJf ldc2-0.17.5-linux-x86_64.tar.xz

```

####Kallisto
Transcript quant (fast)

install:
```bash
module load git
wget https://github.com/pachterlab/kallisto/releases/download/v0.43.1/kallisto_linux-v0.43.1.tar.gz

gunzip kallisto_linux-v0.43.1.tar.gz
tar -xf kallisto_linux-v0.43.1.tar

added to .bash_profile
PATH=$PATH:$HOME/bin:path/to/kallisto
```
###Genome Annotation software

For MAKER and RepeatModeler, see `genome_annotation.md`

####GeneMark ES
This was a pain to install. From:
http://topaz.gatech.edu/GeneMark/index.html
YAML
   Hash::Merge
   Logger::Simple
   Parallel::ForkManager
I used `wget` once I got to the download page for GeneMark. Copying the gm_key didnt really do anything, so I added the main folder filled with perl scripts to my path. I then had to install some dependencies based on the README. Some I found on BIOCONDA and others I used cpan install (while in my python environment). So will need to load anaconda module for this.

####HTSLIB and ANGSD
http://www.popgen.dk/angsd/index.php/Installation
From ANGSD website

```
git clone https://github.com/samtools/htslib.git
git clone https://github.com/ANGSD/angsd.git
cd htslib;make;cd ../angsd ;make HTSSRC=../htslib
```

but HTSLIB didnt really work. I had to
```
load module zlib
load module xz
load module git
```
then

```
./configure --profix=$HOME
make install
```

THE ABOVE WAS A WASTE OF TIME
I followed the unix install direcitons instead and this just worked. I still had to load zlib, xz, git(?)

```
load module zlib
load module xz
load module git
wget http://popgen.dk/software/download/angsd/angsd0.918.tar.gz
tar xf angsd0.918.tar.gz
cd htslib;make;cd ..
cd angsd
make HTSSRC=../htslib
cd ..
```

####Apollo browser
I have yet to get this to work

https://genomearchitect.readthedocs.io/en/1.0.4/Quick_start_guide/

Locally machine had to install JDK. Then set JAVA_HOME
`export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_152.jdk/Contents/Home`

####JBrowse
First, set up Apache web server basically following advice here:
https://jason.pureconcepts.net/2016/09/install-apache-php-mysql-mac-os-x-sierra/

had trouble with permissions...good luck

test in browser with:

http://http://localhost/jbrowse/JBrowse-1.12.3rc2/index.html?data=sample_data/json/yeast

Eventually got my reference fasta together and working below:
http://http://localhost/jbrowse/JBrowse-1.12.3rc2/index.html?data=data/json/wsfw_maker

Good tips from here:
https://gist.github.com/darencard/4db3be0c396dd24a5dbdec649ca4adf9

The gff2jbrowse.pl script does not seem to work. Issue connecting to JBlibs module? not clear

Now - maker2jbrowse.pl seems to work

First, needed to get reference genome into Jbrowse:

```
 bin/prepare-refseqs.pl --out data/json/wsfw_maker --fasta /Users/erikenbody/Google_Drive/Tulane/WSFW_Data/Genomics_DNA_RNA/Reference_Genome_Annotation/WSFW_ref_final_assembly.fasta
 ```

```
bin/maker2jbrowse /Users/erikenbody/Google_Drive/Tulane/WSFW_Data/Genomics_DNA_RNA/Reference_Genome_Annotation/WSFW_assembly_maker2.all.gff -o data/json/wsfw_maker
```
