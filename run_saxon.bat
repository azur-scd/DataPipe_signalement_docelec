@echo off
:: PREREQUISITES:
:: saxon9he.jar must be installed

:: USAGE:
:: run_saxon.bat stylesheet.xsl source.xml output.xml x

set STYLESHEET=%1
set SOURCE=%2
set OUTPUT=%3

java -jar "saxon-he-9.4.0.7.jar" ^
     -xsl:%STYLESHEET% -s:%SOURCE% -o:%OUTPUT%