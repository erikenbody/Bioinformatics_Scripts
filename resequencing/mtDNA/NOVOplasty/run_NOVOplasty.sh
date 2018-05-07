#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -e run_NOVOplasty_%A_%a.err            # File to which STDERR will be written
#SBATCH -o run_NOVOplasty_%A_%a.out           # File to which STDOUT will be written
#SBATCH -J run_NOVOplasty           # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --time=0-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=normal
#SBATCH --mail-user=eenbody@tulane.edu # Email to send notifications to

for filename in *.fastq.gz
do
  SAMPLE=$(echo $filename | rev | cut -c 13- | rev)
  cat <<EOF > ${filename}_config.txt
  Project:
-----------------------
Project name          = $SAMPLE
Type                  = mito
Genome Range          = 12000-22000
K-mer                 = 18
Max memory            =
Extended log          = 0
Save assembled reads  = no
Seed Input            = wsfw_mtdna_seed_gb_JF915818.1.fasta
Reference sequence    =
Variance detection    = no
Heteroplasmy          =
Chloroplast sequence  =

Dataset 1:
-----------------------
Read Length           = 125
Insert size           = 300
Platform              = illumina
Single/Paired         = PE
Combined reads        =
Forward reads         = ${SAMPLE}.R1.fastq.gz
Reverse reads         = ${SAMPLE}.R2.fastq.gz

Optional:
-----------------------
Insert size auto      = yes
Insert Range          = 1.6
Insert Range strict   = 1.2


Project:
-----------------------
Project name         = Choose a name for your project, it will be used for the output files.
Type                 = (chloro/mito/mito_plant) "chloro" for chloroplast assembly, "mito" for mitochondrial assembly and
                       "mito_plant" for mitochondrial assembly in plants.
Genome Range         = (minimum genome size-maximum genome size) The expected genome size range of the genome.
                       Default value for mito: 12000-20000 / Default value for chloro: 120000-200000
                       If the expected size is know, you can lower the range, this can be useful when there is a repetitive
                       region, what could lead to a premature circularization of the genome.
K-mer                = (integer) This is the length of the overlap between matching reads (Default: 39).
                       If reads are shorter then 90 bp or you have low coverage data, this value should be decreased down to 23.
                       For reads longer then 101 bp, this value can be increased, but this is not necessary.
Max memory           = You can choose a max memory usage, suitable to automatically subsample the data or when you have limited
                       memory capacity. If you have sufficient memory, leave it blank, else write your available memory in GB
                       (if you have for example a 8 GB RAM laptop, put down 7 or 7.5 (don't add the unit in the config file))
Extended log         = Prints out a very extensive log, could be useful to send me when there is a problem  (0/1).
Save assembled reads = All the reads used for the assembly will be stored in seperate files (yes/no)
Seed Input           = The path to the file that contains the seed sequence.
Reference (optional) = If a reference is available, you can give here the path to the fasta file.
                       The assembly will still be de novo, but references of the same genus can be used as a guide to resolve
                       duplicated regions in the plant mitochondria or the inverted repeat in the chloroplast.
                       References from different genus haven't beeen tested yet.
Variance detection   = If you select yes, you should also have a reference sequence (previous line). It will create a vcf file
                       with all the variances compared to the give reference (yes/no)
Heteroplasmy         = If yo uwant to detect heteroplasmy,first assemble the genome without this option. Then give the resulting
                       sequence as a reference and as a seed input. And give the minimum minor allele frequency for this option
                       (0.01 will detect heteroplasmy of >1%)
Chloroplast sequence = The path to the file that contains the chloroplast sequence (Only for mito_plant mode).
                       You have to assemble the chloroplast before you assemble the mitochondria of plants!

Dataset 1:
-----------------------
Read Length          = The read length of your reads.
Insert size          = Total insert size of your paired end reads, it doesn't have to be accurate but should be close enough.
Platform             = illumina is for now the only option
Single/Paired        = For the moment only paired end reads are supported.
Combined reads       = The path to the file that contains the combined reads (forward and reverse in 1 file)
Forward reads        = The path to the file that contains the forward reads (not necessary when there is a merged file)
Reverse reads        = The path to the file that contains the reverse reads (not necessary when there is a merged file)

Optional:
-----------------------
Insert size auto     = (yes/no) This will finetune your insert size automatically (Default: yes)
Insert Range         = This variation on the insert size, could lower it when the coverage is very high or raise it when the
                       coverage is too low (Default: 1.6).
Insert Range strict  = Strict variation to resolve repetitive regions (Default: 1.2).
EOF

 NOVOPlasty2.6.7.pl -c ${filename}_config.txt
done
