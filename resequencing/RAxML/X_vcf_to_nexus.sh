#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e 2nexus.err            # File to which STDERR will be written
#SBATCH -o 2nexus.out           # File to which STDOUT will be written
#SBATCH -J 2nexus           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --time=6-23:59:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

java -Xmx60g -Xms512m -jar ~/BI_software/PGDSpider_2.1.1.3/PGDSpider2-cli.jar -inputfile RAxML_input.vcf -inputformat VCF -outputfile RAxML_input.nexus -outputformat NEXUS -spid spid_RAxML_input_nexus.spid
