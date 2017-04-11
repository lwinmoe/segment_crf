#!/usr/bin/perl
#Lwin Moe, October 2016
package syllabify_burmese;
use strict;
use Encode;       # for Unicode handling
our (@ISA, @EXPORT, @EXPORT_OK);
use Exporter;
@ISA            = qw(Exporter);
@EXPORT         = qw(syllabify);
@EXPORT_OK      = qw(:DEFAULT %Table);

############### Usage example
# use Encode;
# use burmeseunicode;
#my $foo = "နေကောင်းလား။";		# the text we want to convert
#$foo = Encode::decode_utf8($foo);		# from bytes to UTF8 encoding
#$foo = syllabify($foo);			
#$foo = Encode::encode_utf8($foo);		# back to bytes
#print qq($foo\n);

############### variables
my $consonants = qq(\x{1000}|\x{1001}|\x{1002}|\x{1003}|\x{1004}|\x{1005}|\x{1006}|\x{1007}|\x{1008}|\x{1009}|\x{100A}|\x{100B}|\x{100C}|\x{100D}|\x{100E}|\x{100F}|\x{1010}|\x{1011}|\x{1012}|\x{1013}|\x{1014}|\x{1015}|\x{1016}|\x{1017}|\x{1018}|\x{1019}|\x{101A}|\x{101B}|\x{101C}|\x{101D}|\x{101E}|\x{101F}|\x{1020}|\x{1021});
my $shanConsonants = qq(\x{1075}|\x{1076}|\x{1078}|\x{101E}|\x{107A}|\x{107C}|\x{107D}|\x{107E}|\x{101B}|\x{1080}|\x{1081}|\x{1022});
my $medial = qq(\x{103B}|\x{103C}|\x{103D}|\x{103E}|\x{105E}|\x{105F}|\x{1060});
my $shanMedial = qq(\x{1082});
my $shanTones = qq(\x{1087}|\x{1088}|\x{1089}|\x{108A}|\x{108B}|\x{108C});
my $vowels = qq(\x{102B}|\x{102C}|\x{102D}|\x{102E}|\x{102F}|\x{1030}|\x{1031}|\x{1032}|\x{1084}|\x{1085});
my $joinedVowels = qq(\x{102D}\x{102F}|\x{1031}\x{102C}|\x{1031}\x{102B}); # VOWEL O, VOWEL AU
my $burmeseTones = qq(\x{1036}|\x{1037}|\x{1038});
my $virama = qq(\x{1039});
my $killer = qq(\x{103A});
my $individuals = qq(\x{1023}|\x{1024}|\x{1025}|\x{1026}|\x{1027}|\x{1028}|\x{1029}|\x{102A}});
my $numbers = qq(\x{1040}|\x{1041}|\x{1042}|\x{1043}|\x{1044}|\x{1044}|\x{1045}|\x{1046}|\x{1047}|\x{1048}|\x{1049});
my $puncs = qq(\x{104A}|\x{104B});

sub syllabify {
  local ($_) = shift;
  ################ normalization
  s/($individuals)/$1\|/g;
  s/($numbers)/$1\|/g;
  s/($puncs)/$1\|/g;

  s/($consonants)/$1\|/g;
  s/\|(($medial)+)/$1\|/g;
  s/\|($joinedVowels|$vowels)/$1\|/g;
  s/\|($killer)/$1\|/g;
  s/\|($burmeseTones)/$1$2\|/g;
  s/\|($consonants)($killer)/$1$2\|/g;
  s/\|($consonants)($burmeseTones)/$1$2\|/g;
  s/\|($killer)/$1\|/g;
  s/\|($burmeseTones)/$1\|/g;
  s/\|($killer)/$1\|/g;
  s/\|($virama)/$1/g;
  
  s/ *\|+ */\|/g;

  return $_;
} # POST: syllables

1;
