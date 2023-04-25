# Overview

A simple powershell script that can be used to convert a CSV file with Towns or POIs and their coordinates to a SeeYou .CUP file that can be used by LK8000, XCSoar, and other Navigation software used for flying.

## File input
The main input is a CSV file with the following columns
  - Name - the name of the point or town (Example: "Sofia")
  - lat - Geographical latitude in decimal format. (Example: 42.696627)
  - lon - Geographical longitude in decimal format. (Example: 23.321071)
  - alt - Altitude in meters (Example: 515)
  
  Here's a sample file:
  ```
"Name,"lat","lon","alt"
"Prague",50.0755,14.4378,177
"Brno",49.1952,16.6068,237
"Ostrava",49.8209,18.2625,210
"Plzen",49.7465,13.3776,312
  ```

## Script usage
The script takes a few parameters:
  - FileInput - Path to the file with coordinates (Example: C:\file.csv)
  - FileOutput - Path to the output file (Example: C:output.cup)
  - Country - 2-letter code of the country (Examples: BG, CZ, IT, DE)
  - Style - Describes the type of the points, Towns, peaks, etc.
  Some sample styles are:
  ```
  1 Waypoint
  2 Airfield with grass surface runway
  5 Airfield with solid surface runway
  7 Mountain top
  9 VOR
  11 Cooling Tower
  12 Dam
  14 Bridge
  15 Power Plant
  16 Castle
  ```


Example: Convert-PoICoordinatesToCup.ps1 -InputFile "C:\towns.csv" -Country "BG" -Style "1" -FileOutput "output.cup"
