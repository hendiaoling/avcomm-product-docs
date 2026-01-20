@echo off
setlocal

:: 获取脚本目录和项目根目录
set "SCRIPT_DIR=%~dp0"
set "PROJECT_ROOT=%SCRIPT_DIR%.."

echo Starting AsciiDoc to Word (.docx) conversion...
echo Project Root: %PROJECT_ROOT%

if not exist "%PROJECT_ROOT%\docs" (
    echo Error: 'docs' directory not found.
    pause
    exit /b 1
)

for %%f in ("%PROJECT_ROOT%\docs\*.adoc") do (
    echo Converting %%f to Word...
    
    :: 1. adoc -> xml (DocBook)
    call asciidoctor -b docbook "%%f" -o "%%~dpnxf.xml"
    
    :: 2. xml -> docx
    if exist "%%~dpnxf.xml" (
        pandoc "%%~dpnxf.xml" -f docbook -t docx -o "%%~dpnxf.docx"
        del "%%~dpnxf.xml"
        echo  - Generated: %%~dpnxf.docx
    ) else (
        echo  - Failed to generate DocBook XML.
    )
)

echo Conversion complete.
pause