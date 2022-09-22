#!/usr/bin/perl

use strict;

my $face = $ARGV[0];
my $latenc = $ARGV[1];
my $cyrenc = $ARGV[2];

sub transformfont {
    my $shape = shift;
    my $width = shift;
    if (-f "${face}${shape}${latenc}${width}.afm") {
	print STDOUT "\\transformfont{${face}${shape}8r${width}}{\\reencodefont{8r}{\\fromafm{${face}${shape}${latenc}${width}}}}\n";
    }
    if (-f "${face}${shape}${cyrenc}${width}.afm") {
	print STDOUT "\\transformfont{${face}${shape}6r${width}}{\\reencodefont{6r}{\\fromafm{${face}${shape}${cyrenc}${width}}}}\n";
    }
}

sub transformslfont {
    my $shape = shift;
    my $width = shift;
    if (-f "${face}${shape}${latenc}${width}.afm" && ! -f "${face}${shape}o${latenc}${width}.afm") {
	print STDOUT "\\transformfont{${face}${shape}o8r${width}}{\\slantfont{167}{\\frommtx{${face}${shape}8r${width}}}}\n";
    }
    if (-f "${face}${shape}${cyrenc}${width}.afm" && ! -f "${face}${shape}o${cyrenc}${width}.afm") {
	print STDOUT "\\transformfont{${face}${shape}o6r${width}}{\\slantfont{167}{\\frommtx{${face}${shape}6r${width}}}}\n";
    }
}

print STDOUT <<'EOF';
\input fontinst.sty
\input fnstcorr
\input cyralias

\installfonts
\transformfont{psyro}{\slantfont{167}{\fromafm{psyr}}}
EOF

&transformfont ('r', '');
&transformfont ('ri', '');
&transformfont ('ro', '');
&transformfont ('b', '');
&transformfont ('bi', '');
&transformfont ('bo', '');
&transformslfont ('r', '');
&transformslfont ('b', '');

&transformfont ('r', 'c');
&transformfont ('ri', 'c');
&transformfont ('ro', 'c');
&transformfont ('b', 'c');
&transformfont ('bi', 'c');
&transformfont ('bo', 'c');
&transformslfont ('r', 'c');
&transformslfont ('b', 'c');

print STDOUT <<'EOF';
\endinstallfonts

\bye
EOF
