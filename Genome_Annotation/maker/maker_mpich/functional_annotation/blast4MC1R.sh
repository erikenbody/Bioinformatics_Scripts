


#did this on uppmax
makeblastdb -in WSFW_ref_final_assembly.fasta -out WSFW_ref_final_assembly -dbtype nucl -title WSFW_ref_final_assembly

blastn -db WSFW_ref_final_assembly -query mc1r.fasta -out mc1r.out -evalue .000001 -outfmt 6 -num_alignments 1 -seg yes -soft_masking true -lcase_masking -max_hsps 1 -num_threads 20
