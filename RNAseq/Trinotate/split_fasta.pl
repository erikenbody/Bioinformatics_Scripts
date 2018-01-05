#!/usr/bin/perl -w

use warnings;
use strict;

#print "\nUsage: split_fasta.pl <input_file> <output_volume_prefix> <num_sequences_per_volume>\n";

## input for script

my $infile = $ARGV[0];
my $outfile = $ARGV[1];
my $num_seq_perl_vol = $ARGV[2];

my ($header, $sequence);


open FQFILE, "< $infile" or die "Can't open $infile : $!";

my $filecount = 1;

open OUTFILE, "> $outfile.$filecount.fasta" or die "Can't open $outfile : $!";

local $/ = ">";
my $seqcount = -1;

while ($sequence = <FQFILE>) {

  $seqcount++;

  chomp $sequence;

  ($header) = $sequence =~ /^(.+)\n/;
  $sequence =~ s/^.+\n//;

  if ($seqcount <= $num_seq_perl_vol) {

    if ($seqcount >= 1 ) {
      print OUTFILE ">$header", "\n$sequence";
    }

  }
  else {

    close OUTFILE;

    $filecount++;

    $seqcount=1;

    open OUTFILE, "> $outfile.$filecount.fasta" or die "Can't open $outfile : $!";

    print OUTFILE ">$header", "\n$sequence";

  }

}

close FQFILE;
close OUTFILE;

exit;

################################################
