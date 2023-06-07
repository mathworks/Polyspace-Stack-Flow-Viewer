#!/usr/bin/perl

# Copyright (c) 2023 The MathWorks, Inc.
# All Rights Reserved.

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

use strict;
use warnings;

###############
#  Variables  #
###############

my $line;
my @matches;
my $length;
my $i;
my $function_name;
my %functions_hash;
my $next_token;
my $start;
my $next_start;
my $debug;
my $is_leaf;
my $is_node;
my $nb_space;
my $next_nb_space;
my $rest;
my $filename_export = "Result_List_cpp.txt";
my $output_file='output.html';
my $filename_html;
my $cpp_app=0;
my $project;
my $legal_notice;

###############
#  Functions  #
###############

sub help {
print <<"END";
SYNOPSIS
	$0 EXPORT_FILE REPORT_FILE 
	$0 -h

DESCRIPTION
  The script is aimed at understanding how the stack is used by showing the stack usage
  by functions through the call hierarchy.
  The script will read an export file (in tsv format) and a report (created with 
  the template CallHierarchy) in HTML format and will produce another HTML file, named
  output.html, showing the minimum and maximum stack usage in the call hierarchy. 

OPTIONS
	    -h
	      Display this help

END
}

sub read_args {
my $argt;

if (grep {$_ eq '-h'} @ARGV) {
	&help();
	exit 0;
} elsif (scalar(@ARGV) == 2) {
	# test the existence of the files
	if (-e $ARGV[0] && -e $ARGV[1]) {
		$filename_export = $ARGV[0];
		$filename_html = $ARGV[1];
	} else {
		die("Cannot open the file(s) in argument. Please check the file paths\n");
	}
} else {
	# Print usage message and exit
	print "Usage: $0 EXPORT_FILE REPORT_FILE\n";
	print "Or: $0 -h to get help\n";
	exit 1;
}

}

# read the export file (Result_List.txt by default)
# to create the hashtable which associates
# function and min/max stack usage 
sub read_export {
my $metrics_found=0;

open (FH, $filename_export);   # open in read-only mode
$line = <FH>;
$cpp_app = ( scalar(split /\t/, $line) == 14);
while (<FH>) {
	$line = $_;
	if ($cpp_app) {
		if ($line =~ /\tFunction Metrics.*Minimum Stack Usage\t([^\t]*)\t[^\t]*\t([^\t]*)\t/) {
			$metrics_found = 1;
			$function_name = $2;
			if ($1 =~ /Not computed/) {
				$functions_hash{$function_name}{"minsu"}="?";
			} else {
				$functions_hash{$function_name}{"minsu"}=$1;
			}
		}
		if ($line =~ /\tFunction Metrics.*Maximum Stack Usage\t([^\t]*)\t[^\t]*\t([^\t]*)\t/) {
			$function_name = $2;
			if ($1 =~ /Not computed/) {
				$functions_hash{$function_name}{"maxsu"}="?";
			} else {
				$functions_hash{$function_name}{"maxsu"}=$1;
			}
		}
	} else {
		if ($line =~ /\tFunction Metrics.*Minimum Stack Usage\t([^\t]*)\t([^\t]*)\t/) {
			$metrics_found = 1;
			$function_name = $2;
			if ($1 =~ /Not computed/) {
				$functions_hash{$function_name}{"minsu"}="?";
			} else {
				$functions_hash{$function_name}{"minsu"}=$1;
			}
		}
		if ($line =~ /\tFunction Metrics.*Maximum Stack Usage\t([^\t]*)\t([^\t]*)\t/) {
			$function_name = $2;
			if ($1 =~ /Not computed/) {
				$functions_hash{$function_name}{"maxsu"}="?";
			} else {
				$functions_hash{$function_name}{"maxsu"}=$1;
			}
		}

	}
}

close (FH);

return $metrics_found;
}

# Parse the report in HTML to extract information
sub read_report {
my $tokens_found=0;
open (FH,$filename_html) or die("Cannot find $filename_html");

while (<FH>) {
	$line = $_;

	if ($line =~ /class="rgSubtitle".*Call Hierarchy Report for Project: (\w+)</) {
		$project = $1;
	}

	if ($line =~ /class="rgLegalNotice".*(Verification Author.*)/) {
		$legal_notice = "$1<br>\n"; 
		while ($line !~ /\w+<\/span>/) {
			$line = <FH>;
			$legal_notice .= "$line<br>\n"; 
		}
	}

	if ($line =~ /<table class.*Call tree/) { # find the right table
		$tokens_found = 1;
		$line =~ s/<td><p\/><\/td>/<td><p><span> <\/span><\/p><\/td>/g;
		@matches = $line =~ m/<td><p><span>(.*?)<\/span><\/p><\/td>/g;
	}
}
close(FH);
return $tokens_found;
}

#  Process the two sources of information
#  and generate
sub generate {

my $bend = "└";
my $hori = "─";
my $vert = "│";
my $te   = "├";

my $depth=0;
my $next_depth=0;
my $new_depth=0;

$length = @matches;
my $token;
my $file_name;

open(FH, '>', $output_file) or die $!;

# Write HTML header
print FH "<html>\n<head>\n<meta charset=\"UTF-8\">\n<title>Call Hierarchy report with stack usage for $project</title>\n</head>\n<body>\n";

print FH "<H1>Call Hierarchy report with stack usage for project $project</H1>\n\n";
print FH "<br>\n";
print FH "$legal_notice\n";
print FH "<br>\n";
print FH "<b>Minimum and maximum stack usage is:</b>\n";
print FH "<pre>\n";

my ($main) = $matches[8] =~ /\.(\w+)/; # extract name of the main
$main = "$main()";
my $main_stats = $main." [".$functions_hash{$main}{"minsu"}."..".$functions_hash{$main}{"maxsu"}."]";

print FH "$main_stats\n";

for ($i = 16; $i < $length; $i = $i + 8) {
	$token = $matches[$i];
	$next_token = $matches[$i+8];

	if ($token =~ /Already displayed/) {
		print FH "^^ $token ^^\n";
		next;
	}
	if ($token =~ /Never called procedure/) {
		last;
	}
	if ($token =~ /RecursiveCall/) {
		print FH "]]   RecursiveCall   [[\n";
		next;
	}

	# HTML special characters
	$token =~ s/&gt;/>/g;
	$token =~ s/&lt;/</g;
	$token =~ s/&amp;/&/g;

	$next_token =~ s/&gt;/>/g;
	$next_token =~ s/&lt;/</g;
	$next_token =~ s/&amp;/&/g;

	if ( $token =~ /^(\|[\| -]+>)/ ) {
		$start = $1;
		$is_leaf = ($start =~ /\|   >/);
		$is_node = ($start =~ /\|  - >/);

		# get the file and function name
		if ($token =~ /[\| -]+ > (\w+)\.(.*)$/) {
			$file_name = $1;
			$function_name = $2;
			if ($function_name !~ /\(.*\)$/) {  # bug
				$function_name = $function_name."()";
			}
		}

		if (exists $functions_hash{$function_name}) {
			# if the function can be found in the hash
			$rest = $function_name." [".$functions_hash{$function_name}{"minsu"}."..".$functions_hash{$function_name}{"maxsu"}."]";
		} else {
			$rest = $function_name." [0..0]";		
			if ($file_name =~ /pst_stubs/) {
				$rest = $rest." (stubbed)";
			}
		}

		$depth = () = $start =~ /\|  /g;
		$depth--;

		if ( $next_token =~ /^(\|[\| -]+)/ ) {
			$next_start = $1;
			$next_depth = () = $next_start =~ /\|  /g;
			$next_depth--;
		}

		if ($next_depth == $depth) {
			print FH "|  " x $depth;
			print FH "$te $rest\n";
		} elsif ($next_depth > $depth) {
			print FH "|  " x $depth;
			print FH "$te $rest\n";
		} elsif ($next_depth < $depth) {
			print FH "|  " x $depth;
			print FH "$bend $rest\n";
		} else {
			print FH "|  " x $depth;
			print FH "$bend $rest\n";
		}

	} else { # if it's a regular line (containing function information)
		print "Unknown line format! $token\n";
	}

}
print FH "<pre>\n";
# Write HTML footer
print FH "</body>\n</html>\n";

# Close file handle
close(FH);
}

###################
##   Main part   ##
###################

read_args();

print "Reading the export file...";
if (!read_export()) {
	print "Error\nNo code metrics for stack usage found in the export file. Cannot continue.\n";
	exit 1;
} else {
	print "Ok\n";
}
print "Reading the report file...";
if (!read_report()) {
	print "Error\nTable for Call Tree information not found in the HTML file. Cannot continue.\n";
	exit 1;
} else {
	print "Ok\n";
}
print "Generating the output file...";
generate();
print "Ok\n";
print "File $output_file generated\n";

