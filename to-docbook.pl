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

	my $equiv = undef;

	if ($terms =~ /^(.*) = (.*)$/) {
	    $terms = $1;
	    $equiv = $2;
	}

	print qq{<glossentry id=\"$id\"><glossterm>$terms</glossterm>

<glossdef>};

	if ($equiv) {
	    $equiv = process_markup($equiv);
	    print qq{<para>$equiv</para>\n};
	}


	$first = 0;
    } else {
	$para = process_markup($para);

	print qq{<para>$para</para>};
    }
}
print qq{</glossdef>\n</glossentry>\n\n};


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

    $term =~ s/[,\(].*$//;
    $term =~ s/\s+$//s;
    $term =~ s/\s/-/g;
    $term = lc($term);

    return $term;
}

sub process_markup {
    my $para = shift;

    $para =~ s/<</&lt;&lt;/g;
    $para =~ s/>>/&gt;&gt;/g;

    $para =~ s/~/&nbsp;/g;

    $para =~ s/\n/ /gs;

    $para =~ s/@\[\[/См.&nbsp;[[/g;

    $para =~ s/\[\[(.*?)\]\]/glossterm($1)/gex;

    return $para;
}

sub glossterm {
    my $term = shift;

    my $id;
    if ($term =~ /^(.*)\|(.*)$/) {
	$id = id_from_term($2);
	$term = $1;
    } else {
	$id = id_from_term($term);
    }
    return qq{<glossterm linkend="$id">$term</glossterm>};
}
