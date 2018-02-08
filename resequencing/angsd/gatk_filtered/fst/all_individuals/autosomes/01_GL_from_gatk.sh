#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e angsd_from_gatk.err            # File to which STDERR will be written
#SBATCH -o angsd_from_gatk.out           # File to which STDOUT will be written
#SBATCH -J angsd_from_gatk          # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

#exceeded memory when set to 64gb

module load zlib/1.2.8
module load xz/5.2.2

HOME_D=/home/eenbody/reseq_WD/angsd/gatk_filtered/fst_angsd
SAMPLEDIR=/home/eenbody/reseq_WD/GATK_Haplotype_Caller/all_individuals/filtered_vcfs/autosomes/pops_subset/all_ind_HighestFilt/
SUBSET=all_individuals
REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
RUN=autosome_scaffolds
CHR=autosomes
DESCRIPTION=highest_filter_allInd
FAI=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fai

cd $HOME_D/$SUBSET/$CHR

if [ -d "Results" ]; then echo "dir exists" ; else mkdir Results; fi

for POP in aida naimii lorentzi moretoni
do
  echo $POP
  MININD=$(if [[ "$POP"  == "aida" ]]; then echo 4; else echo 5; fi)
  NUMIND=$(if [[ "$POP"  == "aida" ]]; then echo 7; else echo 10; fi)
  angsd -vcf-pl $SAMPLEDIR/${POP}_${CHR}_WSFW_CovFil_2.26_9.04_s.vcf.gz -ref $REFGENOME -fai ${REFGENOME}.fai -anc $REFGENOME \
                -nind $NUMIND -P 20 -out Results/${POP}.${RUN}_${DESCRIPTION}_s.ref \
                -minInd $MININD -minMapQ 20 -minQ 20 \
                -doMaf 1 -doMajorMinor 1 -doSaf 1
done

echo "done running angsd with VCF in. Now running realSFS"

POP1=aida
POP2=naimii
POP3=lorentzi
POP4=moretoni

realSFS -P 20 Results/${POP1}.${RUN}_${DESCRIPTION}.ref.saf.idx Results/${POP2}.${RUN}_${DESCRIPTION}.ref.saf.idx > Results/${POP1}_${POP2}_${DESCRIPTION}.sfs
realSFS -P 20 Results/${POP1}.${RUN}_${DESCRIPTION}.ref.saf.idx Results/${POP3}.${RUN}_${DESCRIPTION}.ref.saf.idx > Results/${POP1}_${POP3}_${DESCRIPTION}.sfs
realSFS -P 20 Results/${POP1}.${RUN}_${DESCRIPTION}.ref.saf.idx Results/${POP4}.${RUN}_${DESCRIPTION}.ref.saf.idx > Results/${POP1}_${POP4}_${DESCRIPTION}.sfs
realSFS -P 20 Results/${POP2}.${RUN}_${DESCRIPTION}.ref.saf.idx Results/${POP3}.${RUN}_${DESCRIPTION}.ref.saf.idx > Results/${POP2}_${POP3}_${DESCRIPTION}.sfs
realSFS -P 20 Results/${POP2}.${RUN}_${DESCRIPTION}.ref.saf.idx Results/${POP4}.${RUN}_${DESCRIPTION}.ref.saf.idx > Results/${POP2}_${POP4}_${DESCRIPTION}.sfs
realSFS -P 20 Results/${POP3}.${RUN}_${DESCRIPTION}.ref.saf.idx Results/${POP4}.${RUN}_${DESCRIPTION}.ref.saf.idx > Results/${POP3}_${POP4}_${DESCRIPTION}.sfs





###MISC CODE####

#angsd -vcf-gl $SAMPLEDIR/${POP}_${CHR}_WSFW_CovFil_2.26_9.04_s.vcf.gz -fai ${REFGENOME}.fai -nind 7 -anc ${REFGENOME} -nThreads 8 -out Results/test1 -doSaf 1 -doPost

#
# angsd -vcf-pl All_WSFW_passed_CovFil.vcf.gz -ref $REFGENOME -fai ${REFGENOME}.fai -anc $REFGENOME \
#               -nind 37 -out test_results/test_more_commands \
#               -minInd 5 \
#               -doMaf 1 -doMajorMinor 1 -doSaf 1
#
#
#
# for POP in aida naimii lorentzi moretoni
# do
#  echo $POP
#  MININD=$(if [[ "$POP"  == "aida" ]]; then echo 4; else echo 5; fi)
#  BAMLIST=$HOME_D/${POP}_bamlist.txt
#  angsd -b $BAMLIST -ref $REFGENOME -anc $REFGENOME -out Results/${POP}.${RUN}_${DESCRIPTION}.ref -rf $REGIONS -P 20 \
#                -uniqueOnly 1 -remove_bads 1 -only_proper_pairs 0 -trim 0 \
#                -minMapQ 20 -minQ 20 -setMinDepth 83.66 -setMaxDepth 334.64 -SNP_pval 1e-6 -minInd $MININD -minMaf 0.01 \
#                -doCounts 1 \
#                -doMaf 1 -doMajorMinor 1 -GL 1 -doSaf 1
# done
