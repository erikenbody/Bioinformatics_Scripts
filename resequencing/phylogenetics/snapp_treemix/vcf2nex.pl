#!/bin/perl

# Attempts to convert vcf file to nexus that can be read by BEAUti with SNAPP template
# YMMV
# Usage: perl vcf2nex.pl < file.cvs > file.nex


# process header
while ($header !~ /CHROM/) {
	$header = <>;
}

$offset = 9;

@s = split('\s+', $header);
for ($i = $offset; $i <= $#s; $i++) {
	$taxon[$i-$offset] = $s[$i];
}

#foreach $s (@taxon) {
#	print STDERR ">$s<\n";
#}
$n = $#taxon + 1;

# process body
$k = 0;
while ($s = <>) {
	@s = split("[\\s]+", $s);
$start = $#s+1-$n;
$offset2 = $start;
$div = 1;
#print STDERR "$start $s\n";

	for ($i = $start; $i <= $#s; $i += $div) {
		$s = $s[$i];
		if ($s =~ /^([^:\/]*)\/([^:\/]*)/) {
#print STDERR ">$1 $2<";
			$data[$i/$div-$offset2][0] = $data[$i/$div-$offset2][0].$1;
			$data[$i/$div-$offset2][1] = $data[$i/$div-$offset2][1].$2;
		} else {
			$data[$i/$div-$offset2][0] = $data[$i/$div-$offset2][0].'?';
			$data[$i/$div-$offset2][1] = $data[$i/$div-$offset2][1].'?';
		}	
	}
#print STDERR "\n";
	$k++;
}

print "#NEXUS\n";
print "Begin data;\n";
print "        Dimensions ntax=".(2*$#taxon+2)." nchar=$k;\n";
print "        Format datatype=binary symbols=\"01\" gap=-;\n";
print "        Matrix\n";
for ($i = 0; $i <= $#taxon; $i++) {
    # correct for sites with more than 2 characters
    $data[$i][0] =~ s/[23]/1/g;
    $data[$i][1] =~ s/[23]/1/g;

	print "$taxon[$i]_1  $data[$i][0]\n";
	print "$taxon[$i]_2  $data[$i][1]\n";
}
print ";\nEnd;\n"
