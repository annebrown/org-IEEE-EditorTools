#!/usr/bin/perl

################################################################################
#
# Filename: script.pl
# 
# Purpose:
# 	Convert .txt IEEE comment files into .csv files for IEEE Editor
#
# Issues with Filemaker utility:
#	1. .txt entries are asked for "CommenterName:", however, the Filemaker 
#		utility asks for first and last name separately, and then places a comma 
#		after the first name in the output.
#
################################################################################

use 5.010;
use strict;
use warnings;
$|=1; # Buffering

# Variables
my $output_filename;
my @txt_filenames;
my @csv_filenames;
my $result = "";

@txt_filenames = get_filenames(); # Get list of .txt files

# Convert .txt into .csv 
foreach (@txt_filenames) {
	if (substr($_,length($_) - 4,4) ne '.txt' ) {next;} # only .txt files
	$output_filename = substr($_, 0,length($_)-3) ."csv"; # Creating output filename
	print "\nConverting filename: \n\t\"$_\" \n into \n\t\"$output_filename\"\n";
	$result = convert_txt_comment_to_csv("$_","$output_filename");	
}

print "\n$result\n";

sub get_filenames {
	my ($dir) = @_;
		opendir DIR, "." or die "Failed in sub 'get_filenames' while trying to open directory: $dir  \nPerl says: \n$!";
		my @filenames = readdir DIR;
		shift @filenames; shift @filenames; # remove . and ..
	return @filenames;
}

sub convert_txt_comment_to_csv {
	my($infile,$outfile) =@_; # relative filenames
	my $str = "";
	my $commentstart = 0;
	my $remedystart = 0;
	my $line_no = 1;
	
	# Opening input file
	open INFILE, "$infile" or die "Failed in sub 'convert_txt_comment_to_csv' while trying to open for reading file: $infile  \nPerl says: \n$!";     
 
	 # Creating output file
	 if ( -e $outfile) { return "Error: file \"$outfile\" already exists.\n"; }  	
	 open OUTFILE, ">$outfile" or die "Failed in sub 'convert_txt_comment_to_csv' while trying to open for writing file: $outfile  \nPerl says: \n$!";          

	while(<INFILE>){  # reads line by line from FILE
		if (!$commentstart and !$remedystart) {chomp;}  # avoids \n on last field
				
		if (/CommentID:/) { $str = $str ."\"0";	next;} # begin record 
		elsif (/CommenterName:/) { $_ = substr($_, 14,);}
		elsif (/CommenterEmail:/) { $_ = substr($_, 15,); }
		elsif (/CommenterPhone:/) { $_ = substr($_, 15,); }
		elsif (/CommenterCellPhone:/) { $_ = substr($_, 19,); }
		elsif (/CommenterCompany:/) { $_ = substr($_, 17,); }
		elsif (/Clause:/) { $_ = substr($_, 7,); }
		elsif (/Subclause:/) { $_ = substr($_, 10,); }
		elsif (/Page:/) {  $_ = substr($_, 5,); }
		elsif (/Line:/) {  $_ = substr($_, 5,); }
		elsif (/CommentType:/) { $_ = substr($_, 12,); }
		elsif (/Comment:/) { $_ = substr($_, 8,); $commentstart = 1; }
		elsif (/CommentEnd:/) { $commentstart=0; next; }
		elsif (/SuggestedRemedy:/) { $_ = substr($_, 16,); $remedystart = 1; }
		elsif (/RemedyEnd:/) { $remedystart=0; $str = $str ."~~X~O\"\n"; next;	}  # end record
		elsif ($commentstart or $remedystart) { $_ =~ s/^\s+//; $_ =~ s/\s+$//; $str = $str ."$_\x0b"; next; }  
		else { next; }
		
		# Trim trailing and leading white spaces
		$_ =~ s/^\s+//; $_ =~ s/\s+$//; 
		
		$str = $str ."~" .$_;
	}
	
	print OUTFILE $str;  # Write to file 
	
	close INFILE;                  
	close OUTFILE;    
	
	return "Success\n";
}