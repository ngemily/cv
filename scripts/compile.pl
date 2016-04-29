#! /usr/bin/perl

use strict;
use warnings;

use YAML;
use Data::Dumper;

my $DEBUG = 0;

sub dprint {
    print "DBG @_\n" if $DEBUG;
}

my $file = $ARGV[0];
my $target = $ARGV[1];

dprint("src: $file");
dprint("out: $target");

# step 1: open file
open my $fh, '<', $file
    or die "can't open input file: $!";
open my $ofh, '>', $target
    or die "can't open output file: $!";

# step 2: slurp file contents
my $yml = do { local $/; <$fh> };

# step 3: convert YAML 'stream' to perl hash ref
my @contents = Load($yml);
dprint("Reading contents...");
print Dumper($contents[0]), "\n" if $DEBUG;

my $title    = $contents[0]{'title'};
my $subtitle = $contents[0]{'subtitle'};
my $year     = $contents[0]{'year'};
my $body     = $contents[0]{'body'};
my @tags     = @{$contents[0]{'tags'}} if $contents[0]{'tags'};

my $longest = (sort { length($b) <=> length($a) } @tags)[0];

# Sample output:
#
#   \cvitem{2015}
#   {Altera}{IP \& Device Software}
#       \blap{\llap{\makebox[2em + \widthof{Verilog} + \widthof{IP \& Device Software}][l]{
#           \shortstack[r]{
#               \rectangled{Verilog} \\
#               \rectangled{C++} \\
#               \rectangled{Quartus}
#           }
#       }}}
#       <body text>

my $tex = << "EOM";
\\cvitem{$year}{$title}{$subtitle}
\\blap{\\llap{\\makebox[2em + \\widthof{$longest} + \\widthof{$subtitle}][l]{
    \\shortstack[r]{
EOM

my $last = $#tags;
foreach my $tag (@tags){
    $tex = $tex ."        ";
    $tex = $tex ."\\rectangled{$tag}";
    $tex = $tex ."\\\\" if $last--;
    $tex = $tex ."\n";
}

$tex = $tex . << "EOM";
    }
}}}

$body
EOM

print $ofh $tex;

close($fh);
close($ofh);
