$image = "$env:USERPROFILE\Downloads\wallpaper.png" # Dynamically resolves to the current user's Downloads folder

<# 
.NOTES 
    This will take the image you downloaded and set it as the target's wallpaper
#>

Function Set-WallPaper {
    param (
        [parameter(Mandatory=$True)]
        [string]$Image,
        [parameter(Mandatory=$False)]
        [ValidateSet('Fill', 'Fit', 'Stretch', 'Tile', 'Center', 'Span')]
        [string]$Style = 'Fill'  # Set default to 'Fill'
    )

    $WallpaperStyle = Switch ($Style) {
        "Fill" {"10"}
        "Fit" {"6"}
        "Stretch" {"2"}
        "Tile" {"0"}
        "Center" {"0"}
        "Span" {"22"}
    }

    If($Style -eq "Tile") {
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 1 -Force
    } Else {
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force
        New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 0 -Force
    }

    Add-Type -TypeDefinition @"
    using System; 
    using System.Runtime.InteropServices;

    public class Params
    { 
        [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
        public static extern int SystemParametersInfo (Int32 uAction, 
                                                       Int32 uParam, 
                                                       String lpvParam, 
                                                       Int32 fuWinIni);
    }
"@

    $SPI_SETDESKWALLPAPER = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02

    $fWinIni = $UpdateIniFile -bor $SendChangeEvent

    [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
}

# Example call to the function:
Set-WallPaper -Image $image -Style "Fill"
