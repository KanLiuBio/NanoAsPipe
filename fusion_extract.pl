#!/usr/bin/perl
use strict;
use warnings;
my %hash;
open (IN,"$ARGV[0]")||die "$!";
open (OUT,">$ARGV[1]")||die "$!";
while (<IN>) {
	chomp;$_=~s/\r//g;
	if ($_ eq '') {
		next;
	}
	my @array=split (/\t/,$_);
	my @array2=split (/\;/,$array[8]);
	$hash{$array[12]}{$array2[0]}.=$_."\n";
}
foreach my $c (keys %hash) {
	my @array=values %{$hash{$c}};
	if ($#array>0) {
		print OUT "$c";
		foreach my $d (keys %{$hash{$c}}) {
			print OUT "\t$d";
		}
		print OUT "\n";
	}
}
close (IN);
close (OUT);
