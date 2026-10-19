<#
.SYNOPSIS
    Automated startup script for the Cross-Architecture Legal Bill Summarization platform.

.DESCRIPTION
    Initializes the virtual environment, checks dependencies, and launches the FastAPI
    backend and Streamlit dashboard simultaneously with health checks and clean shutdown.

.PARAMETER OnlyAPI
    Launch only the FastAPI backend service on port 8000.

.PARAMETER OnlyDashboard
    Launch only the Streamlit dashboard on port 8501.

.PARAMETER ApiPort
    Port number for the FastAPI backend (default: 8000).

.PARAMETER DashboardPort
    Port number for the Streamlit dashboard (default: 8501).

.PARAMETER NoBrowser
    Do not automatically open the web browser.
#>

[CmdletBinding()]
param(
    [switch]$OnlyAPI,
    [switch]$OnlyDashboard,
    [int]$ApiPort = 8000,
    [int]$DashboardPort = 8501,
    [switch]$NoBrowser
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $ScriptDir

# Styling helper functions
function Write-Header {
    param([string]$Text)
    Write-Host "`n========================================================" -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor White
    Write-Host "========================================================`n" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Text)
    Write-Host "[OK] $Text" -ForegroundColor Green
}

function Write-Info {
    param([string]$Text)
    Write-Host "[INFO] $Text" -ForegroundColor Yellow
}

function Write-Err {
    param([string]$Text)
    Write-Host "[ERROR] $Text" -ForegroundColor Red
}

Write-Header "Cross-Architecture Legal Bill Summarization Platform"

# 1. Locate Virtual Environment
$VenvPython = Join-Path $ScriptDir ".venv\Scripts\python.exe"
$VenvUvicorn = Join-Path $ScriptDir ".venv\Scripts\uvicorn.exe"
$VenvStreamlit = Join-Path $ScriptDir ".venv\Scripts\streamlit.exe"

if (-not (Test-Path $VenvPython)) {
    Write-Info "Virtual environment not detected. Creating .venv..."
    python -m venv .venv
    Write-Success "Created virtual environment at .venv"
    
    Write-Info "Upgrading pip and installing requirements..."
    & $VenvPython -m pip install --upgrade pip
    & $VenvPython -m pip install -r requirements.txt
    Write-Success "Installed dependencies from requirements.txt"
} else {
    Write-Success "Found existing virtual environment at .venv"
}

# Verify critical executables
if (-not (Test-Path $VenvUvicorn)) {
    $VenvUvicorn = "$VenvPython -m uvicorn"
}
if (-not (Test-Path $VenvStreamlit)) {
    $VenvStreamlit = "$VenvPython -m streamlit"
}

$ProcessesToClean = @()

# Cleanup on exit
$cleanupBlock = {
    Write-Host "`nShutting down legal summarizer services..." -ForegroundColor Yellow
    foreach ($proc in $ProcessesToClean) {
        if ($proc -and -not $proc.HasExited) {
            try {
                Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
                Write-Host "Stopped process ID $($proc.Id)" -ForegroundColor DarkGray
            } catch {}
        }
    }
    Write-Host "Shutdown complete." -ForegroundColor Green
}

try {
    # 2. Launch FastAPI Backend
    if (-not $OnlyDashboard) {
        Write-Info "Starting FastAPI backend on http://localhost:$ApiPort..."
        
        $apiArgs = "src.api.app:app --host 127.0.0.1 --port $ApiPort --reload"
        $apiProcess = Start-Process -FilePath $VenvPython -ArgumentList "-m uvicorn $apiArgs" -PassThru -NoNewWindow
        $ProcessesToClean += $apiProcess

        # Health probe loop
        $healthy = $false
        $attempts = 0
        Write-Info "Waiting for FastAPI health endpoint to respond..."
        while (-not $healthy -and $attempts -lt 15) {
            Start-Sleep -Seconds 1
            $attempts++
            try {
                $response = Invoke-RestMethod -Uri "http://127.0.0.1:$ApiPort/api/health" -Method Get -TimeoutSec 2 -ErrorAction SilentlyContinue
                if ($response.status -eq "healthy") {
                    $healthy = $true
                }
            } catch {}
        }

        if ($healthy) {
            Write-Success "FastAPI backend is LIVE at http://localhost:$ApiPort (Docs: http://localhost:$ApiPort/docs)"
        } else {
            Write-Err "FastAPI health check timed out. Continuing startup..."
        }
    }

    # 3. Launch Streamlit Dashboard
    if (-not $OnlyAPI) {
        Write-Info "Starting Streamlit dashboard on http://localhost:$DashboardPort..."
        
        $browserFlag = if ($NoBrowser) { "--server.headless true" } else { "--server.headless false" }
        $dashArgs = "run src/dashboard/app.py --server.port $DashboardPort $browserFlag"
        
        if ($OnlyDashboard) {
            # Run in foreground if only dashboard requested
            & $VenvPython -m streamlit run src/dashboard/app.py --server.port $DashboardPort
        } else {
            # Run in background and open browser
            $dashProcess = Start-Process -FilePath $VenvPython -ArgumentList "-m streamlit $dashArgs" -PassThru -NoNewWindow
            $ProcessesToClean += $dashProcess
            
            Write-Success "Streamlit dashboard is LIVE at http://localhost:$DashboardPort"
            
            if (-not $NoBrowser) {
                Start-Sleep -Seconds 2
                Start-Process "http://localhost:$DashboardPort"
            }
            
            Write-Header "Services Running Successfully"
            Write-Host "  * FastAPI API Docs:    http://localhost:$ApiPort/docs" -ForegroundColor Cyan
            Write-Host "  * Streamlit Dashboard: http://localhost:$DashboardPort" -ForegroundColor Cyan
            Write-Host "`nPress Ctrl+C to terminate all services.`n" -ForegroundColor White
            
            # Keep script alive to handle Ctrl+C
            while ($true) {
                if ($apiProcess.HasExited) {
                    Write-Err "FastAPI backend exited unexpectedly (Exit code: $($apiProcess.ExitCode))."
                    break
                }
                if ($dashProcess.HasExited) {
                    Write-Err "Streamlit dashboard exited unexpectedly (Exit code: $($dashProcess.ExitCode))."
                    break
                }
                Start-Sleep -Seconds 1
            }
        }
    } elseif ($OnlyAPI) {
        Write-Header "FastAPI Running in Standalone Mode"
        Write-Host "  * API Docs: http://localhost:$ApiPort/docs" -ForegroundColor Cyan
        Write-Host "`nPress Ctrl+C to terminate.`n" -ForegroundColor White
        
        while (-not $apiProcess.HasExited) {
            Start-Sleep -Seconds 1
        }
    }
}
finally {
    & $cleanupBlock
}
