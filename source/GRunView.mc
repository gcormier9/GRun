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


class GRunView extends WatchUi.DataField
{
  // Array of the current heart rate zone threshold values in beats per minute (bpm)
  protected var hrZones;
  // Elapsed Distance (km or miles)
  protected var distance = 0.0;
  // Determine distance offset on each lap (in meter)
  protected var distanceOffset = 0.0;
  // Timer
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
  
  protected var color1 = Graphics.COLOR_BLACK;
  protected var color2 = Graphics.COLOR_WHITE;
  protected var colorBorder = Graphics.COLOR_DK_GRAY;
  protected var colorHeader = Graphics.COLOR_LT_GRAY;
  
  // Display Header background in red/green/blue based on values (exemple current pace)
  protected var dynamicHeaderColor;
  // Display Data foreground in red/green/blue based on values (exemple current pace)
  protected var dynamicForegroundColor;
  
  // Header Position change the layout. Possible values are 1, 2 and 3
  protected var headerPosition;
  // Header Height in pixel. Calculated using HeaderHeight parameter in percentage
  protected var headerHeight;
  // If true, rows 4/5 have same color as rows 1/2/3
  protected var singleBackgroundColor;
  
  //Allow to set column for second row with different size 
  protected var columnWidthRatio1;
  //Allow to set column for third row with different size 
  protected var columnWidthRatio2;
  // If pace is lower than minPace, it will be displayed in blue
  // If pace is between minPace and maxPace, it will be displayed in green
  // If pace is greater than maxPace, it will be displayed in red
  protected var minPace;
  protected var maxPace;
  // If greater than 0, distance will be rounded to the nearest lapDistance every time lap button is pressed
  protected var lapDistance;
  
  // vX variables are used to stored the type of data each area will display (Exemple: Current Pace, Distance, etc.)
  protected var v1, v2, v3, v4, v5, v6, v7, v8, v9, v10;
  // vXdata variables contains the actuel value to display. For example, if v1 is configure to display current pace, v1data will display MM:SS
  protected var v1data, v2data, v3data, v4data, v5data, v6data, v7data, v8data, v9data, v10data;
  // vXarea indicates the x/y coordonate of the Value area, including header
  protected var v1area = [0,0,0,0], v2area = [0,0,0,0], v3area = [0,0,0,0], v4area = [0,0,0,0], v5area = [0,0,0,0], v6area = [0,0,0,0], v7area = [0,0,0,0], v8area = [0,0,0,0], v9area = [0,0,0,0], v10area = [0,0,0,0];
  
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
    OPTION_ETA_5K = 21,
    OPTION_ETA_10K = 22,
    OPTION_ETA_HALF_MARATHON = 23,
    OPTION_ETA_MARATHON = 24,
    OPTION_CURRENT_LAP_TIME = 25,
    OPTION_CURRENT_LAP_DISTANCE = 26,
    OPTION_CURRENT_LAP_PACE = 27,
    OPTION_TRAINING_EFFECT = 28,
    OPTION_CORRECTED_DISTANCE = 29,
    OPTION_TIMER_TIME_ON_PREVIOUS_LAP = 30,
    OPTION_ETA_LAP = 31.
    OPTION_LAP_COUNT = 32
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
  
  
  function configureAreaDimension(s, v1, v2, v3, valueArea1, valueArea2, valueArea3, y, height)
  {
    var i = 0;
    var commaIndex = s.find(",");
    var numberArray = [0, 0, 0];
    
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
    
    var nonEmptyValues = (v1 == 0 ? 0 : 1) + (v2 == 0 ? 0 : 1) + (v3 == 0 ? 0 : 1);
    
    // String s is missing parameters (comma missing)
    // Redefine string s using default value: 2,1,2
    if (nonEmptyValues > i)
    {
      numberArray[0] = 2;
      numberArray[1] = 1;
      numberArray[2] = 2;
    }
    
    if (nonEmptyValues == i && i < 3)
    {
      var count = 0;
      if (v1 != 0 /* OPTION_EMPTY */) { numberArray[0] = numberArray[count]; count++; }
      if (v2 != 0 /* OPTION_EMPTY */) { numberArray[1] = numberArray[count]; count++; }
      if (v3 != 0 /* OPTION_EMPTY */) { numberArray[2] = numberArray[count]; }
    }
    
    if (v1 == 0 /* OPTION_EMPTY */) { numberArray[0] = 0; }
    if (v2 == 0 /* OPTION_EMPTY */) { numberArray[1] = 0; }
    if (v3 == 0 /* OPTION_EMPTY */) { numberArray[2] = 0; }
    
    var totalWidthRatio = numberArray[0] + numberArray[1] + numberArray[2];
    if (totalWidthRatio == 0) { totalWidthRatio = 1; }
    var columnWidth1 = deviceWidth * numberArray[0] / totalWidthRatio;
    var columnWidth2 = deviceWidth * numberArray[1] / totalWidthRatio;
    var columnWidth3 = deviceWidth * numberArray[2] / totalWidthRatio;

    assignAreaValues(valueArea1, 0, y, columnWidth1, height);
    assignAreaValues(valueArea2, columnWidth1, y, columnWidth2, height);
    if (valueArea3 != null) { assignAreaValues(valueArea3, columnWidth1 + columnWidth2, y, columnWidth3, height); }
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
    columnWidthRatio1 = getParameter("ColumnWidthRatio1", "2,1,2");
    columnWidthRatio2 = getParameter("ColumnWidthRatio2", "2,1,2");
    
    dynamicHeaderColor = getParameter("HeaderBackgroundColor", true);
    dynamicForegroundColor = getParameter("DataForegroundColor", false);
    
    lapDistance = getParameter("LapDistance", 0).toNumber();

    minPace = getParameter("MinPace", isPaceUnitsImperial ? 510 : 315).toNumber();
    maxPace = getParameter("MaxPace", isPaceUnitsImperial ? 555 : 345).toNumber();
        
    // Select which values are displayed in each area
    // Value must be selected according to the enum
    // The following options are currently supported:
    //  - OPTION_EMPTY = 0
    //  - OPTION_CURRENT_TIME = 1
    //  - OPTION_TIMER_TIME = 2
    //  - OPTION_ELAPSED_DISTANCE = 5
    //  - OPTION_CURRENT_HEART_RATE = 6
    //  - OPTION_CURRENT_PACE = 7
    //  - OPTION_CURRENT_SPEED = 8
    //  - OPTION_AVERAGE_HEART_RATE = 9
    //  - OPTION_AVERAGE_PACE = 10
    //  - OPTION_AVERAGE_SPEED = 12
    //  - OPTION_CALORIES = 13
    //  - OPTION_CURRENT_CADENCE = 14
    //  - OPTION_ALTITUDE = 15
    //  - OPTION_TOTAL_ASCENT = 16
    //  - OPTION_TOTAL_DESCENT = 17
    //  - OPTION_CURRENT_BATTERY = 18
    //  - OPTION_CURRENT_LOCATION_ACCURACY = 19
    //  - OPTION_CURRENT_LOCATION_ACCURACY_AND_BATTERY = 20
    //  - OPTION_ETA_5K = 21
    //  - OPTION_ETA_10K = 22
    //  - OPTION_ETA_HALF_MARATHON = 23
    //  - OPTION_ETA_MARATHON = 24
    //  - OPTION_CURRENT_LAP_TIME = 25
    //  - OPTION_CURRENT_LAP_DISTANCE = 26
    //  - OPTION_CURRENT_LAP_PACE = 27
    //  - OPTION_TRAINING_EFFECT = 28
    //  - OPTION_TIMER_TIME_ON_PREVIOUS_LAP = 30
    //  - OPTION_ETA_LAP = 31
    //  - OPTION_LAP_COUNT = 32
    v1 = getParameter("Area1", 6 /* OPTION_CURRENT_HEART_RATE */);
    v2 = getParameter("Area2", 21 /* OPTION_ETA_5K */);
    v3 = getParameter("Area3", 0 /* OPTION_EMPTY */);
    v4 = getParameter("Area4", 7 /* OPTION_CURRENT_PACE */);
    v5 = getParameter("Area5", 5 /* OPTION_ELAPSED_DISTANCE */);
    v6 = getParameter("Area6", 14 /* OPTION_CURRENT_CADENCE */);
    v7 = getParameter("Area7", 10 /* OPTION_AVERAGE_PACE */);
    v8 = getParameter("Area8", 2 /* OPTION_TIMER_TIME */);
    v9 = getParameter("Area9", 1 /* OPTION_CURRENT_TIME */);
    v10 = getParameter("Area10", 20 /* OPTION_CURRENT_LOCATION_ACCURACY_AND_BATTERY */);
    
    hrZones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_RUNNING);
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
    
    assignAreaValues(v1area, 0, 0, deviceWidth, y1);
    configureAreaDimension(columnWidthRatio1, v2, v3, v4, v2area, v3area, v4area, y1, height);
    configureAreaDimension(columnWidthRatio2, v5, v6, v7, v5area, v6area, v7area, y2, height);
    configureAreaDimension("1,1", v8, v9, 0, v8area, v9area, null, y3, y4 - y3);
    assignAreaValues(v10area, 0, y4, deviceWidth, deviceHeight - y4);

    // Move empty area to the top
    if ( (v8 == 0 /* OPTION_EMPTY */) && (v9 == 0 /* OPTION_EMPTY */) ) {
      v8area[2] = deviceWidth;
      v8 = v10;
      v10 = 0 /* OPTION_EMPTY */;
    }
    
    if (v10 == 0 /* OPTION_EMPTY */) {
      height = deviceHeight - y3 - 10;  // Remove last 10 pixels from the bottom of the screen (Not enough width)
      v8area[3] = height;
      v9area[3] = height;
    }
    
    // Set default values
    v1data = initDataVariables(v1);
    v2data = initDataVariables(v2);
    v3data = initDataVariables(v3);
    v4data = initDataVariables(v4);
    v5data = initDataVariables(v5);
    v6data = initDataVariables(v6);
    v7data = initDataVariables(v7);
    v8data = initDataVariables(v8);
    v9data = initDataVariables(v9);
    v10data = initDataVariables(v10);
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
    
    startDistanceCurrentLap = convertUnitIfRequired((info.elapsedDistance + distanceOffset) / 1000, 0.62137119 /* CONVERSION_KM_TO_MILE */, isDistanceUnitsImperial); 
  }
  
  
  function onWorkoutStepComplete()
  {
    onTimerLap();
  }
  
  
  function configureID(id, selectedOption)
  {
    if (id == 1) { v1 = selectedOption; }
    else if (id == 2) { v2 = selectedOption; }
    else if (id == 3) { v3 = selectedOption; }
    else if (id == 4) { v4 = selectedOption; }
    else if (id == 5) { v5 = selectedOption; }
    else if (id == 6) { v6 = selectedOption; }
    else if (id == 7) { v7 = selectedOption; }
    else if (id == 8) { v8 = selectedOption; }
    else if (id == 9) { v9 = selectedOption; }
    else if (id == 10) { v10 = selectedOption; }
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
      if (lapDistance > 0 && distanceOffset != 0) { return (timer <= 0) ? 0 : convertUnitIfRequired(distance / timer * 3.6, 0.62137119 /* CONVERSION_KM_TO_MILE */, isPaceUnitsImperial); }
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
      return convertUnitIfRequired(info.altitude, 3.28084 /* CONVERSION_METER_TO_FEET */, isElevationUnitsImperial).toNumber();
    }
    
    // The total ascent during the current activity in meters (m)
    if ( (value == 16 /* OPTION_TOTAL_ASCENT */) && (info.totalAscent != null) )
    {
      return convertUnitIfRequired(info.totalAscent, 3.28084 /* CONVERSION_METER_TO_FEET */, isElevationUnitsImperial).toNumber();
    }

    // The total descent during the current activity in meters (m)
    if ( (value == 17 /* OPTION_TOTAL_DESCENT */) && (info.totalDescent != null) )
    {
      return convertUnitIfRequired(info.totalDescent, 3.28084 /* CONVERSION_METER_TO_FEET */, isElevationUnitsImperial).toNumber();
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
    
    if (value >= 21 /* OPTION_ETA_5K */ && value <= 24 /* OPTION_ETA_MARATHON */)
    {
      var etaGoalTable = [5000, 10000, 21097.5, 42195];
      var distanceMetric = convertUnitIfRequired(distance * 1000, 1.609344 /* CONVERSION_MILE_TO_KM */, isDistanceUnitsImperial);
      var remainingDistanceMetric = etaGoalTable[value - 21 /* OPTION_ETA_5K */] - distanceMetric;
      if (remainingDistanceMetric < 0) {
        if (value < 24 /* OPTION_ETA_MARATHON */) { configureID(id, value + 1); }
        else { return valueData; }
      }

      var avgSpeedMetric = 0;
      if (lapDistance > 0 && distanceOffset != 0)
      {
        if (timer > 0) { avgSpeedMetric = distanceMetric / timer; }
      }
      
      else if (info.averageSpeed != null)
      {
        avgSpeedMetric = info.averageSpeed;
      }
      
      if (avgSpeedMetric <= 0) { return valueData; }
      return timer + (remainingDistanceMetric / avgSpeedMetric);
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
    
    if (value == 29 /* OPTION_CORRECTED_DISTANCE */)
    {
      return distanceOffset;
    }
    
    // Time taken on previous km or mile
    if (value == 30 /* OPTION_TIMER_TIME_ON_PREVIOUS_LAP */) 
    {
      return timerLastLap;
    }
    
    if (value == 31 /* OPTION_ETA_LAP */)
    {
      //System.println("!!!! VALIDER SI FONCTIONNEL EN MILE VS KM");
      if (lapDistance <= 0 || timer <= 0) { return 0; }
      
      var distanceMetric = convertUnitIfRequired(distance * 1000, 1.609344 /* CONVERSION_MILE_TO_KM */, isDistanceUnitsImperial);
      var startDistanceCurrentLapMetric = convertUnitIfRequired(startDistanceCurrentLap * 1000, 1.609344 /* CONVERSION_MILE_TO_KM */, isDistanceUnitsImperial);
      
      var distanceCurrentLap = distanceMetric - startDistanceCurrentLapMetric;
      var remainingLapDistance = lapDistance - distanceCurrentLap;
      //System.println("distance: " + distance + ", distanceMetric: " + distanceMetric + ", startDistanceCurrentLapMetric: " + startDistanceCurrentLapMetric + ", lapDistance: " + lapDistance + ", distanceCurrentLap: " + distanceCurrentLap);
      //if (distanceCurrentLap <= 0 || remainingLapDistance <= 0) { return valueData; }
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
      distance = convertUnitIfRequired((info.elapsedDistance + distanceOffset) / 1000, 0.62137119 /* CONVERSION_KM_TO_MILE */, isDistanceUnitsImperial);
    }

    v1data = computeValue(info, 1, v1, v1data);
    v2data = computeValue(info, 2, v2, v2data);
    v3data = computeValue(info, 3, v3, v3data);
    v4data = computeValue(info, 4, v4, v4data);
    v5data = computeValue(info, 5, v5, v5data);
    v6data = computeValue(info, 6, v6, v6data);
    v7data = computeValue(info, 7, v7, v7data);
    v8data = computeValue(info, 8, v8, v8data);
    v9data = computeValue(info, 9, v9, v9data);
    v10data = computeValue(info, 10, v10, v10data);
  }
  
  
  // Display the value you computed here. This will be called
  // once a second when the data field is visible.
  function onUpdate(dc)
  {
    // Set colors
    if (DataField.getBackgroundColor() != color2)
    {
      var tempColor = color1;
      color1 = color2;
      color2 = tempColor;
      
      tempColor = colorBorder;
      colorBorder = colorHeader;
      colorHeader = tempColor;
    }
    
    // Inverse background for row 4 and 5
    if (singleBackgroundColor == false)
    {
      dc.setColor(color1, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(v8area[0], v8area[1], deviceWidth, deviceHeight);
    } 
    
    // Display Area
    displayArea(dc, 1, v1, v1data, v1area);
    displayArea(dc, 2, v2, v2data, v2area);
    displayArea(dc, 3, v3, v3data, v3area);
    displayArea(dc, 4, v4, v4data, v4area);
    displayArea(dc, 5, v5, v5data, v5area);
    displayArea(dc, 6, v6, v6data, v6area);
    displayArea(dc, 7, v7, v7data, v7area);
    displayArea(dc, 8, v8, v8data, v8area);
    displayArea(dc, 9, v9, v9data, v9area);
    displayArea(dc, 10, v10, v10data, v10area);
    
    if ( (v8 != 0 /* OPTION_EMPTY */) && (v9 != 0 /* OPTION_EMPTY */) )
    {
      dc.setPenWidth(3);
      if (singleBackgroundColor) { dc.setColor(color1, Graphics.COLOR_TRANSPARENT); }
      else { dc.setColor(color2, Graphics.COLOR_TRANSPARENT); }
      dc.drawLine(v8area[2], v8area[1] + 5, v8area[2], v8area[1] + v8area[3] - 5);
      dc.setPenWidth(1);
    }
    
    // Display lines
    dc.setColor(colorBorder, Graphics.COLOR_TRANSPARENT);
    
    // Display horizontal lines
    dc.setPenWidth(2);
    drawHorizontalLine(dc, v2area[1]);
    drawHorizontalLine(dc, v5area[1]);
    drawHorizontalLine(dc, v8area[1]);
    
    // Display vertical lines
    drawVerticalLine(dc, v3, v3area);
    drawVerticalLine(dc, v4, v4area);
    drawVerticalLine(dc, v6, v6area);
    drawVerticalLine(dc, v7, v7area);
    
    dc.setPenWidth(1);
    var headerY = (headerPosition == 3) ? v2area[1] + v2area[3] - headerHeight : v2area[1] + headerHeight;
    drawHorizontalLine(dc, headerY);
    headerY = (headerPosition == 2) ? v5area[1] + v5area[3] - headerHeight : v5area[1] + headerHeight;
    drawHorizontalLine(dc, headerY);

  }
  
  function drawHorizontalLine(dc, y)
  {
    dc.drawLine(0, y, deviceWidth, y);
  }
  
  function drawVerticalLine(dc, type, valueArea)
  {
    if (type != 0 /* OPTION_EMPTY */) { dc.drawLine(valueArea[0], valueArea[1], valueArea[0], valueArea[1] + valueArea[3]); }
  }

  
  function displayArea(dc, id, type, value, valueArea)
  {
    if (type == 0 /* OPTION_EMPTY */) { return; }
    var color = getColor(type, value);
    
    var areaX = valueArea[0];
    var areaY = valueArea[1];
    var areaWidth = valueArea[2];
    var areaHeight = valueArea[3];
    var areaXcenter = areaX + (areaWidth / 2);
  
    // Set Header values, except for Area 1, 8 and 9
    if ( (id >= 2) && (id <= 7) && (headerHeight > 0) )
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
      var bgColor = (dynamicHeaderColor && (color != null)) ? color : colorHeader;
      dc.setColor(bgColor, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(areaX, headerY, areaWidth, headerHeight);
      
      // Header Text
      var textColor = (dynamicHeaderColor && (color != null)) ? Graphics.COLOR_WHITE : color1;
      dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
      dc.setClip(areaX + leftOffsetX, headerY, areaWidth - leftOffsetX - rightOffsetX, headerHeight);
      dc.drawText(headerXcenter, headerYcenter, fontHeader, getHeaderName(type), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);      
      dc.clearClip();
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
    
    dc.setClip(areaX + leftOffsetX, areaY, areaWidth - leftOffsetX - rightOffsetX, areaHeight);
    
    if (type == 25 /* OPTION_CURRENT_LAP_TIME = 25 */)
    {
      var distanceMetric = convertUnitIfRequired(distance * 1000, 1.609344 /* CONVERSION_MILE_TO_KM */, isDistanceUnitsImperial);
      var startDistanceCurrentLapMetric = convertUnitIfRequired(startDistanceCurrentLap * 1000, 1.609344 /* CONVERSION_MILE_TO_KM */, isDistanceUnitsImperial);
      var lapPercenrage = (distanceMetric - startDistanceCurrentLapMetric) / lapDistance;
      
      dc.setColor(0x00AA00, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(areaX + leftOffsetX, areaY, (areaWidth - leftOffsetX - rightOffsetX) * lapPercenrage, areaHeight);
    }
    
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
      if (dynamicForegroundColor && (color != null)) { dc.setColor(color, Graphics.COLOR_TRANSPARENT); }
      else if (id < 8 || singleBackgroundColor) { dc.setColor(color1, Graphics.COLOR_TRANSPARENT); }
      else { dc.setColor(color2, Graphics.COLOR_TRANSPARENT); }
    
      var formattedValue = getFormattedValue(id, type, value);
      // Display HR icon if in Area 1, 8 or 9
      if ( ((type == 6 /* OPTION_CURRENT_HEART_RATE */) || (type == 9 /* OPTION_AVERAGE_HEART_RATE */)) && ((id == 1) || (id >= 8)) )
      {
        var iconWidth = 24; //dc.getTextWidthInPixels("0", fontIcons);
        var font = getFont(dc, type, formattedValue, areaWidth - leftOffsetX - rightOffsetX - (iconWidth * 1.5), areaHeight);
        var textWidth = (iconWidth / 2) + dc.getTextWidthInPixels(formattedValue, font);
        
        // Always display HR icon in color
        if (color != null) { dc.setColor(color, Graphics.COLOR_TRANSPARENT); }
        dc.drawText(areaXcenter - (textWidth / 2), areaYcenter, fontIcons, 0, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        if (dynamicForegroundColor && (color != null)) { dc.setColor(color, Graphics.COLOR_TRANSPARENT); }
        else if (id < 8 || singleBackgroundColor) { dc.setColor(color1, Graphics.COLOR_TRANSPARENT); }
        else { dc.setColor(color2, Graphics.COLOR_TRANSPARENT); }
        dc.drawText(areaXcenter + (iconWidth / 2), areaYcenter, font, formattedValue, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
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
    if (type == 21 /* OPTION_ETA_5K */) { return "ETA 5K"; }
    if (type == 22 /* OPTION_ETA_10K */) { return "ETA 10K"; }
    if (type == 23 /* OPTION_ETA_HALF_MARATHON */) { return "ETA 21K"; }
    if (type == 24 /* OPTION_ETA_MARATHON */) { return "ETA 42K"; }
    if (type == 25 /* OPTION_CURRENT_LAP_TIME */) { return "LTIME"; }
    if (type == 26 /* OPTION_CURRENT_LAP_DISTANCE */) { return "LDIST"; }
    if (type == 27 /* OPTION_CURRENT_LAP_PACE */) { return "LPACE"; }
    if (type == 28 /* OPTION_TRAINING_EFFECT */) { return "TE"; }
    if (type == 29 /* OPTION_CORRECTED_DISTANCE */) { return "+/-"; }
    if (type == 30 /* OPTION_TIMER_TIME_ON_PREVIOUS_LAP */) { return "LAST LAP"; }
    if (type == 31 /* OPTION_ETA_LAP */) { return "ETA LAP"; }
    if (type == 32 /* OPTION_LAP_COUNT */) { return "LAP"; }
    
    return "";
  }
  
  
  function getHour(h)
  {
    if (System.getDeviceSettings().is24Hour) { return h; }
    if (h > 12) { return h - 12; }
    return h;
  }
  
  
  function getFormattedValue(id, type, value)
  {
    if (type == 0 /* OPTION_EMPTY */)
    {
      return "";
    }
    
    if (type == 1 /* OPTION_CURRENT_TIME */)
    {
      return getHour(value.hour) + "h" + value.min.format("%02d");
    }
    
    if (type == 7 /* OPTION_CURRENT_PACE */ ||
        type == 10 /* OPTION_AVERAGE_PACE */ ||
        type == 27 /* OPTION_CURRENT_LAP_PACE */ ||
        type ==  30 /* OPTION_TIMER_TIME_ON_PREVIOUS_LAP */)
    {
      return formatDuration(Math.round(value), false);
    }
    
    if (type == 2 /* OPTION_TIMER_TIME */ ||
        type == 21 /* OPTION_ETA_5K */ ||
        type == 22 /* OPTION_ETA_10K */ ||
        type == 23 /* OPTION_ETA_HALF_MARATHON */ ||
        type == 24 /* OPTION_ETA_MARATHON */ ||
        type == 25 /* OPTION_CURRENT_LAP_TIME */ ||
        type == 31 /* OPTION_ETA_LAP */)
    {
      return formatDuration(Math.round(value), true);
    }

    if (value instanceof Float) { return formatFloat(value); }
    return value.toString();
  }
  
  
  function getFont(dc, type, value, maxWidth, maxHeight)
  {
    var fontID = Graphics.FONT_NUMBER_THAI_HOT;
    var textDimension;
    if (type == 1 /* OPTION_CURRENT_TIME */ || type == 35 /* OPTION_CURRENT_LOCATION */) { fontID = Graphics.FONT_LARGE; }
    
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
      if (value < hrZones[1]) { return null; } // Black
      else if (value < hrZones[2]) { return 0x00AAFF; } // Blue
      else if (value < hrZones[3]) { return 0x00AA00; } // Green
      else if (value < hrZones[4]) { return 0xFF5500; } // Orange
      return 0xFF0000;                                  // Red
    }
  
    if (type == 7 /* OPTION_CURRENT_PACE */ ||
        type == 10 /* OPTION_AVERAGE_PACE */ ||
        type == 27 /* OPTION_CURRENT_LAP_PACE */)
    {
      if (value <= 0) { return null; }
      else if (value < minPace) { return Graphics.COLOR_BLUE; }
      else if (value > maxPace) { return Graphics.COLOR_RED; }
      return Graphics.COLOR_DK_GREEN;
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


  function formatFloat(f)
  {
    // Calling format("%.1f") will round the value. To truncate the value instead of rounding, we simply multiply by 10, convert to Integer and divide by 10.0 (Float).
    // Example: 4.48 --> (4.48 * 10).toNumber() = 44 / 10.0 = 4.4
    if (f < 10) { return ((f * 100).toNumber() / 100.0).format("%.2f"); }
    return ((f * 10).toNumber() / 10.0).format("%.1f");
  }
  
  
  function formatDuration(seconds, displayHour)
  {
    if (seconds instanceof String) { return seconds; } 
    seconds = seconds.toNumber();
    
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
    return hh > 0 ? hh + ":" + mm.format("%02d") + ":" + ss.format("%02d") : mm.format("%d") + ":" + ss.format("%02d");
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
    //var grayColor = (id >= 8) ? colorBorder : colorHeader;
    var grayColor = (id >= 8 && singleBackgroundColor == false) ? colorHeader : colorBorder;
    
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
    //else if (type == 21 /* OPTION_ETA_5K */) { return "OPTION_ETA_5K"; }
    //else if (type == 22 /* OPTION_ETA_10K */) { return "OPTION_ETA_10K"; }
    //else if (type == 23 /* OPTION_ETA_HALF_MARATHON */) { return "OPTION_ETA_HALF_MARATHON"; }
    //else if (type == 24 /* OPTION_ETA_MARATHON */) { return "OPTION_ETA_MARATHON"; }
    //else if (type == 25 /* OPTION_CURRENT_LAP_TIME */) { return "OPTION_CURRENT_LAP_TIME"; }
    //else if (type == 26 /* OPTION_CURRENT_LAP_DISTANCE */) { return "OPTION_CURRENT_LAP_DISTANCE"; }
    //else if (type == 27 /* OPTION_CURRENT_LAP_PACE */) { return "OPTION_CURRENT_LAP_PACE"; }
    //else if (type == 28 /* OPTION_TRAINING_EFFECT */) { return "OPTION_TRAINING_EFFECT"; }
    //else if (type == 29 /* OPTION_CORRECTED_DISTANCE */) { return "OPTION_CORRECTED_DISTANCE"; }
    //else if (type == 30 /* OPTION_TIMER_TIME_ON_PREVIOUS_LAP */) { return "OPTION_TIMER_TIME_ON_PREVIOUS_LAP"; }
    //else if (type == 31 /* OPTION_ETA_LAP */) { return "OPTION_ETA_LAP"; }
    //else if (type == 32 /* OPTION_LAP_COUNT */) { return "OPTION_LAP_COUNT"; }
    //
    //return type;
  //}
}