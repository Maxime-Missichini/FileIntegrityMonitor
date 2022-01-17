Write-Host "Hi, what do you want to do ?"
Write-Host "1) Collect a new baseline ?"
Write-Host "2) Begin monitoring files with saved baseline ?"

# Need to secure this, don't trust users input
$answer = Read-Host "Please enter your response"

Write-Host "User answer : $($answer)"

Function ComputeFileHash($filePath){
    return Get-FileHash -Path $filePath -Algorithm SHA512
}

# Temporary solution to always overwrite
Function FileExists(){
    $baselineExists = Test-Path -Path \.baseline.txt
    if ($baselineExists){
        # Delete it
        Remove-Item -Path .\baseline.txt
    }
}

if ($answer -eq "1") {
    #Delete existing baseline
    FileExists

    # Collect the files
    $files = Get-ChildItem -Path ".\testFiles"
    foreach ($file in $files){
        # Calculate Hash for this file
        $hash = ComputeFileHash($file.Fullname)

        # Need to check if baseline already exist so we overwrite and don't append
        # Get file path with a pipe and then file hash and send it to baseline.txt, we need to append so we don't overwrite
        "$($hash.Path)|$($hash.Hash)" | Out-File -FilePath ".\baseline.txt" -Append
    }
    Write-Host "Baseline computed"

}
elseif ($answer -eq "2") {
    # Begin monitoring
    # Load file|hash from baseline and store them in a dictionnary
    $filePathAndHashes = Get-Content -Path .\baseline.txt

    foreach ($file in $filePathAndHashes) {
        # Split with pipe
        $line = $file.split("|")

        # Empty dictionary
        $dictionary = @{}
        $dictionary.Add("line[0]","line[1]")
    }

    Write-Host "Monitor launched"
    # Think about a correct way to do it
    while ($true) {
        Start-Sleep -Seconds 1
        # Collect the files

        # Create a function later
        $files = Get-ChildItem -Path ".\testFiles"
        foreach ($file in $files){
            # Calculate Hash for this file
            $hash = ComputeFileHash($file.Fullname)

            if ($filePathAndHashes[$hash.Path] -eq $null) {
                # Then a file has been added, notify the user
                Write-Host "$($hash.Path) has been added to the folder !" -ForegroundColor Red
            }
            elseif ($filePathAndHashes[$hash.Path] -eq $hash.hash) {
                # If the hash didn't change, then there is no modification, do nothing
            }
            else {
                # File has been changed, notify the user
                Write-Host "$($hash.Path) has been modified !" -ForegroundColor Red
            }
        }

        # Check if there is deleted files
        foreach ($filePath in $dictionary.Keys) {
            $exists = Test-Path -Path $filePath
            if (-Not $exists) {
                # Then it has been deleted
                    Write-Host "$($file) has been deleted !" -ForegroundColor Red
            }
        }
    }
}