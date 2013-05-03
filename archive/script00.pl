#!/usr/bin/perl

use 5.010;
use strict;
use warnings;

# Variables
my $txt_dir = "input";
my $csv_dir = "output";
my $output_filename;
my @txt_filenames;
my @csv_filenames;

print "\n\n#########START#########\n";
print "\nIEEE comment files (.txt) are in: /$txt_dir\n";
print "Filemaker files (.csv) are in: /$csv_dir\n";

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
	
}

# Get list of .csv filenames
@csv_filenames = get_filenames($csv_dir); # Get list of output files
print "\nResulting .csv files:\n";
foreach (@csv_filenames) {
	print "$_\n";
}
print "\n";



# convert_ieee_txt_comment_to_csv_for_filemaker_input($input_directory, $output_directory);







# For each input file, output a csv equivalent



# Opening input file
# print "----Opening Filename: $input_directory/$input_file\n"; #shows you what we have read
# open(INFILE, "$input_directory/$input_file");          #opens tile in read-mode



# # 
# print "----Opening Output Filename: $output_directory/$output_file\n"; #shows you what we will write into
# open OUTFILE, ">$output_directory/$output_file";  #opens file to be written to

# # while(<INFILE>){                   #reads line by line from FILE 
   # chomp;
   # print "$_\n"; #shows you what we have read
   # print OUTFILE $_;             #write it to our file
# }
# print "------------Closing Files---------------\n";

# # close INFILE;                   #then close our file.
# close OUTFILE;                      #close the file.

# # convert_ieee_txt_comment_to_csv_for_filemaker_input {
   # $input_directory, $output_directory, $input_file, $output_file}

# # sub convert_ieee_txt_comment_to_csv_for_filemaker_input {
   # $input_directory, $output_directory, $input_file, $output_file}
# }

print "\n##########END##########\n\n";

sub get_filenames {
	my ($dir) = @_;
	    opendir DIR, $dir or die "Failed in sub 'get_filenames' while trying to open directory: $dir  \nPerl says: \n$!";
	    my @filenames = readdir DIR;
	    shift @filenames; shift @filenames; # remove . and ..
	return @filenames;
}