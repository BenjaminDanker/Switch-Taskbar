param(
    [ValidateSet("install", "uninstall")]
    [string]$Action = "install"
)

$ErrorActionPreference = "Stop"

$InstallDir = Join-Path $env:LOCALAPPDATA "SwitchTaskbar"
$StartupDir = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs\Startup"

$SourceScript = Join-Path $PSScriptRoot "SwitchTaskbar.ps1"
$SourceCmd    = Join-Path $PSScriptRoot "SwitchTaskbar.cmd"

$InstalledScript = Join-Path $InstallDir "SwitchTaskbar.ps1"
$InstalledCmd    = Join-Path $StartupDir "SwitchTaskbar.cmd"

try {
    switch ($Action) {
        "install" {
            # Make sure the required source files actually exist
            if (-not (Test-Path $SourceScript)) {
                throw "Missing source file: $SourceScript"
            }

            if (-not (Test-Path $SourceCmd)) {
                throw "Missing source file: $SourceCmd"
            }

            # Create application directory if needed
            New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null

            # Install files
            Copy-Item $SourceScript $InstalledScript -Force
            Copy-Item $SourceCmd $InstalledCmd -Force

            Write-Host "SwitchTaskbar installed successfully."
            Write-Host "Script:  $InstalledScript"
            Write-Host "Startup: $InstalledCmd"
        }

        "uninstall" {
            # Only remove files owned by SwitchTaskbar
            if (Test-Path $InstalledScript) {
                Remove-Item $InstalledScript -Force
            }

            if (Test-Path $InstalledCmd) {
                Remove-Item $InstalledCmd -Force
            }

            # Remove the directory only if it is now empty
            if (
                (Test-Path $InstallDir) -and
                -not (Get-ChildItem $InstallDir -Force | Select-Object -First 1)
            ) {
                Remove-Item $InstallDir -Force
            }

            Write-Host "SwitchTaskbar uninstalled successfully."
        }
    }
}
catch {
    Write-Error "SwitchTaskbar setup failed: $($_.Exception.Message)"
    exit 1
}