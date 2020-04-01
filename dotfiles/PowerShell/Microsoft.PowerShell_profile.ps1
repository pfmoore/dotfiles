# Remove badly-chosen default aliases
Remove-Item -Force -ErrorAction SilentlyContinue alias:curl
Remove-Item -Force -ErrorAction SilentlyContinue alias:wget
Remove-Item -Force -ErrorAction SilentlyContinue alias:diff

function Show-VcsPrompt {
    # Raw search of repo data, using commands is too slow...
    $root = (Get-Location)
    while ($root) {
        if (Test-Path -Type Leaf "$root/.hg/branch") {
            $branch = (Get-Content "$root/.hg/branch")
            Write-Host -NoNewline -Fore Green "[HG: $branch] "
            break
        }
        if (Test-Path -Type Leaf "$root/.git/HEAD") {
            $ref = (Get-Content "$root/.git/HEAD")
            Write-Host -NoNewline -Fore Green "[Git: "
            if ($ref -match "^ref:\s*refs/heads/(.*)$") {
                Write-Host -NoNewline -Fore Green $Matches[1]
            }
            else {
                Write-Host -NoNewline -Fore Green $ref
            }
            Write-Host -NoNewline -Fore Green "] "
            break
        }
        $root = Split-Path -Parent $root
    }
}

function Show-VenvPrompt {
    if (Test-Path env:VIRTUAL_ENV) {
        $envname = Split-Path -Leaf $env:VIRTUAL_ENV
        Write-Host -NoNewline -Fore Green "($envname) "
    }
}

function Show-LastTimePrompt {
    $dur = (get-history -ea 0 -count 1 | % { $_.EndExecutionTime - $_.StartExecutionTime})
    if ($dur -ne $null) { #  -and $dur.Seconds -gt 0) {
        Write-Host -NoNewLine -Fore Blue "{$($dur.ToString('mm\:ss\.fff'))} "
    }
}

function prompt
{
    $host.ui.rawui.WindowTitle = $(get-location).ProviderPath
    Write-Host -NoNewline -ForegroundColor Cyan "PS "
    Write-Host -NoNewline -ForegroundColor Red $(get-date -uformat "%H:%M")
    Write-Host -NoNewline " "
    Show-VenvPrompt
    Show-VcsPrompt
    Show-LastTimePrompt
    Write-Host -NoNewline -ForegroundColor Yellow $(get-location).ProviderPath
    Write-host ""
    Write-Host -NoNewline -ForegroundColor Blue ("-" * $NestedPromptLevel)
    #if ($env:ConEmuANSI -eq "ON") {
    #    Write-Host -NoNewLine ([char]27 + "[?25h")
    #}
    ">"
}

function Join-File (
    [parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true)]
    [string[]] $Path,
    [parameter(Position=1,Mandatory=$true)]
    [string] $Destination
)
{
    cmd /c copy /b ($Path -join '+') $Destination
}

function exec {
    Param(
        $Executable,
        $Arguments
    )

    $FixedArgs = $Arguments | Foreach-Object {
        $a = [regex]::Replace(
            $_,
            '(\\*)"',
            { '\' + $args[0].Groups[1] + $args[0] }
        )
        if ($a -match '[ \t]') {
            $a = $a -replace '\\+$', "$&$&"
        }
        $a
    }

    & $Executable @FixedArgs
}

function CSV {
    $a = @($input)
    if ($a.Count -gt 0 -and $a[0] -is [String]) {
        $a | ConvertFrom-Csv
    }
    else {
        $a | ConvertTo-Csv -NoTypeInformation
    }
}

$envstack = New-Object Collections.Stack

#Function Activate-Venv ([String]$EnvName) {
#    if (!(Test-Path -Type Leaf "$EnvName\Scripts\python.exe")) {
#        throw "$Name is not a virtualenv"
#    }
#    $current_state = ($env:VIRTUAL_ENV, $env:PATH, $env:PYTHONHOME)
#    $envstack.Push($currentstate)
#    $env:VIRTUAL_ENV = (Resolve-Path $EnvName).Path
#    $env:PATH = $env:VIRTUAL_ENV + "\Scripts;" +$env:PATH
#    Remove-Item -ea 0 env:PYTHONHOME
#}
#
#Function Deactivate-Venv () {
#    $env:VIRTUAL_ENV, $env:PATH, $env:PYTHONHOME = $envstack.Pop()
#}

# set-alias git "C:\Utils\Git\bin\git.exe"
# set-alias hg "C:\Program Files\Mercurial\hg.exe"
# set-alias sqlite3 "C:\Utils\Misc\sqlite3.exe"
# set-alias perl C:\Utils\Perl\perl\bin\perl.exe
# set-alias perldoc C:\Utils\Perl\perl\bin\perldoc.bat
# set-alias psql "C:\Program Files\PostgreSQL\9.3\bin\psql.exe"
# set-alias vboxmanage "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

function bd ($p) {
    Push-Location
    $parts = $pwd.Path.Split('\')
    $count = $parts.Count
    for($idx=0; $idx -lt $count; $idx+=1) {
        if($parts[$idx] -match $p) {
            Set-Location ($parts[0..$idx] -join '\')
            break
        }
    }
}

Function Format-FileSize($size) {
    # Param ([int]$size)
    If     ($size -gt 1TB) {[string]::Format("{0:0.00} TB", $size / 1TB)}
    ElseIf ($size -gt 1GB) {[string]::Format("{0:0.00} GB", $size / 1GB)}
    ElseIf ($size -gt 1MB) {[string]::Format("{0:0.00} MB", $size / 1MB)}
    ElseIf ($size -gt 1KB) {[string]::Format("{0:0.00} kB", $size / 1KB)}
    ElseIf ($size -gt 0)   {[string]::Format("{0:0.00} B", $size)}
    Else                   {""}
}

function wmidf {
    Get-WmiObject -query "select * from win32_logicaldisk" |
        Select DeviceID,
               FileSystem,
               @{Name="Size"; Expression={Format-FileSize($_.Size)}},
               @{Name="Free";Expression={Format-FileSize($_.FreeSpace)}},
               @{Name="Used";Expression={Format-FileSize($_.Size-$_.FreeSpace)}}
}

function google {
    start "https://www.google.co.uk/search?q=$args"
}

# Wrapping commands with arguments
function nl_sample {
  # Number lines in a file using perl
  $input | perl -pe '$_ = qq($. $_)' $args
}

# wget http://psget.net/GetPsGet.ps1
# . GetPsGet.ps1
# Install-Module PsReadLine
# Install-Module TabExpansion++
# Install-Module PsWatch
# Install-Module PsUrl
# Install-Module PowerYaml

function Imp ($name) {
    Write-Host -NoNewLine -Fore Green "Loading module $name..."
    Import-Module $name
    Write-Host -Fore Green " OK"
}

