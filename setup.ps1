#
# Functions
#
# Source: https://github.com/jamestharpe/windows-development-environment

function Update-Environment-Path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}


# 
# Dependencies
#
# Source: https://github.com/microsoft/winget-cli/issues/1861

# Get 'Desktop Installer'
Add-AppxPackage -Path https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx

# Get Microsoft.UI.Xaml
# Note: nuget is not owned by Microsoft, but is funded by microsoft.:shrug:
Invoke-WebRequest -Uri https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.3 -OutFile .\microsoft.ui.xaml.2.7.3.zip
Expand-Archive .\microsoft.ui.xaml.2.7.3.zip
Add-AppxPackage .\microsoft.ui.xaml.2.7.3\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx

Remove-Item "microsoft.ui.xaml.2.7.3.zip"
Remove-Item "microsoft.ui.xaml.2.7.3" -Recurse

#
# Winget
#
# Source: https://stackoverflow.com/questions/74166150/install-winget-by-the-command-line-powershell

# get latest download url
$URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
$URL = (Invoke-WebRequest -UseBasicParsing -Uri $URL).Content | ConvertFrom-Json |
        Select-Object -ExpandProperty "assets" |
        Where-Object "browser_download_url" -Match '.msixbundle' |
        Select-Object -ExpandProperty "browser_download_url"

# download
Invoke-WebRequest -Uri $URL -OutFile "Setup.msix" -UseBasicParsing

# install
Add-AppxPackage -Path "Setup.msix"

# delete file
Remove-Item "Setup.msix"

Update-Environment-Path
