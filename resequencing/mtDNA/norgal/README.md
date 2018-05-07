#### Running norgal

This was a good idea (suggested by EL), because it can just take fastq reads and pull out the mtDNA genome without any other input. However, for me it only pumped out a short (350bp) fragment that blasts to a tree. This isn't really enough documentation to troubleshoot. If you do, check out how much is in the assembly folder - maybe that contains reads that mapped to the reference genome included?

This was tricky to install because there is no documentation. I ran with python 3 in an anaconda environment that had matplotlib installed. One software binary (arwen) did not work (GLIBC error associated with wrong LIBC version), so I downloaded and compiled the arwen binary and moved it to the folder where the software is called from. This worked fine. 
