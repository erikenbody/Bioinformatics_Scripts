#!/usr/bin/python

#Modified from https://github.com/CoBiG2/RAD_Tools/blob/master/vcf2snapp.py by Allison Shultz

# vcf2snapp converts VCF into nexus format with binary encoding for SNPs

import argparse
from collections import OrderedDict

parser = argparse.ArgumentParser(description="Convert VCF to nexus for SNAPP")

parser.add_argument("-in", dest="infile", help="The vcftools input file",
                    required=True)

arg = parser.parse_args()


def vcf2snapp(vcf_file, output_file):
    """
    Converts VCF file into Nexus binary format to SNAPP. Ignores non-biallelic
    SNPs.
    """

    fh = open(vcf_file)

    chroms = []

    for line in fh:

        # Skip header
        if line.startswith("##"):
            pass
        elif line.startswith("#CHROM"):
            # Get taxa information
            taxa_list = line.strip().split()
            nexus_data = OrderedDict((x, []) for x in taxa_list[9:])
        elif line.strip() != "":
            fields = line.strip().split()

            ref_snp = fields[3]
            alt_snp = fields[4]

            # If SNP is not bialleic, ignore
            if len(alt_snp) > 1:
                continue

            # Record data for each Taxon
            for tx in nexus_data:
                # Get genotype
                gen = fields[taxa_list.index(tx)]
                gen = gen.split(":")[0]

                if gen == "./.":
                    nexus_data[tx].append("-")
                elif gen == "0/0":
                    nexus_data[tx].append("0")
                elif gen == "1/1":
                    nexus_data[tx].append("2")
                elif gen == "1/0" or gen == "0/1":
                    nexus_data[tx].append("1")


    # Write nexus files
    nexus_fh = open(output_file, "w")

    # Write header
    ntaxa = len(nexus_data)
    nloci = len(nexus_data[tx])
    nexus_fh.write("#NEXUS\nBEGIN Data;\n\tDIMENSIONS NTAX={} NCHAR={};\n\t"
        r'FORMAT DATATYPE=standard SYMBOLS="012" INTERLEAVE=no missing=-;'
        "\n"
        "Matrix\n".format(ntaxa, nloci))

    # Write Data
    for tx in nexus_data:
        nexus_fh.write("{}\t{}\n".format(tx, "".join(nexus_data[tx])))

    # Write file ending
    nexus_fh.write(";\nEND;\n")
    nexus_fh.close()


def main():
    # Args
    infile = arg.infile
    output_file = infile.split(".")[0] + ".nex"

    vcf2snapp(infile, output_file)


main()