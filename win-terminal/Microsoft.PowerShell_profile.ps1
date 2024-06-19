# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/blueish.omp.json" | Invoke-Expression

# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/spaceship.omp.json" | Invoke-Expression

# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/stelbent.minimal.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/kali.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/pure.omp.json" | Invoke-Expression

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile))
{
  Import-Module "$ChocolateyProfile"
}

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView


Import-Module -Name Terminal-Icons
# ini untuk alias tambahan personal
New-Alias ci code-insiders
New-Alias v nvim
New-Alias ll ls
New-Alias c code
New-Alias python3 python
# function n { neovide --opengl }
New-Alias n neovide
# New-Alias black python -m black
$host.ui.RawUI.WindowTitle = “ Pojok Code ”
clear -x  
# Personalize the console
#$Host.UI.RawUI.WindowTitle = "Windows Powershell " + $Host.Version;

# Draw welcome screen  
# Write-Host -ForegroundColor DarkYellow "                _       _                    _       "
# Write-Host -ForegroundColor DarkYellow "               (_)     | |                  | |      "
# Write-Host -ForegroundColor DarkYellow "    _ __   ___  _  ___ | | __   ___ ___   __| | ___  "
# Write-Host -ForegroundColor DarkYellow "   | '_ \ / _ \| |/ _ \| |/ /  / __/ _ \ / _  |/ _ \ "
# Write-Host -ForegroundColor DarkYellow "   | |_) | (_) | | (_) |   <  | (_| (_) | (_| |  __/ "
# Write-Host -ForegroundColor DarkYellow "   | .__/ \___/| |\___/|_|\_\  \___\___/ \__,_|\___| "
# Write-Host -ForegroundColor DarkYellow "   | |        _/ |                                   "
# Write-Host -ForegroundColor DarkYellow "   |_|       |__/                                    "

# Write-Host -ForegroundColor DarkYellow "                _      __                __    "
# Write-Host -ForegroundColor DarkYellow "    ___ ___    (____  / /__  _______ ___/ ___  "
# Write-Host -ForegroundColor DarkYellow "   / _ / _ \  / / _ \/  '_/ / __/ _ / _  / -_) "
# Write-Host -ForegroundColor DarkYellow "  / .__\_____/ /\___/_/\_\  \__/\___\_,_/\__/  "
# Write-Host -ForegroundColor DarkYellow " /_/      |___/                                "
# Write-Host -ForegroundColor DarkYellow " "

# Write-Host -ForegroundColor DarkYellow "┌─┐┌─┐ ┬┌─┐┬┌─  ┌─┐┌─┐┌┬┐┌─┐"
# Write-Host -ForegroundColor DarkYellow "├─┘│ │ ││ │├┴┐  │  │ │ ││├┤ "
# Write-Host -ForegroundColor DarkYellow "┴  └─┘└┘└─┘┴ ┴  └─┘└─┘─┴┘└─┘"
                                        
function prompt {
  $loc = $executionContext.SessionState.Path.CurrentLocation;

  $out = ""
  if ($loc.Provider.Name -eq "FileSystem") {
    $out += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
  }

  if('c:\Users\Asep' -eq $executionContext.SessionState.Path.CurrentLocation) {
    $host.UI.RawUI.WindowTitle = " Pojok Code ";
    $out += "  PCode$(' ❯' * ($nestedPromptLevel + 1)) ";
    # $folder=(get-location).drive.name+":\...\PCode"
    # $out += " $folder$(' ❯' * ($nestedPromptLevel + 1)) ";
  }else{
    # $out += " $loc$(' ❯' * ($nestedPromptLevel + 1)) ";
    # $dir=($loc.path).split("\")[-2]
    # $folder=(get-location).drive.name+":\...\"+$( $dir + "\" + ( get-item $pwd ).Name )
    # $folder=$( $dir + "\" + ( get-item $pwd ).Name )

    # $folder1= ($loc.path).split("\")[-2]
    # $folder2= ($loc.path).split("\")[-1]
    # $folder=$folder1 + "\" + $folder2

    $folder= ($loc.path).split("\")[-1]
    $host.UI.RawUI.WindowTitle = "  " +$folder+ "  ";
    $out += "  $folder$(' ❯' * ($nestedPromptLevel + 1)) ";
  }
  
   return $out
}

if($host.UI.RawUI.WindowTitle -eq 'c:\WINDOWS\system32\cmd.exe'){
  $host.UI.RawUI.WindowTitle = "Pojok Code"
}

# Set-Location -Path $executionContext.SessionState.Path.CurrentLocation;
# Install-Module oh-my-posh -Scope CurrentUser
                                  
# Config Neovim Swicher with gui 
function Invoke-Nvim {
    param (
        [string]$AppName
    )
    $env:NVIM_APPNAME = $AppName
    nvim $args
}

function Select-NvimConfig {
    # $items = 'default', 'kickstart', 'LazyVim', 'NvChad', 'AstroNvim'
    $items = 'default', 'NvChad'
    $config = $items | Out-GridView -Title ' Neovim Config ' -PassThru
    if ($null -eq $config) {
        Write-Host "Tidak ada yang dipilih"
        return
    }
    elseif ($config -eq 'default') {
        $config = ''
    }
    Invoke-Nvim -AppName $config
}

# --- neovim config switcher with alias-------------------------------------------
# function nvimAstro {
#     $Env:NVIM_APPNAME = 'AstroVim'
#     nvim 
# }
#
# function nvimLazy {
#     $Env:NVIM_APPNAME = 'LazyVim'
#     nvim 
# }

function nvimNvChad {
    $Env:NVIM_APPNAME = 'NvChad'
    nvim 
}

function nvimDefault {
    $Env:NVIM_APPNAME = 'nvim'
    nvim 
}

# set-alias -name nvim-astr -value nvimAstro
# set-alias -name nvim-lazy -value nvimLazy
set-alias -name nvim-chad -value nvimNvChad
set-alias -name nvim-defa -value nvimDefault
