#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Mon Jan  8 14:33:11 2018

@author: erikenbody
"""

import gffutils
db = gffutils.create_db('xaa.gff', ':memory:',merge_strategy="create_unique")


with open('tmp.gff', 'w') as fout:
    for d in db.directives:
        fout.write('##{0}\n'.format(d))

    for feature in db.all_features():
        if feature.featuretype == 'exon':

            # If level=1 not specified, it will also return gene "grandparent"
            # which you don't care about
            parent = list(db.parents(feature, level=1))

            # sanity checking
            assert len(parent) == 1
            parent = parent[0]

            feature.attributes['Name'] = parent.attributes['Name']
        fout.write(str(feature) + '\n')