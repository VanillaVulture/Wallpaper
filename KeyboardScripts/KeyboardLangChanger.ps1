# Japanese Language Code
$LangCode = "0411"
$LangTag = "ja-JP"

# Step 1: Check if Japanese is already installed
$CurrentLangs = Get-WinUserLanguageList
if ($CurrentLangs.LanguageTag -notcontains $LangTag) {
    Write-Host "Japanese language not found. Adding it now..."
    $CurrentLangs += New-WinUserLanguageList $LangTag
    Set-WinUserLanguageList -LanguageList $CurrentLangs -Force
    Start-Sleep -Seconds 5  # Wait for the language to install
} else {
    Write-Host "Japanese language is already installed."
}

# Step 2: Change the Keyboard Layout to Japanese
$RegPath = "HKCU:\Keyboard Layout\Preload"
$CurrentLayouts = Get-ItemProperty -Path $RegPath

# Ensure Japanese is added to the list
$Exists = $false
foreach ($Property in $CurrentLayouts.PSObject.Properties) {
    if ($Property.Value -eq $LangCode) {
        $Exists = $true
        break
    }
}

if (-not $Exists) {
    $Slot = ($CurrentLayouts.PSObject.Properties.Name | Measure-Object).Count + 1
    Set-ItemProperty -Path $RegPath -Name "$Slot" -Value $LangCode
    Write-Host "Japanese keyboard layout (0411) added."
} else {
    Write-Host "Japanese keyboard layout is already set."
}

# Step 3: Ensure IME is Enabled
$IMEPath = "HKCU:\Software\Microsoft\InputMethod\Settings\CHS"
if (-Not (Test-Path $IMEPath)) {
    New-Item -Path $IMEPath -Force | Out-Null
}
Set-ItemProperty -Path $IMEPath -Name "Enable" -Value 1
Write-Host "Japanese IME is enabled."

# Step 4: Force Update to Japanese
$RegInputPath = "HKCU:\Control Panel\International\User Profile"
Set-ItemProperty -Path $RegInputPath -Name "InputMethodOverride" -Value $LangCode

# Step 5: Restart Explorer to Apply Changes
Stop-Process -Name "explorer" -Force
Start-Process "explorer"

Write-Host "Japanese keyboard is now active! Try typing, or log out and log back in if needed."
