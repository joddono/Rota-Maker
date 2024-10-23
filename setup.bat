@echo off
echo Setting up the Python environment...

:: Check if Python is installed
python --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Python is not installed. Downloading and installing Python 3.8+...

    :: Download Python installer
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://www.python.org/ftp/python/3.9.9/python-3.9.9-amd64.exe', 'python_installer.exe')"

    echo Installing Python...
    start /wait python_installer.exe /quiet InstallAllUsers=1 PrependPath=1

    :: Verify installation
    python --version >nul 2>&1
    if %ERRORLEVEL% neq 0 (
        echo Python installation failed. Please install Python manually and rerun the setup.
        exit /b 1
    )
    echo Python installed successfully.
)

:: Create requirements.txt if it doesn't exist
if not exist requirements.txt (
    echo Creating requirements.txt...
    (
        echo customtkinter
        echo pillow
        echo openpyxl
        echo cryptography
        echo bcrypt
        echo python-dateutil
        echo matplotlib
    ) > requirements.txt
)

:: Install necessary Python packages from requirements.txt
echo Installing dependencies from requirements.txt...
pip install -r requirements.txt

:: Check for SQLite database file and create if necessary
if not exist Rota_Maker.db (
    echo Creating SQLite database...
    python -c "import sqlite3; conn = sqlite3.connect('Rota_Maker.db'); conn.close();"
)

echo Setup complete. You can now run the application with python main.py