# Found It on the Internet
# Script asks your credentals before login to PS session logon
#
# Instruction:
# 1. Run script
# 2. Enter your credentals to remote sever

$Server = "" # Enter your remote server name. Example: server.domain.com

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$Server/PowerShell/ -Authentication Kerberos -Credential $UserCredential 
Import-PSSession $Session