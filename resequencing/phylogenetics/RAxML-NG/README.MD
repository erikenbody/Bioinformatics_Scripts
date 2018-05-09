### RAxML-NG

Before I installed RAxML...I should have been trying their newer version RAxML-NG

This was a pain to install and I found solution here:
https://groups.google.com/forum/#!searchin/raxml/$20GNU$20compiler$20too$20old!%7Csort:date/raxml/rP803B3pwP0/6dexfM_XGAAJ

```
mkdir build && cd build
CXX=gcc cmake ..
module load cmake/3.0.2
CXX=gcc cmake ..
make

```

should try running with VCF option (see help)

include ascernment bias
https://github.com/amkozlov/raxml-ng/issues/15

Try running with fasta made from pgd spider

why failing on memory? maybe help here? https://groups.google.com/forum/#!searchin/raxml/memory$20RAxML-ng%7Csort:date/raxml/sh038fSKfTQ/xCbiLddaBQAJ

try from VCFtools vcf?
