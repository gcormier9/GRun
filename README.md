# GRun
Configurable Garmin Watch datafield

![GRun Cover Image](/doc/GRunWatch.png) 


## Description
Highly configurable datafield where you can select up to 10 fields to display. If less fields are configured, the field area on each line will automatically expand.
The second and third row display a header field with the value. The Header fields can be positioned Top/Top, Top/Bottom or Bottom/Top.

The first, fourth and fifth row display values without header.

The following fields are currently supported:
- Empty
- Time
- Timer
- Time spend on current km/mile
- Last km/mile Time
- Distance
- Current Heart Rate
- Current Pace
- Current Speed
- Average Heart Rate
- Average Pace
- Average Pace (Calculated mnually using timer/distance)
- Average Speed
- Calories
- Current Cadence
- Altitude
- Total Ascent
- Total Descent
- Battery Icon
- GPS Icon
- GPS Icon & Battery Icon
- ETA 5K
- ETA 10K
- ETA Half Marathon (21.075.5 km)
- ETA Marathon (42.195 km)
- Lap Time
- Lap Distance
- Lap Pace
- Training Effect (on supported devices)
- Total Corrected Distance (meter)

## Notes
- Fields related to distance are displayed in km or mile depending on the user profile, except for "Total correct distance", which is always displayed in meter.
- Fields related to speed are displayed in km/h or mile/h depending on the user profile.
- Fields related to pace are displayed in min/km or min/mile depending on the user profile.
- Heart Rate is displayed in color based on user profile heart rate zone.
- Current Pace and Average Pace are displayed in color based on application parameters
  - Blue if too fast, Green if between Min and Max Pace, Red if too slow

## Configuration
### Header Position
Header Position can have 3 positions.
#### 1) Top / Top
![GRun TopTop](/doc/GRunWatch2.png)

#### 2) Top / Bottom
![GRun TopBottom](/doc/GRunWatch3.png)
#### 3) Bottom / Top
![GRun BottomTop](/doc/GRunWatch4.png)

### Header Height
On row #2 and #3, header height can be configured using a percentage of the area.
You can hide headers by setting the value to 0:

![GRun Hide Headers](/doc/GRunHeaders0.png)

A value of 100 will hide the actual values (not very useful):

![GRun Hide Headers](/doc/GRunHeaders100.png)

Default value of 30 looks like this:

![GRun Hide Headers](/doc/GRunHeaders30.png)

### Uniform Background Color
By default, rows 4 and 5 have a different background color.
![GRun BottomTop](/doc/GRunWatch10.png)

To have a uniform background color, simply enable this setting.
![GRun BottomTop](/doc/GRunWatch11.png)

### Lap Distance
Lap Distance is useful for people running in competition. It allows to readjust distance. For example, if you set the value to 1000 (meters), it allows you to press the lap button at each kilometer. If Garmin had calculated a value of 1.01 km at km #1, it will readjust to 1.00 km when you press the lap button. Average Speed, Pace, ETA will be readjust using the updated distance. To determine what the new distance should be, the distance is divided by "Lap Distance" and is adjusted to the closest value. For example, if "Lap Distance" is set to 400 meters and you press the lap button at 1195 meters, the distance will be corrected to 1200 meters. If the distance was 1225 meters, it would be corrected to 1200 meters. It is important to note that you do not have to press lap button on every lap since the value is always corrected using the closest lap distance.

### Minimum/Maximum Pace
Current Pace and Average Pace are displayed in color based on application parameters
  - Blue if too fast, Green if between Min and Max Pace, Red if too slow

![GRun PaceColor](/doc/GRunWatch5.png)

### Middle Column Percentage Size
You can reduce or increase the width of the middle column. Simply configure the value as a percentage of the original value. I personally set it to 75% in order to have left and right column larger. I can then set value in format MM:SS on left and right column and keep decimal value in the middle column.

If you prefer, you could also set it to 100 in order to have all the columns of the same size.
![GRun MiddleColumn100](/doc/GRunWatch6.png)

Or you could also set it to a value higher than 100 (Example 125) to have the middle column 125% larger.
![GRun MiddleColumn125](/doc/GRunWatch7.png)

### Column Width Ratio
"Column Width Ratio" is used to configured the width of each fields on row #2 and #3. You simply have to provide 3 numbers separated by comma. The default value is 2,1,2 meaning colum #1 and #3 are 2 times bigger than column number #2. For those you prefer percentage, similar result would have been achieved with "40,20,40" : column #1 and #3 taking 40% of the available width while column #2 taking 20%. If a parameter is set to "Empty", its percentage will be set to 0. If we keep the example of "2,1,2" with parameter #2 set to empty, value will automatically became "2,0,2". In this case, it will mean column #1 and #3 will take 50% of the screen. 

### Fields
Up to 10 fields can be displayed using application parameters.

![GRun GarminConnectParams](/doc/GarminConnectParams.png)
![GRun Fields](/doc/GRunWatchFields.png)

#### Less fields
If some fields are configured with option  **Empty**, the other fields on the same line will automatically expand. For example, the following screen is configured with **Field 2B = Empty**.

![GRun Expand](/doc/GRunWatch1.png)

## Release Notes
### Version 1.20
 - Added a parameter to have a uniform background color. By default rows 4 and 5 have a different background color.
 - Added support for new watches (Descent Mk1, Edge 530, Edge 820, Edge 830, Fenix 6, Fenix 6 Pro, Fenix 6S, Fenix 6S Pro, Fenix 6x Pro, Forerunner 245, Forerunner 245m, Forerunner 945, Captain Marvel, First Avenger, MARQ Athlete, MARQ Aviator, MARQ Captain, MARQ Driver, MARQ Expedition, Oregon 7xx, Rino 7xx, Venu, Vivoactive 3d, Vivoactive 3m LTE, Vivoactive 4, Vivoactive 4S)
 
### Version 1.19
 - Redesign settings to adjust column width (Less user friend, but more customizable).
   + Default value is "2,1,2" which means first column will have a width of 2/5, second column will have a width of 1/5 and third column will have a width of 2/5. If a parameter is set to Empty, the value is ignored. For example, if column2 is empty, that the ratio become 2/4 for column #1 and 2/4, 0/4 for column #2 and 2/4 for column #3.
 - Add a parameter to set "Header Height" in percentage. This allow to completely hide headers to maximize space.
 - Header Font tried to used the maximum space possible
 - Changed default parameters

### Version 1.18
 - Added Training Effect on supported devices (Fenix 5, Fenix 5s, Fenix 5x, Fenix 5x Plus, Fenix Chronos, Forerunnner 645, Forerunnner 645 Music, Forerunnner 935, Edge 1030, Edge 520 Plus)
 - Add a parameter to correct distance on lap. Distance is rounded to the nearest "Lap Distance".
 - Code improvement to optimize memory
 - Code Framework using Jungles to implement features for specific devices (Example: Training Effect)

### Version 1.17
 - Added options to display Header background or data foreground in color
 - Area 4a/4b and 5 can be shrinked together if one of them is empty
 - Improve code to use less memory

![GRun Version 1.16](/doc/GRunWatch9.png)

### Version 1.15
 - Added color for Lap Pace

### Version 1.14
 - Added the following fields: Lap Time, Lap Distance, Lap Pace
 
### Version 1.13
 - Adjust font vertical position for fenix 5s and fenix chronos

### Version 1.11
 - Area 4 and 6 expand vertically: If values 4A/4B or 5 are missing, area 4A/4B or 5 will expand vertically
 - ETA Auto-Switch: If one area is configured with "ETA 5K" and you reach 5 km during your run. the value will automatically change to "ETA 10K", then "ETA 21K", then "ETA 42K". Same apply to "ETA 10K" and "ETA 21K".
 - "Time spend on current km/mile" displays a background color indicating progress on the current km/mile.
 - Float fields are displayed with 2 digits if lower than 10 (Example: 9.92). Values greather than 10 display a single digit (Example: 10.1)
 - Bug Fix: Area "Battery Icon" now display the battery icon instead of the GPS icon
 - Code Optimization to minimize memory usage
 
 ![GRun Version 1.10](/doc/GRunWatch8.png)
