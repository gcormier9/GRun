@echo off

REM IF "%~1"=="-FIXED_CTRL_C" (
REM    REM Remove the -FIXED_CTRL_C parameter
REM    SHIFT
REM ) ELSE (
REM    REM Run the batch with <NUL and -FIXED_CTRL_C
REM    CALL <NUL %0 -FIXED_CTRL_C %*
REM    GOTO :EOF
REM )


SET CONNECTIQ_HOME=C:\Source\Git\Connect-IQ SDK\connectiq-sdk-win-3.1.8-2020-03-04-e5981d10b
cd "%CONNECTIQ_HOME%\bin"

echo Start Simulator Application
start "Simulator" simulator.exe

REM Low Mem Devices
echo ----------------------------------------
echo Running Simulator on low-memory devices
echo ----------------------------------------

FOR %%d IN (
  edge130
  fenix5
  fenix5s
  fenix6
  fenix6s
  fenixchronos
  fr245
  fr245m
  fr645
  fr935
  legacyherocaptainmarvel
  legacyherofirstavenger
  legacysagadarthvader
  legacysagarey
  venu
  vivoactive3
  vivoactive3d
  vivoactive3m
  vivoactive3mlte
  vivoactive4
  vivoactive4s
) DO (
  CALL :RUN_SIMULATOR "%%d"
)

REM High Mem Devices
echo ----------------------------------------
echo Running Simulator on high-memory devices
echo ----------------------------------------

FOR %%d IN (
  approachs62
  d2charlie
  d2delta
  d2deltapx
  d2deltas
  descentmk1
  edge520plus
  edge530
  edge820
  edge830
  edge1030
  edge1030bontrager
  edgeexplore
  fenix5plus
  fenix5splus
  fenix5x
  fenix5xplus
  fenix6pro
  fenix6spro
  fenix6xpro
  fr645m
  fr945
  marqadventurer
  marqathlete
  marqaviator
  marqcaptain
  marqcommander
  marqdriver
  marqexpedition
  oregon7xx
  rino7xx
) DO (
  CALL :RUN_SIMULATOR "%%d"
)

GOTO :eof

:RUN_SIMULATOR
echo.
echo %~1
echo  + Compile
java -cp monkeybrains.jar com.garmin.monkeybrains.Monkeybrains -d %1 -f C:\Source\Git\GRun\monkey.jungle -o C:\Source\Git\GRun\bin\GRun.prg -y "C:\Source\Git\Connect-IQ SDK\developer_key"
REM monkeyc.bat -d %%d -f C:\Source\Git\GRun\monkey.jungle -o C:\Source\Git\GRun\bin\GRun.prg -y "C:\Source\Git\Connect-IQ SDK\developer_key"

echo  + Run
start %1 java -cp monkeybrains.jar com.garmin.monkeybrains.monkeydodeux.MonkeyDoDeux -f C:\Source\Git\GRun\bin\GRun.prg -d %1 -s shell.exe
REM monkeydo.bat C:\Source\Git\GRun\bin\GRun.prg %%d

pause

tasklist /FI "IMAGENAME eq Simulator.exe" 2>NUL | find /I /N "Simulator">NUL
if errorlevel 1 (
  echo Restart Simulator Application
  start "Simulator" simulator.exe
  GOTO RUN_SIMULATOR %1
)

