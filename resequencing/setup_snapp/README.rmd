## Setting up for snapp


```
java -Xmx30g -Xms512m -jar ~/BI_software/PGDSpider_2.1.1.3/PGDSpider2-cli.jar -inputfile subset_tree_input.vcf -inputformat VCF -outputfile subset_tree.phy -outputformat PHYLIP -spid pgd_top4_gr4cov.spid
```
Latter go and re run the angsd vcf to include 34 and 9, because they're high coverage and the other high coverage individuals aren't related to each other.

trying with just Nexus

```
java -Xmx30g -Xms512m -jar ~/BI_software/PGDSpider_2.1.1.3/PGDSpider2-cli.jar -inputfile subset_tree_input.vcf -inputformat VCF -outputfile subset_tree.phy -outputformat NEXUS -spid to_nexus.spid
```
