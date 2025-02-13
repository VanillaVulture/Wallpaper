# Japanese Language and Keyboard Codes
$LangCode = "0411"  # Japanese Keyboard Layout (Microsoft IME)
$LangTag = "ja-JP"  # Japanese Language Tag

# Step 1: Ensure Japanese is installed
$CurrentLangs = Get-WinUserLanguageList
if ($CurrentLangs.LanguageTag -notcontains $LangTag) {
    Write-Host "Japanese language not found. Adding it now..."
    $CurrentLangs += New-WinUserLanguageList $LangTag
    Set-WinUserLanguageList -LanguageList $CurrentLangs -Force
    Start-Sleep -Seconds 5  # Wait for the language to install
} else {
    Write-Host "Japanese language is already installed."
}

# Step 2: Set Japanese (IME) as the default input method
$RegInputPath = "HKCU:\Control Panel\International\User Profile"
Set-ItemProperty -Path $RegInputPath -Name "InputMethodOverride" -Value $LangCode
Write-Host "Japanese IME set as the default input method."

# Step 3: Add Japanese Keyboard Layout to Preload
$RegPath = "HKCU:\Keyboard Layout\Preload"
$CurrentLayouts = Get-ItemProperty -Path $RegPath

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

# Step 4: Restart Explorer to Apply Changes
Stop-Process -Name "explorer" -Force
Start-Process "explorer"

Write-Host "Japanese Keyboard and IME are now active! Try typing, or log out and log back in if needed."
