# Define the URL of the wallpaper
$wallpaperUrl = "https://raw.githubusercontent.com/VanillaVulture/Wallpaper/main/ComputersDefaultWallpaper.png"

# Get the current user's Pictures directory
$wallpaperPath = "$env:USERPROFILE\Pictures\ComputersDefaultWallpaper.png"

# Download the wallpaper
Invoke-WebRequest -Uri $wallpaperUrl -OutFile $wallpaperPath

# Set the wallpaper using registry and SystemParametersInfo
$RegPath = "HKCU:\Control Panel\Desktop"

# Update registry keys to change wallpaper
Set-ItemProperty -Path $RegPath -Name Wallpaper -Value $wallpaperPath
Set-ItemProperty -Path $RegPath -Name WallpaperStyle -Value 2  # Stretch wallpaper
Set-ItemProperty -Path $RegPath -Name TileWallpaper -Value 0

# Refresh the wallpaper
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[Wallpaper]::SystemParametersInfo(20, 0, $wallpaperPath, 3)
