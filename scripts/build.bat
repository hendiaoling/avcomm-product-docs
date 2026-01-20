@echo off
setlocal

:: 获取脚本文件所在的目录 (例如 d:\...\scripts\)
set "SCRIPT_DIR=%~dp0"
:: 获取项目根目录 (脚本目录的上一级)
set "PROJECT_ROOT=%SCRIPT_DIR%.."

echo Starting AsciiDoc to Markdown conversion...
echo Project Root: %PROJECT_ROOT%

if not exist "%PROJECT_ROOT%\docs" (
    echo Error: 'docs' directory not found at "%PROJECT_ROOT%\docs".
    pause
    exit /b 1
)

for %%f in ("%PROJECT_ROOT%\docs\*.adoc") do (
    echo Converting %%f...
    
    :: 1. 使用 Asciidoctor 将 .adoc 转为 .xml (DocBook)
    call asciidoctor -b docbook "%%f" -o "%%~dpnxf.xml"
    
    :: 2. 使用 Pandoc 将 .xml 转为 .md (GitHub Flavored Markdown)
    if exist "%%~dpnxf.xml" (
        pandoc "%%~dpnxf.xml" -f docbook -t gfm -o "%%~dpnxf.md"
        :: 删除中间生成的 xml 文件
        del "%%~dpnxf.xml"
        echo  - Generated: %%~dpnxf.md
    ) else (
        echo  - Failed to convert to DocBook.
    )
)

echo Conversion complete.
pause