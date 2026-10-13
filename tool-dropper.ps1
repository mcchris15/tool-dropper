# filePath variable stores the path for the file to be edited
$filePath = "tool_heights.txt"
# backupPath variable  stores the path for the backup file to be created
$backupPath = "tool_heights_backup.txt"
# lines variable contains a list of all lines readfrom the file
$lines = Get-Content $filePath

# Displays contents of file before editing, then gives user a prompt to run the rest of the script
Write-Host -Separator "`n" "Current numbers:`n" $lines
$runPrompt = Read-Host -Prompt "Tool heights will be dropped by 0.03, and a backup of current numbers will be created. Proceed? (Y/N)"  

# Rest of script runs if user inputs "Y" or "y"
if($runPrompt -eq "Y" -or $runPrompt -eq "y") {
    # Create backup of original file
    Copy-Item -Path $filePath -Destination $backupPath -Force
    # for loop that reads each line, edits it if need be, and adds it to newLines variable
    $newLines = foreach($line in $lines){
        # If a number matching the pattern "##.####" is found in the string, operate on it
        if ($line -match "-\d+\.\d{4}"){
            # Convert string a double and subtract 0.03
            $newNumber = [double]$Matches[0] - 0.03
            # Convert double back to a string
            $newNumber = [string]$newNumber
            # Converting to double truncates trailing 0s; check if number still matches pattern "##.####" and if not, append 0s until it does  
            while ($newNumber -notmatch "-\d+\.\d{4}"){
                $newNumber += "0"
            }
            # Replace the number string on the original line with the number string stored in newNumber
            $line -replace "-\d+\.\d+",$newNumber
        } else{
            # If the current line doesn't contain a number matching the pattern, leave it alone
            $line
        }	
    }
    # Write content from newLines variable to the original file
    $newLines | Set-Content $filePath
    # Display new numbers, then display success message and prompt for exit
    Write-Host -Separator "`n" "New numbers:`n" $newLines
    Read-Host -Prompt "Tool heights dropped successfully. Press enter to exit"
} else {
    # If user doesn't enter "Y" or "y" on original prompt, exit script
    exit
}
