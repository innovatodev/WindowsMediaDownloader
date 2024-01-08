<#
.SYNOPSIS
Downloads Windows ISO files for specified OS and Type.

.DESCRIPTION
The Invoke-WindowsMediaDownloader function downloads Windows ISO files from a specified URI.
It allows users to select the operating system (OS), the type of Windows (such as consumer for client or 2019 for server),
the language, and the destination for the download.

.PARAMETER OS
Specifies the operating system for which to download the ISO. Valid options are 'server', '10', and '11'.

.PARAMETER Type
Specifies the type of Windows ISO to download. Options include 'consumer', 'business', '2022', '2019', and '2016'.

.PARAMETER Lang
Specifies the language for the ISO. If not set, the function will prompt for a language choice.

.PARAMETER Destination
Specifies the directory where the ISO file will be downloaded. Default is the user's Downloads folder.

.PARAMETER Force
Forces the download of the ISO even if a file with the same name already exists at the destination.

.PARAMETER Skip
Skips the download if a file with the same name already exists at the destination.

.PARAMETER NoDownload
If set, the function will not download the file but return the final URI for the selected ISO.

.EXAMPLE
Invoke-WindowsMediaDownloader -OS '11' -Type 'consumer' -Lang 'en-us'

Downloads latest consumer version of Windows 11 with language 'en-us'

.EXAMPLE
Invoke-WindowsMediaDownloader -OS '11' -Type 'consumer'

Asks to select a language from the availables list and downloads latest consumer version of Windows 11

.EXAMPLE
Invoke-WindowsMediaDownloader -OS 'server' -Type '2022'

Asks to select a language from the availables list and downloads latest 2022 version of Windows Server

.NOTES
Author: innovatodev

.LINK
https://github.com/innovatodev/WindowsMediaDownloader

#>

function Invoke-WindowsMediaDownloader {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)][ValidateSet('server', '10', '11')][String]$OS,
        [Parameter(Mandatory = $true, Position = 1)][ValidateSet('consumer', 'business', '2022', '2019', '2016')][String]$Type,
        [Parameter()][String]$Lang = "",
        [Parameter()][System.IO.DirectoryInfo]$Destination = "$env:USERPROFILE\Downloads",
        [Parameter()][Switch]$Force,
        [Parameter()][Switch]$Skip,
        [Parameter()][Switch]$NoDownload

    )
    function Select-Option {
        param(
            [parameter(Mandatory = $true, Position = 0)][string]$Message,
            [parameter(Mandatory = $true, Position = 1)][string[]]$Options
        )
        $Selected = $null
        while ($null -eq $Selected) {
            Write-Host "`n$Message" -ForegroundColor Yellow
            for ($i = 0; $i -lt $Options.Length; $i++) {
                Write-Host "`n[" -NoNewline
                Write-Host "$($i+1)" -NoNewline -ForegroundColor Yellow
                Write-Host "]" -NoNewline
                Write-Host " $($Options[$i])" -NoNewline
            }
            $SelectedIndex = [int](Read-Host "`nSelect an option")
            if ($SelectedIndex -gt 0 -and $SelectedIndex -le $Options.Length) {
                $Selected = $Options[$SelectedIndex - 1]
            } else {
                Write-Host "`nInvalid Option" -ForegroundColor Red
            }
        }
        return $Selected
    }
    $uri = "https://massgrave.dev/windows_$($OS)_links.html"
    $response = Invoke-WebRequest -Uri $uri -UseBasicParsing -DisableKeepAlive | Select-Object Links
    $finalURI = ""
    $finalDestination = ""
    $langHash = @{}
    [string[]]$langOptions = @()

    if ([String]::IsNullOrEmpty($Lang)) { $filterURL = "*https://drive.massgrave.dev/*$($OS)*$($Type)*x64*.iso*" }
    else { $filterURL = "*https://drive.massgrave.dev/*$Lang*$($OS)*$($Type)*x64*.iso*" }

    if ([String]::IsNullOrEmpty($Lang)) {
        $selected = $response.Links | Where-Object { $_.outerHTML -like $filterURL }
        $selected.href | ForEach-Object {
            $split = (($_ -split 'https://drive.massgrave.dev/')[1] -Split ('_'))[0]
            $langHash.Add($split, $_)
        }
        $langHash.GetEnumerator() | Sort-Object Value | ForEach-Object { $langOptions += $_.Key }
        $askLang = Select-Option -Message "Please Select a langage" -Options $langOptions
        $splitFileName = ($($langHash["$askLang"]) -split 'https://drive.massgrave.dev/')[1]
        $finalURI = $($langHash["$askLang"])
        $finalDestination = "$Destination\$splitFileName"
        if ($NoDownload) { return $finalURI }
    } else {
        $selected = $response.Links | Where-Object { $_.outerHTML -like $filterURL } | Select-Object -First 1
        if ($null -eq $selected.href) { Write-Error "No ISO Found on $uri" ; return }
        $splitFileName = ($($selected.href) -split 'https://drive.massgrave.dev/')[1]
        $finalURI = $($selected.href)
        $finalDestination = "$Destination\$splitFileName"
        if ($NoDownload) { return $finalURI }
    }

    if (Test-Path $finalDestination) {
        if ($Skip -eq $true) {
            Write-Warning "$finalDestination already exists, skipping."
            return $finalDestination
        } elseif ($Force -eq $true) {
            Write-Host "Downloading: $finalURI" -ForegroundColor Blue
            Write-Host "Destination: $finalDestination" -ForegroundColor Magenta
            try {
                Write-Warning "Removing $finalDestination"
                Remove-Item $finalDestination -Force -Confirm:$false | Out-Null
                Invoke-WebRequest -Uri $finalURI -OutFile $finalDestination
            } catch { Write-Error "Error downloading $finalURI" ; return $null }
        } else { Write-Error "The ISO already exists, please add -Force to overwrite." ; return $null }
    } else {
        Write-Host "Downloading: $finalURI" -ForegroundColor Blue
        Write-Host "Destination: $finalDestination" -ForegroundColor Magenta
        try {
            Invoke-WebRequest -Uri $finalURI -OutFile $finalDestination
        } catch { Write-Error "Error downloading $finalURI" ; return $null }
    }

    Write-Host "Ready: $finalDestination" -ForegroundColor Green
    return $finalDestination
}
