# =============================
# Configuration Variables
# =============================

# Use a configuration file to store sensitive data
$configPath = Join-Path $PSScriptRoot "config.json"
$config = Get-Content $configPath -Raw | ConvertFrom-Json

# Configuration variables from JSON
$serverFolder = $config.serverFolder
$localFolder = $config.localFolder
$ppkFilePath = $config.ppkFilePath
$username = $config.username
$serverIP = $config.serverIP
$pscpPath = $config.pscpPath
$logFile = Join-Path $PSScriptRoot "logs\$(Get-Date -Format 'yyyy-MM-dd')-copy_log.txt"

# Create logs directory if it doesn't exist
$logDir = Split-Path $logFile -Parent
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

# =============================
# Function Definitions
# =============================

function Write-Log {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Message,
        [ValidateSet('INFO', 'WARNING', 'ERROR')]
        [string]$Level = 'INFO'
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $formattedMessage = "[$timestamp] [$Level] $Message"
    
    # Write to console with appropriate color
    switch ($Level) {
        'ERROR'   { Write-Host $formattedMessage -ForegroundColor Red }
        'WARNING' { Write-Host $formattedMessage -ForegroundColor Yellow }
        'INFO'    { Write-Host $formattedMessage -ForegroundColor Green }
    }
    
    # Write to log file
    Add-Content -Path $logFile -Value $formattedMessage
}

function Test-Prerequisites {
    $prerequisites = @(
        @{ Path = $pscpPath; Type = "PSCP executable" },
        @{ Path = $ppkFilePath; Type = "PPK key file" },
        @{ Path = $configPath; Type = "Configuration file" }
    )

    $allValid = $true
    foreach ($item in $prerequisites) {
        if (-not (Test-Path -Path $item.Path)) {
            Write-Log -Level ERROR -Message "$($item.Type) not found at path: $($item.Path)"
            $allValid = $false
        }
    }

    return $allValid
}

function Initialize-LocalFolder {
    if (-not (Test-Path -Path $localFolder)) {
        try {
            New-Item -ItemType Directory -Path $localFolder -Force | Out-Null
            Write-Log -Message "Created local folder: $localFolder"
        }
        catch {
            Write-Log -Level ERROR -Message "Failed to create local folder: $_"
            return $false
        }
    }
    return $true
}

function Start-FileSync {
    $pscpArguments = @(
        "-batch",                                   # Disable all interactive prompts
        "-i", $ppkFilePath,                        # Specify the PPK key file
        "-r",                                      # Recursive copy
        "-p",                                      # Preserve file attributes
        "${username}@${serverIP}:${serverFolder}*", # Source
        $localFolder                               # Destination
    )

    try {
        $process = Start-Process -FilePath $pscpPath -ArgumentList $pscpArguments -Wait -NoNewWindow -PassThru
        return $process.ExitCode
    }
    catch {
        Write-Log -Level ERROR -Message "Failed to execute PSCP: $_"
        return 1
    }
}

# =============================
# Main Execution
# =============================

# Error handling
$ErrorActionPreference = "Stop"

try {
    # Check prerequisites
    if (-not (Test-Prerequisites)) {
        exit 1
    }

    # Initialize local folder
    if (-not (Initialize-LocalFolder)) {
        exit 1
    }

    # Start sync process
    Write-Log -Message "Starting file synchronization..."
    $exitCode = Start-FileSync

    # Handle results
    if ($exitCode -eq 0) {
        Write-Log -Message "Files synchronized successfully from ${serverIP}:${serverFolder} to ${localFolder}"
    }
    else {
        Write-Log -Level ERROR -Message "Synchronization failed with exit code $exitCode"
        exit $exitCode
    }
}
catch {
    Write-Log -Level ERROR -Message "Unexpected error: $_"
    exit 1
}