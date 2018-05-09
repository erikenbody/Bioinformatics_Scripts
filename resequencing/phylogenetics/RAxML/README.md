Remove mtDNA
Make VCF with highest coverage individuals (how much filtering?)
Re run PGDSpider (how much filtering?)
Run through phrynomics to get only non missing sites?
Run RAXML. How to get branch support fromt his?


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
history
```
