# GRun
Configurable Garmin Watch datafield

![GRun Cover Image](/doc/GRunCover.png) 


## How to use
1. Press the button to view the activity list
2. Select an activity
3. Select the activity settings.
4. Select Data Screens
5. Depending on your watch model:


vivoactive3/4
  
- Select Layout, and select 1
- Select Screen 1 > Edit Data Fields, and select Connect IQ > GRun


fenix5
  
- Select a data screen to customize.
- Select Layout, and select 1
- Select Field 1, and select Connect IQ > GRun


## Description
Highly configurable datafield where you can select up to 10 fields to display. If less fields are configured, the field area on each line will automatically expand.
The second and third row display a header field with the value.

The first, fourth and fifth row display values without header.

The following fields are currently supported:
- Empty
- Time
- Timer
- Distance
- Current Heart Rate
- Average Heart Rate
- Heart Rate Zone
- Current Pace
- Average Pace
- Current Speed
- Average Speed
- Current Cadence
- Average Cadence
- Current Power (on supported devices)
- Average Power (on supported devices)
- Calories
- Altitude
- Total Ascent
- Total Descent
- ETA 5K
- ETA 10K
- ETA Half Marathon (21.0975 km)
- ETA Marathon (42.195 km)
- ETA 50K
- ETA 100K
- Required Pace 5K
- Required Pace 10K
- Required Pace Half Marathon (21.0975 km)
- Required Pace Marathon (42.195 km)
- Required Pace 50K
- Required Pace 100K
- ETA Lap
- Lap Count
- Previous Lap Time
- Previous Lap Distance
- Previous Lap Pace
- Lap Time
- Lap Distance
- Lap Pace
- Time Ahead/Behind
- Training Effect (on supported devices)
- Battery Icon
- GPS Icon
- GPS Icon and Battery Icon

High-Memory devices also supports the following fields:
- Average Pace (Last X sec)
- Average Speed (Last X sec)
- Average Vertical Speed (m/min) (Last X sec)
- Average Vertical Speed (m/hour) (Last X sec)
- Max Power (on supported devices)
- Required Speed 5K
- Required Speed 10K
- Required Speed Half Marathon (21.0975 km)
- Required Speed Marathon (42.195 km)
- Required Speed 100K
- Required Pace Lap Distance
- Required Speed Lap Distance
- Lap Average Heart Rate

### Supported Features/Devices

| Device Qualifier        | Device Name                           | Available Memory | Low Memory | High Memory | Training Effect | Power*  |
| ----------------------- | ------------------------------------- |:----------------:|:----------:|:-----------:|:---------------:|:-------:|
| approachs62             | Approach S62                          | 124.7 KB         |            | &check;     |                 |         |
| d2air                   | D2 Air                                | 28.7 KB          | &check;    |             |                 |         |
| d2charlie               | D2 Charlie                            | 124.7 KB         |            | &check;     |                 | &check; |
| d2delta                 | D2 Delta                              | 124.7 KB         |            | &check;     |                 | &check; |
| d2deltapx               | D2 Delta PX                           | 124.7 KB         |            | &check;     |                 | &check; |
| d2deltas                | D2 Delta S                            | 124.7 KB         |            | &check;     |                 | &check; |
| descentmk1              | Descent Mk1                           | 124.7 KB         |            | &check;     | &check;         | &check; |
| descentmk2              | Descent Mk2                           | 124.7 KB         |            | &check;     | &check;         | &check; |
| descentmk2s             | Descent Mk2 S                         | 124.7 KB         |            | &check;     | &check;         | &check; |
| edge1030                | Edge 1030                             | 124.7 KB         |            | &check;     | &check;         | &check; |
| edge1030plus            | Edge 1030 Plus                        | 124.7 KB         |            | &check;     | &check;         | &check; |
| edge1030bontrager       | Edge 1030 Bontrager                   | 124.7 KB         |            | &check;     | &check;         | &check; |
| edge130                 | Edge 130                              | 28.7 KB          | &check;    |             |                 | &check; |
| edge130plus             | Edge 130 Plus                         | 28.7 KB          | &check;    |             |                 | &check; |
| edge520plus             | Edge 520 Plus                         | 124.7 KB         |            | &check;     | &check;         | &check; |
| edge530                 | Edge 530                              | 124.7 KB         |            | &check;     | &check;         | &check; |
| edge820                 | Edge 820                              | 124.7 KB         |            | &check;     |                 | &check; |
| edge830                 | Edge 830                              | 124.7 KB         |            | &check;     | &check;         | &check; |
| edgeexplore             | Edge Explore                          | 124.7 KB         |            | &check;     |                 |         |
| enduro                  | Enduro                                | 28.7 KB          | &check;    |             | &check;         | &check; |
| fenix5                  | fēnix 5                               | 28.7 KB          | &check;    |             | &check;         | &check; |
| fenix5plus              | fēnix 5 Plus                          | 124.7 KB         |            | &check;     |                 | &check; |
| fenix5s                 | fēnix 5S                              | 28.7 KB          | &check;    |             | &check;         | &check; |
| fenix5splus             | fēnix 5S Plus                         | 124.7 KB         |            | &check;     |                 | &check; |
| fenix5x                 | fēnix 5X                              | 124.7 KB         |            | &check;     | &check;         | &check; |
| fenix5xplus             | fēnix 5X Plus                         | 124.7 KB         |            | &check;     | &check;         | &check; |
| fenix6                  | fēnix 6                               | 28.7 KB          | &check;    |             | &check;         | &check; |
| fenix6pro               | fēnix 6 Pro                           | 124.7 KB         |            | &check;     | &check;         | &check; |
| fenix6s                 | fēnix 6S                              | 28.7 KB          | &check;    |             | &check;         | &check; |
| fenix6spro              | fēnix 6S Pro                          | 124.7 KB         |            | &check;     | &check;         | &check; |
| fenix6xpro              | fēnix 6X Pro                          | 124.7 KB         |            | &check;     | &check;         | &check; |
| fenixchronos            | fēnix Chronos                         | 28.7 KB          | &check;    |             | &check;         | &check; |
| fr55                    | Forerunner 55                         | 28.7 KB          | &check;    |             |                 |         |
| fr245                   | Forerunner 245                        | 28.7 KB          | &check;    |             | &check;         |         |
| fr245m                  | Forerunner 245 Music                  | 124.7 KB         |            | &check;     | &check;         | &check; |
| fr645                   | Forerunner 645                        | 28.7 KB          | &check;    |             | &check;         |         |
| fr645m                  | Forerunner 645 Music                  | 60.7 KB          |            | &check;     | &check;         |         |
| fr745                   | Forerunner 745                        | 124.7 KB         |            | &check;     | &check;         | &check; |
| fr935                   | Forerunner 935                        | 28.7 KB          | &check;    |             | &check;         | &check; |
| fr945                   | Forerunner 945                        | 124.7 KB         |            | &check;     | &check;         | &check; |
| fr945lte                | Forerunner 945 LTE                    | 124.7 KB         |            | &check;     | &check;         | &check; |
| legacyherocaptainmarvel | Captain Marvel                        | 28.7 KB          | &check;    |             |                 |         |
| legacyherofirstavenger  | First Avenger                         | 28.7 KB          | &check;    |             |                 |         |
| legacysagadarthvader    | Darth Vader                           | 28.7 KB          | &check;    |             |                 |         |
| legacysagarey           | Rey                                   | 28.7 KB          | &check;    |             |                 |         |
| marqadventurer          | MARQ Adventurer                       | 124.7 KB         |            | &check;     | &check;         | &check; |
| marqathlete             | MARQ Athlete                          | 124.7 KB         |            | &check;     | &check;         | &check; |
| marqaviator             | MARQ Aviator                          | 124.7 KB         |            | &check;     | &check;         | &check; |
| marqcaptain             | MARQ Captain                          | 124.7 KB         |            | &check;     | &check;         | &check; |
| marqcommander           | MARQ Commander                        | 124.7 KB         |            | &check;     | &check;         | &check; |
| marqdriver              | MARQ Driver                           | 124.7 KB         |            | &check;     | &check;         | &check; |
| marqexpedition          | MARQ Expedition                       | 124.7 KB         |            | &check;     | &check;         | &check; |
| marqgolfer              | MARQ Golfer                           | 124.7 KB         |            | &check;     | &check;         | &check; |
| oregon7xx               | Oregon 7xx                            | 124.7 KB         |            | &check;     |                 |         |
| rino7xx                 | Rino 7xx                              | 124.7 KB         |            | &check;     |                 |         |
| venu                    | Venu                                  | 28.7 KB          | &check;    |             |                 |         |
| venu2                   | Venu 2                                | 28.7 KB          | &check;    |             |                 |         |
| venu2s                  | Venu 2S                               | 28.7 KB          | &check;    |             |                 |         |
| venu2d                  | Venu Mercedes-Benz Collection         | 28.7 KB          | &check;    |             |                 |         |
| vivoactive3             | vívoactive 3                          | 28.7 KB          | &check;    |             |                 |         |
| vivoactive3d            | vívoactive 3 Mercedes-Benz Collection | 28.7 KB          | &check;    |             |                 |         |
| vivoactive3m            | vívoactive 3 Music                    | 28.7 KB          | &check;    |             |                 |         |
| vivoactive3mlte         | vívoactive 3 Music LTE                | 28.7 KB          | &check;    |             |                 |         |
| vivoactive4             | vívoactive 4                          | 28.7 KB          | &check;    |             |                 |         |
| vivoactive4s            | vívoactive 4S                         | 28.7 KB          | &check;    |             |                 |         |

* Power has limited support. The datafield simply display the value of `Toybox.Activity.Info.currentPower`

### Notes
- Fields related to distance are displayed in km or mile depending on the user profile.
- Fields related to speed are displayed in km/h or mile/h depending on the user profile.
- Fields related to pace are displayed in min/km or min/mile depending on the user profile.
- Heart Rate is displayed in color based on user profile heart rate zone.
  - Zone 1 : Black
  - Zone 2 : Blue
  - Zone 3 : Green
  - Zone 4 : Orange
  - Zone 5 : Red
- Current Pace/Speed, Average Pace/Speed, Previous/Current Lap Pace, "Time Ahead/Behind" and Current/Average Cadence (High-Memory devices only) are displayed in color based on application parameters
  - Blue if too fast, Green if within Target Pace Range, Red if too slow

## Configuration
### Target Pace
"Target Pace" is your ideal pace for a run. The value is configured in seconds per km or in seconds per mile. km or mile is chosen automatically based on watch settings.
For example, if your watch is configured with metric values and your objective is to run 10k in exactly 1 hour, configure "Target Pace" to be 360 (360 seconds = 6:00 min/km).

### Pace Range
Pace Range is used to determine if your pace/speed is too slow or too fast. For example, if you configure "Target Pace" at 5:30 min/km (330 seconds) and you can configure "Pace Range" at 15 seconds, it means a good pace will be within 5:15 min/km to 5:45 min/km. If your pace/speed is too slow, the pace/speed is displayed in red, if it's too fast, it is displayed in blue and if it's within the range, it will be displayed in green.

![GRun PaceColor](/doc/GRunWatch5.png)


### Lap Distance (in meters)
Lap Distance is useful for people running in competition. It allows to readjust distance. For example, if you set the value to 1000 (meters), it allows you to press the lap button at each kilometer. If Garmin had calculated a value of 1.01 km at km #1, it will readjust to 1.00 km when you press the lap button. Average Speed, Pace, ETA, etc. will be readjusted using the updated distance. To determine what the new distance should be, the distance is divided by "Lap Distance" and is adjusted to the closest value. For example, if "Lap Distance" is set to 400 meters and you press the lap button at 1195 meters, the distance will be corrected to 1200 meters. If the distance was 1225 meters, it would also be corrected to 1200 meters. It is important to note that you do not have to press lap button on every lap since the value is always corrected using the closest lap distance.

__*** Note__ : Lap Distance must always be set in meters regarless of the watch settings. If you'd like to set the "Lap Distance" to 1 mile, you have to configure it to 1609 (1609 meters = 1 mile).

### Header Height
On row #2 and #3, header height can be configured using a percentage of the area.
You can hide headers by setting the value to 0:

![GRun Hide Headers](/doc/GRunHeaders0.png)

A value of 100 will hide the actual values (not very useful):

![GRun Hide Headers](/doc/GRunHeaders100.png)

Default value of 30 looks like this:

![GRun Hide Headers](/doc/GRunHeaders30.png)

### Row Height Ratio
"Row Height Ratio" is used to configured the height of each rows. You simply have to provide 5 numbers separated by comma. Each number represent the height of the row in relation to the other. With the default value is 4,7,7,3,3, row #1 will used 4 / (4+7+7+3+3) of the screen, or 16.67% of the screen. On a device with a height of 240 pixels, row #1 will used 40 pixels, row #2 and #3 will used 70 pixels and row #4 and #5 will used 30 pixels. If all the parameters in a row are set to "Empty", its height will automatically be set to 0.

Example using 4 rows: 4,7,7,0,3

![GRun MiddleColumn100](/doc/GRunWatch15.png)

Example using 3 rows: 5,7,0,0,2

![GRun MiddleColumn100](/doc/GRunWatch16.png)

### Column Width Ratio
"Column Width Ratio" is used to configured the width of each fields on row #2 and #3. You simply have to provide 3 numbers separated by comma. The default value is 2,1,2 meaning colum #1 and #3 are 2 times bigger than column number #2. For those who prefer percentage, similar result would have been achieved with "40,20,40" : column #1 and #3 taking 40% of the available width while column #2 taking 20%. If a parameter is set to "Empty", its percentage will be set to 0. If we keep the example of "2,1,2" with parameter #2 set to empty, value will automatically became "2,0,2". In this case, it will mean column #1 and #3 will take 50% of the screen.

Default value: "2,1,2" with middle parameter set to Empty on first row  
**Note**: Configuration using "1,1,1" with middle parameter set to Empty would give the same result

![GRun MiddleColumn100](/doc/GRunWatch6.png)

#### Less fields
If some fields are configured with option  **Empty**, the other fields on the same line will automatically expand. For example, the following screen is configured with **Field 2B = Empty**.

![GRun Expand](/doc/GRunWatch1.png)


### Uniform Background Color
By default, rows 4 and 5 have a different background color.

![GRun BottomTop](/doc/GRunWatch10.png)

To have a uniform background color, simply enable this setting.

![GRun BottomTop](/doc/GRunWatch11.png)

### Dynamic Header Background Color
If enabled, Header background colors will changed depending on your pace/speed.

![GRun BottomTop](/doc/GRunWatch12.png)

### Dynamic Data Background Color
If enabled, data background colors will changed depending on your pace/speed.

![GRun BottomTop](/doc/GRunWatch13.png)

### Dynamic Data Foreground Color
If enabled, data foreground colors will changed depending on your pace/speed.

![GRun BottomTop](/doc/GRunWatch14.png)


### Fields
Up to 10 fields can be displayed using application parameters.

![GRun GarminConnectParams](/doc/GarminConnectParams.png)
![GRun Fields](/doc/GRunWatchFields.png)

#### Fields Description
Most fields do not require explanation, but others might...

##### ETA (5K, 10K, Half Marathon, Marathon, 50K, 100K, Lap Distance)
ETA fields help determine your finish time based on your average speed/pace. It can help determine the finish time for 5 km, 10 km, half-marathon (21.0975 km), marathon (42.195), 50 km, 100 km or the "Lap Distance" configured on the "Lap Distance" parameters.
Except for "ETA Lap Distance", each ETA field will automatically changed once distance has been reached. For example, if you use "ETA 5K", the field will automatically changed to "ETA 10K" once you have run 5 kilometers.

##### Required Pace/Speed (5K, 10K, Half Marathon, Marathon, 50K, 100K, Lap Distance)
This field is helpful to determine the pace/speed required to finish your race at "Target Pace". For example, if your "Target Pace" is configured to 360 (6:00 minutes/km) and you have run 3 km in 15 minutes, "Required Pace 5K" will display "7:30" since you still have 15 minutes to run 2 km.
Except for "Required Pace/Speed Lap Distance", each Required Pace/Speed field will automatically changed once distance has been reached. For example, if you use "Required Pace/Speed 5K", the field will automatically changed to "Required Pace/Speed 10K" once you have run 5 kilometers.

##### Time Ahead/Behind
Use this field to determine how far you are from your "Target Pace". For example, if your "Target Pace" is configured to 360 (6:00 minutes/km) and you have run 3 km in 28 minutes and 30 seconds, the field will display "-1:30" since you are 1 min and 30 seconds faster than planned.

##### Training Effect
You can read more about training effect @ https://www.garmin.com.my/minisite/runningscience/#training-effect

##### Average Speed/Pace (Last X sec)
You can use this metric if you'd like more control over the calculated speed. This field calculates the speed/pace of the last X seconds by calculating the distance run during those last seconds. You configure the number of seconds you'd like to use using the field "Speed/Pace (Last X sec)".

##### Average Vertical Speed (/min)
Calculate the vertical speed in meter/min or feet/min depending on the watch settings. This field calculates the vertical speed of the last X seconds by calculating the altitude difference between now and the previous X seconds. You configure the number of seconds you'd like to use using the field "Vertical Speed (Last X sec)".


## Release Notes
### Version 1.34
 - fr245m was listed has a low memory device, instead of high-memory device.
 - Display average cadence using `info.averageCadence * 2` to workaround Garmin CIQ

| Memory Usage on va3 (28.6 KB)     | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 25.5 kB | 27.3 kB |
| 10 sec running                    | 25.5 kB | 27.7 kB |
| After setting change              | 25.5 kB | 28.4 kB |

| Memory Usage on fenix5 (28.6 KB)  | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 25.5 kB | 27.4 kB |
| 10 sec running                    | 25.5 kB | 27.8 kB |
| After setting change              | 25.5 kB | 28.4 kB |


| Memory Usage on fr945 (124.6 KB)  | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 30.6 kB | 32.8 kB |
| 10 sec running                    | 30.6 kB | 33.1 kB |
| After setting change              | 30.6 kB | 33.8 kB |

### Version 1.33
 - Version 1.32 was invalid as I forgot to remove troubleshooting code.

| Memory Usage on va3 (28.6 KB)     | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 25.5 kB | 27.1 kB |
| 10 sec running                    | 25.5 kB | 27.5 kB |
| After setting change              | 25.5 kB | 28.4 kB |

| Memory Usage on fenix5 (28.6 KB)  | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 25.4 kB | 27.4 kB |
| 10 sec running                    | 25.4 kB | 27.7 kB |
| After setting change              | 25.4 kB | 28.4 kB |


| Memory Usage on fr945 (124.6 KB)  | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 30.5 kB | 32.6 kB |
| 10 sec running                    | 30.5 kB | 33.0 kB |
| After setting change              | 30.5 kB | 33.7 kB |

### Version 1.32
 - Added support for D2 Air X10

| Memory Usage on va3 (28.6 KB)     | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 25.5 kB | 27.1 kB |
| 10 sec running                    | 25.5 kB | 27.5 kB |
| After setting change              | 25.5 kB | 28.4 kB |

| Memory Usage on fenix5 (28.6 KB)  | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 25.4 kB | 27.4 kB |
| 10 sec running                    | 25.4 kB | 27.7 kB |
| After setting change              | 25.4 kB | 28.4 kB |


| Memory Usage on fr945 (124.6 KB)  | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 30.5 kB | 32.6 kB |
| 10 sec running                    | 30.5 kB | 33.0 kB |
| After setting change              | 30.5 kB | 33.7 kB |

### Version 1.31
 - Added support for new watches (Epix Gen 2, Fenix 7, Fenix 7s, Fenix 7x, Venu 2 Plus)

| Memory Usage on va3 (28.6 KB)     | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 25.5 kB | 27.1 kB |
| 10 sec running                    | 25.5 kB | 27.5 kB |
| After setting change              | 25.5 kB | 28.4 kB |

| Memory Usage on fenix5 (28.6 KB)  | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 25.4 kB | 27.4 kB |
| 10 sec running                    | 25.4 kB | 27.7 kB |
| After setting change              | 25.4 kB | 28.4 kB |


| Memory Usage on fr945 (124.6 KB)  | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 30.5 kB | 32.6 kB |
| 10 sec running                    | 30.5 kB | 33.0 kB |
| After setting change              | 30.5 kB | 33.7 kB |

### Version 1.30
 - Added Lap Average Heart Rate on high memory devices

| Memory Usage on va3 (28.6 KB)     | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 25.5 kB | 27.1 kB |
| 10 sec running                    | 25.5 kB | 27.5 kB |
| After setting change              | 25.5 kB | 28.4 kB |

| Memory Usage on fenix5 (28.6 KB)  | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 25.4 kB | 27.4 kB |
| 10 sec running                    | 25.4 kB | 27.7 kB |
| After setting change              | 25.4 kB | 28.4 kB |


| Memory Usage on fr945 (124.6 KB)  | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 30.5 kB | 32.6 kB |
| 10 sec running                    | 30.5 kB | 33.0 kB |
| After setting change              | 30.5 kB | 33.7 kB |

### Version 1.29
 - Fix missing options (Required Pace 50K/100K) for high-memory devices with no support for "Power" options
 - Fix cadence color (high memory devices only): Blue if too fast, Green if within Target Cadence Range, Red if too slow
 
| Memory Usage on va3 (28.6 KB)     | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 25.5 kB | 27.1 kB |
| 10 sec running                    | 25.5 kB | 27.5 kB |
| After setting change              | 25.5 kB | 28.4 kB |

| Memory Usage on fenix5 (28.6 KB)  | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 25.5 kB | 27.4 kB |
| 10 sec running                    | 25.5 kB | 27.8 kB |
| After setting change              | 25.5 kB | 28.4 kB |


| Memory Usage on fr945 (124.6 KB)  | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 30.0 kB | 32.1 kB |
| 10 sec running                    | 30.0 kB | 32.5 kB |
| After setting change              | 30.0 kB | 33.2 kB |

### Version 1.28
 - Code improvement to optimize memory utilization
 - Remove Header Position parameter (to save memory usage). Header Position is now forced to "Top / Top"
 - Added Previous Lap Distance & Previous Lap Pace on all devices
 - On high-memory devices only, added Target Cadence & Cadence Range parameters to display cadence in color if outside the range
 - Added support for new watches (D2 Air, Descent Mk2, Descent Mk2 S, Edge 1030 Plus, Edge 130 Plus, Enduro, Forerunner 55, Forerunner 745, Forerunner 945 LTE, MARQ Golfer, Venu 2, Venu 2S, Venu Mercedes-Benz Collection)

| Memory Usage on va3 (28.6 KB)     | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 25.5 kB | 27.1 kB |
| 10 sec running                    | 25.5 kB | 27.5 kB |
| After setting change              | 25.5 kB | 28.4 kB |

| Memory Usage on fenix5 (28.6 KB)  | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 25.5 kB | 27.4 kB |
| 10 sec running                    | 25.5 kB | 27.8 kB |
| After setting change              | 25.5 kB | 28.4 kB |


| Memory Usage on fr945 (124.6 KB)  | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 30.0 kB | 32.1 kB |
| 10 sec running                    | 30.0 kB | 32.5 kB |
| After setting change              | 30.0 kB | 32.9 kB |

### Version 1.27
 - Added option to control row height
 - Added "Required Pace to meet Target Pace" 50K on all devices.
 - Added ETA 50K on all devices
 - Current Time now use standard format hh:mm (Example: 13:00) instead of 13h00¸
 - Code modification to maximize font size

| Memory Usage on va3 (28.6 KB)     | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 25.5 kB | 27.2 kB |
| 10 sec running                    | 25.5 kB | 27.6 kB |
| After setting change              | 25.5 kB | 28.5 kB |

| Memory Usage on fenix5 (28.6 KB)  | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 25.4 kB | 27.3 kB |
| 10 sec running                    | 25.4 kB | 27.7 kB |
| After setting change              | 25.4 kB | 28.4 kB |


| Memory Usage on fr945 (124.6 KB)  | Current | Peak    |
| --------------------------------- |:-------:|:-------:|
| At startup                        | 29.6 kB | 31.6 kB |
| 10 sec running                    | 29.6 kB | 32.0 kB |
| After setting change              | 29.6 kB | 32.6 kB |

### Version 1.26
 - Updated background/foreground colors for better readability
 - Added grey color for HR Zone 1
 - Added the Current Power and Average Power and supported low memory devices (Fenix 5/5s/6/6s/Chronos, Forerunner 935 and Edge 130)

Memory Usage on va3    (Current | Peak) : 
   * At startup:           24.9 kB | 26.4 kB
   * 10 sec running:       24.9 kB | 26.8 kB
   * After setting change: 24.9 kB | 27.8 kB

Memory Usage on fenix5 (Current | Peak) : 
   * At startup:           25.0 kB | 26.7 kB
   * 10 sec running:       25.0 kB | 27.1 kB
   * After setting change: 25.0 kB | 27.8 kB

Memory Usage on fr945  (Current | Peak) : 
   * At startup:           29.1 kB | 30.9 kB
   * 10 sec running:       29.1 kB | 31.3 kB
   * After setting change: 29.1 kB | 32.1 kB

### Version 1.25
 - Added "Required Pace to meet Target Pace" for 5K, 10K, Half Marathon, Marathon distance and 100K on all devices.
 - Added ETA 100K on all devices
 - Added Heart Rate Zone on all devices
 - Replaced option for "Dynamic Data Color". Data Color can now be more customized
 - Replaced blue/green color code on white background
 - Code improvement to optimize memory utilization
 - Added support for new watches (Approach S62, MARQ Adventurer, MARQ Commander, Darth Vader, Rey)

Memory Usage on va3   (Current | Peak) : 
   * At startup:           24.6 kB | 26.2 kB
   * 10 sec running:       24.6 kB | 26.6 kB
   * After setting change: 24.6 kB | 27.5 kB

Memory Usage on fr945 (Current | Peak) : 
   * At startup:           28.9 kB | 30.8 kB
   * 10 sec running:       28.9 kB | 31.2 kB
   * After setting change: 28.9 kB | 32.0 kB

### Version 1.24
 - Bugfix on Garmin Venue to properly display fields

Memory Usage on va3   (Current | Peak) : 
   * At startup:           25.6 kB | 27.0 kB
   * 10 sec running:       25.6 kB | 27.4 kB
   * After setting change: 25.6 kB | 28.4 kB

Memory Usage on fr945 (Current | Peak) : 
   * At startup:           31.5 kB | 33.4 kB
   * 10 sec running:       31.5 kB | 33.7 kB
   * After setting change: 31.5 kB | 34.5 kB

### Version 1.23
 - Replaced "Min Pace", "Max Pace" settings with "Target Pace" and "Pace Range"
 - Reorder settings
 - Added color for speed metrics (current, average)
 - Removed the following fields on all supported devices:
   + Total Corrected Distance
 - Added the following fields on all supported devices:
   + Time Ahead/Behind
   + Average Cadence
 - Added the following fields on high-memory devices:
   + Current Power
   + Average Power
   + Max Power
   + Average Speed/Pace over a defined period of time
   + Average Vertical Speed over a defined period of time (in meter or feet per minute)
   + Average Vertical Speed over a defined period of time (in meter or feet per hour)
   + HR Zone Number
   + Target Pace/Speed (5K, 10K, Half Marathon, Marathon, Lap Distance)

Memory Usage on va3   (Current | Peak) : 
   * At startup:           25.5 kB | 27.0 kB
   * 10 sec running:       25.5 kB | 27.4 kB
   * After setting change: 25.5 kB | 28.4 kB

Memory Usage on fr945 (Current | Peak) : 
   * At startup:           31.5 kB | 33.4 kB
   * 10 sec running:       31.5 kB | 33.7 kB
   * After setting change: 31.5 kB | 34.5 kB
   
### Version 1.22
 - BugFix : It it now possible to use "Lap Time" if "Lap Distance" is set to 0
 - Compiled using Connect IQ SDK Release 3.1.6

### Version 1.21
 - Removed "Average Pace (Calculated manually using timer/distance)" field
 - Replaced field "Time spend on current km/mile" by "ETA Lap"
 - Replaced field "Time spend on previous km/mile" by "Previous Lap Time"
 - Added field "Lap Count" 
 - Increased line width between fields from 1 pixel to 2 pixels


 - Memory Usage on va3 (Current | Peak) : 
   * At startup:           25.6 kB | 27.0 kB
   * 10 sec running:       25.6 kB | 27.4 kB
   * After setting change: 25.6 kB | 28.4 kB
 
 - Compiled using Connect IQ SDK Release 3.1.5
 
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
 - Added Training Effect on supported devices (Fenix 5, Fenix 5s, Fenix 5x, Fenix 5x Plus, Fenix Chronos, Forerunner 645, Forerunner 645 Music, Forerunner 935, Edge 1030, Edge 520 Plus)
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
