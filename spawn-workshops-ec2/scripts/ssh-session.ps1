$variable=Split-Path -Path $MyInvocation.MyCommand.Path -Parent
cd $variable

$address = Get-Content .\instance-address
ssh -i ssh.key ubuntu@$address