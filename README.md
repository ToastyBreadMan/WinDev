# WinDev

A quick Powershell script to install development tools on a fresh VM

## Install 

Run the following oneliner **from an admin powershell env** to start the setup:

```
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/ToastyBreadMan/WinDev/main/setup.ps1'))
```

---

If running powershell functions directly from a string downloaded over the
internet wigs you out (understandable), you can follow the following steps:

Download the 'setup.ps1' file:
```
Invoke-WebRequest -Uri https://raw.githubusercontent.com/ToastyBreadMan/WinDev/main/setup.ps1 -OutFile $env:USERPROFILE'\Downloads\setup.ps1'
```

Review the downloaded file and then run the script with:
```
Get-Content $env:USERPROFILE'\Downloads\setup.ps1' -Raw | IEX
```
