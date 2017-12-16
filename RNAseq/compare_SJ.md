
```
STAR --runThreadN 20 --genomeDir /lustre/project/jk/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/STAR \
--readFilesIn 9-33254-aida-SP_S9_clp.fq.1.gz 9-33254-aida-SP_S9_clp.fq.2.gz \
--readFilesCommand zcat \
--outSAMtype BAM SortedByCoordinate \
--twopassMode Basic \
--genomeLoad NoSharedMemory \
--outFileNamePrefix 9-33254-aida-SP_S9_ \

Started job on |	Oct 07 09:24:01
														Started mapping on |	Oct 07 09:26:05
																	 Finished on |	Oct 07 09:28:04
			Mapping speed, Million of reads per hour |	347.44

												 Number of input reads |	11484770
										 Average input read length |	145
																	 UNIQUE READS:
									Uniquely mapped reads number |	9740413
											 Uniquely mapped reads % |	84.81%
												 Average mapped length |	143.74
											Number of splices: Total |	3613423
					 Number of splices: Annotated (sjdb) |	3547527
											Number of splices: GT/AG |	3498804
											Number of splices: GC/AG |	32489
											Number of splices: AT/AC |	2521
							Number of splices: Non-canonical |	79609
										 Mismatch rate per base, % |	0.43%
												Deletion rate per base |	0.02%
											 Deletion average length |	1.94
											 Insertion rate per base |	0.03%
											Insertion average length |	2.60
														MULTI-MAPPING READS:
			 Number of reads mapped to multiple loci |	356650
						% of reads mapped to multiple loci |	3.11%
			 Number of reads mapped to too many loci |	7020
						% of reads mapped to too many loci |	0.06%
																 UNMAPPED READS:
			% of reads unmapped: too many mismatches |	0.00%
								% of reads unmapped: too short |	12.02%
										% of reads unmapped: other |	0.01%
																 CHIMERIC READS:
											Number of chimeric reads |	0
													 % of chimeric reads |	0.00%
```


```
STAR --runThreadN 20 --genomeDir /lustre/project/jk/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/STAR_sj \
--readFilesIn 9-33254-aida-SP_S9_clp.fq.1.gz 9-33254-aida-SP_S9_clp.fq.2.gz \
--readFilesCommand zcat \
--outSAMtype BAM SortedByCoordinate \
--twopassMode Basic \
--genomeLoad NoSharedMemory \
--outFileNamePrefix 9-33254-aida-SP_S9_ \


#outfile
Started job on |	Oct 07 13:30:21
														Started mapping on |	Oct 07 13:33:54
																	 Finished on |	Oct 07 13:37:04
			Mapping speed, Million of reads per hour |	217.61

												 Number of input reads |	11484770
										 Average input read length |	145
																	 UNIQUE READS:
									Uniquely mapped reads number |	9569090
											 Uniquely mapped reads % |	83.32%
												 Average mapped length |	143.83
											Number of splices: Total |	3644947
					 Number of splices: Annotated (sjdb) |	3582297
											Number of splices: GT/AG |	3541846
											Number of splices: GC/AG |	34252
											Number of splices: AT/AC |	3065
							Number of splices: Non-canonical |	65784
										 Mismatch rate per base, % |	0.42%
												Deletion rate per base |	0.02%
											 Deletion average length |	1.94
											 Insertion rate per base |	0.01%
											Insertion average length |	1.83
														MULTI-MAPPING READS:
			 Number of reads mapped to multiple loci |	371149
						% of reads mapped to multiple loci |	3.23%
			 Number of reads mapped to too many loci |	5097
						% of reads mapped to too many loci |	0.04%
																 UNMAPPED READS:
			% of reads unmapped: too many mismatches |	0.00%
								% of reads unmapped: too short |	12.74%
										% of reads unmapped: other |	0.67%
																 CHIMERIC READS:
											Number of chimeric reads |	0
													 % of chimeric reads |	0.00%

```

```
STAR --runThreadN 20 --genomeDir /lustre/project/jk/Enbody_WD/WSFW_DDIG/Reference_Genome_WSFW/STAR_sj \
--readFilesIn 9-33254-aida-SP_S9_clp.fq.1.gz 9-33254-aida-SP_S9_clp.fq.2.gz \
--readFilesCommand zcat \
--outSAMtype BAM SortedByCoordinate \
--genomeLoad NoSharedMemory \
--outFileNamePrefix 9-33254-aida-SP_S9_ \

#outfile
Started job on |	Oct 07 13:46:09
														Started mapping on |	Oct 07 13:46:14
																	 Finished on |	Oct 07 13:49:23
			Mapping speed, Million of reads per hour |	218.76

												 Number of input reads |	11484770
										 Average input read length |	145
																	 UNIQUE READS:
									Uniquely mapped reads number |	9571933
											 Uniquely mapped reads % |	83.34%
												 Average mapped length |	143.83
											Number of splices: Total |	3636672
					 Number of splices: Annotated (sjdb) |	3562645
											Number of splices: GT/AG |	3542178
											Number of splices: GC/AG |	27803
											Number of splices: AT/AC |	2632
							Number of splices: Non-canonical |	64059
										 Mismatch rate per base, % |	0.42%
												Deletion rate per base |	0.02%
											 Deletion average length |	1.94
											 Insertion rate per base |	0.01%
											Insertion average length |	1.83
														MULTI-MAPPING READS:
			 Number of reads mapped to multiple loci |	369440
						% of reads mapped to multiple loci |	3.22%
			 Number of reads mapped to too many loci |	5647
						% of reads mapped to too many loci |	0.05%
																 UNMAPPED READS:
			% of reads unmapped: too many mismatches |	0.00%
								% of reads unmapped: too short |	12.74%
										% of reads unmapped: other |	0.65%
																 CHIMERIC READS:
											Number of chimeric reads |	0
													 % of chimeric reads |	0.00%

```
