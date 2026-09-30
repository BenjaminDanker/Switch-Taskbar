# SwitchTaskbar

A small Windows PowerShell utility that moves the taskbar to the bottom of selected monitor. It runs at sign-in after installation. When the taskbar position changes, Windows Explorer is restarted to apply it.

## Install

Open PowerShell in this folder and run:

```powershell
.\Setup.ps1  install
```

The setup copies the script to `%LOCALAPPDATA%\SwitchTaskbar` and adds a launcher to your Startup folder. The computer must have at least two detected displays.

## Uninstall

```powershell
.\Setup.ps1 uninstall
```

This removes the installed script and startup launcher. It does not move the taskbar back to another display.
