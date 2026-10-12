$filePath = "tool_heights.txt"
$backupPath = "tool_heights_backup.txt"

Copy-Item -Path $filePath -Destination $backupPath -Force

$lines = Get-Content $filePath

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