@echo off
REM Builds Plotweaver with debug info, then opens it in RAD Debugger.
REM   debug.bat        open the debugger (press F5 to start the game)
REM   debug.bat run    open the debugger and start the game immediately
REM Works from any folder: it always builds and launches from the project root,
REM so the game finds assets/ the same way it does under run.bat.
setlocal
pushd "%~dp0"

REM Same flags as run.bat, but `build` only compiles, it doesn't run or delete the exe.
odin build src -collection:pw=src -out:bin/plotweaver.exe -debug
if errorlevel 1 goto :fail

REM Prefer raddbg on PATH; fall back to the install folder for terminals opened before PATH changed.
set "RADDBG=raddbg.exe"
where raddbg.exe >nul 2>nul || set "RADDBG=F:\raddbg\raddbg.exe"

set "AUTORUN="
if /i "%~1"=="run" set "AUTORUN=--auto_run"

REM `start` returns control to the terminal; the debugger inherits this folder as the game's working dir.
start "" "%RADDBG%" %AUTORUN% "%CD%\bin\plotweaver.exe"
popd
exit /b 0

:fail
echo Build failed, not launching the debugger.
popd
exit /b 1
