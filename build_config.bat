@echo off
REM =============================================
REM Avro Keyboard Build Configuration
REM =============================================

REM Version number for file naming
set VERSION=5.7.0

REM Path to RAD Studio installation
SET RADSTUDIO_VERSION=23.0
set RAD_STUDIO_PATH=%programfiles(x86)%\Embarcadero\Studio\%RADSTUDIO_VERSION%

REM Path to 7-Zip installation
set SEVENZIP_PATH=C:\Program Files\7-Zip

REM Build options (yes/no)
set BUILD_PORTABLE=yes
set BUILD_STANDARD=yes

REM Build 64-bit binaries (true/false)
set BUILD_X64=true


REM Get directory of this script
SET SCRIPT_DIR=%~dp0
REM Normalize by removing trailing backslash if present
IF "%SCRIPT_DIR:~-1%"=="\" SET SCRIPT_DIR=%SCRIPT_DIR:~0,-1%
SET PROJECT_ROOT=%SCRIPT_DIR%