#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e angsds4dxy.1.err            # File to which STDERR will be written
#SBATCH -o angsds4dxy.1.out           # File to which STDOUT will be written
#SBATCH -J angsds4dxy           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to
#
module load zlib/1.2.8
module load xz/5.2.2
ANGSD=/lustre/project/jk/Enbody_WD/BI_software/angsd_20Feb20/angsd
HOME_D=/home/eenbody/reseq_WD/angsd/fst_angsd

WORK_D=/lustre/project/jk/Enbody_WD/WSFW_DDIG/reseq_WD/angsd/2020_analysis/rerun_dxy
MAFS=../run_pcangsd/WSFW_4pca.mafs.gz
## First take the sites from the pcangsd run and make a sites file
gunzip -c $MAFS > all_pops_mafs.mafs
sed '1d' all_pops_mafs.mafs > all_pops_mafs_NH.mafs
#remove maf < 0.05
awk '{ if ($7 > 0.05 && $7 <0.95) { print } }' all_pops_mafs_NH.mafs >  all_pops_mafs_NH_maf0.05.mafs

cut -f 1-4 all_pops_mafs_NH_maf0.05.mafs > all_pops_mafs_NH_maf0.05_cut.mafs
$ANGSD/angsd sites index all_pops_mafs_NH_maf0.05_cut.mafs


for POP in aida moretoni lorentzi naimii
do
  echo $POP
  MININD=$(if [[ "$POP"  == "aida" ]]; then echo 4; else echo 5; fi)
  BAMLIST=$HOME_D/${POP}_bamlist.txt

  /lustre/project/jk/Enbody_WD/BI_software/angsd-0.931/angsd/angsd -b $BAMLIST -ref $REFGENOME -anc $REFGENOME \
                -out ${POP}.${RUN}.ref -P 20 \
                -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 0 -trim 0 \
                -minMapQ 20 -minQ 20 -minInd $MININD -doCounts 1 \
                -GL 1 -doSaf 1

done
