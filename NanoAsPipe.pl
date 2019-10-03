#!/usr/bin/perl
# Copyright (c) Dr. Chi Zhang's Bioinformatics Lab in Beadle Center, UNL.
# Author:Liu Kan <kliu7@unl.edu>
# Date & Version: 2017-10-05 Version 1.0
# Description: 
use strict;
use warnings;
use Getopt::Long;
my $ver="1.0"; #version
my %opts;
GetOptions(\%opts,"input:s","genome:s","annotation:s","output:s","overlap:s","cpu:s","codeDir:s","SamtoolsDir:s","BedtoolsDir:s","GraphmapDir:s","h!");
my $usage=<<"USAGE";
       Program : $0
       Version : $ver
       Usage : $0 [mandatory options are listed below]

               -input: Input MinION fastq files directory for the analysis  
               -codeDir: Directory for all the NanoAsPipe scripts 
               -output: Output directory to restore the temporary and final results
               -genome: Reference genome sequences for alignment  
               -annotation: Gtf annotation file containing the exon feature of the reference species
               -overlap: Minimum error merge size for MinION RNA-seq at the exon/intron boundary (default: 5)

               -SamtoolsDir: Directory for samtools
               -BedtoolsDir: Directory for bedtools
               -GraphmapDir: Directory for GraphMap
               -cpu: Number of CPUs for GraphMap (default: 4)

               -h Display this usage information
USAGE
die $usage if (!defined $opts{input} || !defined $opts{genome} || !defined $opts{annotation} || !defined $opts{output} || !defined $opts{codeDir} || !defined $opts{overlap}  || !defined $opts{cpu} || !defined $opts{SamtoolsDir} || !defined $opts{BedtoolsDir} || !defined $opts{GraphmapDir} ||$opts{h});
my $Time_Start =scalar (localtime(time())); 
print "NanoAsPipe starts at $Time_Start\n";
print "*********************************\n";

my $input=$opts{input};
my $output=$opts{output};
my $genome=$opts{genome};
my $gtf=$opts{annotation};
my $overlap=$opts{overlap}?$opts{overlap}:5;
my $cpuNum=$opts{cpu}?$opts{cpu}:4;

my $nano_dir=$opts{codeDir};
my $samtools_dir=$opts{SamtoolsDir};
my $bedtools_dir=$opts{BedtoolsDir};
my $graphmap_dir=$opts{GraphmapDir};

opendir(DH, "$input");
my @files = readdir(DH);
closedir(DH);

foreach my $file (@files)
{
	next if($file !~ /\.fastq$/);
	#Alignment:
	my $fileIn=$input.'/'.$file;
	my $fileOut=$output.'/'.$file.'.sam';
	my $cmd='';
#	$cmd=$graphmap_dir.' align -r '.$genome.' -d '.$fileIn.' -o '.$fileOut.' -t '.$cpuNum;
#	#print "$cmd\n";
#	system $cmd;
#
#	#Transformation of alignment result:
#	$fileIn=$fileOut;
#	$fileOut=$fileIn.'.bam';
#	$cmd=$samtools_dir.' view -bS -o '.$fileOut.' '.$fileIn;
#	system $cmd;

	$fileIn=$fileOut;
	$fileOut=$fileIn.'.sort';
	$cmd=$samtools_dir.' sort '.' -o '.$fileOut.' '.$fileIn;
	system $cmd;

#	$fileIn=$fileOut.'.bam';
	$cmd=$samtools_dir.' index '.$fileOut;
	system $cmd;

	$fileOut=$fileIn.'.bed';
	$cmd=$bedtools_dir.' bamtobed -splitD -cigar -i '.$fileIn.' > '.$fileOut;
	system $cmd;

	$fileIn=$fileOut;
	$fileOut=$fileIn.'.intersect';
	$cmd=$bedtools_dir.' intersect -b '.$fileIn.' -a '.$gtf.' -wao > '.$fileOut;
	system $cmd;

	$fileIn=$fileOut;
	$fileOut=$fileIn.'.match';
	$cmd=q[ awk  -F'\t' '{if ($11 != -1 ) {print $0} }' ].$fileIn.' > '.$fileOut;
	system $cmd;

	$fileIn=$fileOut;
	$cmd='perl '.$nano_dir.'/filter_nanopore_mistake.pl '.$fileIn;
	system $cmd;

	$fileIn=$output;
	$fileOut=$fileIn.'/Total_result';
	$cmd='perl '.$nano_dir.'/combine_AS.pl '.$fileIn.' '.$fileOut;
	system $cmd;

}

my $Time_Stop =scalar (localtime(time())); 
print "NanoAsPipe stops at $Time_Stop\n";

