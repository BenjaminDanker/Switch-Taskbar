Add-Type -AssemblyName System.Windows.Forms

function Set-TaskbarMonitor {
    param(
        [int]$Monitor = 2
    )

    $screens = [System.Windows.Forms.Screen]::AllScreens

    if ($Monitor -lt 1 -or $Monitor -gt $screens.Count) {
        throw "Monitor must be between 1 and $($screens.Count)."
    }

    $screen = $screens[$Monitor - 1]

    $Path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'
    $Settings = (Get-ItemProperty $Path -Name Settings).Settings

    # Fixed byte offsets in the StuckRects3 Settings structure
    $OffsetLeft   = 24
    $OffsetTop    = 28
    $OffsetRight  = 32
    $OffsetBottom = 36

    # Read current taskbar rectangle
    $CurrentLeft   = [BitConverter]::ToInt32($Settings, $OffsetLeft)
    $CurrentTop    = [BitConverter]::ToInt32($Settings, $OffsetTop)
    $CurrentRight  = [BitConverter]::ToInt32($Settings, $OffsetRight)
    $CurrentBottom = [BitConverter]::ToInt32($Settings, $OffsetBottom)

    # Preserve current taskbar height
    $TaskbarHeight = [Math]::Abs($CurrentBottom - $CurrentTop)

    # Desired taskbar position: bottom of selected monitor
    $Left   = $screen.Bounds.Left
    $Right  = $screen.Bounds.Right
    $Bottom = $screen.Bounds.Bottom
    $Top    = $Bottom - $TaskbarHeight

    # Only update if the taskbar is not already on the selected monitor
    if (
        $CurrentLeft   -ne $Left   -or
        $CurrentTop    -ne $Top    -or
        $CurrentRight  -ne $Right  -or
        $CurrentBottom -ne $Bottom
    ) {
        [BitConverter]::GetBytes([int]$Left).CopyTo($Settings, $OffsetLeft)
        [BitConverter]::GetBytes([int]$Top).CopyTo($Settings, $OffsetTop)
        [BitConverter]::GetBytes([int]$Right).CopyTo($Settings, $OffsetRight)
        [BitConverter]::GetBytes([int]$Bottom).CopyTo($Settings, $OffsetBottom)

        Set-ItemProperty $Path -Name Settings -Value $Settings

        Get-Process explorer -ErrorAction SilentlyContinue | Stop-Process
    }
}

Set-TaskbarMonitor 2