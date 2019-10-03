#!/usr/bin/perl
use strict;
use warnings;
my (%size,%length,%link);
open (IN,"$ARGV[0]")||die "$!";
open (IN2,"$ARGV[1]")||die "$!";
open (IN3,"$ARGV[2]")||die "$!";
open (OUT,">$ARGV[3]")||die "$!";
while (<IN>) {
	chomp;$_=~s/\r//g;
	if ($_ eq '') {
		next;
	}
	my @array=split (/\t/,$_);
	$size{$array[0]}=$array[1];
}
while (<IN2>) {
	chomp;$_=~s/\r//g;
	if ($_ eq '') {
		next;
	}
	if ($_=~/^\@/ && $_=~/\s+/) {
		my @array=split (/\s+/,$_);
		$array[0]=~s/\@//g;
		$array[-1]=~s/length\=//g;
		$length{$array[0]}=$array[-1];
	}
}
while (<IN3>) {
	chomp;$_=~s/\r//g;
	if ($_ eq '') {
		next;
	}
	my @array=split (/\t/,$_);
	if ($array[0] eq $array[9]) {
		my @array2=split (/transcript\_id/,$array[8]);
		my @array3=split (/\;/,$array2[1]);
		$array3[0]=~s/\"|\s+//g;
		$link{$array3[0]}{$array[12]}=1;
	}
}
foreach my $c (keys %link) {
	foreach my $d (keys %{$link{$c}}) {
		print OUT "$c\t$size{$c}\t$d\t$length{$d}\n";
	}
}
close (IN);
close (IN2);
close (IN3);
close (OUT);
