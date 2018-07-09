    # This script
    # Searches forder for *.xlsx
    # If found it starts looking files with the same name but with other extenstion in specific folders
    # All found files will be packed to WinRar archive and then they will be deleted (-DF key)
    
    Set-Executionpolicy -Scope CurrentUser -ExecutionPolicy UnRestricted

    $name = dir "D:\org\For_sending\Export" | Where-Object {$_.Extension -like "*.xlsx"} #Search all docs with extention xlsx
    foreach ( $i in $name ) {

    $short=([io.fileinfo]"D:\org\For_sending\Export\$i").basename #Separate path and file name

    # Inspect all nessecery extension in the specified folders below
    $path1="D:\org\For_sending\Export\$short.tiff"
    $path1="D:\org\For_sending\Export\$short.tif"
    $path2="D:\org\For_sending\Export\$short.pdf"
    $path3="D:\org\For_sending\Export\$short.docx"
    $path4="D:\org\For_sending\Export\$short.rtf"
    $path5="D:\org\For_sending\Export\$short.jpg"
    $path6="D:\org\For_sending\Export\$short.jpeg"
    $path7="D:\org\For_sending\Answers\$short.tif"
    $path8="D:\org\For_sending\Answers\$short.tiff"
    $path9="D:\org\For_sending\Answers\$short.pdf"
    $path10="D:\org\For_sending\Answers\$short.docx"
    $path11="D:\org\For_sending\Answers\$short.rtf"
    $path12="D:\org\For_sending\Answers\$short.jpg"
    $path13="D:\org\For_sending\Answers\$short.jpeg"

    $path14="D:\org\For_sending\Export\$short.xlsx"

    $array=$path1, $path2, $path3, $path4, $path5, $path6, $path7, $path8, $path9, $path10, $path11, $path12, $path13, $path14 # Create array for selected files
    
    $output_array=@()
        
    foreach ($s in $array) {

        $isfile = Test-Path $s # Check file exists with specified extension

        if($isfile -eq "True") {
            $s = "$s"
            $output_array += @($s) # If file exists with specified extension add it to array to prepair output for WinRar
        }
    }

    if($output_array.count -ge 2) {
        &"C:\Program Files (x86)\WinRAR\WinRAR.exe" a -ep1 -DF "D:\org\For_sending\Answers\$short.rar" $output_array
        Write-host "Adding $output_array"
        Wait-Event -Timeout 2
    }

    else {
        Write-host "No related files found for $short, archive not created!"
        Write-host ""
        }
    
    Write-host "Completed archive creation $short"
    Write-host ""
}

Wait-Event -Timeout 2




