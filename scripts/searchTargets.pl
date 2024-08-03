#!/usr/bin/perl

use strict;
use warnings;
use JSON;
use IPC::System::Simple qw(capture);

# Created by D

my $BASE_PATH = $ENV{BASE_PATH};

my $json_data = capture("$BASE_PATH/scripts/queries.py --get_all");

my $data = decode_json($json_data);

my $search_term = $ARGV[0];

foreach my $target (keys %$data) {
	if(match($target)) {
		print $target
	}
}

sub match {
	my $target = @_;

	print "Matching: $target"

}

