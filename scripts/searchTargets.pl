#!/usr/bin/perl

use strict;
use warnings;

# Created by D

# Usage statement
if (@ARGV == 0) {
    print "Usage: $0 <search>\n";
    exit 1;
}

# Config check
my $scriptPath;
if (!defined $ENV{CONFIG}) {
    print "Command executed standalone: Running config\n";
    my $script_path = `dirname $0`;
    # Assuming config.sh is a Perl script that needs to be executed
    do "$script_path/../config/config.pl" or die "Could not run config: $!";
    $scriptPath = $script_path;
}
else {
    $scriptPath = $ENV{'scriptPath'};
}

# Var definitions
my $search_term = $ARGV[0];

# Program
my $all_data = `$scriptPath/queries.py get all`;

if ($search_term eq "") {
	print "$all_data\n";
}
else {

	my @targets = split /\n\n/, $all_data;
	my $is_blank = 0;
	foreach my $target (@targets) {
		if ($target =~ /$search_term/)
		{
			print "$target\n";
			$is_blank = 1;
		}
	}
	if ($is_blank == 0) {
		print "No targets matched $search_term\n"
	}
}
