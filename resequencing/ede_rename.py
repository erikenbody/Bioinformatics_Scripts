# -*- coding: utf-8 -*-
"""
Spyder Editor

"""

import os


# build a dictionary of old filenames mapping to new filenames
file_dict = {}
fp = open("DNA_Barcodes_Problem_Solving.csv")
fp.readline() # skip header line
for line in fp:
    line_lst = line.strip().split(',')
    old = line_lst[0].strip()
    new = line_lst[1].strip()
    file_dict[old]=new
 
    
for filename in os.listdir("."):  # lists files in current directory
    if filename.endswith(".bam"):
        filename_lst = filename.split('.')
        name = filename_lst[0]
        middle = filename_lst[1]
        extension = filename_lst[2]
        for old in file_dict:
            if old in name:
                new_name = file_dict[old]
                if 'realign' in name:
                    new_filename = new_name + "_realigned." + middle + "." + extension
                    os.rename(filename,new_filename)
                    print filename + " changed to " + new_filename
                else:
                    print("Oops -- some other name format")
                break
