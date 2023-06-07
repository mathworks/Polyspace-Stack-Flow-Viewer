# Polyspace Stack Flow Viewer

Polyspace Stack Flow Viewer is a Perl script showing the stack usage of a C or C++ program throughout the call tree of this program. 
It can be then used to help developers identify potential stack overflow issues or better understand the stack usage of C/C++ programs.

# Usage

The tool will read two files generated from Polyspace Code Prover results:
* an export file in tsv format
* a report in HTML format created using the report template CallHierarchy.rpt
It will then generate an HTML file showing the stack usage using thee call hierarchy of functions.

The stack usage computed by Polyspace is actually a minimum and maximum stack usage.
When the stack cannot be computed, a ? will be given.

arguments:
 export_file html_file

Example:
 
 extract.bat Result_List_cpp.txt cpp_example.html

 
The HTML output will contain the minimum and maximum stack usage for each function is the code metrics has been computed, other a ? will be given.

# Installation

# License

The license for Polyspace Access Utility is available in the LICENSE.TXT file in this GitHub repository.

# Community Support

[MATLAB Central](https://www.mathworks.com/matlabcentral)

Copyright 2023 The MathWorks, Inc.
