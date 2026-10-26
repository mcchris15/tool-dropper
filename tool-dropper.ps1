Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# filePath variable stores the path for the file to be edited
$filePath = "tool_heights.tt"
# backupPath variable  stores the path for the backup file to be created
$backupPath = "tool_heights.bak"
# lines variable contains a list of all lines readfrom the file
$lines = Get-Content $filePath

# Create the main window frame
$form = New-Object System.Windows.Forms.Form
$form.Text = "Tool Tracker"
$form.Size = New-Object System.Drawing.Size(900,570)
$form.StartPosition = "CenterScreen"

# Add a descriptive label
$label = New-Object System.Windows.Forms.Label
$label.Size = New-Object System.Drawing.Size(0,0)
$label.Text = "Edits the values in tool_heights.txt. You may drop current numbers by 0.03 or clear all numbers from file."
$form.Controls.Add($label)

$heightsDisplay = New-Object System.Windows.Forms.TextBox
$heightsDisplay.ReadOnly = $true
$heightsDisplay.Text = $lines -join "`r`n"
$heightsDisplay.Multiline = $true
$heightsDisplay.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
$heightsDisplay.Location = New-Object System.Drawing.Point(10,20)
$heightsDisplay.Size = New-Object System.Drawing.Size(860,451)
$form.Controls.Add($heightsDisplay)
$form.ActiveControl = $label

# Add button for decreasing values
$dropButton = New-Object System.Windows.Forms.Button
$dropButton.Location = New-Object System.Drawing.Point(10,501)
$dropButton.Size = New-Object System.Drawing.Size(90,23)
$dropButton.Text = "-0.03"
$dropbutton.Add_Click({
    # Create backup of original file
    Copy-Item -Path $filePath -Destination $backupPath -Force
    $lines = Get-Content $filePath
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
    $heightsDisplay.Text = $newLines -join "`r`n"
})
$form.Controls.Add($dropButton)

# Add button for raising values
$raiseButton = New-Object System.Windows.Forms.Button
$raiseButton.Location = New-Object System.Drawing.Point(10,476)
$raiseButton.Size = New-Object System.Drawing.Size(90,23)
$raiseButton.Text = "+0.03"
$raiseButton.Add_Click({
    # Create backup of original file
    Copy-Item -Path $filePath -Destination $backupPath -Force
    $lines = Get-Content $filePath
    # for loop that reads each line, edits it if need be, and adds it to newLines variable
    $newLines = foreach($line in $lines){
        # If a number matching the pattern "##.####" is found in the string, operate on it
        if ($line -match "-\d+\.\d{4}"){
            # Convert string a double and add 0.03
            $newNumber = [double]$Matches[0] + 0.03
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
    $heightsDisplay.Text = $newLines -join "`r`n"
})
$form.Controls.Add($raiseButton)

# Add button for clearing values
$clearButton = New-Object System.Windows.Forms.Button
$clearButton.Location = New-Object System.Drawing.Point(105,501)
$clearButton.Size = New-Object System.Drawing.Size(90,23)
$clearButton.Text = "Clear Values"
$clearbutton.Add_Click({
    # Create backup of original file
    Copy-Item -Path $filePath -Destination $backupPath -Force
    $lines = Get-Content $filePath
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
    $heightsDisplay.Text = $newLines -join "`r`n"
    $undoButton.Enabled = $true
    $clearButton.Enabled = $false
})
$form.Controls.Add($clearButton)

# Add button for undo last operation
$undoButton = New-Object System.Windows.Forms.Button
$undoButton.Location = New-Object System.Drawing.Point(200,501)
$undoButton.Size = New-Object System.Drawing.Size(90,23)
$undoButton.Text = "Undo"
$undoButton.Enabled = $false
$undoButton.Add_Click({
    $lines = Get-Content $backupPath
    $lines | Set-Content $filePath
    $heightsDisplay.Text = $lines -join "`r`n"
    $undoButton.Enabled = $false
    $clearButton.Enabled = $true
    $editButton.Enabled = $true
    $form.ActiveControl = $label
})
$form.Controls.Add($undoButton)

$editButton = New-Object System.Windows.Forms.Button
$editButton.Location = New-Object System.Drawing.Point(105,476)
$editButton.Size = New-Object System.Drawing.Size(90,23)
$editButton. Text = "Edit Values"
$editButton.Add_Click({
    $heightsDisplay.ReadOnly = $false
    $editButton.Enabled = $false
    $saveButton.Enabled = $true
})
$form.Controls.Add($editButton)

$saveButton = New-Object System.Windows.Forms.Button
$saveButton.Enabled = $false
$saveButton.Text = "Save Edit"
$saveButton.Size = New-Object System.Drawing.Size(90,23)
$saveButton.Location = New-Object System.Drawing.Point(200,476)
$saveButton.Add_Click({
    Copy-Item -Path $filePath -Destination $backupPath -Force
    $heightsDisplay.ReadOnly = $true
    $saveButton.Enabled = $false
    $undoButton.Enabled = $true
    $heightsDisplay.Text | Set-Content $filePath
})
$form.Controls.Add($saveButton)
# Display the window and capture output
$result = $form.ShowDialog()