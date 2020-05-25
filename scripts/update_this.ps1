copy -force ~/.gitconfig dotfiles/.gitconfig
copy -force ~/.local/config/PowerShell.ps1 dotfiles/Powershell
copy -force $env:LOCALAPPDATA\Packages\*Terminal*\LocalState\* dotfiles/WindowsTerminal
copy -force ~/volt/lock.json dotfiles/volt/lock.json
copy -force -rec ~/volt/plugconf dotfiles/volt
copy -force -rec ~/volt/rc dotfiles/volt
copy -force -rec ~/scoop/persist dotfiles/scoop -exclude "*.$env:ComputerName.*log", Keypirinha.history
