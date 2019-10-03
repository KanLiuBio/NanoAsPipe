#!/usr/bin/perl
use strict;
use warnings;
use List::MoreUtils qw(uniq);
my (%location,%rest,%ref);
open (IN,"$ARGV[0]")||die "$!";
open (OUT,">$ARGV[0].all")||die "$!"; # Reformat the information as new output
while (<IN>) {
	chomp;$_=~s/\r//g;
	if ($_ eq '') {
		next;
	}
	my @array=split (/\t/,$_);
	$ref{$array[8]}=$array[3].'_'.$array[4];
	$location{$array[8]}{$array[12]}.=$array[10].'_'.$array[11].'|';
	$rest{$array[8]}{$array[12]}=$array[0]."\t".$array[3]."\t".$array[4]."\t".$array[6]."\t".$array[8]."\t".$array[12]."\t".$array[14];
}
close (IN);
foreach my $c (sort keys %location) {
	foreach my $d (sort keys %{$location{$c}}) {
		my @array=split (/\||\_/,$location{$c}{$d});
		for (my $e=1;$e<$#array ;$e+=2) {
			if ($array[$e+1]-$array[$e]<=5) {
				$array[$e]=0;$array[$e+1]=0;
			}
		}
		my @array2=grep {$_ >0} @array;
		my @array3=split (/\_/,$ref{$c});
		my $new_location=join '_',@array2;
		print OUT "$rest{$c}{$d}\t$new_location\n";
	}
}
close (OUT);
my (%duplicate,%fusion,%times);
open (TEMP,"$ARGV[0].all")||die "$!";
open (TEMP2,">$ARGV[0].all.redup")||die "$!";
open (TEMP3,">$ARGV[0].all.fusion")||die "$!";
while (<TEMP>) {
	chomp;$_=~s/\r//g;
	if ($_ eq '') {
		next;
	}
	my @array=split (/\t/,$_);
	my $locus=$array[0].'_'.$array[1].'_'.$array[2];
	if (!defined $duplicate{$locus}{$array[5]}) {
		print TEMP2 "$_\n";	
		$fusion{$array[5]}{$array[4]}=$_;
		$times{$array[5]}+=1;
	}
	$duplicate{$locus}{$array[5]}=$_;
}
foreach my $c (keys %fusion) {
	if ($times{$c}<2) {
		next;
	}
	foreach my $d (keys %{$fusion{$c}}) {
		print TEMP3 "$fusion{$c}{$d}\n";
	}
}
close (TEMP);
close (TEMP2);
close (TEMP3);
my (%SE,%SE_detail);
open (OUT3,">$ARGV[0]\.A5SS")||die "$!";
open (OUT4,">$ARGV[0]\.A3SS")||die "$!";
open (OUT5,">$ARGV[0]\.RI")||die "$!";
open (OUT6,">$ARGV[0]\.SE")||die "$!";
open (OUT2,">$ARGV[0]\.OtherAS")||die "$!";
open (TEMP4,"$ARGV[0].all.redup")||die "$!";
while (<TEMP4>) {
	chomp;$_=~s/\r//g;
	if ($_ eq '') {
		next;
	}
	my @array=split (/\t/,$_);
	my @array2=split (/\_/,$array[-1]);
	my $test=$array[4].'_'.$array[1].'_'.$array[2];
	$SE{$array[5]}{$test}=$_;
	my @array3=split(/\;/,$array[4]);
	$SE_detail{$array[5]}.=$array[3].'_';
	if ($#array2>1) {
		if ($array2[0] ==$array[1] && $array2[-1]==$array[2]) {
			print OUT5 "$_\n"; 
		}
	}
	else
	{
		if ($array2[0] ==$array[1] && $array2[1]!=$array[2]) {
			print OUT3 "$_\n";
		}
		elsif ($array2[0] !=$array[1] && $array2[1]==$array[2]) {
			print OUT4 "$_\n";
		}
		else
		{
			print OUT2 "$_\n";
		}
	}
}
foreach my $c (keys %SE) {
	my @array=keys %{$SE{$c}};
	if ($#array>0) {
		my @array2=split(/\_/,$SE_detail{$c});
		my @array3= uniq(@array2);
		if ($#array3>0) {
			my @array4=();
			foreach my $d (keys  %{$SE{$c}}) {
				my @array5=split(/\;/,$d);
				push @array4,$array5[0];
			}
			my %seen = ();
			my @dup = map { 1==$seen{$_}++ ? $_ : () } @array4;
			if (@dup) {
				foreach my $e (keys  %{$SE{$c}}) {
					foreach my $f (@dup) {
						if ($e=~/$f/) {
							print OUT6 "$SE{$c}{$e}\n";
						}
					}
				}
			}
		}
	}
}
close (TEMP4);
close (OUT2);
close (OUT3);
close (OUT4);
close (OUT5);
close (OUT6);
