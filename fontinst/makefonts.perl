#!/usr/bin/perl

use strict;

my $face = $ARGV[0];
my $enc = $ARGV[1];

my $texenc;
my $srcenc;
for ($enc) {
    /OT1/ && do {$texenc = '7t';$srcenc = '8r';last;};
    /T1/ && do {$texenc = '8t';$srcenc = '8r';last;};
    /TS1/ && do {$texenc = '8c';$srcenc = '8r';last;};
    /OT2/ && do {$texenc = '7k';$srcenc = '6r';last;};
    /T2A/ && do {$texenc = '6a';$srcenc = '6r';last;};
    /T2B/ && do {$texenc = '6t';$srcenc = '6r';last;};
    /T2C/ && do {$texenc = '6c';$srcenc = '6r';last;};
    /X2/ && do {$texenc = '6x';$srcenc = '6r';last;};
}

my $lcenc = $enc;
$lcenc =~ tr/A-Z/a-z/;

my $ft;
for ($enc) {
    /OT1|T1/ && do {$ft = ",latin";last;};
    /TS1/ && do {$ft = ",textcomp";last;};
    /OT2|T2A|T2B|T2C|X2/ && do {$ft = ",latin,cyrillic";last;};
}

sub installfont {
    my ($shape, $width, $arg) = @_;
    my $srcfont="${face}${shape}${srcenc}${width}";
    if (${srcenc} == "6r") {
	$srcfont="${srcfont},${face}${shape}8r${width}";
    }
    if (-f "${face}${shape}${srcenc}${width}.mtx") {
	print STDOUT "\\installfont{${face}${shape}${texenc}${width}}{${srcfont},psyr scaled 1100${ft}}{${lcenc}}{${enc}}{${face}}${arg}\n";
    }
}

sub installslfont {
    my ($shape, $width, $arg) = @_;
    my $srcfont="${face}${shape}${srcenc}${width}";
    if (${srcenc} == "6r") {
	$srcfont="${srcfont},${face}${shape}8r${width}";
    }
    if (-f "${face}${shape}${srcenc}${width}.mtx") {
	print STDOUT "\\installfont{${face}${shape}${texenc}${width}}{${srcfont},psyro scaled 1100${ft}}{${lcenc}}{${enc}}{${face}}${arg}\n";
    }
}

sub installcapsfont {
    my ($shape, $width, $arg) = @_;
    my $srcfont="${face}${shape}${srcenc}${width}";
    if (${srcenc} == "6r") {
	$srcfont="${srcfont},${face}${shape}8r${width}";
    }
    if (-f "${face}${shape}${srcenc}${width}.mtx" && $enc ne 'TS1') {
	print STDOUT "\\installfont{${face}${shape}c${texenc}${width}}{${srcfont},psyr scaled 1100${ft}}{${lcenc}c}{${enc}}{${face}}${arg}\n";
    }
}

print STDOUT <<'EOF';
\input fontinst.sty
\input fnstcorr
\input cyralias

\installfonts
EOF
printf STDOUT "\\installfamily{%s}{%s}{}\n", $enc, $face;

&installfont('r', '', '{m}{n}{}');
&installcapsfont('r', '', '{m}{sc}{}');
&installslfont('ro', '', '{m}{sl}{}');
&installslfont('ri', '', '{m}{it}{}');
&installfont('b', '', '{b}{n}{}');
&installcapsfont('b', '', '{b}{sc}{}');
&installslfont('bo', '', '{b}{sl}{}');
&installslfont('bi', '', '{b}{it}{}');

&installfont('r', 'c', '{c}{n}{}');
&installcapsfont('r', 'c', '{c}{sc}{}');
&installslfont('ro', 'c', '{c}{sl}{}');
&installslfont('ri', 'c', '{c}{it}{}');
&installfont('b', 'c', '{bc}{n}{}');
&installcapsfont('b', 'c', '{bc}{sc}{}');
&installslfont('bo', 'c', '{bc}{sl}{}');
&installslfont('bi', 'c', '{bc}{it}{}');

print STDOUT <<'EOF';
\endinstallfonts

\bye
EOF
