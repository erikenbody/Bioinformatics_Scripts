#!/bin/bash
#!/bin/bash
#SBATCH --qos=normal
#SBATCH --time=0-3:00
#SBATCH --mem=2000
#SBATCH --verbose    ###        Verbosity logs error information into the error file
#SBATCH --job-name=wsfw_merge_lanes### Job Name
#SBATCH --nodes=1             ### Node count required for the job
#SBATCH --ntasks-per-node=20   ### Number of tasks to be launched per Node
#SBATCH --output=merge_lanes.out
#SBATCH --error=merge_lanes.error.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=eenbody@tulane.edu

date
pwd

#from: https://superuser.com/questions/947008/concatenate-csv-files-with-the-same-name-from-subdirectories
ALLFILE=`
for FILE in {1,2}lane/*
do
  basename $FILE
done | sort | uniq

`
for FILE in $ALLFILE
do
  cat {1,2}lane/$FILE > merged/$FILE
done
