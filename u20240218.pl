#!/usr/bin/env perl

use warnings;
use strict;

use Text::CSV;
use Template;


if ($#ARGV == 0) {
	my $csv = Text::CSV->new ({sep_char => ";"});
	open my $fh, "<:encoding(utf8)", $ARGV[0] or die "$ARGV[0]: $!";
	while (my $row = $csv->getline ($fh)) {
		if ($row->[1]) {
			if (-d "/etc/letsencrypt/live/$row->[0]") {
				if (-f "/etc/nginx/virtualhosts/$row->[0].conf") {
				} else {
					&add_nginx_virtualhost($row);
				}
			} else {
				print "/usr/bin/certbot certonly --webroot --webroot-path /var/www/html -m $row->[2] --agree-tos --no-eff-email --non-interactive -d $row->[0]\n";
				&add_nginx_virtualhost($row);
			}
		}
	}
	close $fh;
} else {
	exit 1;
}

sub add_nginx_virtualhost {
	my $row = shift @_;
	my $virtualhost;
	my $tt = Template->new;
	$tt->process('vitrualhost.tt', { domain => $row->[0], ip => $row->[1] }, \$virtualhost);
	open (nginx_virtualhost_fh, ">", "/etc/nginx/virtualhosts/$row->[0].conf");
	print nginx_virtualhost_fh $virtualhost;
	close nginx_virtualhost_fh;
}
