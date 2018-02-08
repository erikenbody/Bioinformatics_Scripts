#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e ngscovar.err            # File to which STDERR will be written
#SBATCH -o ngscovar.out           # File to which STDOUT will be written
#SBATCH -J ngs_covar           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=1
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load zlib/1.2.8
module load xz/5.2.2
#

WORK_D=/home/eenbody/reseq_WD/angsd/angsd_pca_NR_auto
RUN=WSFW_F_NR_auto
cd $WORK_D
N_SITES=`cat $WORK_D/$RUN.mafs | tail -n+2 | wc -l`
echo $N_SITES

#probably could have included the gunzip command in this submit file
#changed nind to 37 (n)

ngsCovar -probfile $WORK_D/${RUN}.geno -outfile $WORK_D/${RUN}.covar \
-nind 32 -minmaf 0.05 -nsites $N_SITES
