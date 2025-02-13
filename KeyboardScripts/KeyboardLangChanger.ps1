# Define the Japanese language code
$LangCode = "0411"  # Japanese (Microsoft IME)

# Set the keyboard layout in the user registry
$RegPath = "HKCU:\Keyboard Layout\Preload"
$CurrentLayouts = Get-ItemProperty -Path $RegPath

# Check if Japanese is already in the list
$Exists = $false
foreach ($Property in $CurrentLayouts.PSObject.Properties) {
    if ($Property.Value -eq $LangCode) {
        $Exists = $true
        break
    }
}

if (-not $Exists) {
    # Find the next available key slot and add Japanese layout
    $Slot = ($CurrentLayouts.PSObject.Properties.Name | Measure-Object).Count + 1
    Set-ItemProperty -Path $RegPath -Name "$Slot" -Value $LangCode
    Write-Host "Japanese (0411) keyboard layout added."
} else {
    Write-Host "Japanese keyboard layout already exists."
}

# Change the active input method
$RegInputPath = "HKCU:\Control Panel\International\User Profile"
Set-ItemProperty -Path $RegInputPath -Name "InputMethodOverride" -Value $LangCode

# Restart Windows Explorer to apply changes
Stop-Process -Name "explorer" -Force
Start-Process "explorer"

Write-Host "Keyboard layout switched to Japanese (Microsoft IME). You may need to log out and log back in for full effect."
