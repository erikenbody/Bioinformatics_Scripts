#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e ln_mrg.err            # File to which STDERR will be written
#SBATCH -o ln_mrg.out           # File to which STDOUT will be written
#SBATCH -J ln_mrg           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

#from: https://superuser.com/questions/947008/concatenate-csv-files-with-the-same-name-from-subdirectories
ALLFILE=`
for FILE in /home/eenbody/Enbody_WD/WSFW_DDIG/Raw_WSFW_WGS/WGS_Lane*/L*/Fastq/*.gz
do
  basename $FILE
done | sort | uniq
`
for FILE in $ALLFILE
do
  cat /home/eenbody/Enbody_WD/WSFW_DDIG/Raw_WSFW_WGS/WGS_Lane*/L*/Fastq/$FILE > $FILE
done
