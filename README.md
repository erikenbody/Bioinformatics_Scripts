### Bioinformatics Scripts Overview
##### *And other related first steps, including software installation*

This repository is just a place to deposit scripts used while analyzing Whole-genome Resequencing and RNAseq data related to my dissertation on White-shouldered Fairywrens (more info: erikenbody.github.io).

There are few custom scripts in here and mostly these are sbatch submission's to the Tulane HPC cluster (Cypress). Cypress uses SLURM based submissions, so `.sh` in this repository use SLURM syntax. However, the rest of the commands should be general purpose and I try to annotate the code as much as possible throughout.

There are some places where I used custom python scripts and R scripts written by Allison Shultz on her detailed WGS repository here:
https://github.com/ajshultz/whole-genome-reseq
Which follows her reccomended workflow here:
https://github.com/ajshultz/pop-gen-pipeline


Below, you will find a running list of notes I made while running miscellaneous tasks related to this project. These include simple unix commands, helpful bash scripts, tips for transferring NGS data between clusters, and notes on the installation of various software.

#### Useful unix commands
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
```

To run something in the background, run it, then click `ctrl-z` then type `bg`, to check active jobs type `jobs`

#### Change file extensions
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
#### Copying files from Odyssey

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

I was still worried that the file sizes seemed off using `du -s` or `du -b` between the original files and on cypress. So, I decided to check the md5sum.txt that they provide with the sequencing data. Unfortunately, the columns were switched (should be checksum space space filename), so I downloaded the md5sum.txt, opened in excel, moved columns, saved as .txt (space delimited?) then opened in textwrangler, clicked 'text' dropdown then detab and 2 for lines. Then saved as unix format. Uploaded to cluster using scp. There was probably an easier way to do this and it took several file format attempts. Once this was correct and on Cypress, I ran:
```bash
md5sum -c updated3_md5sum.txt
```

When the second lane was available, I used this to copy

```bash
scp -rp eenbody@odyssey.rc.fas.harvard.edu:/n/ngsdata/170824_NS500422_0539_AHWGYJBGX2/ .
```

#### Installing Software

##### FastQc
Downloaded linux zip folder and used `scp` to copy to cluster. I can run it from the FastQC in my WD using ./fastqc. I was able to add it to my .bash_profile (which sources on startup) on cypress by adding it to my path

helpful related link: https://www.ccs.uky.edu/docs/cluster/env.html

```bash
nano .bash_profile
#add the following line
PATH=$PATH:$HOME/bin:/home/eenbody/Enbody_WD/FastQC
source #only neccessary this time when I hadnt restarted
fastqc --help #to check
```

##### Trinity
Note: Trinity is a module, but I made this path to access scripts available to Trinity.

```bash
PATH=$PATH:$HOME/bin:/home/eenbody/BI_software/trinityrnaseq-Trinity-v2.4.0/util
```

##### multiqc
This is a helpful little software package that compiles all of the fastqc files into a readable report. I installed locally using pip (its python based) and copied files from cypress locally. Harvard generated fastqc files during processing.

To run on the cluster:
```
cd /path/to/fastqc/files
module load anaconda
source activate ede_py
multiqc .
```

##### rcorrector
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

##### cutadapt
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

##### fastx toolkit
Was suggested by simon to use to make rRNA reference. But could not get it to compile. I instead used it on odyssey

##### BUSCO
This is used to evaluate the quality of assembled transcripts. It is a python based software so I used anaconda to install. It should now run when I load anaconda and activate ede_py.

```bash
module load anaconda
source activate ede_py
conda install -c bioconda busco
```

#### Maintaining scripts
I write scripts locally, then use rsync to keep them synced with my cypress directory.
```
rsync -aP ~/Google_Drive/Tulane/WSFW_Data/Genomics_DNA_RNA/Bioinformatics_Scripts cyp:/home/eenbody/Enbody_WD
```
