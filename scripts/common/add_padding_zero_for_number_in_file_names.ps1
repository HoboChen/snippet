function PadNumbersInFileName($originalName, $paddingLength) {
    # Separate base filename and extension
    $baseName = [IO.Path]::GetFileNameWithoutExtension($originalName)
    $extension = [IO.Path]::GetExtension($originalName)

    # Find all the numbers in the base filename
    $matches = [regex]::Matches($baseName, '\d+')

    # Create an array to store the parts of the new base filename
    $newNameParts = New-Object System.Collections.ArrayList

    # Initialize the start index for the next part of the filename
    $nextStartIndex = 0

    foreach ($match in $matches) {
        # Add the part of the base filename before the current match to the array
        $newNameParts.Add($baseName.Substring($nextStartIndex, $match.Index - $nextStartIndex)) | Out-Null

        # Pad the current match with leading zeros to the specified length
        $paddedNumber = $match.Value.PadLeft($paddingLength, '0')

        # Add the padded number to the array
        $newNameParts.Add($paddedNumber) | Out-Null

        # Update the start index for the next part of the base filename
        $nextStartIndex = $match.Index + $match.Length
    }

    # Add the part of the base filename after the last match to the array
    $newNameParts.Add($baseName.Substring($nextStartIndex)) | Out-Null

    # Join the parts of the new base filename into a single string and append the extension
    $newName = -join $newNameParts
    $newName += $extension

    return $newName
}


#Test 1
$originalName = "1_1.mp3"
$expectedNewName = "01_01.mp3"
$result = PadNumbersInFileName $originalName 2
if ($result -eq $expectedNewName) {
    Write-Host "Test 1 passed"
} else {
    Write-Host "Test 1 failed: expected '$expectedNewName', got '$result'"
}

#Test 2
$originalName = "123_456.mp3"
$expectedNewName = "123_456.mp3"
$result = PadNumbersInFileName $originalName 2
if ($result -eq $expectedNewName) {
    Write-Host "Test 2 passed"
} else {
    Write-Host "Test 2 failed: expected '$expectedNewName', got '$result'"
}

#Test 3
$originalName = "123#6x7892aa55555.mp3"
$expectedNewName = "0123#0006x7892aa55555.mp3"
$result = PadNumbersInFileName $originalName 4
if ($result -eq $expectedNewName) {
    Write-Host "Test 3 passed"
} else {
    Write-Host "Test 3 failed: expected '$expectedNewName', got '$result'"
}

#Specify the path to the directory
$directoryPath = "C:\Path\To\Your\Directory"

#Specify the desired length after padding
$paddingLength = 2

#Get all mp3 files in the directory
$files = Get-ChildItem -Path $directoryPath -Filter "*.mp3"

foreach ($file in $files) {
    #Remove the extension from the filename
    $originalBaseName = [IO.Path]::GetFileNameWithoutExtension($file.Name)

    #Get the new base name by padding the numbers in the original base name
    $newBaseName = PadNumbersInFileName $originalBaseName $paddingLength

    #Add the file extension
    $newFileName = "$newBaseName.mp3"

    #Full path for the new file name
    $newFilePath = Join-Path -Path $file.DirectoryName -ChildPath $newFileName

    #Rename the file
    Rename-Item -Path $file.FullName -NewName $newFilePath
}