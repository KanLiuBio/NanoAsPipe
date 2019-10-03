#!/usr/bin/perl
use strict;
use warnings;
my (%A5SS,%A3SS,%RI,%SE,%fusion,%detail);
opendir(IN,"$ARGV[0]")||die "$!";
while (my $file=readdir(IN)) {
	if ($file=~/\.A5SS/) {
		open (TEMP,"$ARGV[0]/$file")||die "$!";
		while (<TEMP>) {
			chomp;$_=~s/\r//g;
			if ($_ eq '') {
				next;
			}
			my @array=split (/\t/,$_);
			$A5SS{$array[4]}{$array[1].'_'.$array[2]}+=1;
			$detail{$array[4]}{$array[1].'_'.$array[2]}=$array[0]."\t".$array[1]."\t".$array[2]."\t".$array[3]."\t".$array[4];
		}
		close (TEMP);
	}
	elsif ($file=~/\.A3SS/) {
		open (TEMP,"$ARGV[0]/$file")||die "$!";
		while (<TEMP>) {
			chomp;$_=~s/\r//g;
			if ($_ eq '') {
				next;
			}
			my @array=split (/\t/,$_);
			$A3SS{$array[4]}{$array[1].'_'.$array[2]}+=1;
			$detail{$array[4]}{$array[1].'_'.$array[2]}=$array[0]."\t".$array[1]."\t".$array[2]."\t".$array[3]."\t".$array[4];
		}
		close (TEMP);
	}
	elsif ($file=~/\.RI/) {
		open (TEMP,"$ARGV[0]/$file")||die "$!";
		while (<TEMP>) {
			chomp;$_=~s/\r//g;
			if ($_ eq '') {
				next;
			}
			my @array=split (/\t/,$_);
			$RI{$array[4]}{$array[1].'_'.$array[2]}+=1;
			$detail{$array[4]}{$array[1].'_'.$array[2]}=$array[0]."\t".$array[1]."\t".$array[2]."\t".$array[3]."\t".$array[4];
		}
		close (TEMP);
	}
	elsif ($file=~/\.SE/) {
		open (TEMP,"$ARGV[0]/$file")||die "$!";
		while (<TEMP>) {
			chomp;$_=~s/\r//g;
			if ($_ eq '') {
				next;
			}
			my @array=split (/\t/,$_);
			$SE{$array[4]}{$array[1].'_'.$array[2]}+=1;
			$detail{$array[4]}{$array[1].'_'.$array[2]}=$array[0]."\t".$array[1]."\t".$array[2]."\t".$array[3]."\t".$array[4];
		}
		close (TEMP);
	}
	elsif ($file=~/\.fusion.pair/) {
		open (TEMP,"$ARGV[0]/$file")||die "$!";
		while (<TEMP>) {
			chomp;$_=~s/\r//g;
			if ($_ eq '') {
				next;
			}
			$_=~s/gene\_id//g;
			my @array=split (/\t+/,$_);
			$fusion{$array[0]}{$array[1]}+=1;
		}
		close (TEMP);
	}
}
closedir (IN);
open (OUT,">$ARGV[1]\.A5SS_total")||die "$!";
print OUT "Chr\tStart\tStop\tStrand\tAnnotation\tSupport_read_count\n";
foreach my $c (keys %A5SS) {
	foreach my $d (keys %{$A5SS{$c}}) {
		print OUT "$detail{$c}{$d}\t$A5SS{$c}{$d}\n";
	}
}
close (OUT);
open (OUT2,">$ARGV[1]\.A3SS_total")||die "$!";
print OUT2 "Chr\tStart\tStop\tStrand\tAnnotation\tSupport_read_count\n";
foreach my $c (keys %A3SS) {
	foreach my $d (keys %{$A3SS{$c}}) {
		print OUT2 "$detail{$c}{$d}\t$A3SS{$c}{$d}\n";
	}
}
close (OUT2);
open (OUT3,">$ARGV[1]\.RI_total")||die "$!";
print OUT3 "Chr\tStart\tStop\tStrand\tAnnotation\tSupport_read_count\n";
foreach my $c (keys %RI) {
	foreach my $d (keys %{$RI{$c}}) {
		print OUT3 "$detail{$c}{$d}\t$RI{$c}{$d}\n";
	}
}
close (OUT3);
open (OUT4,">$ARGV[1]\.SE_total")||die "$!";
print OUT4 "Chr\tStart\tStop\tStrand\tAnnotation\tSupport_read_count\n";
foreach my $c (keys %SE) {
	foreach my $d (keys %{$SE{$c}}) {
		print OUT4 "$detail{$c}{$d}\t$SE{$c}{$d}\n";
	}
}
close (OUT4);


open (OUT5,">$ARGV[1]\.fusion_total")||die "$!";
print OUT5 "FusionGeneA_ID\tFusionGeneB_ID\n";
foreach my $c (keys %fusion) {
	foreach my $d (keys %{$fusion{$c}}) {
		if (defined $fusion{$d}{$c}) {
			delete $fusion{$d}{$c};
		}
		print OUT5 "$c\t$d\n";
	}
}
close (OUT5);
