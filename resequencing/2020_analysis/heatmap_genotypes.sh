#uppmax
cd /crex/proj/uppstore2019097/nobackup/enbody_wagtails_working/WSFW

ml bcftools
bcftools view -r scaffold_142:1200000-1500000 -O z -o WSFW_scaffold_142.1.2.1.5.vcf.gz WSFW_scaffold_142.recode.vcf.gz
~/fc/finch_code/lowpass/14_external_imputation_glimpse/vcf2genos.sh WSFW_scaffold_142.1.2.1.5.vcf.gz WSFW_scaffold_142.1.2.1.5

VCF=RBFW_sc142_inv.vcf.gz
SAMPLE=RBFW_sc142_inv
bcftools query -l $VCF | tr "\n" "\t" > ${SAMPLE}_header.txt
echo "" >> ${SAMPLE}_header.txt #add new line at end of header
bcftools query -f '[%GT\t]\n' $VCF > ${SAMPLE}_raw.genos
cat ${SAMPLE}_header.txt ${SAMPLE}_raw.genos > ${SAMPLE}.genos
bcftools query -f '%CHROM\t %POS\t %REF\t %ALT\n' $VCF > ${SAMPLE}_raw.pos
echo -e "CHROM\tPOS\tREF\tALT" | cat - ${SAMPLE}_raw.pos > ${SAMPLE}.pos
paste -d "\t" ${SAMPLE}.pos ${SAMPLE}.genos > ${SAMPLE}.pos.genos
rm ${SAMPLE}.pos
rm ${SAMPLE}_raw.pos
rm ${SAMPLE}.genos
rm ${SAMPLE}_raw.genos
rm ${SAMPLE}_header.txt

###setup selec scan
bcftools view -v snps -m2 -M2 -f .,PASS -e 'AF==1 | AF==0 | ALT="*" | TYPE~"indel" | ref="N"' -r scaffold_142 -O z -o WSFW_scaffold_142_mlg.vcf.gz WSFW_scaffold_142.recode.vcf.gz
#must remove all annotations or the conversion script does not work
#FILE NAME MUST BE _mlg
bcftools annotate -x INFO,^FORMAT/GT -O z -o WSFW_scaffold_142_clean_mlg.vcf.gz WSFW_scaffold_142_mlg.vcf.gz
#ssx12 written in python2
pyenv global 2.7.6

python ./SS-X12_program/vcf2ssx.py WSFW_scaffold_142_clean_mlg.vcf.gz yes yes

python ./SS-X12_program/SS-X12.py WSFW_scaffold_142_clean_mlg.txt.gz LOR,MOR my_population_IDs3.txt lorentzi_moretoni_3 20000 2000 none none

#too few snps per window
python ./SS-X12_program/SS-X12.py WSFW_scaffold_142_mlg.txt.gz LOR,MOR my_population_IDs3.txt lorentzi_moretoni 20000 2000 none none
python ./SS-X12_program/SS-X12.py WSFW_scaffold_142_mlg.txt.gz LOR,MOR,AID my_population_IDs3.txt lorentzi_moretoni_aida 20000 2000 1 2,3

#try bigger window
python ./SS-X12_program/SS-X12.py WSFW_scaffold_142_mlg.txt.gz LOR,MOR my_population_IDs3.txt lorentzi_moretoni_2 50000 20000 none none
python ./SS-X12_program/SS-X12.py WSFW_scaffold_142_mlg.txt.gz LOR,MOR,AID my_population_IDs3.txt lorentzi_moretoni_aida_2 50000 20000 1 2,3

#why does input include 2 and 3 if unphased? also output is only 1 value
