$filePath = "tool_heights.txt"
$backupPath = "tool_heights_backup.txt"
$lines = Get-Content $filePath

Write-Host -Separator "`n" "Current numbers:`n" $lines

$runPrompt = Read-Host -Prompt "Tool heights will be dropped by 0.03, and a backup of current numbers will be created. Proceed? (Y/N)"  

if($runPrompt -eq "Y" -or $runPrompt -eq "y") {
    Copy-Item -Path $filePath -Destination $backupPath -Force
    $newLines = foreach($line in $lines){
        if ($line -match "-\d+\.\d+"){
            $newNumber = [double]$Matches[0] - 0.03
            $newNumber = [string]$newNumber
            while ($newNumber -notmatch "-\d+\.\d{4}"){
                $newNumber += "0"
            }
            $line -replace "-\d+\.\d+",$newNumber
        } else{
            $line
        }	
    }
    $newLines | Set-Content $filePath
    Write-Host -Separator "`n" "`nNew numbers:`n" $newLines
    Read-Host -Prompt "Tool heights dropped successfully. Press enter to exit"
} else {
    exit
}
