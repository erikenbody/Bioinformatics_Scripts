#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=23:00:00
#SBATCH -e joint_genotype3.err            # File to which STDERR will be written
#SBATCH -o joint_genotype3.out        # File to which STDOUT will be written
#SBATCH -J JointGenotype           # Job name
#SBATCH --mem=128000
#SBATCH --cpus-per-task=20
#SBATCH --qos=normal
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

export PATH=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre

SAMPLEDIR=/home/eenbody/reseq_WD/GATK_Haplotype_Caller/all_individuals/01_haplotype_caller
REF=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
WORK_D=/home/eenbody/reseq_WD/GATK_Haplotype_Caller/all_individuals

cd $WORK_D

java -Xmx16g -XX:ParallelGCThreads=1 -Djava.io.tmpdir=tmp -jar ~/BI_software/GenomeAnalysisTK.jar \
-T GenotypeGVCFs \
-nt 20 \
-R $REF \
--variant $SAMPLEDIR/10_33240_naimii_CTGAAA.raw.g.vcf \
--variant $SAMPLEDIR/11_33248_aida_CTGGCC.raw.g.vcf \
--variant $SAMPLEDIR/12_33249_aida_TAATGT.raw.g.vcf \
--variant $SAMPLEDIR/1_33221_naimii_CTCACG.raw.g.vcf \
--variant $SAMPLEDIR/13_33252_aida_ATTTCG.raw.g.vcf \
--variant $SAMPLEDIR/14_33253_aida_TGTACG.raw.g.vcf \
--variant $SAMPLEDIR/15_33254_aida_CAGTGT.raw.g.vcf \
--variant $SAMPLEDIR/16_33256_aida_ATCACG.raw.g.vcf \
--variant $SAMPLEDIR/17_33257_aida_GACTCA.raw.g.vcf \
--variant $SAMPLEDIR/18_33297_lorentzi_ATGACT.raw.g.vcf \
--variant $SAMPLEDIR/19_47720_moretoni_GTAGGC.raw.g.vcf \
--variant $SAMPLEDIR/20_36126_moretoni_AGACCA.raw.g.vcf \
--variant $SAMPLEDIR/21_36148_moretoni_TCAGCC.raw.g.vcf \
--variant $SAMPLEDIR/22_36149_moretoni_ACGGTC.raw.g.vcf \
--variant $SAMPLEDIR/2_33223_naimii_CAGCTT.raw.g.vcf \
--variant $SAMPLEDIR/23_36182_moretoni_TTCGAA.raw.g.vcf \
--variant $SAMPLEDIR/24_36188_moretoni_AGGTAC.raw.g.vcf \
--variant $SAMPLEDIR/25_47617_lorentzi_TATCAG.raw.g.vcf \
--variant $SAMPLEDIR/26_47623_lorentzi_CCATGT.raw.g.vcf \
--variant $SAMPLEDIR/27_47631_lorentzi_ATGCGC.raw.g.vcf \
--variant $SAMPLEDIR/28_47653_lorentzi_TTAGCT.raw.g.vcf \
--variant $SAMPLEDIR/29_47657_lorentzi_GCCATA.raw.g.vcf \
--variant $SAMPLEDIR/30_47672_lorentzi_AGTGCC.raw.g.vcf \
--variant $SAMPLEDIR/31_47683_lorentzi_CTTGAC.raw.g.vcf \
--variant $SAMPLEDIR/32_47707_moretoni_CATTAG.raw.g.vcf \
--variant $SAMPLEDIR/3_33225_naimii_CGCTAC.raw.g.vcf \
--variant $SAMPLEDIR/33_47717_moretoni_TCGGAT.raw.g.vcf \
--variant $SAMPLEDIR/34_47745_moretoni_CGATGT.raw.g.vcf \
--variant $SAMPLEDIR/35_47815_moretoni_TGACCA.raw.g.vcf \
--variant $SAMPLEDIR/36_97513_lorentzi_GCCAAT.raw.g.vcf \
--variant $SAMPLEDIR/37_97528_lorentzi_CTTGTA.raw.g.vcf \
--variant $SAMPLEDIR/4_33228_naimii_ATTGTA.raw.g.vcf \
--variant $SAMPLEDIR/5_33230_naimii_TCCTAG.raw.g.vcf \
--variant $SAMPLEDIR/6_33232_naimii_AGATCC.raw.g.vcf \
--variant $SAMPLEDIR/7_33233_naimii_TTGTCA.raw.g.vcf \
--variant $SAMPLEDIR/8_33234_naimii_AGCTTT.raw.g.vcf \
--variant $SAMPLEDIR/9_33235_naimii_ATCCGC.raw.g.vcf \
--heterozygosity 0.005 \
-o All_WSFW.vcf.gz \
--includeNonVariantSites \
