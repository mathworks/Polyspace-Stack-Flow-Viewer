#!/bin/bash

# Copyright

# Check if there are any arguments
if [ "$#" -eq 0 ]; then 
  echo Usage:
  echo  $0 EXPORT_FILE REPORT_FILE
  echo  where EXPORT_FILE is an export of Polyspace results in tsv format
  echo  and REPORT_FILE is a Polyspace report in HTML format created with the Call_Hierarchy template.
  echo  Or
  echo  $0 -h
  echo  to see the help
  exit 1
fi

# Call the Perl script with the arguments
perl extract.pl "$@"


