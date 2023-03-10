#
# Functions
#
# Source: https://github.com/jamestharpe/windows-development-environment

function Update-Environment-Path {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

function Install-Program {	
	param (
		[Parameter(Mandatory)]
		[string]$ProgramName,
		[string]$OverrideParams
	)

	if (!$PSBoundParameters.ContainsKey('OverrideParams')) {
		winget install --id $ProgramName --silent --accept-package-agreements --accept-source-agreements --disable-interactivity
	}
	else {
		winget install --id $ProgramName --silent --accept-package-agreements --accept-source-agreements --disable-interactivity --override $OverrideParams
	}
}

#current role
if (!(New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	Write-Error "Needs to be run from elevated shell"
	return
}

# Apparently progress bars drastically slow WebRequest downloads
$ProgressPreference = 'SilentlyContinue'

# 
# Dependencies
#
# Source: https://github.com/microsoft/winget-cli/issues/1861

# Get 'Desktop Installer'
Write-Output "Installing dependency 'Microsoft Desktop Installer'"
Add-AppxPackage -Path https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx

# Get Microsoft.UI.Xaml
# Note: nuget is not owned by Microsoft, but is funded by microsoft.:shrug:
Write-Output "Installing dependency 'Microsoft UI Xaml 2.7'"
Invoke-WebRequest -Uri https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.3 -OutFile $env:USERPROFILE'\Downloads\microsoft.ui.xaml.2.7.3.zip'
Expand-Archive -Path $env:USERPROFILE'\Downloads\microsoft.ui.xaml.2.7.3.zip' -DestinationPath $env:USERPROFILE'\Downloads\microsoft.ui.xaml.2.7.3'
Add-AppxPackage $env:USERPROFILE'\Downloads\microsoft.ui.xaml.2.7.3\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx'

Remove-Item $env:USERPROFILE'\Downloads\microsoft.ui.xaml.2.7.3.zip'
Remove-Item $env:USERPROFILE'\Downloads\microsoft.ui.xaml.2.7.3' -Recurse

#
# Winget
#
# Source: https://stackoverflow.com/questions/74166150/install-winget-by-the-command-line-powershell

# get latest download url
Write-Output "Installing winget"
$URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
$URL = (Invoke-WebRequest -UseBasicParsing -Uri $URL).Content | ConvertFrom-Json |
        Select-Object -ExpandProperty "assets" |
        Where-Object "browser_download_url" -Match '.msixbundle' |
        Select-Object -ExpandProperty "browser_download_url"

# download
Invoke-WebRequest -Uri $URL -OutFile $env:USERPROFILE'\Downloads\Setup.msix' -UseBasicParsing

# install
Add-AppxPackage -Path $env:USERPROFILE'\Downloads\Setup.msix'

# delete file
Remove-Item $env:USERPROFILE'\Downloads\Setup.msix'

Update-Environment-Path

# winget programs
Install-Program -ProgramName Mozilla.firefox
Install-Program -ProgramName Git.Git
Install-Program -ProgramName Microsoft.VisualStudioCode -OverrideParams '/SILENT /mergetasks="!runcode,addcontextmenufiles,addcontextmenufolders"'
Install-Program -ProgramName Python.Python.3.9
Install-Program -ProgramName 7zip.7Zip
Install-Program -ProgramName WinSCP.WinSCP
Install-Program -ProgramName ojdkbuild.ojdkbuild
Install-Program -ProgramName ojdkbuild.openjdk.11.jdk

# MS STORE id's
# Windbg: 9PGJGD53TN86
# Sysinternals: 9P7KNL5RWT25
Install-Program -ProgramName 9PGJGD53TN86
Install-Program -ProgramName 9P7KNL5RWT25

Update-Environment-Path

# Other programs not on winget

$URL = "https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/latest"
$URL = (Invoke-WebRequest -UseBasicParsing -Uri $URL).Content | ConvertFrom-Json |
		Select-Object -ExpandProperty "assets" |
		Where-Object "browser_download_url" -Match '.zip' |
		Select-Object -ExpandProperty "browser_download_url"

Invoke-WebRequest -Uri $URL -OutFile $env:USERPROFILE'\Downloads\ghidra.zip' -UseBasicParsing
Expand-Archive -Path $env:USERPROFILE'\Downloads\ghidra.zip' -DestinationPath $env:USERPROFILE'\Documents\ghidra'
Remove-Item $env:USERPROFILE'\Downloads\ghidra.zip'


$URL = 'https://sourceforge.net/projects/regshot/files/latest/download'
Invoke-WebRequest -UseBasicParsing -UserAgent "Wget" -Uri $URL -OutFile $env:USERPROFILE'\Downloads\regshot.zip'
Expand-Archive -Path $env:USERPROFILE'\Downloads\regshot.zip' -DestinationPath $env:USERPROFILE'\Documents\regshot'
Remove-Item $env:USERPROFILE'\Downloads\regshot.zip'


# Pip programs
pip install frida

# Restore Progress bars to session
$ProgressPreference = 'Continue'
