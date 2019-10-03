#!/usr/bin/perl
use strict;
use warnings;
my %size;
open (IN,"$ARGV[0]")||die "$!";
open (OUT,">$ARGV[1]")||die "$!";
while (<IN>) {
	chomp;$_=~s/\r//g;
	if ($_ eq '') {
		next;
	}
	my @array=split(/\t/,$_);
	my @array2=split (/transcript\_id/,$array[8]);
	my @array3=split (/\;/,$array2[1]);
	$array3[0]=~s/\"|\s+//g;
	$size{$array3[0]}+=$array[4]-$array[3]+1;
}
foreach my $c (keys %size) {
	print OUT "$c\t$size{$c}\n";
}
close (IN);
close (OUT);
