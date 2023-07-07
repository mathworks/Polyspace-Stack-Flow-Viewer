:: Copyright (c) 2023 The MathWorks, Inc.
:: All Rights Reserved.
::
:: Permission is hereby granted, free of charge, to any person obtaining a copy
:: of this software and associated documentation files (the "Software"), to deal
:: in the Software without restriction, including without limitation the rights
:: to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
::
:: The above copyright notice and this permission notice shall be included in
:: all copies or substantial portions of the Software.:x
::
:: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
:: IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
:: FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
:: AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
:: LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM
:: OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
:: THE SOFTWARE.

@echo off
set PATH_PERL=E:\Program Files\MATLAB\R2018a\sys\perl\win32\bin

set argCount=0
for %%x in (%*) do (
   set /A argCount+=1
   set "argVec[!argCount!]=%%~x"
)

:: Check if there are any arguments
if %argCount% == 0 (
  echo Usage:
  echo  %~n0 EXPORT_FILE REPORT_FILE
  echo  where EXPORT_FILE is an export of Polyspace results in tsv format
  echo  and REPORT_FILE is a Polyspace report in HTML format created with the Call_Hierarchy template.
  echo  Or
  echo  %~n0 -h
  echo  to see the help
  exit /b 2
)

set SCRIPT_ARGS=%*

:: Call the Perl script with the arguments
"%PATH_PERL%/perl.exe" stack_flow_viewer.pl %SCRIPT_ARGS%
