#### Running NOVOplasty

I decided to try this after NORGAL failed and because it is supposed to run super fast.

Tried an atp gene from NCBI and also CO1 (CO1 at the link below):
https://www.ncbi.nlm.nih.gov/nuccore/JF919506.1

Running with default parameters using sample 10 I received a 300bp long fragment that blasts to a tree and a very long "smallest contig". I tweeked some params and same. So I looked at this advice:
https://github.com/ndierckx/NOVOPlasty/issues/22

And when I followed these directions, I got many contigs, some of which map to the RBFW mtDNA genome, but most did not.

I tried with the genome as a reference and same. 

How to get length of fasta sequence:
 grep -v ">" Contigs_1_10_33240_naimii_CTGAAA.fasta | wc | awk '{print $3-$1}'
