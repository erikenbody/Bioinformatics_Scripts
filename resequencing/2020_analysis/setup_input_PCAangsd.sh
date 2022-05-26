#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e angsd2020_%J.err            # File to which STDERR will be written
#SBATCH -o angsd2020_%J.out           # File to which STDOUT will be written
#SBATCH -J angsd2020           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=7-00:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load zlib/1.2.8
module load xz/5.2.2
module load gcc/6.3.0
module load anaconda3/5.1.0

HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd
WORK_D=/home/eenbody/reseq_WD/angsd/2020_analysis/run_pcangsd

cd $WORK_D

REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta

BAMLIST=$HOME_D/allpops_bamlist.txt

# /lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/angsd -ref $REFGENOME -anc $REFGENOME \
#           -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 0 -trim 0 \
#           -GL 2 -out WSFW_4pca -nThreads 20 -doGlf 2 -doMajorMinor 1 -doMaf 1 -SNP_pval 1e-6 -bam $BAMLIST


#python ../pcangsd/pcangsd.py -beagle WSFW_4pca.beagle.gz -selection -o WSFW_2 -sites_save -threads 20
#python ../pcangsd/pcangsd.py -beagle WSFW_4pca.beagle.gz -o WSFW_pcangsd_admix -admix -threads 20

#python ../pcangsd/pcangsd.py -beagle  WSFW_4pca.beagle.gz -o WSFW.cov -threads 20
ANGSD_PATH=/lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/
$ANGSD_PATH/misc/NGSadmix -seed 9482 -likes WSFW_4pca.beagle.gz -K 1 -outfiles ngs_admix_k1.1 -P 20
$ANGSD_PATH/misc/NGSadmix -seed 3234 -likes WSFW_4pca.beagle.gz -K 2 -outfiles ngs_admix_k2.1 -P 20
$ANGSD_PATH/misc/NGSadmix -seed 8595 -likes WSFW_4pca.beagle.gz -K 3 -outfiles ngs_admix_k3.1 -P 20
$ANGSD_PATH/misc/NGSadmix -seed 2346 -likes WSFW_4pca.beagle.gz -K 4 -outfiles ngs_admix_k4.1 -P 20
$ANGSD_PATH/misc/NGSadmix -seed 9459 -likes WSFW_4pca.beagle.gz -K 5 -outfiles ngs_admix_k5.1 -P 20

$ANGSD_PATH/misc/NGSadmix -seed 3923 -likes WSFW_4pca.beagle.gz -K 1 -outfiles ngs_admix_k1.2 -P 20
$ANGSD_PATH/misc/NGSadmix -seed 2323 -likes WSFW_4pca.beagle.gz -K 2 -outfiles ngs_admix_k2.2 -P 20
$ANGSD_PATH/misc/NGSadmix -seed 2343 -likes WSFW_4pca.beagle.gz -K 3 -outfiles ngs_admix_k3.2 -P 20
$ANGSD_PATH/misc/NGSadmix -seed 1290 -likes WSFW_4pca.beagle.gz -K 4 -outfiles ngs_admix_k4.2 -P 20
$ANGSD_PATH/misc/NGSadmix -seed 1002 -likes WSFW_4pca.beagle.gz -K 5 -outfiles ngs_admix_k5.2 -P 20

$ANGSD_PATH/misc/NGSadmix -seed 9029 -likes WSFW_4pca.beagle.gz -K 1 -outfiles ngs_admix_k1.3 -P 20
$ANGSD_PATH/misc/NGSadmix -seed 1239 -likes WSFW_4pca.beagle.gz -K 2 -outfiles ngs_admix_k2.3 -P 20
$ANGSD_PATH/misc/NGSadmix -seed 3840 -likes WSFW_4pca.beagle.gz -K 3 -outfiles ngs_admix_k3.3 -P 20
$ANGSD_PATH/misc/NGSadmix -seed 9391 -likes WSFW_4pca.beagle.gz -K 4 -outfiles ngs_admix_k4.3 -P 20
$ANGSD_PATH/misc/NGSadmix -seed 9394 -likes WSFW_4pca.beagle.gz -K 5 -outfiles ngs_admix_k5.3 -P 20
