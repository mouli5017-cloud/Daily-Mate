@echo off
REM ============================================================
REM  DailyMate - Single-launcher batch file
REM  Sets up the environment (if needed) and starts the app.
REM ============================================================
setlocal EnableDelayedExpansion
cd /d "%~dp0"

echo.
echo =====================================================
echo   DailyMate - Personal Notes ^& Task Reminders
echo =====================================================
echo.

REM ---------- Find Python ----------
set "PYTHON="
where py >nul 2>nul && set "PYTHON=py -3"
if not defined PYTHON where python >nul 2>nul && set "PYTHON=python"
if not defined PYTHON (
    echo [ERROR] Python was not found on this machine.
    echo         Install Python 3.11+ from https://www.python.org and try again.
    pause
    exit /b 1
)

echo [1/4] Python: !PYTHON!

REM ---------- Create virtual environment (first run only) ----------
if not exist ".venv\Scripts\python.exe" (
    echo [2/4] Creating virtual environment .venv ...
    !PYTHON! -m venv .venv
    if errorlevel 1 (
        echo [ERROR] Failed to create virtual environment.
        pause
        exit /b 1
    )
) else (
    echo [2/4] Virtual environment found (.venv)
)
set "VENV_PYTHON=.venv\Scripts\python.exe"

REM ---------- Install / verify dependencies ----------
echo [3/4] Checking dependencies ...
"%VENV_PYTHON%" -c "import customtkinter, plyer, win10toast, pyttsx3" 2>nul
if errorlevel 1 (
    echo       Installing dependencies from requirements.txt ...
    "%VENV_PYTHON%" -m pip install -r requirements.txt
    if errorlevel 1 (
        echo [ERROR] Failed to install dependencies.
        pause
        exit /b 1
    )
) else (
    echo       Dependencies already installed.
)

REM ---------- Launch the app ----------
echo [4/4] Launching DailyMate ...
echo.
"%VENV_PYTHON%" main.py
set "EXIT_CODE=%ERRORLEVEL%"

if not "%EXIT_CODE%"=="0" (
    echo.
    echo [NOTE] DailyMate exited with code %EXIT_CODE%.
    pause
)

endlocal