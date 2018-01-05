#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=6-23:00:00
#SBATCH -e vcffilt2.err            # File to which STDERR will be written
#SBATCH -o vcffilt2.out           # File to which STDOUT will be written
#SBATCH -J vcffilt           # Job name
#SBATCH --mem=64000
#SBATCH --cpus-per-task=20
#SBATCH --qos=long
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

module load anaconda/2.5.0
module load zlib/1.2.8

source activate ede_py

export PATH=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre

#SAMPLEDIR=/lustre/project/jk/Enbody_WD/WSFW_DDIG/reseq_WD/GATK_Haplotype_Caller/all_individuals/seperate_snps_indels
SAMPLEDIR=/lustre/project/jk/Enbody_WD/WSFW_DDIG/reseq_WD/GATK_Haplotype_Caller/all_individuals/
REF=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
#WORK_D=/lustre/project/jk/Enbody_WD/WSFW_DDIG/reseq_WD/GATK_Haplotype_Caller/all_individuals/seperate_snps_indels
WORK_D=/lustre/project/jk/Enbody_WD/WSFW_DDIG/reseq_WD/GATK_Haplotype_Caller/all_individuals/

cd $WORK_D

if [ -d "filtered_vcfs" ]; then echo "info dir exists" ; else mkdir filtered_vcfs; fi

OUT=filtered_vcfs

#This is a beast of a chunk of code.Notes:
#Would not run with a -Djava.io.tmpdir=tmp
#Would not run with:
#-filterExpression "!vc.hasAttribute('DP')"
#--filterName "noCoverage"
#DESCRIPTION OF FILTERS:
#MinCov = Filters out sites that fall below mean depth/2 (5.68/2=2.84) - determined after averaging depth of all samples (see Rscript from ANGSD output)
#MaxCov = Filters out sites that fall above mean depth*2 (5.68*2=11.36) - determined after averaging depth of all samples (see Rscript from ANGSD output)
#badSeq = For SNPs: Filter RPRS<-8.0 | For Indels or sites with Indels/SNPs: RPRS<-20 and QD <20
#badStrand = For SNPs: filter out FS > 60.0 and SOR >3.0 | For Indels or sites with Indels/SNPs: FS >200, SOR >10
#badMap = For SNPs: filter out MQ < 40.0 and MQRS <-12.5
#THESE ARE THE DEFAULT VALUES. However, I checked the INFO files output from VCFINFO and they seem pretty much fine for my dataset. At least, no glaring differences.

java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/BI_software/GenomeAnalysisTK.jar \
-T VariantFiltration \
-nt 20 \
-R $REF \
--variant $SAMPLEDIR/All_WSFW.vcf.gz \
--filterExpression "vc.hasAttribute('DP') && DP < 2.8" \
--filterName "MinCov" \
--filterExpression "vc.hasAttribute('DP') && DP > 11.4" \
--filterName "MaxCov" \
--filterExpression "(vc.isSNP() && (vc.hasAttribute('ReadPosRankSum') && ReadPosRankSum < -8.0)) || ((vc.isIndel() || vc.isMixed()) && (vc.hasAttribute('ReadPosRankSum') && ReadPosRankSum < -20.0)) || (vc.hasAttribute('QD') && QD < 2.0) " \
--filterName "badSeq" \
--filterExpression "(vc.isSNP() && ((vc.hasAttribute('FS') && FS > 60.0) || (vc.hasAttribute('SOR') && SOR > 3.0))) || ((vc.isIndel() || vc.isMixed()) && ((vc.hasAttribute('FS') && FS > 200.0) || (vc.hasAttribute('SOR') && SOR > 10.0)))" \
--filterName "badStrand" \
--filterExpression "vc.isSNP() && ((vc.hasAttribute('MQ') && MQ < 40.0) || (vc.hasAttribute('MQRankSum') && MQRankSum < -12.5))" \
--filterName "badMap" \
-o $OUT/All_WSFW_fil.vcf

#check SOR

# java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/BI_software/GenomeAnalysisTK.jar \
# -T SelectVariants \
# -R $REF \
# --variant $SAMPLEDIR/$OUT/All_WSFW_fil.vcf \
# --excludeFiltered \
# -o $OUT/All_WSFW_passed_fil.vcf

#Dont use the filter for coverage. GATK forums seem to suggest this isnt a good idea?
#help from: https://gatkforums.broadinstitute.org/gatk/discussion/3328/using-selectvariants-to-select-for-multiple-expressions
#and https://www.biostars.org/p/231912/

# java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/BI_software/GenomeAnalysisTK.jar \
# -T SelectVariants \
# -R $REF \
# --variant $SAMPLEDIR/$OUT/All_WSFW_fil.vcf \
# -select 'FILTER != "badSeq"' \
# -select 'FILTER != "badStrand"' \
# -select 'FILTER != "badMap"' \
# -o $OUT/All_WSFW_passed_fil_NoCov.vcf

#this will filter non biallelic sites
#vcftools --vcf $OUT/All_WSFW_passed_fil_NoCov.vcf --min-alleles 2 --max-alleles 2 --maf 0.1 --max-missing 0.2 --out $OUT/All_WSFW_passed_fil_NoCov_BA.vcf
#this will filter non biallelic sites and do VCF depth filtering
#vcftools --vcf $OUT/All_WSFW_passed_fil_NoCov.vcf --min-alleles 2 --max-alleles 2 --maf 0.1 --max-missing 0.2 --min-meanDP 2.0 --max-meanDP 50.0 --out $OUT/filtered_vcfs/All_WSFW_passed_fil_NoCov_BA_VCF_depthfil.vcf
#this will filter non biallelic sites on the already depth filtered one
#vcftools --vcf $OUT/All_WSFW_passed_fil.vcf --min-alleles 2 --max-alleles 2 --maf 0.1 --max-missing 0.2 --out $OUT/All_WSFW_passed_fil_BA.vcf


#-restrictAllelesTo MULTIALLELIC #could use this to filter out things not biallelic

#####BELOW ARE SEGMENTS OF CODE NOTATING IF IT WORKED OR NOT##### Keeping around for now
#ran this code originally on SNPs that were filtered out
# java -Xmx16g -XX:ParallelGCThreads=1 -Djava.io.tmpdir=tmp -jar ~/BI_software/GenomeAnalysisTK.jar \
# -T VariantFiltration \
# -R $REF \
# --variant $SAMPLEDIR/WSFW_raw_snps.vcf \
# --filterExpression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" \
# --filterName "default_filter" \
# -o WSFW_filtered_snps.vcf

# #works
# java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/BI_software/GenomeAnalysisTK.jar \
# -T VariantFiltration \
# -R $REF \
# --variant $SAMPLEDIR/WSFW_raw_snps.vcf \
# --filterExpression "(vc.isSNP() && (vc.hasAttribute('ReadPosRankSum') && ReadPosRankSum < -3.0)) || (vc.hasAttribute('QD') && QD < 2.0) "  \
# --filterName "noCoverage" \
# -o test.vcf
#
# #works
# java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/BI_software/GenomeAnalysisTK.jar \
# -T VariantFiltration \
# -R $REF \
# --variant $SAMPLEDIR/WSFW_raw_snps.vcf \
# --filterExpression "(vc.isSNP() && (vc.hasAttribute('ReadPosRankSum') && ReadPosRankSum < -3.0)) || (vc.hasAttribute('QD') && QD < 2.0) "  \
# --filterName "badSeq"  \
# --filterExpression "(vc.isSNP() && ((vc.hasAttribute('FS') && FS > 60.0) || (vc.hasAttribute('SOR') && SOR > 3.0)))"  \
# --filterName "badStrand"  \
# --filterExpression "vc.isSNP() && ((vc.hasAttribute('MQ') && MQ < 40.0) || (vc.hasAttribute('MQRankSum') && MQRankSum < -4.0))"  \
# --filterName "badMap"  \
# -o test.vcf
#
# #works
# java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/BI_software/GenomeAnalysisTK.jar \
# -T VariantFiltration \
# -R $REF \
# --variant $SAMPLEDIR/All_WSFW.vcf.gz \
# --filterExpression "(vc.isSNP() && (vc.hasAttribute('ReadPosRankSum') && ReadPosRankSum < -3.0)) || (vc.hasAttribute('QD') && QD < 2.0) "  \
# --filterName "badSeq"  \
# --filterExpression "(vc.isSNP() && ((vc.hasAttribute('FS') && FS > 60.0) || (vc.hasAttribute('SOR') && SOR > 3.0)))"  \
# --filterName "badStrand"  \
# --filterExpression "vc.isSNP() && ((vc.hasAttribute('MQ') && MQ < 40.0) || (vc.hasAttribute('MQRankSum') && MQRankSum < -4.0))"  \
# --filterName "badMap"  \
# -o test.vcf
#
# #doesnt work
# java -Xmx16g -XX:ParallelGCThreads=1 -jar ~/BI_software/GenomeAnalysisTK.jar \
# -T VariantFiltration \
# -R $REF \
# --variant $SAMPLEDIR/All_WSFW.vcf.gz \
# --filterExpression "!vc.hasAttribute('DP')" \
# --filterName "noCoverage" \
# --filterExpression "vc.hasAttribute('DP') && DP < 2.8" \
# --filterName "MinCov" \
# --filterExpression "vc.hasAttribute('DP') && DP > 11.4" \
# --filterName "MaxCov" \
# --filterExpression "(vc.isSNP() && (vc.hasAttribute('ReadPosRankSum') && ReadPosRankSum < -8.0)) || ((vc.isIndel() || vc.isMixed()) && (vc.hasAttribute('ReadPosRankSum') && ReadPosRankSum < -20.0)) || (vc.hasAttribute('QD') && QD < 2.0) " \
# --filterName "badSeq" \
# --filterExpression "(vc.isSNP() && ((vc.hasAttribute('FS') && FS > 60.0) || (vc.hasAttribute('SOR') && SOR > 3.0))) || ((vc.isIndel() || vc.isMixed()) && ((vc.hasAttribute('FS') && FS > 200.0) || (vc.hasAttribute('SOR') && SOR > 10.0)))" \
# --filterName "badStrand" \
# --filterExpression "vc.isSNP() && ((vc.hasAttribute('MQ') && MQ < 40.0) || (vc.hasAttribute('MQRankSum') && MQRankSum < -12.5))" \
# --filterName "badMap" \
# -o test.vcf

#testing with -nt, no success
# java -XX:ParallelGCThreads=1 -jar ~/BI_software/GenomeAnalysisTK.jar \
# -T VariantFiltration \
# -nt 20 \
# -R $REF \
# --variant WSFW_raw_snps.vcf \
# --filterExpression "vc.hasAttribute('DP') && DP < 2.8" \
# --filterName "MinCov" \
# --filterExpression "vc.hasAttribute('DP') && DP > 11.4" \
# --filterName "MaxCov" \
# --filterExpression "(vc.isSNP() && (vc.hasAttribute('ReadPosRankSum') && ReadPosRankSum < -8.0)) || ((vc.isIndel() || vc.isMixed()) && (vc.hasAttribute('ReadPosRankSum') && ReadPosRankSum < -20.0)) || (vc.hasAttribute('QD') && QD < 2.0) " \
# --filterName "badSeq" \
# --filterExpression "(vc.isSNP() && ((vc.hasAttribute('FS') && FS > 60.0) || (vc.hasAttribute('SOR') && SOR > 3.0))) || ((vc.isIndel() || vc.isMixed()) && ((vc.hasAttribute('FS') && FS > 200.0) || (vc.hasAttribute('SOR') && SOR > 10.0)))" \
# --filterName "badStrand" \
# --filterExpression "vc.isSNP() && ((vc.hasAttribute('MQ') && MQ < 40.0) || (vc.hasAttribute('MQRankSum') && MQRankSum < -12.5))" \
# --filterName "badMap" \
# -o TEST.vcf
