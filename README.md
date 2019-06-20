# GRun
Configurable Garmin Watch datafield

![GRun Cover Image](/doc/GRunWatch.png) 

## Release Notes
### Version 1.19
 - Application Settings can be changed while application is running
 - Redesign settings to adjust column width (Less user friend, but more customizable)
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

## Notes
- Fields related to distance are displayed in km or mile depending on the user profile.
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

### Fields
Up to 10 fields can be displayed using application parameters.

![GRun GarminConnectParams](/doc/GarminConnectParams.png)
![GRun Fields](/doc/GRunWatchFields.png)

#### Less fields
If some fields are configured with option  **Empty**, the other fields on the same line will automatically expand. For example, the following screen is configured with **Field 2B = Empty**.

![GRun Expand](/doc/GRunWatch1.png)
