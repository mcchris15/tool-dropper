
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# filePath variable stores the path for the file to be edited
$filePath = "tool_heights.txt"
# backupPath variable  stores the path for the backup file to be created
$backupPath = "tool_heights_backup.txt"
# lines variable contains a list of all lines readfrom the file
$lines = Get-Content $filePath

# Create the main window frame
$form = New-Object System.Windows.Forms.Form
$form.Text = "Tool Dropper"
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = "CenterScreen"
$form.Topmost = $true

# Add a descriptive label
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,40)
$label.Text = "Edits the values in tool_heights.txt. You may drop current numbers by 0.03 or clear all numbers from file."
$form.Controls.Add($label)

# Add button for decreasing values
$dropButton = New-Object System.Windows.Forms.Button
$dropButton.Location = New-Object System.Drawing.Point(10,90)
$dropButton.Size = New-Object System.Drawing.Size(90,23)
$dropButton.Text = "Drop Numbers"
$dropbutton.Add_Click({
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
    
    $label.Text = "Numbers successfully dropped! Backup created in case this was a mistake. You may now close this window."
    $dropButton.Enabled = $false
    $clearButton.Enabled = $false
    $quitButton.Enabled = $false

    Get-Process -Name "notepad" -ErrorAction SilentlyContinue | 
        Where-Object { $_.MainWindowTitle -eq "tool_heights - Notepad" } | 
        Stop-Process -Force
})
$form.Controls.Add($dropButton)

# Add button for clearing values
$clearButton = New-Object System.Windows.Forms.Button
$clearButton.Location = New-Object System.Drawing.Point(100,90)
$clearButton.Size = New-Object System.Drawing.Size(90,23)
$clearButton.Text = "Clear Numbers"
$clearbutton.Add_Click({
    # Create backup of original file
    Copy-Item -Path $filePath -Destination $backupPath -Force
    # for loop that reads each line, edits it if need be, and adds it to newLines variable
    $newLines = foreach($line in $lines){
            # If a number matching the pattern "##.####" is found in the string, operate on it
            if ($line -match "-\d+\.\d{4}"){
                # Convert number in string to blank space
                $blankspace = " "
                # Replace the number string on the original line with blank space
                $line -replace "-\d+\.\d+",$blankSpace
            } else{
                # If the current line doesn't contain a number matching the pattern, leave it alone
                $line
            }	
        }

    # Write content from newLines variable to the original file
    $newLines | Set-Content $filePath
    
    $label.Text = "Numbers successfully cleared! Backup created in case this was a mistake. You may now close this window."
    $dropButton.Enabled = $false
    $clearButton.Enabled = $false
    $quitButton.Enabled = $false

    # Find Notepad processes where the window title matches the exact file name
    Get-Process -Name "notepad" -ErrorAction SilentlyContinue | 
        Where-Object { $_.MainWindowTitle -eq "tool_heights - Notepad" } | 
        Stop-Process -Force
})
$form.Controls.Add($clearButton)

# Add button for quitting
$quitButton = New-Object System.Windows.Forms.Button
$quitButton.Location = New-Object System.Drawing.Point(190,90)
$quitButton.Size = New-Object System.Drawing.Size(90,23)
$quitButton.Text = "Cancel"
$quitbutton.Add_Click({$form.Close()})
$form.Controls.Add($quitButton)

# Display the window and capture output
$result = $form.ShowDialog()