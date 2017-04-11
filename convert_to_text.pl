#!/usr/bin/perl
use strict;
use Encode;
if (@ARGV < 1) {
    print qq(convert_to_text.pl input_file\n);
    exit;
}

foreach my $file (@ARGV) {
    print STDERR qq(Converting $file from CRF++ format.\n);
    local $/ = "";
    open IN, "$file" or die "can't read $file\n";
    while (<IN>) {
        my $curr = $_;
        my @lines = split /\n/, $curr;
        foreach my $line (@lines) {
            next if $line =~ /#/;
            my ($syllable) = $line =~ /(.*?)\t/;
            my ($tag) = $line =~ /.*\t(.*)/;
            my $space = '';
            $space = "  " if $tag =~/B/;
            $space = "  " if $tag =~/S/;
            print qq($space$syllable); 
        }
        print qq(\n);
    } 
}
