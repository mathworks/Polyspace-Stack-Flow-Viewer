@echo off

:: Check if there are any arguments
if "%~1" == "" (
  echo Usage:
  echo  %~n0 EXPORT_FILE REPORT_FILE
  echo  where EXPORT_FILE is an export of Polyspace results in tsv format
  echo  and REPORT_FILE is a Polyspace report in HTML format created with the Call_Hierarchy template.
  echo  Or
  echo  %~n0 -h
  echo  to see the help
  exit /b 2
)

set PERL_ARGS=%*

:: Call the Perl script with the arguments
::"E:\Program Files\MATLAB\R2018a\sys\perl\win32\bin\perl.exe" extract.pl Result_List_cpp.txt cpp_example.html
::"E:\Program Files\MATLAB\R2018a\sys\perl\win32\bin\perl.exe" extract.pl Result_List_Dassault.txt dassault_file.html
"E:\Program Files\MATLAB\R2018a\sys\perl\win32\bin\perl.exe" extract.pl Result_List.txt code_prover_demo.html


::"E:\Program Files\MATLAB\R2018a\sys\perl\win32\bin\perl.exe" extract.pl "%PERL_ARGS%"
