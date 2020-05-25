copy -force dotfiles/.gitconfig ~/.gitconfig 
copy -force dotfiles/Powershell/PowerShell.ps1 ~/.local/config/PowerShell.ps1
$terminal_settings = (Resolve-Path $env:LOCALAPPDATA\Packages\*Terminal*\LocalState).Path
# Breaks because background image is in use
copy -force dotfiles/WindowsTerminal/* $terminal_settings
del -rec ~/volt
copy -rec dotfiles/volt ~/volt
volt get -l
# Breaks if keypirinha is running
del -rec -force ~/scoop/persist
copy -rec dotfiles/scoop/persist ~/scoop/persist
if ([Environment]::GetEnvironmentVariable("WORK_DIRECTORY", "User") -eq $null) {
    Write-Host -ForegroundColor Red "You need to set the environment variable WORK_DIRECTORY"
}