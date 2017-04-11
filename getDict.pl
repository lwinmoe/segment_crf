#!/usr/bin/perl
use strict;
use Encode;
if (@ARGV < 1) {
    print qq(getDict.pl input_file\n);
    exit;
}
my %dict;
foreach my $file (@ARGV) {
    print STDERR qq(Building the dictionary from $file.\n);
    open IN, "$file" or die "can't read $file\n";
    while (<IN>) {
        chomp;
        next unless $_;
        my $curr = $_;
        my @words = split / +/, $curr;
        foreach my $word (@words) {
            next unless $word;
            $dict{$word}++;
        }
    } 
}

foreach my $key (keys %dict) {
    print qq($key\n);
}
