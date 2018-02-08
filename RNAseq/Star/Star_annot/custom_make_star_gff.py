#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan  8 18:17:37 2018

@author: enbody
"""
from __future__ import print_function
fp = open("wsfw_maker_renamed_nosemi_blast_ipr.gff")
outfile = open("STAR_wsfw_maker_renamed_nosemi_blast_ipr.gff","w")

count = 0
for line in fp:
    line_lst = line.split()
    if len(line_lst)> 2 and line_lst[2] == 'exon':
        last = line_lst[8]
        last_lst = last.split(";")
        right = last_lst[-1].split("=")[1]
        name = right.split("-")[0]
        #print(name)
        new_line = line.strip() + ";Name=" + name
        print(new_line,file=outfile)
    else:
        print(line.strip(),file=outfile)


    #if count > 100:
     #   break
    #count += 1

fp.close()
outfile.close()
