using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.UserProfile;

// In order to use less memory, numbers have been hardcoded instead of using const..
//const CONVERSION_KM_TO_MILE = 0.62137119; // 1 / 1.609344 /* CONVERSION_MILE_TO_KM */
//const CONVERSION_MILE_TO_KM = 1.609344;
//const CONVERSION_METER_TO_FEET = 3.28084;

// Note on Memory Usage
//  - Boolean used 20 bytes 
//  - Integer used 10 bytes
//  - Float used 20 bytes
//  - Char used 20 bytes
//  - Long used 53 bytes
//  - Double used 53 bytes
//  - String used 33 bytes + 2 bytes/char
//  - Array of Integers used 49 bytes for the Array + 18 bytes/element
//  - Array of Bytes ([1, 2, 3]b) used 49 bytes for the Array + 14 bytes/element
//  - Array of Bytes (new [ARRAY_SIZE]b) used 49 bytes for the Array + 1 byte/element

class GRunView extends WatchUi.DataField
{
  // Array of the current heart rate zone threshold values in beats per minute (bpm)
  protected var hrZones;
  // Elapsed Distance (km or miles)
  protected var distance = 0.0;
  // Determine distance offset on each lap (in meter)
  protected var distanceOffset = 0.0;
  // Timer (in second)
  protected var timer = 0;
  // Number of lap
  protected var lapCount = 0;
  // Time taken on previous lap
  protected var timerLastLap = 0;
  // Exact time when lap has changed
  protected var startTimerCurrentLap = 0;
  // Exact distance when lap has changed
  protected var startDistanceCurrentLap = 0;
  
  // Display data in Metric or Imperial
  protected var isPaceUnitsImperial;
  protected var isDistanceUnitsImperial;
  protected var isElevationUnitsImperial;
  
  // Default colors
  protected var primaryForegroundColor = Graphics.COLOR_BLACK;
  protected var headerBackgroundColor = Graphics.COLOR_LT_GRAY;
  
  // The last 3 bytes contains parameter for: HeaderBackgroundColor, DataBackgroundColor & DataForegroundColor
  //   HeaderBackgroundColor: Display Header background in red/green/blue based on values (exemple current pace)
  //   DataBackgroundColor: Display Data background in red/green/blue based on values (exemple current pace)
  //   DataForegroundColor: Display Data foreground in red/green/blue based on values (exemple current pace)
  protected var dynamicColor;
  
  // Header Position change the layout. Possible values are 1, 2 and 3
  protected var headerPosition;
  // Header Height in pixel. Calculated using HeaderHeight parameter in percentage
  protected var headerHeight;
  // If true, rows 4/5 have same color as rows 1/2/3
  protected var singleBackgroundColor;
  
  // If greater than 0, distance will be rounded to the nearest lapDistance every time lap button is pressed
  protected var lapDistance;
  // Used to determine if we are ahead or behinh de schedule
  protected var targetPace;
  // Used to determine if speed/pace is too slow or too fast
  protected var paceRange;
  
  // Used to stored the type of data each area will display (Exemple: Current Pace, Distance, etc.)
  protected var vType = new [10]b;
  // Contains the actuel value to display. For example, if vData[0] is configure to display current pace, vData[0] will display MM:SS
  protected var vData = new [10];
  // vArea indicates the x/y coordonate of the Value area, including header
  protected var vArea = new [10];
  
  // Adjust text vertical position for specific device model
  public var yOffset = 0;
  // Width of the device screen in pixels
  protected var deviceWidth;
  // Height of the device screen in pixels
  protected var deviceHeight;
  
  // Fonts used by the DataField.
  // Note: "NUMBER" fonts are larger, but only contain numeric values to save memory
  // The following fonts are used on vivoactive3:
  //  - FONT_XTINY:  FNT_NOTO_SANS_BOLD_16PX
  //  - FONT_TINY:   FNT_NOTO_SANS_BOLD_22PX
  //  - FONT_SMALL:  FNT_NOTO_SANS_BOLD_22PX
  //  - FONT_MEDIUM: FNT_NOTO_SANS_BOLD_25PX
  //  - FONT_LARGE:  FNT_NOTO_SANS_BOLD_25PX
  //  - 
  //  - FONT_NUMBER_MILD:     FNT_NOTO_SANS_BOLD_29PX
  //  - FONT_NUMBER_MEDIUM:   FNT_NOTO_SANS_BOLD_NMBR_48PX
  //  - FONT_NUMBER_HOT:      FNT_NOTO_SANS_BOLD_NMBR_76PX
  //  - FONT_NUMBER_THAI_HOT: FNT_NOTO_SANS_BOLD_NMBR_94PX 
  protected var fontIcons = WatchUi.loadResource(Rez.Fonts.Icons);
  protected var fontTiny = WatchUi.loadResource(Rez.Fonts.Roboto_20_Bold);
  protected var fontHeader = Graphics.FONT_LARGE;
  protected var initCompleted = 6;
  
  // GPS Image to display
  protected var imgGPS = WatchUi.loadResource(Rez.Drawables.GPS0);
  
  // In order to use less memory, numbers have been hardcoded instead of using enum..
  // This makes code less readable, but is required since memory on Garmin watch is very limited
  //enum {
  /*
    OPTION_EMPTY = 0,
    OPTION_CURRENT_TIME = 1,
    OPTION_TIMER_TIME = 2,
    OPTION_ELAPSED_DISTANCE = 5,
    OPTION_CURRENT_HEART_RATE = 6,
    OPTION_CURRENT_PACE = 7,
    OPTION_CURRENT_SPEED = 8,
    OPTION_AVERAGE_HEART_RATE = 9,
    OPTION_AVERAGE_PACE = 10,
    OPTION_AVERAGE_SPEED = 12,
    OPTION_CALORIES = 13,
    OPTION_CURRENT_CADENCE = 14,
    OPTION_ALTITUDE = 15,
    OPTION_TOTAL_ASCENT = 16,
    OPTION_TOTAL_DESCENT = 17,
    OPTION_CURRENT_BATTERY = 18,
    OPTION_CURRENT_LOCATION_ACCURACY = 19,
    OPTION_CURRENT_LOCATION_ACCURACY_AND_BATTERY = 20,
    OPTION_CURRENT_POWER = 21,
    OPTION_AVERAGE_POWER = 22,
    OPTION_CURRENT_LAP_TIME = 25,
    OPTION_CURRENT_LAP_DISTANCE = 26,
    OPTION_CURRENT_LAP_PACE = 27,
    OPTION_TRAINING_EFFECT = 28,
    OPTION_TIMER_TIME_ON_PREVIOUS_LAP = 30,
    OPTION_ETA_LAP = 31.
    OPTION_LAP_COUNT = 32,
    OPTION_AVERAGE_CADENCE = 33,
    OPTION_TIME_OFFSET = 34,
    OPTION_HR_ZONE = 35,
    OPTION_ETA_5K = 50,
    OPTION_ETA_10K = 51,
    OPTION_ETA_HALF_MARATHON = 52,
    OPTION_ETA_MARATHON = 53,
    OPTION_ETA_100K = 54,
    OPTION_REQUIRED_PACE_5K = 55,
    OPTION_REQUIRED_PACE_10K = 56,
    OPTION_REQUIRED_PACE_HALF_MARATHON = 57,
    OPTION_REQUIRED_PACE_MARATHON = 58,
    OPTION_REQUIRED_PACE_100K = 59
    */
  //}
  
  
  function getParameter(paramName, defaultValue)
  {
    var paramValue = Application.Properties.getValue(paramName);
    if (paramValue == null) {
      paramValue = defaultValue;
      Application.Properties.setValue(paramName, defaultValue);
    }
    
    if (paramValue == null) { return 0; }
    return paramValue;
  }
  
  
  function assignAreaValues(valueArea, x, y, width, height)
  {
    valueArea[0] = x;
    valueArea[1] = y; 
    valueArea[2] = width;
    valueArea[3] = height;
  }
  
  
  function configureAreaDimension(s, typeArray, areaArray, y, height)
  {
    var i = 0; // Number of param defined in string s, should be equal to 3 for row 2 and 3 and equal to 2 for for 4
    var commaIndex = s.find(",");
    var numberArray = new [3]b; // Contained numbers parsed in string s. "new [3]b" seems equal to [0,0,0]
    
    try
    {
      while (commaIndex != null && i < 2)
      {
        numberArray[i] = s.substring(0, commaIndex).toNumber();
        s = s.substring(commaIndex + 1, s.length());
        commaIndex = s.find(",");
        i++;
      }
      
      numberArray[i] = s.toNumber();
      i++;
    } catch (exception) {}
    
    // Count the number of values to display (!= OPTION_EMPTY)
    var nonEmptyValues = 0;
    for (var j = 0; j < typeArray.size(); j++)
    {
      if (typeArray[j] != 0 /* OPTION_EMPTY */) { nonEmptyValues += 1; }
    }
    
    // String s is missing parameters (comma missing)
    // Redefine string s using default value: 2,1,2
    if (nonEmptyValues > i)
    {
      numberArray = [2, 1, 2]b;
    }
    
    // If string s contains less than 3 parameters, move value in numberArray accordingly.
    // Example: s = "1,2", typeArray = [7 /* OPTION_CURRENT_PACE */, 0 /* OPTION_EMPTY */, 8 /* OPTION_CURRENT_SPEED */]
    // After parsing string s, numberArray = [1,2,0]. After running the code below, numberArray = [1,0,2]
    // For the first step, we copy values for non empty field. [1,2,0] will become [1,2,2]
    var count = 0;
    for (var j = 0; j < typeArray.size(); j++)
    {
      if ( (typeArray[j] != 0 /* OPTION_EMPTY */) && (nonEmptyValues == i) && (i < 3) )
      {
        numberArray[j] = numberArray[count];
        count++;
      }
    }
    
    // For the second step, we insert 0 value for empty field. [1,2,2] will become [1,0,2]
    for (var j = 0; j < typeArray.size(); j++)
    {
      if (typeArray[j] == 0 /* OPTION_EMPTY */)
      {
        // Set size to 0 if value = 0 /* OPTION_EMPTY */
        numberArray[j] = 0;
      }
    }
    
    // Configure each area [x,y,width,height] in areaArray 
    var lastX = 0;
    var columnWidth = [0, 0, 0, 0];
    var totalWidthRatio = numberArray[0] + numberArray[1] + numberArray[2];
    if (totalWidthRatio <= 0) { totalWidthRatio = 1; }
    for (var j = 1; j < areaArray.size() + 1; j++)
    {
      columnWidth[j] = deviceWidth * numberArray[j - 1] / totalWidthRatio;
      assignAreaValues(areaArray[j - 1], lastX + columnWidth[j - 1], y, columnWidth[j], height);
      lastX = columnWidth[j - 1];
    }
  }
  
  
  function initializeUserData()
  {
    initCompleted = 6;
    fontHeader = Graphics.FONT_LARGE;
    var deviceSettings = System.getDeviceSettings();
    isPaceUnitsImperial = (deviceSettings.paceUnits == System.UNIT_STATUTE);
    isDistanceUnitsImperial = (deviceSettings.distanceUnits == System.UNIT_STATUTE);
    isElevationUnitsImperial = (deviceSettings.elevationUnits == System.UNIT_STATUTE);
  
    headerPosition = getParameter("HeaderPosition", 1);
    var headerHeightPercentage = getParameter("HeaderHeight", 30).toFloat() / 100;
    singleBackgroundColor = getParameter("SingleBackgroundColor", false);
    
    // Column width for second row
    var columnWidthRatio1 = getParameter("ColumnWidthRatio1", "2,1,2");
    // Column width for third row
    var columnWidthRatio2 = getParameter("ColumnWidthRatio2", "2,1,2");
    
    dynamicColor = getParameter("HeaderBackgroundColor", true) ? 1 : 0;
    dynamicColor = dynamicColor<<4 | getParameter("DataBackgroundColor", 0);
    dynamicColor = dynamicColor<<4 | getParameter("DataForegroundColor", 0);
    
    lapDistance = getParameter("LapDistance", 0).toNumber();
    targetPace = getParameter("TargetPace", isPaceUnitsImperial ? 530 : 330).toNumber();
    paceRange = getParameter("PaceRange", 15).toNumber();
    
    var TYPE_DEFAULT_VALUE = [
      6 /* OPTION_CURRENT_HEART_RATE */,
      50 /* OPTION_ETA_5K */,
      0 /* OPTION_EMPTY */,
      7 /* OPTION_CURRENT_PACE */,
      5 /* OPTION_ELAPSED_DISTANCE */,
      14 /* OPTION_CURRENT_CADENCE */,
      10 /* OPTION_AVERAGE_PACE */,
      2 /* OPTION_TIMER_TIME */,
      1 /* OPTION_CURRENT_TIME */,
      20 /* OPTION_CURRENT_LOCATION_ACCURACY_AND_BATTERY */
    ];
    
    // Select which values are displayed in each area
    // Value must be selected according to the enum
    for (var i = 0; i < 10; i++)
    {
      // Retrieve configured type
      vType[i] = getParameter("Area" + (i + 1).toString(), TYPE_DEFAULT_VALUE[i]);
      
      // Set default value
      vData[i] = initDataVariables(vType[i]);
    }
        
    hrZones = UserProfile.getHeartRateZones(UserProfile.getCurrentSport());
    deviceWidth = deviceSettings.screenWidth;
    deviceHeight = deviceSettings.screenHeight;
    
    /*
    log("HeaderPosition: " + headerPosition);
    log("Area 1: " + getOptionName(v1));
    log("Area 2a: " + getOptionName(v2));
    log("Area 2b: " + getOptionName(v3));
    log("Area 2c: " + getOptionName(v4));
    log("Area 3a: " + getOptionName(v5));
    log("Area 3b: " + getOptionName(v6));
    log("Area 3c: " + getOptionName(v7));
    log("Area 4a: " + getOptionName(v8));
    log("Area 4b: " + getOptionName(v9));
    log("Area 5: " + getOptionName(v10));
    log("HR Zones: " + hrZones);
    */
    
    self.yOffset = yOffset;
    
    var y1 = deviceHeight / 6;           // 40 px
    var y2 = y1 + deviceHeight * 7/24;   // 110 px
    var y3 = y2 + deviceHeight * 7/24;   // 180 px
    var y4 = y3 + deviceHeight / 8;      // 210 px
    var height = y2 - y1;
    headerHeight = Math.round((height * headerHeightPercentage)).toNumber();
    
    assignAreaValues(vArea[0], 0, 0, deviceWidth, y1);
    configureAreaDimension(columnWidthRatio1, vType.slice(1, 4), vArea.slice(1, 4), y1, height);
    configureAreaDimension(columnWidthRatio2, vType.slice(4, 7), vArea.slice(4, 7), y2, height);
    configureAreaDimension("1,1", vType.slice(7, 9), vArea.slice(7, 9), y3, y4 - y3);
    assignAreaValues(vArea[9], 0, y4, deviceWidth, deviceHeight - y4);

    // Move empty area to the top
    if ( (vType[7] == 0 /* OPTION_EMPTY */) && (vType[8] == 0 /* OPTION_EMPTY */) ) {
      vArea[7][2] = deviceWidth;
      vType[7] = vType[9];
      vType[9] = 0 /* OPTION_EMPTY */;
    }
    
    if (vType[9] == 0 /* OPTION_EMPTY */) {
      height = deviceHeight - y3 - 10;  // Remove last 10 pixels from the bottom of the screen (Not enough width)
      vArea[7][3] = height;
      vArea[8][3] = height;
    }
    
    else {
      vArea[9][3] = vArea[9][3] - 3;
    }
  }
  
  
  function initDataVariables(v)
  {
    if (v == 1 /* OPTION_CURRENT_TIME */)
    {
      return System.getClockTime();
    }
    
    return 0;
  }
  
 
  function initialize()
  {
    DataField.initialize();
    
    // Initialize 2 dimensional array. The sub-array contains [x,y,width,height]
    for (var i = 0; i < 10; i++ )
    {
      vArea[i] = new [4];
    }
    
    initializeUserData();
  }
  
  
  // A lap event has occurred.
  // This method is called when a lap is added to the current activity. A notification is triggered after the lap record has been written to the FIT file.
  function onTimerLap()
  {
    lapCount++;
    timerLastLap = timer - startTimerCurrentLap;
    
    var info = Activity.getActivityInfo();
    startTimerCurrentLap = info.timerTime / 1000.0;
    var distanceMetric = info.elapsedDistance + distanceOffset;
    
    if (lapDistance > 0)
    {
      var diff = distanceMetric.toNumber() % lapDistance;
      diff += distanceMetric - Math.floor(distanceMetric); // Add decimal parts
      
      if (diff < (lapDistance / 2)) { distanceOffset -= diff; } // Distance higher than expected
      else { distanceOffset += (lapDistance - diff); }          // Distance lower than expected
    }
    
    startDistanceCurrentLap = convertUnitIfRequired((info.elapsedDistance + distanceOffset) / 1000.0, 0.62137119 /* CONVERSION_KM_TO_MILE */, isDistanceUnitsImperial); 
  }
  
  
  function onWorkoutStepComplete()
  {
    onTimerLap();
  }
  
  
  //System.println("5km = " + convertUnitIfRequired(5, CONVERSION_KM_TO_MILE, System.getDeviceSettings().distanceUnits) + "mi");
  //System.println("5m = " + convertUnitIfRequired(5, CONVERSION_METER_TO_FEET, System.getDeviceSettings().elevationUnits) + "ft");
  //System.println("10m/s = " + formatDuration(1000 / 10, false) + " min/km = " + formatDuration(convertUnitIfRequired(1000 / 10, CONVERSION_MILE_TO_KM, System.getDeviceSettings().paceUnits), false) + "min/mi");
  //System.println("10m/s = " + (10 * 3.6) + " km/h = " + convertUnitIfRequired(10 * 3.6, CONVERSION_KM_TO_MILE, System.getDeviceSettings().paceUnits) + "mi/h");
  function convertUnitIfRequired(v, convertionFactor, mustConvert)
  {
    if (mustConvert == true) { return v * convertionFactor; }
    return v;
  }

  
  function computeValue(info, id, value, valueData)
  {
    // Current Clock Time
    if (value == 1 /* OPTION_CURRENT_TIME */)
    {
      return System.getClockTime();
    }
    
    // The current timer value
    if (value == 2 /* OPTION_TIMER_TIME */)
    {
      return timer;
    }
    
    // Elapsed  of the current activity in meters (m)
    if (value == 5 /* OPTION_ELAPSED_DISTANCE */)
    {
      return distance;
    }
    
    // Current heart rate in beats per minute (bpm)
    if ( (value == 6 /* OPTION_CURRENT_HEART_RATE */) && (info.currentHeartRate != null) ) 
    {
      return info.currentHeartRate;
    }
    
    // Current pace in second per kilometer
    if ( (value == 7 /* OPTION_CURRENT_PACE */) && (info.currentSpeed != null) )
    {
      if (info.currentSpeed <= 0) { return 0; }
      return convertUnitIfRequired(1000 / info.currentSpeed, 1.609344 /* CONVERSION_MILE_TO_KM */, isPaceUnitsImperial);
    }
    
    // Current speed in meters per second (mps)
    if ( (value == 8 /* OPTION_CURRENT_SPEED */) && (info.currentSpeed != null) )
    {
      return convertUnitIfRequired(info.currentSpeed * 3.6, 0.62137119 /* CONVERSION_KM_TO_MILE */, isPaceUnitsImperial);
    }
    
    // Average heart rate during the current activity in beats per minute (bpm)
    if ( (value == 9 /* OPTION_AVERAGE_HEART_RATE */) && (info.averageHeartRate != null) ) 
    {
      return info.averageHeartRate;
    }
    
    // Average pace in second per kilometer
    if ( (value == 10 /* OPTION_AVERAGE_PACE */) && (info.averageSpeed != null) )
    {
      if (lapDistance > 0 && distanceOffset != 0) { return (distance <= 0) ? 0 : timer / distance; }
      if (info.averageSpeed <= 0) { return 0; }
      return convertUnitIfRequired(1000 / info.averageSpeed, 1.609344 /* CONVERSION_MILE_TO_KM */, isPaceUnitsImperial);
    }
    
    // Average speed during the current activity in meters per second (mps)
    if ( (value == 12 /* OPTION_AVERAGE_SPEED */) && (info.averageSpeed != null) )
    {
      if (lapDistance > 0 && distanceOffset != 0) { return (timer <= 0) ? 0 : distance / timer * 3600; }
      return convertUnitIfRequired(info.averageSpeed * 3.6, 0.62137119 /* CONVERSION_KM_TO_MILE */, isPaceUnitsImperial);
    }
        
    // Calories burned throughout the current activity in kilocalories (kcal)
    if ( (value == 13 /* OPTION_CALORIES */) && (info.calories != null) ) 
    {
      return info.calories;
    }
    
    // Current cadence in revolutions per minute (rpm)
    if ( (value == 14 /* OPTION_CURRENT_CADENCE */) && (info.currentCadence != null) )
    {
      return info.currentCadence;
    }
    
    // Current altitude in meters (m)
    if ( (value == 15 /* OPTION_ALTITUDE */) && (info.altitude  != null) )
    {
      return convertUnitIfRequired(info.altitude, 3.28084 /* CONVERSION_METER_TO_FEET */, isElevationUnitsImperial);
    }
    
    // The total ascent during the current activity in meters (m)
    if ( (value == 16 /* OPTION_TOTAL_ASCENT */) && (info.totalAscent != null) )
    {
      return convertUnitIfRequired(info.totalAscent, 3.28084 /* CONVERSION_METER_TO_FEET */, isElevationUnitsImperial);
    }

    // The total descent during the current activity in meters (m)
    if ( (value == 17 /* OPTION_TOTAL_DESCENT */) && (info.totalDescent != null) )
    {
      return convertUnitIfRequired(info.totalDescent, 3.28084 /* CONVERSION_METER_TO_FEET */, isElevationUnitsImperial);
    }
    
    // Current GPS accuracy & Battery Usage
    if ( (value == 19 /* OPTION_CURRENT_LOCATION_ACCURACY */ || value == 20 /* OPTION_CURRENT_LOCATION_ACCURACY_AND_BATTERY */) && info.currentLocationAccuracy != null )
    {
      if (valueData != info.currentLocationAccuracy)
      {
        var rezGPSTable = [Rez.Drawables.GPS0, Rez.Drawables.GPS1, Rez.Drawables.GPS2, Rez.Drawables.GPS3, Rez.Drawables.GPS4];
        imgGPS = WatchUi.loadResource(rezGPSTable[info.currentLocationAccuracy]);
      }
              
      return info.currentLocationAccuracy;
    }
    
    // Current power in Watts (W)
    if ( (value == 21 /* OPTION_CURRENT_POWER */) && (info.currentPower != null) )
    {
      return info.currentPower;
    }
    
    // Average power during the current activity in Watts (W)
    if ( (value == 22 /* OPTION_AVERAGE_POWER */) && (info.averagePower != null) ) 
    {
      return info.averagePower;
    }
    
    // Elapsed time for the current lap
    if (value == 25 /* OPTION_CURRENT_LAP_TIME */)
    {
      return (timer - startTimerCurrentLap);
    }
    
    // Elapsed distance for the current lap
    if (value == 26 /* OPTION_CURRENT_LAP_DISTANCE */)
    {
      return (distance - startDistanceCurrentLap);
    }
    
    // Average Pace for the current lap
    if (value == 27 /* OPTION_CURRENT_LAP_PACE */)
    {
      var timerCurrentLap = timer - startTimerCurrentLap;
      var distanceCurrentLap = distance - startDistanceCurrentLap;
      
      if (distanceCurrentLap <= 0) { return 0; }
      return timerCurrentLap / distanceCurrentLap;
    }
    
    // The Training Effect score of the current activity
    if ( (value == 28 /* OPTION_TRAINING_EFFECT */) && (info.trainingEffect != null) )
    {
      return info.trainingEffect;
    }
    
    // Time taken on previous km or mile
    if (value == 30 /* OPTION_TIMER_TIME_ON_PREVIOUS_LAP */) 
    {
      return timerLastLap;
    }
    
    if (value == 31 /* OPTION_ETA_LAP */)
    {
      if (lapDistance <= 0 || timer <= 0) { return 0; }
      
      var distanceMetric = convertUnitIfRequired(distance * 1000, 1.609344 /* CONVERSION_MILE_TO_KM */, isDistanceUnitsImperial);
      var startDistanceCurrentLapMetric = convertUnitIfRequired(startDistanceCurrentLap * 1000, 1.609344 /* CONVERSION_MILE_TO_KM */, isDistanceUnitsImperial);
      
      var distanceCurrentLap = distanceMetric - startDistanceCurrentLapMetric;
      var remainingLapDistance = lapDistance - distanceCurrentLap;
      if (remainingLapDistance <= 0) { remainingLapDistance = 0; }
      
      // Elapsed time for the current lap
      var timerCurrentLap = timer - startTimerCurrentLap;
      if (timerCurrentLap <= 0) { return valueData; }
      
      // Calculate average speed on current lap
      var avgSpeedMetric = distanceCurrentLap / timerCurrentLap;
      
      // ETA to reach next Lap
      if (avgSpeedMetric <= 0) { return timerCurrentLap; }
      return timerCurrentLap + (remainingLapDistance / avgSpeedMetric);
    }
    
    if (value == 32 /* OPTION_LAP_COUNT */)
    {
      return lapCount;
    }
    
    // Average cadence during the current activity in revolutions per minute (rpm)
    if ( (value == 33 /* OPTION_AVERAGE_CADENCE */) && (info.averageCadence != null) )
    {
      return info.averageCadence;
    }
    
    // Calculate if we are ahead of behing the target pace
    if (value == 34 /* OPTION_TIME_OFFSET */)
    {
      return timer - (targetPace * distance);
    }
    
    if ( (value == 35 /* OPTION_HR_ZONE */) && (info.currentHeartRate != null) )
    {
      var hr = info.currentHeartRate.toFloat();
      if (hr < hrZones[0]) { return hr / hrZones[0]; }
      
      for (var i = 1; i < 6; i++)
      {
        if (hr < hrZones[i] || i == 5) { return (hr - hrZones[i - 1]) / (hrZones[i] - hrZones[i - 1]) + i; }
      }
    }
    
    if (value >= 50 /* OPTION_ETA_5K */ && value <= 59 /* OPTION_REQUIRED_PACE_100K */)
    {
      var etaGoalTable = [5, 10, 21.0975, 42.195, 100];
      var baseKey = (value - 50 /* OPTION_ETA_5K */) % 5;
      var etaDistance = convertUnitIfRequired(etaGoalTable[baseKey], 0.62137119 /* CONVERSION_KM_TO_MILE */, isDistanceUnitsImperial);

      var remainingDistance = etaDistance - distance;
      if (remainingDistance <= 0) {
        if (baseKey < 4) { vType[id - 1] = value + 1; }
        return valueData;
      }
      
      if (value <= 54 /* OPTION_ETA_100K */)
      {
        var avgSpeed = 0;
        if (lapDistance > 0 && distanceOffset != 0)
        {
          if (timer > 0) { avgSpeed = distance / timer; }
        }
      
        else if (info.averageSpeed != null)
        {
          avgSpeed = convertUnitIfRequired(info.averageSpeed / 1000, 0.62137119 /* CONVERSION_KM_TO_MILE */, isDistanceUnitsImperial);
        }
      
        if (avgSpeed <= 0) { return valueData; }
        return timer + (remainingDistance / avgSpeed);
      }
      
      // else (value >= 55 /* OPTION_REQUIRED_PACE_5K */)
      var remainingTimer = (targetPace * etaDistance) - timer;
      return (remainingTimer / remainingDistance).toNumber();
    }
    
    return valueData;
  }
  
    
  // The given info object contains all the current workout information.
  // Calculate a value and save it locally in this method.
  // Note that compute() and onUpdate() are asynchronous, and there is no
  // guarantee that compute() will be called before onUpdate().
  function compute(info)
  {
    // The current timer value in milliseconds (ms)
    if (info.timerTime != null)
    {
      // Convert in second
      timer = info.timerTime / 1000.0;
    }
    
    // Elapsed  of the current activity in meters (m)
    if (info.elapsedDistance != null)
    {
      distance = convertUnitIfRequired((info.elapsedDistance + distanceOffset) / 1000.0, 0.62137119 /* CONVERSION_KM_TO_MILE */, isDistanceUnitsImperial);
    }

    for (var i = 0; i < 10; i++)
    {
      vData[i] = computeValue(info, i + 1, vType[i], vData[i]);
    }
  }
  
  
  // Display the value you computed here. This will be called
  // once a second when the data field is visible.
  function onUpdate(dc)
  {
    // Set colors
    if (DataField.getBackgroundColor() == primaryForegroundColor)
    {
      primaryForegroundColor = ~primaryForegroundColor & 0xFFFFFF;
      headerBackgroundColor = ~headerBackgroundColor & 0xFFFFFF;
    }
    
    // Bugfix on Garmin Venue.
    var color2 = ~primaryForegroundColor & 0xFFFFFF;
    dc.setColor(~primaryForegroundColor & 0xFFFFFF, Graphics.COLOR_TRANSPARENT);
    dc.fillRectangle(0, 0, deviceWidth, deviceHeight);
    
    // Inverse background for row 4 and 5
    if (singleBackgroundColor == false)
    {
      dc.setColor(primaryForegroundColor, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(vArea[7][0], vArea[7][1], deviceWidth, deviceHeight);
    }
    
    // 6 = 0110 (PARAM_ALL_COLOR or PARAM_TOP_BOTTOM_COLOR_)
    // 5 = 0101 (PARAM_ALL_COLOR or PARAM_MIDDLE_COLOR)
    // 4 = 0100 (PARAM_ALL_COLOR)
    // 2 = 0010 (PARAM_TOP_BOTTOM_COLOR)
    // 1 = 0001 (PARAM_MIDDLE_COLOR)
    // 0 = 0000 (PARAM_DISABLE_COLOR)
    var dynamicDataBackgroundColor = dynamicColor >> 4 & 0xF;
    var dynamicDataForegroundColor = dynamicColor & 0xF;
    var bgColorMiddleRow = dynamicDataBackgroundColor & 0x6 > 0; // dynamicDataBackgroundColor == 4 || dynamicDataBackgroundColor == 2;
    var fgColorMiddleRow = dynamicDataForegroundColor & 0x6 > 0; // dynamicDataForegroundColor == 4 || dynamicDataForegroundColor == 2;
    var bgColorTopBottomRow = dynamicDataBackgroundColor & 0x5;  //dynamicDataBackgroundColor == 4 || dynamicDataBackgroundColor == 1;
    var fgColorTopBottomRow = dynamicDataForegroundColor & 0x5;  //dynamicDataForegroundColor == 4 || dynamicDataForegroundColor == 1;
    
    // Display Area
    for (var i = 0; i < 10; i++)
    {
      if ( (i == 0) || (i >= 7) ) { 
        displayArea(dc, i + 1, vType[i], vData[i], vArea[i], bgColorTopBottomRow, fgColorTopBottomRow);
      }
      
      else {
        displayArea(dc, i + 1, vType[i], vData[i], vArea[i], bgColorMiddleRow, fgColorMiddleRow);
      }
    }
    
    if ( (vType[7] != 0 /* OPTION_EMPTY */) && (vType[8] != 0 /* OPTION_EMPTY */) )
    {
      dc.setPenWidth(3);
      if (singleBackgroundColor) { dc.setColor(primaryForegroundColor, Graphics.COLOR_TRANSPARENT); }
      else { dc.setColor(color2, Graphics.COLOR_TRANSPARENT); }
      dc.drawLine(vArea[7][2], vArea[7][1] + 5, vArea[7][2], vArea[7][1] + vArea[7][3] - 5);
      dc.setPenWidth(1);
    }
    
    // Display lines
    dc.setColor(~headerBackgroundColor & 0xFFFFFF, Graphics.COLOR_TRANSPARENT);
    
    // Display horizontal lines
    dc.setPenWidth(2);
    drawHorizontalLine(dc, 1);
    drawHorizontalLine(dc, 4);
    drawHorizontalLine(dc, 7);
    
    // Display vertical lines
    drawVerticalLine(dc, 2);
    drawVerticalLine(dc, 3);
    drawVerticalLine(dc, 5);
    drawVerticalLine(dc, 6);
    
    dc.setPenWidth(1);
    var headerY = (headerPosition == 3) ? vArea[1][1] + vArea[1][3] - headerHeight : vArea[1][1] + headerHeight;
    dc.drawLine(0, headerY, deviceWidth, headerY);
    headerY = (headerPosition == 2) ? vArea[4][1] + vArea[4][3] - headerHeight : vArea[4][1] + headerHeight;
    dc.drawLine(0, headerY, deviceWidth, headerY);
  }
  
  function drawHorizontalLine(dc, areaIndex)
  {
    dc.drawLine(0, vArea[areaIndex][1], deviceWidth, vArea[areaIndex][1]);
  }
  
  
  function drawVerticalLine(dc, areaIndex)
  {
    if (vType[areaIndex] != 0 /* OPTION_EMPTY */) { dc.drawLine(vArea[areaIndex][0], vArea[areaIndex][1], vArea[areaIndex][0], vArea[areaIndex][1] + vArea[areaIndex][3]); }
  }

  
  function displayArea(dc, id, type, value, valueArea, dynamicBackgroundColor, dynamicForegroundColor)
  {
    if (type == 0 /* OPTION_EMPTY */) { return; }
    var hasHeader = false;
    
    var fgColor = null;
    var bgColor = null;
    var color = getColor(type, value);
    
    var isWhiteBG = (primaryForegroundColor == Graphics.COLOR_BLACK);
    if ( (id >= 8) && (singleBackgroundColor == false) ) { isWhiteBG = !isWhiteBG; }
    
    var areaX = valueArea[0];
    var areaY = valueArea[1];
    var areaWidth = valueArea[2];
    var areaHeight = valueArea[3];
    var areaXcenter = areaX + (areaWidth / 2);
  
    // Set Header values, except for Area 1, 8 and 9
    if ( (id >= 2) && (id <= 7) )
    {
      hasHeader = true;
      
      if (headerHeight > 0)
      {
        var leftOffsetX = 0;
        var rightOffsetX = 0;
        var headerY = valueArea[1];
        areaHeight -= headerHeight;
        
        if ( (headerPosition == 2 && id > 4) || (headerPosition == 3 && id < 5) )
        {
          headerY += valueArea[3] - headerHeight;
        }
        
        else
        {
          areaY += headerHeight;
        }
        
        var headerYcenter = headerY + (headerHeight / 2);
        if (areaX == 0) { leftOffsetX = (deviceWidth - getWidth(headerYcenter)) / 2; }
        if (areaX + areaWidth == deviceWidth) { rightOffsetX = (deviceWidth - getWidth(headerYcenter)) / 2; }
        if ( (id == 2) || (id == 3) || (id == 5) || (id == 6) ) { rightOffsetX += 1; }
        if ( (id == 3) || (id == 4) || (id == 6) || (id == 7) ) { leftOffsetX += 2; }
        var headerXcenter = areaXcenter + (leftOffsetX / 2) - (rightOffsetX / 2);
        
        if (initCompleted > 0)
        {
          initCompleted--;
          var font = getFont(dc, 1, getHeaderName(type), areaWidth - leftOffsetX - rightOffsetX, headerHeight - 2);
          if (font < fontHeader) { fontHeader = font; }
        }
        
        // Header Background Color
        var dynamicHeaderBackgroundColor = (dynamicColor >> 8) == 1;
        var headerBgColor = (dynamicHeaderBackgroundColor && (color != null)) ? color : headerBackgroundColor;
        dc.setColor(headerBgColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(areaX, headerY, areaWidth, headerHeight);
        
        // Header Text
        var headerFgColor = primaryForegroundColor;
        if ( (headerBgColor == Graphics.COLOR_RED) || (headerBgColor == Graphics.COLOR_DK_GREEN && !dynamicBackgroundColor) ) { headerFgColor = Graphics.COLOR_WHITE; }
        dc.setColor(headerFgColor, Graphics.COLOR_TRANSPARENT);
        dc.setClip(areaX + leftOffsetX, headerY, areaWidth - leftOffsetX - rightOffsetX, headerHeight);
        dc.drawText(headerXcenter, headerYcenter, fontHeader, getHeaderName(type), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);      
        dc.clearClip();
      }
    }
    
    // Set Data values
    var leftOffsetX = 0;
    var rightOffsetX = 0;
    var areaYcenter = areaY + (areaHeight / 2) - 1;
    if (areaX == 0) { leftOffsetX = (deviceWidth - getWidth(areaYcenter)) / 2; }
    if (areaX + areaWidth == deviceWidth) { rightOffsetX = (deviceWidth - getWidth(areaYcenter)) / 2; }
    areaXcenter += (leftOffsetX / 2) - (rightOffsetX / 2);
    
    // Realign row 4 and 5 on some devices
    if (id > 7) { areaYcenter += yOffset; }
    
    if (color != null)
    {
      if (dynamicBackgroundColor)
      {
        bgColor = color;
        
        if (bgColor == Graphics.COLOR_RED) { fgColor = Graphics.COLOR_WHITE; }
        else { fgColor = primaryForegroundColor; }
        
        var bgHeight = areaHeight;
        if (deviceHeight - areaY - areaHeight <= 10) { bgHeight = deviceHeight; }
        
        dc.setColor(bgColor, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(areaX, areaY, areaWidth, bgHeight);
      }
      
      else if (dynamicForegroundColor)
      {
        // Replace some colors on white background
        if (isWhiteBG)
        {
          if (color == Graphics.COLOR_BLUE) // 0x00AAFF
          {
            color = 0x0000AA;
          }
          
          else if (color == Graphics.COLOR_DK_GREEN) // 0x00AA00
          {
            color = 0x005500;
          }
          
          else if (color == Graphics.COLOR_LT_GRAY)
          {
            color = Graphics.COLOR_DK_GRAY;
          }
        }
        
        // Replace some colors on black background
        else
        {
          if (color == Graphics.COLOR_BLUE) // 0x00AAFF
          {
            color = 0x00FFFF;
          }
          
          else if (color == Graphics.COLOR_DK_GREEN) // 0x00AA00
          {
            color = 0x00FF00;
          }
        }
        
        fgColor = color;
      }
    }
    
    dc.setClip(areaX + leftOffsetX, areaY, areaWidth - leftOffsetX - rightOffsetX, areaHeight);
    
    //if ( (type == 25 /* OPTION_CURRENT_LAP_TIME = 25 */) && (lapDistance > 0) )
    //{
    //  var distanceMetric = convertUnitIfRequired(distance * 1000, 1.609344 /* CONVERSION_MILE_TO_KM */, isDistanceUnitsImperial);
    //  var startDistanceCurrentLapMetric = convertUnitIfRequired(startDistanceCurrentLap * 1000, 1.609344 /* CONVERSION_MILE_TO_KM */, isDistanceUnitsImperial);
    //  var lapPercentage = (distanceMetric - startDistanceCurrentLapMetric) / lapDistance;
    //  
    //  dc.setColor(0x00AA00, Graphics.COLOR_TRANSPARENT);
    //  dc.fillRectangle(areaX + leftOffsetX, areaY, (areaWidth - leftOffsetX - rightOffsetX) * lapPercentage, areaHeight);
    //}
    
    if (type == 18 /* OPTION_CURRENT_BATTERY */)
    {
      areaYcenter -= 2;
      drawBattery(dc, id, areaXcenter, areaYcenter);
    }
    
    else if (type == 19 /* OPTION_CURRENT_LOCATION_ACCURACY */)
    {
      areaYcenter -= 2;
      dc.drawBitmap(areaXcenter - 14, areaYcenter - 11, imgGPS);
    }
    
    else if (type == 20 /* OPTION_CURRENT_LOCATION_ACCURACY_AND_BATTERY */)
    {
      areaYcenter -= 2;
      dc.drawBitmap(areaXcenter - 43, areaYcenter - 11, imgGPS);
      drawBattery(dc, id, areaXcenter + 17 /*(gpsLength / 2)*/, areaYcenter);
    }
    
    else
    {
      if (fgColor != null) { dc.setColor(fgColor, Graphics.COLOR_TRANSPARENT); }
      else if (id < 8 || singleBackgroundColor) { dc.setColor(primaryForegroundColor, Graphics.COLOR_TRANSPARENT); }
      else { dc.setColor(~primaryForegroundColor & 0xFFFFFF, Graphics.COLOR_TRANSPARENT); }
      
      var formattedValue = getFormattedValue(id, type, value);
      // Display HR icon if in Area 1, 8 or 9
      if ( ((type == 6 /* OPTION_CURRENT_HEART_RATE */) || (type == 9 /* OPTION_AVERAGE_HEART_RATE */)) && (hasHeader == false) )
      {
        //var iconWidth = 24; //dc.getTextWidthInPixels("0", fontIcons);
        var font = getFont(dc, type, formattedValue, areaWidth - leftOffsetX - rightOffsetX - 36 /*(iconWidth * 1.5)*/, areaHeight);
        var textWidth = 12 /*(iconWidth / 2)*/ + dc.getTextWidthInPixels(formattedValue, font);
        
        // Display HR value
        dc.drawText(areaXcenter + 12 /*(iconWidth / 2)*/, areaYcenter, font, formattedValue, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Always display HR icon in color
        if ( (fgColor == null) && (color != null) )
        {
          if (isWhiteBG && (color == Graphics.COLOR_LT_GRAY))
          {
            color = Graphics.COLOR_DK_GRAY;
          }
          
          dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        }
        dc.drawText(areaXcenter - (textWidth / 2), areaYcenter, fontIcons, 0, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      }
      
      // Display regular field
      else
      {
        dc.drawText(areaXcenter, areaYcenter, getFont(dc, type, formattedValue, areaWidth - leftOffsetX - rightOffsetX, areaHeight), formattedValue, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      }
    }
    
    dc.clearClip();
  }
  
  
  function getHeaderName(type)
  {
    if (type == 1 /* OPTION_CURRENT_TIME */) { return "TIME"; }
    if (type == 2 /* OPTION_TIMER_TIME */) { return "TIMER"; }
    if (type == 5 /* OPTION_ELAPSED_DISTANCE */) { return "DIST"; }
    if (type == 6 /* OPTION_CURRENT_HEART_RATE */) { return "HR"; }
    if (type == 7 /* OPTION_CURRENT_PACE */) { return "PACE"; }
    if (type == 8 /* OPTION_CURRENT_SPEED */) { return "SPD"; }
    if (type == 9 /* OPTION_AVERAGE_HEART_RATE */) { return "A HR"; }
    if (type == 10 /* OPTION_AVERAGE_PACE */) { return "A PACE"; }
    if (type == 12 /* OPTION_AVERAGE_SPEED */) { return "A SPD"; }
    if (type == 13 /* OPTION_CALORIES */) { return "CAL"; }
    if (type == 14 /* OPTION_CURRENT_CADENCE */) { return "CAD"; }
    if (type == 15 /* OPTION_ALTITUDE */) { return "ALT"; }
    if (type == 16 /* OPTION_TOTAL_ASCENT */) { return "ASCENT"; }
    if (type == 17 /* OPTION_TOTAL_DESCENT */) { return "DESCENT"; }
    if (type == 18 /* OPTION_CURRENT_BATTERY */) { return "BAT"; }
    if (type == 19 /* OPTION_CURRENT_LOCATION_ACCURACY */) { return "GPS"; }
    if (type == 20 /* OPTION_CURRENT_LOCATION_ACCURACY_AND_BATTERY */) { return "GPS/BAT"; }
    if (type == 21 /* OPTION_CURRENT_POWER */) { return "POW"; }
    if (type == 22 /* OPTION_AVERAGE_POWER */) { return "A POW"; }
    if (type == 25 /* OPTION_CURRENT_LAP_TIME */) { return "LTIME"; }
    if (type == 26 /* OPTION_CURRENT_LAP_DISTANCE */) { return "LDIST"; }
    if (type == 27 /* OPTION_CURRENT_LAP_PACE */) { return "LPACE"; }
    if (type == 28 /* OPTION_TRAINING_EFFECT */) { return "TE"; }
    if (type == 30 /* OPTION_TIMER_TIME_ON_PREVIOUS_LAP */) { return "LAST LAP"; }
    if (type == 31 /* OPTION_ETA_LAP */) { return "ETA LAP"; }
    if (type == 32 /* OPTION_LAP_COUNT */) { return "LAP"; }
    if (type == 33 /* OPTION_AVERAGE_CADENCE */) { return "A CAD"; }
    if (type == 34 /* OPTION_TIME_OFFSET */) { return "+/-"; }
    if (type == 35 /* OPTION_HR_ZONE */) { return "HR Z"; }
    if (type == 50 /* OPTION_ETA_5K */) { return "ETA 5K"; }
    if (type == 51 /* OPTION_ETA_10K */) { return "ETA 10K"; }
    if (type == 52 /* OPTION_ETA_HALF_MARATHON */) { return "ETA 21K"; }
    if (type == 53 /* OPTION_ETA_MARATHON */) { return "ETA 42K"; }
    if (type == 54 /* OPTION_ETA_100K */) { return "ETA 100K"; }
    if (type == 55 /* OPTION_REQUIRED_PACE_5K */) { return "RP 5K"; }
    if (type == 56 /* OPTION_REQUIRED_PACE_10K */) { return "RP 10K"; }
    if (type == 57 /* OPTION_REQUIRED_PACE_HALF_MARATHON */) { return "RP 21K"; }
    if (type == 58 /* OPTION_REQUIRED_PACE_MARATHON */) { return "RP 42K"; }
    if (type == 59 /* OPTION_REQUIRED_PACE_100K */) { return "RP 100K"; }
    
    return "";
  }
  
  
  function getFormattedValue(id, type, value)
  {
    if (type == 0 /* OPTION_EMPTY */)
    {
      return "";
    }
    
    if (type == 1 /* OPTION_CURRENT_TIME */)
    {
      var hour = System.getDeviceSettings().is24Hour || value.hour <= 12 ? value.hour : value.hour - 12;
      return hour + "h" + value.min.format("%02d");
    }
    
    if (type == 7 /* OPTION_CURRENT_PACE */ ||
        type == 10 /* OPTION_AVERAGE_PACE */ ||
        type == 27 /* OPTION_CURRENT_LAP_PACE */ ||
        (type >= 55 /* OPTION_REQUIRED_PACE_5K */ && type <= 59 /* OPTION_REQUIRED_PACE_100K */) )
    {
      return formatDuration(value, false);
    }
    
    if (type == 2 /* OPTION_TIMER_TIME */ ||
        type == 25 /* OPTION_CURRENT_LAP_TIME */ ||
        type == 30 /* OPTION_TIMER_TIME_ON_PREVIOUS_LAP */ ||
        type == 31 /* OPTION_ETA_LAP */ ||
        (type >= 50 /* OPTION_ETA_5K */ && type <= 54 /* OPTION_ETA_100K */) )
    {
      return formatDuration(value, true);
    }

    if (type == 5 /* OPTION_ELAPSED_DISTANCE */ ||
        type == 26 /* OPTION_CURRENT_LAP_DISTANCE */)
    {
      // Calling format("%.1f") will round the value. To truncate the value instead of rounding, we simply multiply by 10, convert to Integer and divide by 10.0 (Float).
      // Example: 4.48 --> (4.48 * 10).toNumber() = 44 / 10.0 = 4.4
      return ((value * 100).toNumber() / 100.0).format("%.2f");
    }
    
    if (type == 8 /* OPTION_CURRENT_SPEED */ ||
        type == 12 /* OPTION_AVERAGE_SPEED */ ||
        type == 28 /* OPTION_TRAINING_EFFECT */)
    {
      if (value < 10) { return value.format("%.2f"); }
      return value.format("%.1f");
    }

    if (type == 15 /* OPTION_ALTITUDE */ ||
        type == 16 /* OPTION_TOTAL_ASCENT */ ||
        type == 17 /* OPTION_TOTAL_DESCENT */)
    {
      return Math.round(value).format("%.0f");
    }
    
    if (type == 34 /* OPTION_TIME_OFFSET */)
    {
      var prefix = Math.round(value).toNumber() >= 0 ? "+" : ""; 
      return prefix + formatDuration(value, true);
    }

    if (value instanceof Float) { return value.format("%.1f"); }
    return value.toString();
  }
  
  
  function getFont(dc, type, value, maxWidth, maxHeight)
  {
    var fontID = Graphics.FONT_NUMBER_THAI_HOT;
    var textDimension;
    if (type == 1 /* OPTION_CURRENT_TIME */) { fontID = Graphics.FONT_LARGE; }
    
    while (fontID > 0)
    {
      textDimension = dc.getTextDimensions(value, fontID);
      textDimension[1] = textDimension[1] - (2 * dc.getFontDescent(fontID));
      
      // Horizontal Padding (0.5 left + 0.5 right)
      // Vertical Padding (1 top + 1 bottom)
      if (textDimension[0] <= maxWidth - 1 && textDimension[1] <= maxHeight - 2) { return fontID; }
      fontID--;
    }
    
    return Graphics.FONT_XTINY;
  }
  
  
  function getColor(type, value)
  {
    if (type == 6 /* OPTION_CURRENT_HEART_RATE */ ||
        type == 9 /* OPTION_AVERAGE_HEART_RATE */)
    {
      if (value < hrZones[0]) { return null; }     // Black
      if (value < hrZones[1]) { return 0xAAAAAA; } // Light Gray
      if (value < hrZones[2]) { return 0x00AAFF; } // Blue
      if (value < hrZones[3]) { return 0x00AA00; } // Dark Green
      if (value < hrZones[4]) { return 0xFF5500; } // Orange
      return 0xFF0000;                             // Red
    }
    
    if (type == 8 /* OPTION_CURRENT_SPEED */ ||
        type == 12 /* OPTION_AVERAGE_SPEED */)
    {
      if (value > 0) {
        type = 7; /* OPTION_CURRENT_PACE */
        value = 1000 / (value / 3.6);
      }
    }
  
    if (type == 7 /* OPTION_CURRENT_PACE */ ||
        type == 10 /* OPTION_AVERAGE_PACE */ ||
        type == 27 /* OPTION_CURRENT_LAP_PACE */)
    {
      value = Math.round(value).toNumber();
      if (value <= 0) { return null; }
      if (value < (targetPace - paceRange)) { return Graphics.COLOR_BLUE; } // 0x00AAFF
      if (value > (targetPace + paceRange)) { return Graphics.COLOR_RED; } // 0xFF0000
      return Graphics.COLOR_DK_GREEN; // 0x00AA00
    }
    
    if (type == 34 /* OPTION_TIME_OFFSET */)
    {
      value = Math.round(value).toNumber();
      if (value > 0) { return Graphics.COLOR_RED; }
      else if (value < 0) { return Graphics.COLOR_BLUE; }
    }
    
    return null;
  }
  
  
  function getWidth(y)
  {
    if (System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_ROUND) {
      var radius = deviceWidth / 2;
      var angle = 2 * Math.toDegrees(Math.acos(1 - (y.toFloat() / radius))); // Angle = 2 * arccos(1 - height(y) / radius)
      return (2 * radius * Math.sin(Math.toRadians(angle) / 2)).toNumber();
    }
    
    //else if (System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_SEMI_ROUND) {}
    //else if (System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_RECTANGLE) {}
    return deviceWidth;
  }
  
  
  function formatDuration(seconds, displayHour)
  {
    if (seconds instanceof String) { return seconds; } 
    seconds = Math.round(seconds).toNumber();
    
    var prefix = "";
    if (seconds < 0)
    {
      prefix = "-";
      seconds = -seconds;
    }
    
    var hh = 0;
    var mm = 0;
    
    if (displayHour == true)
    {
      hh = seconds / 3600;
      mm = seconds / 60 % 60;
    }
    
    else
    {
      mm = seconds / 60;
      if (mm > 99) { return "0:00"; }
    }
    
    var ss = seconds % 60;
    return prefix + (hh > 0 ? hh + ":" + mm.format("%02d") : mm.format("%d")) + ":" + ss.format("%02d");
  }
  
  
  function drawBattery(dc, id, x, y/*, fixedBackground*/)
  {
    var width = 50   /* LENGTH_BATTERY_ICON */;
    var height = 20; //(width * 2/5).toNumber();
    var radius = 3;  //0.15 * height;
    var x1 = x - 25; //(width / 2).toNumber();
    var y1 = y - 10; // (height / 2).toNumber();
    var batteryPercentage = System.getSystemStats().battery;
    
    // COLOR_LT_GRAY = 0xAAAAAA
    // COLOR_DK_GRAY = 0x555555
    // (Bitwise NOT 0xA) = 0x5
    // (Bitwise NOT 0x5) = 0xA
    // (Bitwise NOT 0xAAAAAA) = (~0xAAAAAA) = 0xFF55555
    // (0xFF55555 Bitwise AND 0xFFFFFF = 0xFF55555 & 0xFFFFFF = 0x555555 (COLOR_DK_GRAY)
    //var grayColor = (id >= 8) ? colorBorder : ~colorBorder&0xFFFFFF;
    //var grayColor = (id >= 8) ? colorBorder : headerBackgroundColor;
    var grayColor = (id >= 8 && singleBackgroundColor == false) ? headerBackgroundColor : ~headerBackgroundColor & 0xFFFFFF;
    
    dc.setClip(x1 + width + 1, y1, radius - 1, height);
    dc.setColor(grayColor, Graphics.COLOR_TRANSPARENT);
    dc.fillCircle(x1 + width, y, radius);
    dc.clearClip();
    
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    dc.fillRectangle(x1 + 1, y1 + 1, width - 2, height - 2);
    dc.drawRoundedRectangle(x1 + 1, y1 + 1, width - 2, height - 2, 3);
    
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.fillRoundedRectangle(x1 + 2, y1 + 2, width - 4, height - 4, 3);
    
    dc.setColor(grayColor, Graphics.COLOR_TRANSPARENT);
    dc.drawRoundedRectangle(x1, y1, width, height, 3);
    
    //if (fixedBackground == true)
    //{
      dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    //}
    
    /*
    else
    {
      // Display background according to battery percentage
      var width3 = ((100 - batteryPercentage) / 100 * (width - 4)).toNumber();
      var width4 = width - 4 - width3;
      dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(x1 + 2 + width4, y1 + 2, width3, height - 4);
      
      if (batteryPercentage < 10) {
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
      }
      
      else {
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
      }
    }
    */
    
    dc.drawText(x, y - 1, fontTiny, batteryPercentage.format("%d") + "%", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
  }
  
  
  /* Uncomment for debug purpose only. This part of code is commented to optimize memory usage */
  //function log(text)
  //{
    //var date = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    //var formattedDate = date.year + "-" + date.month.format("%02d") + "-" + date.day.format("%02d") + " " + date.hour.format("%02d") + ":" + date.min.format("%02d") + ":" + date.sec.format("%02d");
    //System.println(formattedDate + " " + text);
  //}
  
  //function getOptionName(type)
  //{
    //if (type == 0 /* OPTION_EMPTY */) { return "OPTION_EMPTY"; }
    //else if (type == 1 /* OPTION_CURRENT_TIME */) { return "OPTION_CURRENT_TIME"; }
    //else if (type == 2 /* OPTION_TIMER_TIME */) { return "OPTION_TIMER_TIME"; }
    //else if (type == 5 /* OPTION_ELAPSED_DISTANCE */) { return "OPTION_ELAPSED_DISTANCE"; }
    //else if (type == 6 /* OPTION_CURRENT_HEART_RATE */) { return "OPTION_CURRENT_HEART_RATE"; }
    //else if (type == 7 /* OPTION_CURRENT_PACE */) { return "OPTION_CURRENT_PACE"; }
    //else if (type == 8 /* OPTION_CURRENT_SPEED */) { return "OPTION_CURRENT_SPEED"; }
    //else if (type == 9 /* OPTION_AVERAGE_HEART_RATE */) { return "OPTION_AVERAGE_HEART_RATE"; }
    //else if (type == 10 /* OPTION_AVERAGE_PACE */) { return "OPTION_AVERAGE_PACE"; }
    //else if (type == 12 /* OPTION_AVERAGE_SPEED */) { return "OPTION_AVERAGE_SPEED"; }
    //else if (type == 13 /* OPTION_CALORIES */) { return "OPTION_CALORIES"; }
    //else if (type == 14 /* OPTION_CURRENT_CADENCE */) { return "OPTION_CURRENT_CADENCE"; }
    //else if (type == 15 /* OPTION_ALTITUDE */) { return "OPTION_ALTITUDE"; }
    //else if (type == 16 /* OPTION_TOTAL_ASCENT */) { return "OPTION_TOTAL_ASCENT"; }
    //else if (type == 17 /* OPTION_TOTAL_DESCENT */) { return "OPTION_TOTAL_DESCENT"; }
    //else if (type == 18 /* OPTION_CURRENT_BATTERY */) { return "OPTION_CURRENT_BATTERY"; }
    //else if (type == 19 /* OPTION_CURRENT_LOCATION_ACCURACY */) { return "OPTION_CURRENT_LOCATION_ACCURACY"; }
    //else if (type == 20 /* OPTION_CURRENT_LOCATION_ACCURACY_AND_BATTERY */) { return "OPTION_CURRENT_LOCATION_ACCURACY_AND_BATTERY"; }
    //else if (type == 25 /* OPTION_CURRENT_LAP_TIME */) { return "OPTION_CURRENT_LAP_TIME"; }
    //else if (type == 26 /* OPTION_CURRENT_LAP_DISTANCE */) { return "OPTION_CURRENT_LAP_DISTANCE"; }
    //else if (type == 27 /* OPTION_CURRENT_LAP_PACE */) { return "OPTION_CURRENT_LAP_PACE"; }
    //else if (type == 28 /* OPTION_TRAINING_EFFECT */) { return "OPTION_TRAINING_EFFECT"; }
    //else if (type == 30 /* OPTION_TIMER_TIME_ON_PREVIOUS_LAP */) { return "OPTION_TIMER_TIME_ON_PREVIOUS_LAP"; }
    //else if (type == 31 /* OPTION_ETA_LAP */) { return "OPTION_ETA_LAP"; }
    //else if (type == 32 /* OPTION_LAP_COUNT */) { return "OPTION_LAP_COUNT"; }
    //else if (type == 33 /* OPTION_AVERAGE_CADENCE */) { return "OPTION_AVERAGE_CADENCE"; }
    //else if (type == 34 /* OPTION_TIME_OFFSET */) { return "OPTION_TIME_OFFSET"; }
    //else if (type == 50 /* OPTION_ETA_5K */) { return "OPTION_ETA_5K"; }
    //else if (type == 51 /* OPTION_ETA_10K */) { return "OPTION_ETA_10K"; }
    //else if (type == 52 /* OPTION_ETA_HALF_MARATHON */) { return "OPTION_ETA_HALF_MARATHON"; }
    //else if (type == 53 /* OPTION_ETA_MARATHON */) { return "OPTION_ETA_MARATHON"; }
    //else if (type == 54 /* OPTION_ETA_100K */) { return "OPTION_ETA_100K"; }
    //else if (type == 55 /* OPTION_REQUIRED_PACE_5K */) { return "OPTION_REQUIRED_PACE_5K"; }
    //else if (type == 56 /* OPTION_REQUIRED_PACE_10K */) { return "OPTION_REQUIRED_PACE_10K"; }
    //else if (type == 57 /* OPTION_REQUIRED_PACE_HALF_MARATHON */) { return "OPTION_REQUIRED_PACE_HALF_MARATHON"; }
    //else if (type == 58 /* OPTION_REQUIRED_PACE_MARATHON */) { return "OPTION_REQUIRED_PACE_MARATHON"; }
    //else if (type == 59 /* OPTION_REQUIRED_PACE_100K */) { return "OPTION_REQUIRED_PACE_100K"; }
    //
    //return type;
  //}
}