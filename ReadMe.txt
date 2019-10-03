NanoAsPipe (A pipeline to analyze MinION RNA-seq long reads for alternative splicing events detection)


##Description:
NanoAsPipe is a perl based wrapper/tool that can accept any number of sequence (fastq) files in one single directory to produce an automatic comprehensive analysis of the transcriptome analysis such as quality control, adapter removal, alignment and isoform detection. All parameters (Minimum error merge length, CPU number, etc) are user-declarable at runtime. It is written to run on Linux.

##Current version: 1.0

##Requirements: 
You will need to have the following tools installed and in $PATH, or added to $binpath in the tool:

Samtools (version >= 0.1.19)
Bedtools (version >= v2.25.0)
GraphMap (version >= v0.5.2)
PoreChop (version >= v0.2.1)

All the perl script of NanoAsPipe should be placed in the same directory.

##Usage:

perl NanoAsPipe-1.0.pl [options] 

##Options:
-input=Input MinION fastq files directory for the analysis

-genome=Reference genome sequences for alignment

-annotation=gtf annotation file of reference species downloaded from UCSC

-output=Output directory to restore the final results

-overlap=Minimum error merge size for MinION RNA-seq at the exon/intron boundary (default = 5)

-cpu=Number of CPUs for GraphMap (default 4)


