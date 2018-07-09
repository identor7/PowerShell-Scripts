# Search AD users for Homedirectory in all OU exepting OU Blocked
$list = Get-ADUser -filter {enabled -eq $false} -SearchBase "OU=blocked,DC=rca,DC=ru" | select -property name, samaccountname, Homedirectory

foreach ($i in $list) {
    $Folder = "\\FS\Users\Homes\$($i.sAMAccountname)"
        
    $homes = (Get-ADUser $i.sAMAccountname  -Properties HomeDirectory).homedirectory 
     
    $test = Test-Path "$Folder"
    #$test

    if ($test -eq "True") {

        Write-Host ">" $($i.sAMAccountname) "Has Home folder (+) $Folder"
        Write-Host ""
    }

    else {
        Write-Host ">" $($i.sAMAccountname) "Has No folder (-)"
        Write-Host ""
    }
}