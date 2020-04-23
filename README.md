# My configuration files

This repository holds my various config files ("dotfiles") so that
I can share them across machines.

## Configuration File Locations

### Windows Terminal

Windows Terminal stores its application data in the directory

```
$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState
```

The `profiles.json` file is stored there, as well as other files that are referenced from the profile using `ms-appdata:///Local/...`

Documentation on the settings file is at https://aka.ms/terminal-documentation.

### Powershell Core

Powershell Core stores its main profile file in the directory `PowerShell` under the user's "Documents" directory (which can be found using Powershell as `[Environment]::GetFolderPath("MyDocuments")`). The profile is named `Microsoft.PowerShell_profile.ps1`.

The `Modules` subdirectory contains local modules, and is added to `$env:PSModulePath` by default.

Windows Powershell is similar, but uses the directory `WindowsPowershell`.

## Things I Want To Configure

### Windows Terminal

* Colour scheme
* Background image
* Startup folder
* Font
* Default profile
* Maximize on start
* Word delimiters for double click
* Extra profiles
* Key bindings
  * Open new tab
  * Switch between tabs
  * Split pane

### Powershell

* Prompt
* PSReadLine keys
* Custom modules
  * Posh-Git
  * Oh-My-Posh - Make custom theme
  * Use-RawPipeline
  * powershell-yaml
  * pscx
  * psake
* Custom completion for pip

### Visual Studio Code

Not sure what yet, still considering how to transition from Vim

### Software

Auto-update of scoop, vim, cygwin, pipx.
Automatically add Keypirinha and DigraphMgr to "autostart".

Cygwin setup has command line options. See [here](https://cygwin.com/faq/faq.html#faq.setup.automated) and [here](https://gist.github.com/wjrogers/1016065/385cfab346638f9d99b15e93eeda61ff1ae0a6c5).