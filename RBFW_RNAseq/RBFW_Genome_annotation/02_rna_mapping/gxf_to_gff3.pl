#!/usr/bin/env perl

my $header = qq{
########################################################
# BILS 2015 - Sweden                                   #
########################################################
};


use strict;
use Pod::Usage;
use Getopt::Long;
use BILS::Handler::GXFhandler qw(:Ok);
use BILS::Handler::GFF3handler qw(:Ok);
use Bio::Tools::GFF;
use File::Basename;

my $start_run = time();
my $opt_gfffile;
my $opt_comonTag=undef;
my $opt_verbose=undef;
my $opt_output;
my $opt_help = 0;
my $gffVersion= undef;

# OPTION MANAGMENT
if ( !GetOptions( 'g|gff=s' => \$opt_gfffile,
                  'c|ct=s'      => \$opt_comonTag,
                  'v=i'      => \$opt_verbose,
                  'o|output=s'      => \$opt_output,
                  'gff_version=i'      => \$gffVersion,
                  'h|help!'         => \$opt_help ) )
{
    pod2usage( { -message => 'Failed to parse command line',
                 -verbose => 1,
                 -exitval => 1 } );
}

if ($opt_help) {
    pod2usage( { -verbose => 2,
                 -exitval => 2 } );
}

if (! defined($opt_gfffile) ){
    pod2usage( {
           -message => "\nAt least 1 parameter is mandatory:\nInput reference gff file (-g).\n\n".
           "Ouptut is optional. Look at the help documentation to know more.\n",
           -verbose => 0,
           -exitval => 1 } );
}

if($gffVersion and ($gffVersion != 1 and $gffVersion != 2 and $gffVersion != 3)){
  print "Gff version accepted is 1,2 or 3. $gffVersion is not a correct value.\n";
  exit;
}

######################
# Manage output file #

my $gffout;
if ($opt_output) {
  my($opt_output, $dirs, $suffix) = fileparse($opt_output, (".gff",".gff1",".gff2",".gff3",".gtf",".gtf1",".gtf2",".gtf3",".txt")); #remove extension
  open(my $fh, '>', $opt_output.".gff3") or die "Could not open file '$opt_output' $!";
  $gffout= Bio::Tools::GFF->new(-fh => $fh, -gff_version => 3 );
  }
else{
  $gffout = Bio::Tools::GFF->new(-fh => \*STDOUT, -gff_version => 3);
}

                #####################
                #     MAIN          #
                #####################

######################
### Parse GFF input #
my ($hash_omniscient, $hash_mRNAGeneLink) = BILS::Handler::GXFhandler->slurp_gff3_file_JD($opt_gfffile, $opt_comonTag, $gffVersion, $opt_verbose);
print ("GFF3 file parsed\n");

###
# Print result

print_omniscient($hash_omniscient, $gffout); #print gene modified

my $end_run = time();
my $run_time = $end_run - $start_run;
print "Job done in $run_time seconds\n";
__END__
=head1 NAME
gff3_IO.pl -
This script read and print a gff file. It will be read by GFF3HANDLER that will look for duplicate feature, duplicate ID and will print the features sorted.
The result is written to the specified output file, or to STDOUT.
=head1 SYNOPSIS
    ./gff3_IO.pl -g infile.gff [ -o outfile ]
    ./gff3_IO.pl --help
=head1 OPTIONS
=over 8
=item B<-g>, B<--gff> or B<-ref>
Input GFF3 file that will be read (and sorted)
=item B<-c> or B<--ct>
When the gff file provided is not correcly formated and features are linked to each other by a comon tag (by default locus_tag), this tag can be provided to parse the file correctly.
=item B<-v>
Verbose option to see the warning messages when parsing the gff file.
=item B<-o> or B<--output>
Output GFF file.  If no output file is specified, the output will be
written to STDOUT.
=item B<--gff_version>
If you don't want to use the autodection of the gff/gft version you give as input, you can force the tool to use the parser of the gff version you decide to use: 1,2 or 3.
=item B<-h> or B<--help>
Display this helpful text.
=back
=cut
