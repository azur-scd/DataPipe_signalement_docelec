@echo off
:: PREREQUISITES:
:: saxon9he.jar must be installed

:: USAGE:
:: saxon.bat stylesheet.xsl source.xml output.xml

set STYLESHEET=%1
set SOURCE=%2
set OUTPUT=%3

java -jar "C:\Program Files\Kernow 1.8.0.1\lib\saxon9he.jar" ^
     -xsl:%STYLESHEET% -s:%SOURCE% -o:%OUTPUT%