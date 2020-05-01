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
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/cosmoconsult/remote-dev/$branch/sshd_config" -UseBasicParsing -OutFile "c:\ProgramData\ssh\sshd_config"
$sshKey | Out-File 'c:\programdata\ssh\administrators_authorized_keys' -Encoding utf8
### adapted (pretty much copied) from https://gitlab.com/DarwinJS/ChocoPackages/-/blob/master/openssh/tools/chocolateyinstall.ps1#L433
$path = "c:\ProgramData\ssh\administrators_authorized_keys"
$acl = Get-Acl -Path $path
# following SDDL implies 
# - owner - built in Administrators
# - disabled inheritance
# - Full access to System
# - Full access to built in Administrators
$acl.SetSecurityDescriptorSddlForm("O:BAD:PAI(A;OICI;FA;;;SY)(A;OICI;FA;;;BA)")
Set-Acl -Path $path -AclObject $acl
### end of copy
restart-service sshd