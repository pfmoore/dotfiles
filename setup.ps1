# Set basic configuration variables
[Environment]::SetEnvironmentVariable("WORK_DIRECTORY", "C:\Work\Scratch", "User")

# PATH should have
#   ~/.local/scripts
#   ~/.local/bin
# in that order

#========================================
# $paths = (
#     [Environment]::GetEnvironmentVariable("PATH", "User") -split ";" |
#     Where-Object { $_ -notlike "$env:USERPROFILE\.local\*" }
# ) -join ";"
#
# $local = (
#     ("scripts", "bin") | Foreach-Object { Join-Path $env:USERPROFILE ".local" $_ }
# ) -join ";"
#
# [Environment]::SetEnvironmentVariable("PATH", "$local;$paths", "User")
#========================================

# PATHEXT should have .PY and .PYZ

# Install our preferred Powershell modules

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Package Posh-Git
Install-Package Use-RawPipeline

# We expect the following to be installed:
#   - Python
#   - Cygwin

# Install scoop

Invoke-WebRequest -UseBasicParsing get.scoop.sh | Invoke-Expression
scoop install git
scoop update
scoop update *
scoop bucket add extras
scoop bucket add enk https://github.com/pfmoore/scoop-enk
scoop bucket add pipx https://github.com/uranusjr/pipx-standalone

# Persistent data
# Copy persist from dotfiles to ~/scoop

# Installed as a prerequisite for git
# scoop install 7zip

scoop install bat
scoop install curl
scoop install fd
scoop install fzf
scoop install goawk
scoop install graphviz
scoop install jq
scoop install just
scoop install monaco
scoop install pandoc
scoop install pup
scoop install ripgrep
scoop install spigot
scoop install sqlite
scoop install wget
scoop install wkhtmltopdf
scoop install xsv

scoop install keypirinha
scoop install digraphmgr
scoop install cyg
scoop install volt
scoop install vim

scoop install keepass
scoop install keepass-plugin-keeanywhere

scoop install pipx

pipx install black
pipx install flake8
pipx install howdoi
pipx install invoke
pipx install mypy
pipx install nox
pipx install pew
pipx install pip-run
pipx install pipenv
pipx install shiv
pipx install tox
pipx install virtualenv

# The following need configuring:
#   7-zip:
#       Associations
#       Editor = C:\Users\...\gvim.exe
#   vim:
#       copy -rec dotfiles/volt ~/volt
#       volt get -l
#   keepass:
#       Open database from Google Cloud
#   VS Code:
#       Install Settings Sync
#       Configure it with info from keepass