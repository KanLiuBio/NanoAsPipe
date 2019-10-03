#!/usr/bin/perl
use strict;
use warnings;

open (IN,"$ARGV[0]")||die "$!";
open (OUT,">$ARGV[1]")||die "$!";
while (<IN>) 
{
	chomp;$_=~s/\r//g;
	if ($_ eq '') {
		next;
	}
	my @array=split (/\t/,$_);
	my %hash=();
	for (my $c=1;$c<=$#array ;$c+=1) {
		for (my $d=1;$d<=$#array ;$d+=1) {
			if ($array[$c]=~/$array[$d]/) {
				$hash{$d}=1;
			}
		}
	}
	my @array2=();
	for (my $c=1;$c<=$#array ;$c+=1) {
		if (!defined $hash{$c}) {
			push @array2,$array[$c];
		}
	}
	if ($#array2>0) {
		print OUT "$array[0]";
		foreach my $c (@array2) {
			print OUT "\t$c";
		}
		print OUT "\n";
	}
}
close (IN);
close (OUT);
