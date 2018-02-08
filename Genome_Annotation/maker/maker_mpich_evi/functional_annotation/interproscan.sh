#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=20
#SBATCH -e interproscan.err           # File to which STDERR will be written
#SBATCH -o interproscan.out         # File to which STDOUT will be written
#SBATCH -J interproscan      # Job name
#SBATCH --mem=256000                     # Memory requested
#SBATCH --qos=long
#SBATCH --time=7-00:00:00
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=eenbody@tulane.edu

export PATH=/usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin:$PATH
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre
module load python/2.7.11

MAKER_HOME=/home/eenbody/maker_mpich/WSFW_assembly_maker2.maker.output
WORK_D=/home/eenbody/maker_mpich/WSFW_assembly_maker2.maker.output/functional_annotation/interproscan

cd $WORK_D

interproscan.sh -i $MAKER_HOME/WSFW_assembly_maker2.all.maker.proteins.fasta -t p -dp -pa -appl PfamA,ProDom,SuperFamily,PIRSF --goterms --iprlookup
