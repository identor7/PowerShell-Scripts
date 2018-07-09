# This script was written for problems with permissions while moving home directory
# Please check script on test users before executing in industrial environment
# Fix folder permission and copy home directory thru robocopy from F: to X: (paths are obtained from set.csv)

# 1. You need to create file set.csv by yourself. This file must contain columns: ad username (Name), initial path (From), final path (To). (See the attached example).
# 2. On the running server, you must connect the old path as F: disk and new path like X:
# 3. Run script
# 4. After execution of this script home directory will be mapped like network disk "M"
# 5. After execution will be send a message to user with request to reboot

[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding("cp866")
Set-ExecutionPolicy Unrestricted
Import-Module ActiveDirectory
$all = Import-CSV -Delimiter ";" -Path "X:\Set.csv"

Foreach ($row in $all) {

    $name = $row.Name
    $from = $row.From
    $to = $row.To
    $test = Test-Path "$from"
    
    if ($test -eq "True") {
    
        Write-Host "-------------------------------------------------"
        Write-Host "The name is" $name
        Write-Host "From" $from
        Write-Host "To" $to
        
        # Take ownership
        TAKEOWN /F "$from" /R /D Y

        # Change ownership to Domain Admins group
        icacls "$from" /setowner "Domain Admins" /C /T
        
        # Add to permission Domain Admins group 
        icacls "$from" /grant:r "Domain Admins:F" /C /T
        
        # Add to permission user account
        # icacls "$from" /grant:r "$name":F /C /T == Don't Work (!)
        icacls "$from" /grant:r ("$name" + ':(OI)(CI)F') /C /T
        
        # Also you can delete redundant user account. For example account: testuser
        # icacls $From /remove:g testuser

        # Let's start transferring data
        ROBOCOPY "$from" "$to" /E /SEC /W:5 /R:10 /COPYALL /SECFIX /ZB /MT:10 /V /TS /FP /ETA /TEE /LOG:X:\$name.txt

        # We return the owner of the copied folder to the out user from set.csv filed "Name"
        icacls "$to" /setowner "$name" /C /T
      
        
        # Replace the path in AD to the new home directory
        Set-ADUser "$name" -HomeDrive "M:" -HomeDirectory "\\HOMES\Users\Homes\$name"
        
        # Now rename the old folder to ex-, so that access to lost access
        $from
        $before = Split-Path $from # Path to the last folder
        $before 
        $after = Split-Path -Leaf $from # Define the last folder
        $after
        $newpath = $before + "\ex-" + $after # Concatinate to get filder "ex-" + "user folder"
        $newpath
        Rename-Item $from $newpath # Start to rename
    }
   
   #Insert here the message sending code
   #------------------------------------
     #--- Message Send ----#

    $stname = $name
    $addr = $stname + "" # Your Domian name for "From". Example: "@example.com"

    $smtpServer = "north.rca.ru" # Specify the server name. Example: exchange1.example.com
    $smtpFrom = "Suppert <support@.example.com>" # Specify the mail from address
    $smtpTo = "$addr"
    $messageSubject = "Desk M"
    $messageBody = "Hello! The optimization of the M disk was performed. In order to continue to work correctly with this resource, it is necessary to restart the computer"
    $smtp = New-Object Net.Mail.SmtpClient($smtpServer)
    $smtp.Send($smtpFrom,$smtpTo,$messagesubject,$messagebody)
        
    #--------------------------#
   #------------------------------------
    
    else {
        Write-Host $From "Not Found!" 
        Write-Output $From "Not Found!" | Out-File -FilePath "X:\Fails-$Name.txt" -Append -Encoding Default # Log file
    }    
}