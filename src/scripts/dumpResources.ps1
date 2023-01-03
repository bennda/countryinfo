param(
  [Parameter(Mandatory = $false)]
  [string]$URL = 'https://restcountries.com/v3/all',  
  [Parameter(Mandatory = $false)]
  [string]$DumpPath = "$PSScriptRoot",
  [Parameter(Mandatory = $false)]
  [switch]$Force,
  [Parameter(Mandatory = $false)]
  [switch]$ForceFlags
)

# init variables
$countriesFile = "$DumpPath/countries-src.json"

Write-Host "`n===== dump countries"
Write-Host "URL           = $URL"
Write-Host "DumpPath      = $DumpPath"
Write-Host "Force         = $Force"
Write-Host "ForceFlags    = $ForceFlags"
Write-Host "countriesFile = $countriesFile"

function Get-SourceCountries {
  param(
    [Parameter(Mandatory = $true)]
    [string]$URL,
    [Parameter(Mandatory = $true)]
    [string]$OutputFile,
    [Parameter(Mandatory = $true)]
    [bool]$Force
  )
  if (!(Test-Path "$OutputFile") -or $Force) {
    Write-Host "download: $URL"
    $response = Invoke-WebRequest -Uri "$URL"
    if ($response.StatusCode -ne 200) {
      Write-Host "error: get countries failed ($($response.StatusCode))`n"
      exit 1
    }
    Write-Host "save file: $OutputFile"
    $response.Content | Out-File (New-Item "$OutputFile" -Force) -Force -Encoding utf8
  } 
  
  Write-Host "load file: $OutputFile"
  return Get-Content "$OutputFile" -Raw | ConvertFrom-Json -Depth 100
}

function Get-Flag {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Link,
    [Parameter(Mandatory = $true)]
    [string]$Code,
    [Parameter(Mandatory = $true)]
    [string]$OutputPath,
    [Parameter(Mandatory = $true)]
    [bool]$Force
  )
  
  $name = "$Link".Split('/')[-1]
  $outputName = $Code.ToLower()
  switch ($name) {
    { $_.EndsWith('.png') } {
      $outputName += ".png"
    }
    { $_.EndsWith('.svg') } {
      $outputName += ".svg"
    }
  }

  $outputFile = "$OutputPath/$outputName"
  Write-Host "...$name  -->  $outputFile"
  if (!(Test-Path "$outputFile") -or $Force) {
    Invoke-WebRequest -Uri "$Link" -OutFile (New-Item "$outputFile" -Force)
  }

  return "$outputName"
}

function Get-ConvertedCountries {
  param(
    [Parameter(Mandatory = $true)]
    [string]$SourceFile
  )

  $countries = @()
  $sourceCountries = Get-Content "$SourceFile" -Raw | ConvertFrom-Json -Depth 100

  foreach ($source in $sourceCountries) { 
    $countries += [ordered]@{
      Names         = [ordered]@{
        Name         = [ordered]@{
          Common   = "$($source.name.common)"
          Official = "$($source.name.official)"
        }
        Native       = $source.name.nativeName
        AltSpellings = $source.altSpellings
        Translations = $source.translations
      }
      Codes         = [ordered]@{
        TLD   = $source.tld
        Cca2  = $source.cca2
        Cca3  = $source.cca3
        Ccn3  = $source.ccn3
        Cioc  = $source.cioc
        Fifa  = $source.fifa
        Car   = $source.car.signs
        Phone = [ordered]@{
          Root     = $source.idd.root
          Suffixes = $source.idd.suffixes
        }
      }
      Currencies    = $source.currencies
      Languages     = $source.languages
      Timezones     = $source.timezones
      IsMemberUN    = $source.unMember
      IsIndependent = $source.independent
      GeoData       = [ordered]@{
        Capital      = $source.capital
        Region       = $source.region
        SubRegion    = $source.subregion
        Continents   = $source.continents
        Area         = $source.area
        Population   = $source.population
        Borders      = $source.borders
        IsLandlocked = $source.landlocked
        LatLng       = $source.latlng
      }
      Flag          = $source.flag
    }
  }

  return $countries
}

# get countries
Write-Host "`n===== get countries from source"
$sourceCountries = Get-SourceCountries -URL "$URL" -OutputFile "$countriesFile" -Force $Force

# get country flags
Write-Host "`n===== get flags"
$flags = @()
foreach ($country in $sourceCountries) {
  $country.flags | ForEach-Object {
    $flags += Get-Flag -Link "$_" -Code $country.cca2 -OutputPath "$DumpPath/flags" -Force $ForceFlags
  }
}

# convert source countries into
$countriesFileNew = "$DumpPath/countries.json"
$countries = Get-ConvertedCountries -SourceFile "$countriesFile"
$countries | ConvertTo-Json -Depth 100 -Compress | Out-File (New-Item "$countriesFileNew" -Force) -Encoding utf8 -Force