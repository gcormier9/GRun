@echo off
SET SRCFOLDER=..\..\Git\GRun
SET DESTFOLDER=%cd%
cd /D "%DESTFOLDER%"

echo "Delete folders into: %DESTFOLDER%"
FOR /D %%d IN ("%DESTFOLDER%\*.*") DO RMDIR "%%d" /s /q
IF EXIST "monkey.jungle" DEL /q "monkey.jungle"
pause

echo "Create folders into: %DESTFOLDER%"
FOR /F "delims=" %%d in ('dir "%SRCFOLDER%" /ad /b') DO (
  IF "%%d" == ".git" (
   REM SKIP folder
  ) ELSE IF "%%d" == "doc" (
   REM SKIP folder
  ) ELSE (
    MKDIR "%DESTFOLDER%\%%d"
  )
)
pause

echo "Copy files from: %SRCFOLDER%"
cd /D "%SRCFOLDER%"
COPY "monkey.jungle" "%DESTFOLDER%\"
FOR /F "delims=" %%d in ('dir "%SRCFOLDER%" /ad /b') DO (
  IF "%%d" == "doc" (
   REM SKIP folder
  ) ELSE IF "%%d" == ".git" (
   REM SKIP folder
  ) ELSE IF "%%d" == "bin" (
   REM SKIP folder
  )ELSE (
    XCOPY /s "%%d" "%DESTFOLDER%\%%d"
  )
)

echo.
echo "Copy <iq:products in file: %DESTFOLDER%\manifest.xml"
echo "Change AppName in file: %DESTFOLDER%\resources\strings\strings.xml"
echo.
pause
"C:\Program Files\Notepad++\notepad++.exe" "%DESTFOLDER%\resources\strings\strings.xml"