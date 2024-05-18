#!/bin/sh -e

$script_folder=Split-Path -Path $MyInvocation.MyCommand.Path -Parent
cd $script_folder

$config=@"
Host $(Get-Content .\instance-address)
  HostName $(Get-Content .\instance-address)
  User ubuntu
  IdentityFile $((Get-Location).path)/ssh.key
"@


Write-Output @"
Pour pouvoir se connecter par SSH, ce script doit mettre à jour le fichier ~/.ssh/config avec le contenu suivant:
$config
"@

$response = Read-Host "Mettre à jour le fichier (mettre N si le fichier est déjà à jour)? (O/N): "

$HOME_FOLDER = "UNDEFINED"

if($env:USERPROFILE -ne $null) {
  $HOME_FOLDER = $env:USERPROFILE
} else {
  $HOME_FOLDER = $env:HOME
}

if($response -eq "O") {
    Copy-Item $HOME_FOLDER/.ssh/config $HOME_FOLDER/.ssh/config.backup$(Get-Date -Format "dddd-MM-dd-yyyy-HH-mm")
    Add-Content $HOME_FOLDER/.ssh/config -Value ""
    Add-Content $HOME_FOLDER/.ssh/config $config
    Add-Content $HOME_FOLDER/.ssh/config -Value ""
}

code --remote ssh-remote+ubuntu@$(Get-Content .\instance-address) /