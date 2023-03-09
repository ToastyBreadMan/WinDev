#
# Functions
#
# Source: https://github.com/jamestharpe/windows-development-environment

function Update-Environment-Path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}


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
