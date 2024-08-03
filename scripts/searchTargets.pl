#!/usr/bin/perl
#use warnings;
use JSON;

# Created by D

my $BASE_PATH = $ENV{BASE_PATH};

my $json_data = `$BASE_PATH/scripts/queries.py --get_all`;

my $data = decode_json($json_data);
print "Search Term: ";
$search_term = <STDIN>;
chomp $search_term;
my $found_results = 0;
foreach my $ip (keys %$data) {
	my $search_location = $data->{$ip}->{domain};
    if ($search_location =~ $search_term || $search_term  eq '') {
        print "\033[32mIP: $ip\033[m\n";
        print "Domain: $data->{$ip}->{domain}\n";
        print "Build: $data->{$ip}->{build}\n";
        foreach my $port (keys %{$data->{$ip}->{ports}}) {
            print "\033[33mPort: $port\033[m\n";
            print "Server: $data->{$ip}->{ports}->{$port}->{server}\n";
            print "Content Type: $data->{$ip}->{ports}->{$port}->{content_type}\n";
            print "Connection: $data->{$ip}->{ports}->{$port}->{connection}\n";
        }
        print "\n";
	$found_results = 1;
    }
}
if ($found_results == 0){
	print "No targets with domains matching '$search_term' were found\n"
}
