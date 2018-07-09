# Found It on the Internet
# Script automatically uses you domain credental to remote PS session logon
#
# Instruction:
# 1. Run script
# 2. Execute "Connect-Exchange" in PS console
# 3. Specify your server on request

Function Connect-Exchange
    {
        [CmdletBinding()]
        Param(
        [Parameter(Mandatory=$True)]
        $Server
        )
            $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri ("http://" + $Server + "/PowerShell/") -Authentication Kerberos
                                               Import-PSSession $Session
    }