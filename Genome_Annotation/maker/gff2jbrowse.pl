#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($RealBin);
use lib "$RealBin/../";
use JBlibs;

use Getopt::Long;
use File::Basename;
use File::Spec::Functions;
use File::Temp;
use Pod::Usage;
use URI::Escape;

=head1 USAGE
     maker2jbrowse [OPTION] <gff3file1> <gff3file2> ...
     maker2jbrowse [OPTION] -d <datastore_index>
     This script takes MAKER produced GFF3 files and dumps them into a
     JBrowse for you using pre-configured JSON tracks.
=head1 OPTIONS
=over 4
=item --out <dir>, -o <dir>
Output dir for formatted data.  Defaults to './data'.
=item --prefix <prefix>, -p <prefix>
Prefix for the track label.  Defaults to ''.
=item --ds_index <file.log>, -d <file.log>
Take filenames from a MAKER master datastore index file
(e.g. my_genome_master_datastore_index.log).
=item --help, -h, -?
Displays full help information.
=cut

my $dstore;
my $help;
my $outdir = 'data';
my $prefix = '';
GetOptions(
    "ds_index|d=s" => \$dstore,
    "prefix|p=s" => \$prefix,
    "help|?" => \$help,
    "out|o=s" => \$outdir
   )
    or pod2usage( verbose => 2 );
pod2usage( verbose => 2 ) if $help;

my @files;

if( $dstore ){

    my $base = dirname( $dstore );
    open my $dstore_fh, '<', $dstore or die "$! reading $dstore";

    #uniq the entries
    my %seen;
    while( my $e = <$dstore_fh> ) {
        next if $seen{$e}++;
        chomp $e;
        my ( $id, $dir, $status ) = split("\t", $e);
        next unless $status =~ /FINISHED/;
        $dir =~ s/\/$//;
        push( @files, $dir );
    }

    for my $file ( @files ){
        my ($name) = $file =~ /([^\/]+)$/;
        my $gff = $base ? catfile( $base, $file, "$name.gff" ) : catfile( $file, "$name.gff" );

	unless( -f $gff ){
	    $name = uri_escape( $name, '.' );
	    $gff = $base ? catfile( $base, $file, "$name.gff" ) : catfile( $file, "$name.gff" );
	}

	$file = $gff;
    }
}
else {
    @files = @ARGV;
}

@files or pod2usage( verbose => 1 );

{ # check for missing files
    my $error;
    for my $file (@files){
        unless( -f $file ) {
            $error .= "ERROR: GFF3 file '$file' does not exist\n";
        }
    }
    die $error if $error;
}

my %commands = (

    # consensus gene models
    maker           => [ '--key' => $prefix . 'MAKER',
                         '--className' => 'transcript',
                         '--subfeatureClasses' => '{"exon": "exon", "CDS": "CDS", "five_prime_UTR": "five_prime_UTR", "three_prime_UTR": "three_prime_UTR"}',
                         '--type'  => 'mRNA',
                       ],

    Gnomon          => [ '--key' => $prefix . "Gnomon",
                         '--className' => 'transcript',
                         '--subfeatureClasses' => '{"exon": "exon", "CDS": "CDS", "five_prime_UTR": "five_prime_UTR", "three_prime_UTR": "three_prime_UTR"}',
                         '--type'  => 'mRNA',
                       ],

    # ab initio gene predictions
    snap_masked     => [ '--key' => $prefix . "SNAP",
                         '--className' => 'transcript',
                         '--subfeatureClasses' => '{"match_part": "CDS"}',
                         '--type' => 'match:snap_masked',
                       ],

    augustus        => [ '--key' => $prefix . "Augustus",
                         '--className' => 'transcript',
                         '--subfeatureClasses' => '{"match_part": "CDS"}',
                         '--type' => 'match:augustus',
                       ],

    augustus_masked => [ '--key' => $prefix . "Augustus",
                         '--className' => 'transcript',
                         '--subfeatureClasses' => '{"match_part": "CDS"}',
                         '--type' => 'match:augustus_masked',
                       ],

    genemark        => [ '--key' => $prefix . "GeneMark",
                         '--className' => 'transcript',
                         '--subfeatureClasses' => '{"match_part": "CDS"}',
                         '--type' => 'match:genemark',
                       ],

    genemark_masked => [ '--key' => "$prefix . GeneMark",
                         '--className' => 'transcript',
                         '--subfeatureClasses' => '{"match_part": "CDS"}',
                         '--type' => 'match:genemark_masked',
                       ],

    fgenesh         => [ '--key' => $prefix . "FGENESH",
                         '--className' => 'transcript',
                         '--subfeatureClasses' => '{"match_part": "CDS"}',
                         '--type' => 'match:fgenesh',
                       ],

    fgenesh_masked  => [ '--key' => $prefix . "FGENESH",
                         '--className' => 'transcript',
                         '--subfeatureClasses' => '{"match_part": "CDS"}',
                         '--type' => 'match:fgenesh_masked',
                       ],

    pred_gff        => [ '--key' => $prefix . "Predictions",
                         '--className' => 'transcript',
                         '--subfeatureClasses' => '{"match_part": "match_part"}',
                         '--type' => 'match:pred_gff',
                       ],

    model_gff       => [ '--key' => $prefix . "Models",
                         '--className' => 'transcript',
                         '--subfeatureClasses' => '{"match_part": "match_part"}',
                         '--type' => 'match:model_gff',
                       ],

    # evidence alignments
    blastn          => [ '--key' =>  $prefix . "BLASTN",
                         '--className' => 'generic_parent',
                         '--subfeatureClasses' => '{"match_part": "match_part"}',
                         '--type' => 'expressed_sequence_match:blastn',
                       ],

    blastx          => [ '--key' =>  $prefix . "BLASTX",
                         '--className' => 'generic_parent',
                         '--subfeatureClasses' => '{"match_part": "match_part"}',
                         '--type' => 'protein_match:blastx',
                       ],

    tblastx         => [ '--key' =>  $prefix . "TBLASTX",
                         '--className' => 'generic_parent',
                         '--subfeatureClasses' => '{"match_part": "match_part"}',
                         '--type' => 'translated_nucleotide_match:tblastx',
                       ],

    est2genome      => [ '--key' => $prefix . "est2genome",
                         '--className' => 'generic_parent',
                         '--subfeatureClasses' => '{"match_part": "match_part"}',
                         '--type' => 'expressed_sequence_match:est2genome',
                       ],

    protein2genome  => [ '--key' =>  $prefix . "protein2genome",
                         '--className' => 'generic_parent',
                         '--subfeatureClasses' => '{"match_part": "match_part"}',
                         '--type' => 'protein_match:protein2genome',
                       ],

    cdna2genome     => [ '--key' =>  $prefix . "cdna2genome",
                         '--className' => 'generic_parent',
                         '--subfeatureClasses' => '{"match_part": "match_part"}',
                         '--type' => 'expressed_sequence_match:cdna2genome',
                       ],

    'est_gff:cufflinks' => [ '--key' => $prefix . "RNASeq assembly",
                           '--className' => 'transcript',
                           '--subfeatureClasses' => '{"match_part": "CDS"}',
                           '--type' => 'expressed_sequence_match:est_gff:cufflinks',
                       ],

    protein_gff     => [ '--key' =>  $prefix . "Proteins",
                         '--className' => 'generic_parent',
                         '--subfeatureClasses' => '{"match_part": "protein2genome_part"}',
                         '--type' => 'protein_match:protein_gff',
                       ],

    altest_gff      => [ '--key' =>  $prefix . "altESTs",
                         '--className' => 'generic_parent',
                         '--subfeatureClasses' => '{"match_part": "cdna2genome_part"}',
                         '--type' => 'expressed_sequence_match:altest_gff',
                       ],

    # repeats
    repeatmasker   =>  [ '--key'        => $prefix . "RepeatMasker",
                         '--className'  => 'generic_parent',
                         '--subfeatureClasses' => '{"match_part": "match_part"}',
                         '--type' => 'match:repeatmasker',
                       ],

    repeatrunner  =>   [ '--key' =>  $prefix . "RepeatRunner",
                         '--className' => 'generic_parent',
                         '--subfeatureClasses' => '{"match_part": "match_part"}',
                         '--type' => 'protein_match:repeatrunner',
                       ],

    repeat_gff    =>   [ '--key' =>  $prefix . "Repeats",
                         '--className' => 'generic_parent',
                         '--subfeatureClasses' => '{"match_part": "repeat_part"}',
                         '--type' => 'protein_match:repeat_gff',
                       ],

    # derived from GFF of Acromyrmex echinatior/3.8.gff from antgenomes.org
    AUGUSTUS      =>   [
      '--key'               => $prefix . 'AUGUSTUS',
      '--className'         => 'transcript',
      '--subfeatureClasses' => '{"CDS": "CDS"}',
      '--type'              => 'mRNA:AUGUSTUS',
    ],

    Cufflinks     =>   [
      '--key'               => $prefix . 'Cufflinks',
      '--className'         => 'transcript',
      '--subfeatureClasses' => '{"CDS": "CDS"}',
      '--type'              => 'mRNA:Cufflinks',
    ],

    GeneWise      =>   [
      '--key'               => $prefix . 'GeneWise',
      '--className'         => 'transcript',
      '--subfeatureClasses' => '{"CDS": "CDS"}',
      '--type'              => 'mRNA:GeneWise',
    ],

    SNAP          =>   [
      '--key'               => $prefix . 'SNAP',
      '--className'         => 'transcript',
      '--subfeatureClasses' => '{"CDS": "CDS"}',
      '--type'              => 'mRNA:SNAP',
    ],

    GLEAN         =>   [
      '--key'               => $prefix . 'GLEAN',
      '--className'         => 'transcript',
      '--subfeatureClasses' => '{"CDS": "CDS"}',
      '--type'              => 'mRNA:GLEAN',
    ],

    blat          =>   [
      '--key'               => $prefix . 'blat',
      '--className'         => 'transcript',
      '--subfeatureClasses' => '{"CDS": "CDS"}',
      '--type'              => 'mRNA:blat',
    ],

    cegma         =>   [
      '--key'               => $prefix . 'cegma',
      '--className'         => 'transcript',
      '--subfeatureClasses' => '{"CDS": "CDS"}',
      '--type'              => 'mRNA:cegma',
    ],

    Genewise      =>   [
      '--key'               => $prefix . 'Genewise',
      '--className'         => 'transcript',
      '--subfeatureClasses' => '{"CDS": "CDS"}',
      '--type'              => 'mRNA:Genewise',
    ],
);

for my $gff3_file (@files){
    my @tracks_to_make = do {
        my %t;
        open my $gff3, '<', $gff3_file or die "$! reading $gff3_file";
        while( <$gff3> ) {
            next if /^#/;
            my ( $source, $type ) = /[^\t]*\t([^\t]*)\t([^\t]*)/ or next;
            next if $source eq '.';
            $t{$source} = 1;
            $t{gene}  = 1 if $source eq 'maker';
        }
        keys %t
    };

    my @outdir = ( '--out' => $outdir );

    system 'bin/prepare-refseqs.pl', '--key' => 'DNA', '--gff' => $gff3_file, @outdir,
        and die "prepare-refseqs.pl failed with exit status $?";

    for my $track ( @tracks_to_make ) {

	my $tracklab = join "", $prefix, $track;

	print "$tracklab\n";

	if(!$commands{$track} && $track =~ /^([^\:]+)/ && $commands{$1}){
	    @{$commands{$track}} = @{$commands{$1}}; #makes deep copy
	    $commands{$track}[-1] =~ s/^([^\:]+)\:.*$/$1:$track/;
	}

        unless( $commands{$track} ) {
            warn "Don't know how to format $track tracks, skipping.\n";
            next;
        }

        my @command = (
            'bin/flatfile-to-json.pl',
            '--trackLabel' => $tracklab,
            '--gff' => $gff3_file,
            @outdir,
            @{$commands{$track}}
           );

        #print join(" ",@command)."\n";
        system @command and die "flatfile-to-json.pl failed with exit status $?";
    }
}
