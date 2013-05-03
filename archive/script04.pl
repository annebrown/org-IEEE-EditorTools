#!/usr/bin/perl

use 5.010;
use strict;
use warnings;

# Variables
my $txt_dir = "input";
my $csv_dir = "output-myscript";
my $output_filename;
my @txt_filenames;
my @csv_filenames;
my $result = "";

print "\n\n#################START#################\n";
print "\nIEEE comment files (.txt) directory: /$txt_dir\n";
print "Filemaker files (.csv) directory: /$csv_dir\n";

# Get list of .txt filenames
@txt_filenames = get_filenames($txt_dir); # Get list of input files
print "\nList of .txt files:\n";
foreach (@txt_filenames) {
	print "$_\n";
}
print "\n";

# Convert each .txt file into .csv file
foreach (@txt_filenames) {
	
	$output_filename = substr($_, 0,length($_)-3) ."csv"; # Creating output filename
	print "\nConverting filename: \"/$txt_dir/$_\" into \"/$csv_dir/$output_filename\"\n";
	$result = convert_txt_comment_to_csv("$txt_dir/$_","$csv_dir/$output_filename");	
}

# Get list of .csv filenames
@csv_filenames = get_filenames($csv_dir); # Get list of output files
print "\nResulting .csv files:\n";
foreach (@csv_filenames) {
	 print "$_\n";
}
print "\n\nResult: $result\n";
print "\n##################END##################\n\n";

sub get_filenames {
	my ($dir) = @_;
		opendir DIR, $dir or die "Failed in sub 'get_filenames' while trying to open directory: $dir  \nPerl says: \n$!";
		my @filenames = readdir DIR;
		shift @filenames; shift @filenames; # remove . and ..
	return @filenames;
}

sub convert_txt_comment_to_csv {
	my($infile,$outfile) =@_;
	my $str = "";
	#Opening input file
	#print "----Opening Filename: $infile\n"; 
	open INFILE, "$infile" or die "Failed in sub 'convert_txt_comment_to_csv' while trying to open for reading file: $infile  \nPerl says: \n$!";     
 
	 # Creating output file
	 if ( -e $outfile) { return "Error: file \"$outfile\" already exists.\n"; }  #Check to ensure file does not already exist		
	open OUTFILE, ">$outfile" or die "Failed in sub 'convert_txt_comment_to_csv' while trying to open for writing file: $outfile  \nPerl says: \n$!"; 

	# Output Filemaker beginning stuff
	$str = "\"0";            
	my $commentstart = 0;
	my $remedystart = 0;
	 while(<INFILE>){                   #reads line by line from FILE 
		chomp;  #avoids \n on last field
		if ($_) { print "\$_ BEFORE: '$_' \n"; $_ =~ s/^\s+//; $_ =~ s/\s+$//; print "\$_ AFTER: '$_'\n";} # trim leading and trailing whitespaces
		if (/CommentID:/ or /CommentEnd:/ or /RemedyEnd:/ ) { next } 
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
		elsif (/Comment:/) { $_ = substr($_, 8,); $commentstart = 1; $str = $str ."~";}
		elsif (/CommentEnd:/) { $commentstart=0; }
		elsif (/SuggestedRemedy:/) { $_ = substr($_, 16,); $remedystart = 1; $str = $str ."~";}
		elsif (/RemedyEnd:/) { $remedystart=0; }
		else { next }
		#$_ =~ s/^\s+//g; 
		#$_ =~ s/\s+$//g;
		#$_ =~ s/^\s+|\s+$//g;
		#$_ =~ s/^\s+//; $_ =~ s/\s+$//;
		if ($_) {print "\$_ before: '$_'\n"; $_ =~ s/^\s+//; $_ =~ s/\s+$//;  print "\$_ after: '$_'\n";} # trim leading and trailing whitespaces
		#print "$_\n";
		if ($commentstart or $remedystart) { $_ =~ s/^\s+//; $_ =~ s/\s+$//; $str = $str ."$_"; } else { $str = $str ."~$_"; }		 
	}
		
	# Output Filemaker ending stuff
	$str = $str ."~~X~O\"\n";
	
	print OUTFILE $str;
	
	close INFILE;                   #then close our file.
	close OUTFILE;                      #close the file.
	
	return "Success\n";
}