

module load bioinfo-tools blast/2.7.1+




#did this on uppmax
makeblastdb -in sn180416_satscaf.fasta -out sn180416_satscaf -dbtype nucl -title sn180416_satscaf

blastn -db sn180416_satscaf -query mc1r.fasta -out mc1r_satcsaf.out


makeblastdb -in sn2_indscaf_reformed.fa -out sn2_indscaf_reformed -dbtype nucl -title sn2_indscaf_reformed

blastn -db sn2_indscaf_reformed -query mc1r.fasta -out sn2_indscaf_reformed.out
