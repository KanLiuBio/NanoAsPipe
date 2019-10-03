#!/usr/bin/perl
use strict;
use warnings;
my (%match,%seq,%distance);
open (IN,"$ARGV[0]")||die "$!";
open (OUT,">$ARGV[1]")||die "$!";
while (<IN>) {
	chomp;$_=~s/\r//g;
	if ($_ eq '') {
		next;
	}
	my @array=split (/\t/,$_);
	$seq{$array[0]}=$array[1];
	$match{$array[0]}=$array[3] if(!defined $match{$array[0]});
	$distance{$array[0]}=abs($array[1]-$array[3]) if(!defined $match{$array[0]});
	if (abs($array[1]-$array[3]) <$match{$array[0]}) {
		$match{$array[0]}=$array[3];
		$distance{$array[0]}=abs($array[1]-$array[3]);
	}
}
foreach my $c (keys %seq) {
	print OUT "$c\t$seq{$c}\t$match{$c}\n";
}
close (IN);
close (OUT);
