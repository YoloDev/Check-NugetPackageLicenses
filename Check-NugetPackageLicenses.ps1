function Check-NugetPackageLicenses {

    
    $xml = [xml](Get-Content .\packages.config)

    $xml.packages.package | % {

        $id = $_.id
        $ver=  $_.version
        Write-Host "Checking $id - $ver " -NoNewline
        $license = Get-NugetLicenseDetails $id $ver
        if ($license.LicenseNames.GetType().Name -ne "XmlElement") {
            Write-Host $license.LicenseNames -BackgroundColor Green
        }
        else {
            Write-Warning $license.LicenseUrl 
        }
    }
  
}

function Get-NugetLicenseDetails {

    param(
    [Parameter(Mandatory=$True)]
    [string]$packageId,
    [Parameter(Mandatory=$True)]
    [string]$packageVersion
    )

    $response = $(Invoke-RestMethod "https://nuget.org/api/v2/Packages(Id='$packageId',Version='$packageVersion')?$select=LicenseNames,LicenseUrl").entry.properties
   
   new-object PSObject -Property @{ LicenseNames = $response.LicenseNames; LicenseUrl = $response.LicenseUrl }
}
