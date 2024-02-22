#!/usr/bin/env perl

use warnings;
use strict;

use Text::CSV;

if ($#ARGV == 0) {
    my $csv = Text::CSV->new ({sep_char => ";"});
    open my $fh, "<:encoding(utf8)", $ARGV[0] or die "$ARGV[0]: $!";
	print '#!/bin/sh'."\n";
        while (my $row = $csv->getline ($fh)) {
		if ($row->[1]) {
			if (-d "/etc/letsencrypt/live/$row->[0]") {
 			} else {
				print "/usr/bin/certbot certonly --webroot --webroot-path /var/www/html -m ivan.klyuchnick\@gmail.com --agree-tos --no-eff-email --non-interactive -d $row->[0] -d www\.$row->[0]\n";
			}
		}
        }
        close $fh;
} else {
    print "use $0 /path/to/data.file \n";
}

