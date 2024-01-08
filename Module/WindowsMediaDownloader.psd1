@{
    RootModule        = 'WindowsMediaDownloader.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = '405aeed1-3c66-44d1-9e35-7ed4886317bb'
    Author            = 'innovatodev'
    CompanyName       = 'innovatodev'
    Copyright         = '(c) innovatodev. All rights reserved.'
    Description       = 'Script to download any version of Windows on https://uupdump.net/.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @(
        'Invoke-WindowsMediaDownloader'
    )
    CmdletsToExport   = @()
    VariablesToExport = '*'
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags         = @('Windows', 'ISO', 'Download', 'Media')
            LicenseUri   = 'https://raw.githubusercontent.com/innovatodev/WindowsMediaDownloader/main/LICENSE'
            ProjectUri   = 'https://github.com/innovatodev/WindowsMediaDownloader'
            IconUri      = 'https://raw.githubusercontent.com/innovatodev/WindowsMediaDownloader/main/media/icon.png'
            ReleaseNotes = 'https://raw.githubusercontent.com/innovatodev/WindowsMediaDownloader/main/CHANGELOG.md'
        }
    }
}
