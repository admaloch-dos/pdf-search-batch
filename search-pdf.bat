::Search for items in pdf

:: Loop for Florida Maps directory
@echo off
setlocal enabledelayedexpansion

:: Determine current location
set "main_location=%~dp0"

:: Set location to add word docs
set "pdf_location=%main_location%pdfs"

set desktop_location=%USERPROFILE%\Desktop

::Intro text
echo.
echo *********************************************
echo ******** Florida Memory PDF Search ********
echo *********************************************

echo.
echo Current User: %USERNAME%
echo.
echo Current mode: Search a list of pdfs for a search term and add the text that contains it to a text file.
echo.

:: Check if the pdf directory is empty
dir /b /s /a "%pdf_location%\" | findstr .>nul || (
    echo Unable to locate any pdf documents.
    echo Add files to the, "Add pdfs" folder, then double click enter to continue.
    pause >nul
    goto :LOOP
)

echo Instructions:
echo.
echo  --- 1. Enter a search term and hit enter
echo  --- 2. View search results in text document once search is completed
echo.

:: Set the file name with timestamp
set TIMESTAMP=%DATE:/=-%_%TIME::=-%
set TIMESTAMP=%TIMESTAMP: =%

set file_title="pdf-search"

set "file_name=%file_title%_%TIMESTAMP%"

set file_location=%main_location%\%file_name%.txt

:: Prompt user for Search Term
set /p name="Enter a search term: "

for %%F in ("%pdf_location%\*.pdf") do (
    echo Searching in file: %%F
    pdftotext "%%F" - | findstr /n /i /c:"%name%" > %file_location%
    if not errorlevel 1 (
        echo Name located
        for /f "delims=:" %%P in ('type %file_location%') do (
            set /a start_line=%%P-3
            set /a end_line=%%P+3
        )
    )
)

echo.
echo Search completed
echo.
echo Press any key to exit
pause >nul

endlocal