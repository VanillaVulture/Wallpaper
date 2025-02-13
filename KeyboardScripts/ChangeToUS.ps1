$LangCode = "0409" # English (United States) Input Language Code

# Get the current input methods
$CurrentLangs = Get-WinUserLanguageList

# Check if English (US) is already set
if ($CurrentLangs.LanguageTag -notcontains "en-US") {
    Write-Host "Adding English (en-US) as a new input method..."
    
    # Add English language to user input list
    $CurrentLangs += New-WinUserLanguageList "en-US"
    Set-WinUserLanguageList -LanguageList $CurrentLangs -Force
} else {
    Write-Host "English (en-US) is already installed."
}

# Change the default input method to English (US)
$RegPath = "HKCU:\Keyboard Layout\Preload"
$CurrentLayouts = Get-ItemProperty -Path $RegPath

if ($CurrentLayouts -match $LangCode) {
    Write-Host "English keyboard layout is already set."
} else {
    # Find the first available key slot and set English layout
    $Slot = ($CurrentLayouts.PSObject.Properties.Name | Measure-Object).Count + 1
    Set-ItemProperty -Path $RegPath -Name "$Slot" -Value $LangCode
    Write-Host "English input method added to keyboard layouts."
}

# Force update the keyboard layout without requiring a reboot
$LayoutPath = "HKCU:\Control Panel\International\User Profile"
Set-ItemProperty -Path $LayoutPath -Name "InputMethodOverride" -Value $LangCode
Write-Host "Keyboard layout switched to English successfully."

# Restart Windows Explorer to apply changes immediately
Stop-Process -Name "explorer" -Force
Start-Process "explorer"

Write-Host "Language change complete! You may need to log out and log back in for full effect."
