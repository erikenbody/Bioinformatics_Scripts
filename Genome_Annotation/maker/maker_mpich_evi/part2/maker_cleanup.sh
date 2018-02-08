#!/bin/bash

GENE=WSFW
SP=WSFW
MPRE=WSFW_assembly_maker2

#/home/eenbody/BI_software/maker-mpich/maker/bin/fasta_merge -d *index.log
#/home/eenbody/BI_software/maker-mpich/maker/bin/gff3_merge -d *index.log

/home/eenbody/BI_software/maker-mpich/maker/bin/maker_map_ids --prefix ${GENE} --justify 6 ${MPRE}.all.gff > ${SP}.id.map
cp ${MPRE}.all.gff ${SP}.genome.orig.gff
/home/eenbody/BI_software/maker-mpich/maker/bin/map_fasta_ids ${SP}.id.map ${MPRE}.all.maker.proteins.fasta
/home/eenbody/BI_software/maker-mpich/maker/bin/map_fasta_ids ${SP}.id.map ${MPRE}.all.maker.transcripts.fasta
/home/eenbody/BI_software/maker-mpich/maker/bin/map_gff_ids ${SP}.id.map ${MPRE}.all.gff

#/home/eenbody/BI_software/maker-mpich/maker/bin/map_data_ids ${SP}.id.map ${SP}.renamed.iprscan
