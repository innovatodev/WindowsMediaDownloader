Import-Module .\Module\WindowsMediaDownloader.psd1 -Force

Invoke-WindowsMediaDownloader -OS '11' -Type 'consumer' -Lang 'en-us' -NoDownload
Start-Sleep 1
Invoke-WindowsMediaDownloader -OS '11' -Type 'business' -Lang 'en-us' -NoDownload
Start-Sleep 1
Invoke-WindowsMediaDownloader -OS '10' -Type 'consumer' -Lang 'en-us' -NoDownload
Start-Sleep 1
Invoke-WindowsMediaDownloader -OS '10' -Type 'business' -Lang 'en-us' -NoDownload
Start-Sleep 1
Invoke-WindowsMediaDownloader -OS 'server' -Type '2022' -Lang 'en-us' -NoDownload
Start-Sleep 1
Invoke-WindowsMediaDownloader -OS 'server' -Type '2016' -Lang 'en' -NoDownload
