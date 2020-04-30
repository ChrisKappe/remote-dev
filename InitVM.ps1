param (
    [Parameter()]
    [string]
    $sshKey,
    
    [Parameter()]
    [string]
    $branch
)

# install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco feature enable -n allowGlobalConfirmation
choco install git
choco install vim
choco install openssh -params '"/SSHServerFeature"'

# configure SSH
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/cosmoconsult/remotedev/$branch/sshd_config" -UseBasicParsing -OutFile "c:\ProgramData\ssh\sshd_config"
restart-service sshd
$sshKey | Out-File 'c:\programdata\ssh\administrators_authorized_keys'