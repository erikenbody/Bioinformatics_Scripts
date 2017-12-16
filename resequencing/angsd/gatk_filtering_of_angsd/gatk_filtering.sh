export PATH=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre

REFGENOME=/home/eenbody/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/WSFW_ref_final_assembly.fasta
RUN=autosome_scaffolds
REGIONS=$HOME_D/${RUN}.txt

java -Xmx60g -XX:ParallelGCThreads=1 -jar ~/BI_software/GenomeAnalysisTK.jar \
    -T SelectVariants \
    -R $REFGENOME \
    -V angsdput.vcf \
    -selectType SNP \
    -o raw_snps.vcf
