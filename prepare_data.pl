#!/usr/bin/perl
use strict;
use Encode;
use IO::File;
use syllabify_burmese;

my $numbers = qq(\x{1040}|\x{1041}|\x{1042}|\x{1043}|\x{1044}|\x{1044}|\x{1045}|\x{1046}|\x{1047}|\x{1048}|\x{1049});
my $puncs = qq(\x{104A}|\x{104B});

my $numOfSentences = 0;
my $totalWords = 0;
my $totalSyllables = 0;

my $trainingF = "training.txt";
my $testF = "test.txt";

open TRAIN, ">$trainingF" or die "can't write to $trainingF\n";
open TEST, ">$testF" or die "can't write to $testF\n";

my %files;
foreach my $name (@ARGV) {
    my $file = IO::File->new($name) or next; # print error message here
    my @lines = <$file>;
    foreach my $line (@lines) {
        chomp;
        #print qq($line\n);
        $line = Encode::decode_utf8($line);
        $line =~ s/(\x{104B})/$1\n/g;
        #my @sentences = split(/\x{104B}/, $line);
        my @sentences = split(/\n+/, $line);
        foreach my $sentence (@sentences) {
            chomp;
            $numOfSentences++;
            my $flag = 0;
            $flag = 1 if ($numOfSentences % 10) == 0;
            $sentence =~ s/^\|//sg;
            $sentence =~ s/\t//sg;
            my $s = Encode::encode_utf8($sentence);
            #print qq($s\n);
            my @words = split(/\|/, $sentence);
            my $numOfWords = scalar @words;
            $totalWords += $numOfWords;
            foreach my $word (@words) {
                chomp;
                my $word = syllabify($word);
                my @syllables = split(/\|/,$word); 
                my $numOfSyllables = scalar @syllables;
                $totalSyllables += $numOfSyllables;
                $word = Encode::encode_utf8($word);
                #print qq($word\n);
                #print qq($numOfSyllables\n);
                my $cnt = 0;
                foreach my $syllable (@syllables) {
                    chomp;
                    my $type = "NONE";
                    $type = "DIGIT" if $syllable =~ /$numbers/;
                    $type = "PUNC" if $syllable =~ /$puncs/;
                    $type = "ENG" if $syllable =~ /^[a-zA-Z\(\)\[\]\%\-]+$/;
                    $syllable = Encode::encode_utf8($syllable);
                    if ($numOfSyllables == 1) {
                        if ($flag) {
                            print TEST qq($syllable\t$type\tS\n);
                        } else {
                            print TRAIN qq($syllable\t$type\tS\n);
                        }
                    } else {
                        if ($cnt == 0) {
                            if ($flag) {
                                print TEST qq($syllable\t$type\tB\n);
                            } else {
                                print TRAIN qq($syllable\t$type\tB\n);
                            }
                        } else {
                            if ($flag) {
                                print TEST qq($syllable\t$type\tE\n);
                            } else {
                                print TRAIN qq($syllable\t$type\tE\n);
                            }
                        }
                    }
                    $cnt++;
                }
            }
            if ($flag) { 
                print TEST qq(\n);
            } else { print TRAIN qq(\n); }
        }
        #print qq(=============================\n);
    }
    $files{$name} = \@lines;
    $file->close;
}
close TRAIN;
close TEST;
print STDERR qq(Number of sentences: $numOfSentences\n);
print STDERR qq(Total number of words: $totalWords\n);
print STDERR qq(Total number of syllables: $totalSyllables\n);
