param(
  [Parameter(Mandatory = $false)]
  [string]$URL = 'https://restcountries.com/v3/all',  
  [Parameter(Mandatory = $false)]
  [string]$BasePath = "$PSScriptRoot/../..",
  [Parameter(Mandatory = $false)]
  [switch]$Force,
  [Parameter(Mandatory = $false)]
  [switch]$ForceFlags,
  [Parameter(Mandatory = $false)]
  [switch]$NodeJs
)

# init variables
$countriesFile = "$BasePath/data/countries.json"

Write-Host "`n===== dump countries"
Write-Host "URL           = $URL"
Write-Host "BasePath      = $BasePath"
Write-Host "Force         = $Force"
Write-Host "ForceFlags    = $ForceFlags"
Write-Host "NodeJs        = $NodeJs"
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
    [string[]]$OutputPaths,
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

  $outputFile = "$($OutputPaths[0])/$($outputName)"
  $msg = "...$name  -->  $outputFile"
  if (!(Test-Path "$outputFile") -or $Force) {
    $msg += " [download]"
    Invoke-WebRequest -Uri "$Link" -OutFile (New-Item "$outputFile" -Force)
  }
  Write-Host "$msg"

  for ($i = 1; $i -lt $OutputPaths.Count; $i++) {
    $file = "$($OutputPaths[$i])/$($outputName)"
    $msg = "...$name  -->  $file"
    if (!(Test-Path "$file") -or $Force) {
      $msg += " [copy]"
      Copy-Item -Path "$outputFile" -Destination (New-Item "$file" -Force) -Force
    }
    Write-Host "$msg"
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

# get countries from source
Write-Host "`n===== get countries from source"
$sourceCountries = Get-SourceCountries -URL "$URL" -OutputFile "$countriesFile" -Force $Force

# convert source countries to countries
$countries = Get-ConvertedCountries -SourceFile "$countriesFile"
$json = $countries | ConvertTo-Json -Depth 100 -Compress 

Write-Host "`n===== write countries.json"
@(
  "$BasePath/src/dotnet/DBN.CountryInfo/Data/countries.json",
  "$BasePath/src/nodejs/server/data/countries.json",
  "$BasePath/src/go/server/data/countries.json"
) | ForEach-Object {
  Write-Host "file: $_"
  "$json" | Out-File (New-Item "$_" -Force) -Encoding utf8 -Force
}

# get country flags
Write-Host "`n===== get flags"
$flagOutputPaths = @(
  "$BasePath/src/dotnet/DBN.CountryInfo/Data/Flags", 
  "$BasePath/src/nodejs/server/data/flags", 
  "$BasePath/src/go/server/data/flags"
)
$flags = @()
foreach ($country in $sourceCountries) {
  $country.flags | ForEach-Object {
    $flags += Get-Flag -Link "$_" -Code $country.cca2 -OutputPaths $flagOutputPaths -Force $ForceFlags
  }
}