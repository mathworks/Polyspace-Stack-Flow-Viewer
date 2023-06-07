# Polyspace Stack Flow Viewer

Polyspace Stack Flow Viewer is a Perl script showing the stack usage of a C or C++ program throughout the call tree of this program. 
It can be then used to help developers identify potential stack overflow issues or better understand the stack usage of C/C++ programs.

# Usage

The tool will merge an export file (in tsv format) of a Polyspace® Code Prover&trade; results and a report in HTML format created using the report template CallHierarchy.rpt to procude an HTML file showing the stack usage using thee call hierarchy of functions.


The stack usage metrics computed by Polyspace is shown by a range of the minimum and maximum stack usage.
Please note that when the stack cannot be computed, a ? will be given instead.

# Installation

Perl should be installed on the platform where the tool will be used.

If the script is used under Windows, first edit the script stack_flow_viewer.bat to specify the path to your Perl installation at the second line by modifying the variable PATH_PERL so it contains the absolute path to the bin folder of your Perl installation.

# Calling the tool

Under Windows, launch:

 stack_flow_viewer.bat export_file html_report_file

Under Linux, launch:

 stack_flow_viewer.sh export_file html_report_file

Example:

``` 
 stack_flow_viewer.sh Result_List_cpp.txt cpp_example.html
```

The tool will generate an HTML file named output.html.

# License

The license for Polyspace Stack Flow Viewer is available in the LICENSE.TXT file in this GitHub repository.

# Community Support

[MATLAB Central](https://www.mathworks.com/matlabcentral)

Copyright 2023 The MathWorks, Inc.
