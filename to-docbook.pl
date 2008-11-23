#! /usr/bin/perl -w

use strict;
use warnings FATAL => "uninitialized";

use utf8;

local $/ = "";
binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";

my $first = 1;
while (my $para = <STDIN>) {
    if ($para =~ /^> (.*)/s) {

	if (!$first) {
	    print qq{</glossdef>\n</glossentry>\n\n};
	}

	my $terms = $1;
	$terms =~ s/\s+$//s;
	my $id = id_from_term(first_term($terms));
	print qq{<glossentry id=\"$id\"><glossterm>$terms</glossterm>

<glossdef>};

	$first = 0;
    } else {


	print qq{<para>$para</para>};
    }
}

sub first_term {
    my $line = shift;

    $line =~ s/\s+$//s;

    if ($line =~ /^(.*)\s*[\(,=]/) {
	return $1;
    } else {
	return $line;
    }
}

sub id_from_term {
    my $term = shift;
    $term =~ s/\s+$//s;
    $term =~ s/\s/-/g;
    $term = lc($term);

    return $term;
}
