function Download-FromUrl
{
    param([string]$url, [string]$destinationPath, [string]$hashString)

    $download = $false
    if (-not (Test-Path($destinationPath))) {
        Write-Host "$destinationPath does not exist...downloading..."
        $download = $true
    }
    else {
        # Ensure checksum is valid.
        $hash = Get-FileHash $destinationPath -Algorithm SHA256

        if ($hash.Hash -ne $hashString) {
            Write-Host "$desginationPath does not match expected hash...redownloading..."
            $download = $true
        }
        else {
            Write-Host "$desginationPath exists and matches expected hash.  Nothing to do."
        }
    }

    if ($download) {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12            
        invoke-webrequest $url -OutFile $destinationPath -UserAgent [Microsoft.PowerShell.Commands.PSUserAgent]::FireFox

        $hash = Get-FileHash $destinationPath -Algorithm SHA256
        if ($hash.Hash -ne $hashString) {
            # Download must have failed.
            Write-Host "Downloaded file does not match the given hash.  Aborting"
            exit -1
        }        
    }
}


# Applications
choco install -y googlechrome

# System Utilities
choco install -y sysinternals

# Development tools/apps
choco install -y git
choco install -y cmake --installargs 'ADD_CMAKE_TO_PATH=System'
choco install -y visualstudiocode
choco install -y visualstudio2015professional --timeout 5400 -packageParameters "--AdminFile c:\Users\Public\AdminDeployment.xml"

# Languages
choco install -y python
choco install -y golang

# Qt
# choco install -y qt-vs-addin5
$commonDocuments = [Environment]::GetFolderPath("CommonDocuments")

Download-FromUrl "https://download.qt.io/official_releases/qt/5.6/5.6.3/qt-opensource-windows-x86-msvc2015_64-5.6.3.exe" (join-path $commonDocuments qt-opensource-windows-x86-msvc2015_64-5.6.3.exe) "C69DD3424B82F62C4D4080ED00C8DEE7AA5DB1E9BACE09B7086405609C95941D"
