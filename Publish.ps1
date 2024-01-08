New-Item "$env:UserProfile\Documents\WindowsPowerShell\Modules\WindowsMediaDownloader" -ItemType Directory
Copy-Item -Path ".\Module\*" -Destination "$env:UserProfile\Documents\WindowsPowerShell\Modules\WindowsMediaDownloader" -Recurse
Import-Module "$env:UserProfile\Documents\WindowsPowerShell\Modules\WindowsMediaDownloader\WindowsMediaDownloader.psd1"
Publish-Module -Name WindowsMediaDownloader -NuGetApiKey $env:PSGALLERY_KEY
