# =============================
# Configuration Variables
# =============================

# Path to the source folder on the Ubuntu server
$serverFolder = '/path/to/source/folder/'

# Path to the local destination folder on Windows
$localFolder = 'D:\Path\To\Local\Destination'

# Path to the PPK key file for authentication
$ppkFilePath = 'C:\Path\To\Your\keyfile.ppk'

# Ubuntu server credentials
$username = 'your_username'                  # Your server username
$serverIP = 'your.server.ip.address'         # Your server's IP address

# Path to the pscp executable
$pscpPath = 'C:\Path\To\PuTTY\pscp.exe'

# Log file path (optional)
$logFile = 'D:\Path\To\Log\copy_log.txt'

# =============================
# Function Definitions
# =============================

# Function to log messages
function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $formattedMessage = "[$timestamp] $message"
    Write-Host $formattedMessage
    $formattedMessage | Out-File -FilePath $logFile -Append
}

# =============================
# Pre-Execution Checks
# =============================

# Verify that pscp.exe exists
if (-not (Test-Path -Path $pscpPath)) {
    Log-Message "ERROR: pscp.exe not found at path: $pscpPath"
    exit 1
}

# Ensure the PPK key file exists
if (-not (Test-Path -Path $ppkFilePath)) {
    Log-Message "ERROR: PPK key file not found at path: $ppkFilePath"
    exit 1
}

# Ensure the local destination folder exists; create it if it doesn't
if (-not (Test-Path -Path $localFolder)) {
    try {
        New-Item -ItemType Directory -Path $localFolder -Force | Out-Null
        Log-Message "Created local folder: $localFolder"
    }
    catch {
        Log-Message "ERROR: Failed to create local folder: $_"
        exit 1
    }
}

# =============================
# Execute pscp Command
# =============================

# Construct the pscp command arguments without unnecessary quotes
$pscpArguments = @(
    "-i", "${ppkFilePath}",                     # Specify the PPK key file
    "-r",                                       # Recursive copy
    "-p",                                       # Preserve file attributes (timestamps, etc.)
    "${username}@${serverIP}:${serverFolder}*",  # Source: username@serverIP:/path/to/source/*
    "${localFolder}"                            # Destination: D:\Path\To\Local\Destination
)

# Optional: Display the command for debugging purposes
# Uncomment the line below to see the exact command being executed
# Log-Message "Executing command: `"$pscpPath`" $($pscpArguments -join ' ')"

# Execute the pscp command using the call operator (&)
try {
    & "$pscpPath" $pscpArguments
    $exitCode = $LASTEXITCODE
}
catch {
    Log-Message "ERROR: An error occurred while executing pscp: $_"
    exit 1
}

# =============================
# Post-Execution Handling
# =============================

# Check if pscp executed successfully
if ($exitCode -eq 0) {
    Log-Message "SUCCESS: Files copied successfully from ${serverIP}:${serverFolder} to ${localFolder}."
}
else {
    Log-Message "ERROR: pscp failed with exit code $exitCode."
    exit $exitCode
}

# =============================
# Optional: Further Processing
# =============================

# Add any additional actions here, such as processing copied files or sending notifications.
