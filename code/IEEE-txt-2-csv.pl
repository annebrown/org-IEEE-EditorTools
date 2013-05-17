#!/usr/bin/perl;

################################################################################
#
# Filename: IEEE-txt-2-csv.pl - perl script
# 
# Purpose:
# 	Converts .txt IEEE comment files into .csv files for IEEE Editors
#
# Documentation: See POD
#
# Instructions: 
#   Execute script in directory containing .txt files from contributors.
#
# Issues with Filemaker utility:
#	1. .txt entries are asked for "CommenterName:", however, the Filemaker 
#		utility asks for first and last name separately, and then places a comma 
#		after the first name in the output.
#
#################################################################################

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
		opendir DIR, "." or die "Failed in sub 'get_filenames' while trying to 
		    open directory: $dir  \nPerl says: \n$!";
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
	open my $in_fh, '<', "$infile" or die 
	    "Failed in sub 'convert_txt_comment_to_csv()' while trying to open for 
	    reading file: $infile  \nPerl says: \n$!";     
 
	 # Creating output file
	 if ( -e $outfile) { return "Error: file \"$outfile\" already exists.\n"; }  	
	 open my $out_fh, '>', "$outfile" or die "Failed in sub 'convert_txt_comment_to_csv()' while trying to open for writing file: $outfile  \nPerl says: \n$!";          

	while($in_fh){  # reads line by line from FILE
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
	
	print $out_fh $str;  # Write to file 
	
	close $in_fh;                  
	close $out_fh;    
	
	return "Success\n";
}

=head1 NAME

IEEE-txt-2-csv.pl - perl script

=head1 SYNOPSIS

Run the script in the directory containing .txt files from IEEE contributors.  
The resulting .csv files will be generated into the same directory.

    $ perl ./IEEE-txt-2-csv.pl

=head2 Issues with the FileMaker Utility

.txt entries are asked for "CommenterName:", however, the Filemaker utility asks 
for first and last name separately, and then places a comma 
after the first name in the output.

=head1 DESCRIPTION

Converts .txt IEEE comment files into .csv files for IEEE Editors

=head1 SEE ALSO

    https://github.com/annebrown/IEEE.git

=head1 AUTHOR

Anne Brown

=head1 COPYRIGHT

Copyright (c) 20013, the above named AUTHOR.

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

1;