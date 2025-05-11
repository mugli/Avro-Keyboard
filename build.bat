
@echo off
setlocal enabledelayedexpansion

REM =============================================
REM Avro Keyboard Build Script
REM =============================================
echo Avro Keyboard Build Script
echo =============================================

REM ---------------------------------------------
REM Load configuration
REM ---------------------------------------------
echo Loading configuration...
call build_config.bat
if %errorlevel% neq 0 (
    echo Failed to load configuration.
    exit /b %errorlevel%
)

REM ---------------------------------------------
REM Initialize MS Build
REM ---------------------------------------------
echo Initializing MS Build environment...
set RSVARS_PATH=%RAD_STUDIO_PATH%\bin\rsvars.bat
if not exist %RSVARS_PATH% (
    echo ERROR: RAD Studio environment not found at %RAD_STUDIO_PATH%
    echo Please check RAD_STUDIO_PATH in build_config.bat
    goto :error
)

call %RSVARS_PATH%

echo.
echo =============================================
echo Build process completed successfully!
echo =============================================
goto :end

:error
echo.
echo =============================================
echo ERROR: Build process failed!
echo =============================================
exit /b 1

:end
endlocal
exit /b 0