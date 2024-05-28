$variable=Split-Path -Path $MyInvocation.MyCommand.Path -Parent
cd $variable

powershell ssh-session.ps1 -command "code tunnel"