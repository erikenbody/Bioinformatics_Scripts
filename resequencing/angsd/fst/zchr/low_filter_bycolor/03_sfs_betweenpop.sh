#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e angsd_2dsfs_4.err            # File to which STDERR will be written
#SBATCH -o angsd_2dsfs_4.out           # File to which STDOUT will be written
#SBATCH -J angsd_2dsfs           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=256000
#SBATCH --cpus-per-task=20
#SBATCH --time=6-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

#exceeded memory when set to 64gb
#remove coverage, remove relatives
#already ran lorentzi and naimii sfs elsewhere, so only run moretoni and aida (they were run combined before with relatives)

module load zlib/1.2.8
module load xz/5.2.2

HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/fst_angsd/zchr/nocov_NR_bycolor/
#
cd $WORK_D

RUN=zchr_scaffolds
POP1=blackchest
POP2=whitechest
POP3=whitesp
POP4=lorentzi

/home/eenbody/BI_software/angsd0.920_tar_install/angsd/misc/realSFS -P 20 Results/${POP1}.${RUN}.ref.saf.idx Results/${POP2}.${RUN}.ref.saf.idx > Results/${POP1}_${POP2}.sfs
/home/eenbody/BI_software/angsd0.920_tar_install/angsd/misc/realSFS -P 20 Results/${POP1}.${RUN}.ref.saf.idx Results/${POP3}.${RUN}.ref.saf.idx > Results/${POP1}_${POP3}.sfs
/home/eenbody/BI_software/angsd0.920_tar_install/angsd/misc/realSFS -P 20 Results/${POP2}.${RUN}.ref.saf.idx Results/${POP3}.${RUN}.ref.saf.idx > Results/${POP2}_${POP3}.sfs
/home/eenbody/BI_software/angsd0.920_tar_install/angsd/misc/realSFS -P 20 Results/${POP3}.${RUN}.ref.saf.idx Results/${POP4}.${RUN}.ref.saf.idx > Results/${POP3}_${POP4}.sfs
