<#
    .SYNOPSIS
    Converts a CSV file with GPS Coordinates of PoIs to a "SeeYou" .CUP format

    .DESCRIPTION
    Takes as input a CSV file with the following columns:
        - Name - the name of the point or town (Example: "Sofia")
        - lat - Geographical latitude in decimal format. (Example: 42.696627)
        - lon - Geographical longitude in decimal format. (Example: 23.321071)
        - alt - Altitude in meters (Example: 515)

    .EXAMPLE
    PS> Convert-PoICoordinatesToCup.ps1 -InputFile "C:\towns.csv" -Country "BG" -Style "1"

#>

 PARAM(
    [Parameter(Mandatory)]$fileInput,
    [Parameter(Mandatory)]$fileOutput,
    [Parameter(Mandatory)]$country,
    [Parameter(Mandatory)]$style
    )

$inputPoi = Get-Content $fileInput | ConvertFrom-Csv

function main {
    ForEach ($poi in $inputPoi) {
        if ($poi.Name.length -lt 6) {
            $poiShort = $poi.Name.Replace(' ','')
        } else {
            $poiShort = $poi.Name.Replace(' ','').Substring(0,6)
        }
        $coordinatesInput = ("{0}, {1}" -f $poi.lat, $poi.lon)
        $convertedCoordinates = Coordinates-DecimalToDeg -decimal $coordinatesInput
        ("`"{0}`",{1},{2},{3},{4},{5}.0m,{6},,,,," -f $poi.Name,$poiShort,$country,$convertedCoordinates[0],$convertedCoordinates[1],$poi.alt,$style) | Out-File -FilePath $fileOutput -Append
    }
}

function Coordinates-DecimalToDeg {
 PARAM(
    [Parameter(Mandatory)]$decimal
    )

    $coordinates = $decimal.Split(",")

    $latitude = [math]::Truncate([double]$coordinates[0])
    $longitude = [math]::Truncate([double]$coordinates[1])

    [int]$latitudeAbs = [math]::Abs([double]$latitude)
    [int]$longitudeAbs = [math]::Abs([double]$longitude)

    $latitudeDecimal = [math]::Abs([double]$coordinates[0] - $latitude)
    $longitudeDecimal = [math]::Abs([double]$coordinates[1] - $longitude)

    [int]$latitudeMinutes = [math]::Truncate($latitudeDecimal * 60)
    [int]$longitudeMinutes = [math]::Truncate($longitudeDecimal * 60)

    [double]$latitudeSeconds = ($latitudeDecimal * 60 - $latitudeMinutes) * 60 * 10 # *10 is added because the .CUP format needs the seconds without decimal point (52.5 = 525)
    [double]$longitudeSeconds = ($longitudeDecimal * 60 - $longitudeMinutes) * 60 *10

    [int]$latitudeSecondsFormatted = ("{0:F0}" -f $latitudeSeconds)
    [int]$longitudeSecondsFormatted = ("{0:F1}" -f $longitudeSeconds)

    $latitudeDirection = "N"
    $longitudeDirection = "E"

    if ($latitude -lt 0) {
        $latitudeDirection = "S"
    }

    if ($longitude -lt 0) {
        $longitudeDirection = "W"
    }

    $latOut =  ("{0:D2}{1:D2}.{2:D3}{3}" -f $latitudeAbs, $latitudeMinutes, $latitudeSecondsFormatted, $latitudeDirection)
    $longOut = ("{0:D3}{1:D2}.{2:D3}{3}" -f $longitudeAbs, $longitudeMinutes, $longitudeSecondsFormatted, $longitudeDirection)
    return @($latOut,$longOut)
}

main