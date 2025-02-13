$LangCode = "0411" # Japanese Input Language Code

# Get the current input methods
$CurrentLangs = Get-WinUserLanguageList

# Check if Japanese is already added
if ($CurrentLangs.LanguageTag -notcontains "ja-JP") {
    Write-Host "Adding Japanese (ja-JP) as a new input method..."
    
    # Add Japanese language to user input list
    $CurrentLangs += New-WinUserLanguageList "ja-JP"
    Set-WinUserLanguageList -LanguageList $CurrentLangs -Force
} else {
    Write-Host "Japanese (ja-JP) is already installed."
}

# Change the default input method to Japanese (Microsoft IME)
$RegPath = "HKCU:\Keyboard Layout\Preload"
$CurrentLayouts = Get-ItemProperty -Path $RegPath

if ($CurrentLayouts -match $LangCode) {
    Write-Host "Japanese keyboard layout is already set."
} else {
    # Find the first available key slot and set Japanese layout
    $Slot = ($CurrentLayouts.PSObject.Properties.Name | Measure-Object).Count + 1
    Set-ItemProperty -Path $RegPath -Name "$Slot" -Value $LangCode
    Write-Host "Japanese input method added to keyboard layouts."
}

# Force update the keyboard layout without requiring a reboot
$LayoutPath = "HKCU:\Control Panel\International\User Profile"
Set-ItemProperty -Path $LayoutPath -Name "InputMethodOverride" -Value $LangCode
Write-Host "Keyboard layout switched to Japanese successfully."

# Restart Windows Explorer to apply changes immediately
Stop-Process -Name "explorer" -Force
Start-Process "explorer"

Write-Host "Language change complete! You may need to log out and log back in for full effect."
