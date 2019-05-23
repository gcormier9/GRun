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
  // Integer indicating the current km or mile. For example, if the distance currently traveled is 3.25 km, the variable will be equal to 3.
  protected var currentKM = 0;
  // Time taken on previous km or mile
  protected var timerLastKM = 0;
  // Exact time when "currentKM" was last changed
  protected var startTimerCurrentKM = 0;
  // Distance reset every km or mile
  protected var distanceOnCurrentKM = 0;
  
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
  // Header Height - Set to 0 to hide headers
  protected var headerHeight;
  // By default, the layout has 3 columns with the same width. middleColumnPercentageSize is used to reduce or enlarge the middle column.
  // middleColumnPercentageSize value must be between 0 and 100. It's a percentage value. If the value = 150, the width will be 150% larger.
  // If the value = 50, the width wil be 50% smaller. This can be useful to set value with format like 00:00 and the left/right and
  // keep decimal values (Example: Cadence) in the middle
  protected var middleColumnPercentageSize;
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
  // hXarea indicates the x/y coordonate of the Header area while vXarea indicates the x/y coordonate of the Value area
  protected var v1area, h2area, v2area, h3area, v3area, h4area, v4area, h5area, v5area, h6area, v6area, h7area, v7area, v8area, v9area, v10area;
  
  // Adjust text vertical position for specific device model
  protected var yOffset = 0;
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
  
  protected var imgGPS = WatchUi.loadResource(Rez.Drawables.GPS0);
  
  // In order to use less memory, numbers have been hardcoded instead of using enum..
  // This makes code less readable, but is required since memory on Garmin watch is very limited
  //enum {
  /*
    OPTION_EMPTY = 0,
    OPTION_CURRENT_TIME = 1,
    OPTION_TIMER_TIME = 2,
    OPTION_TIMER_TIME_ON_CURRENT_KM_OR_MILE = 3,
    OPTION_TIMER_TIME_ON_PREVIOUS_KM_OR_MILE = 4,
    OPTION_ELAPSED_DISTANCE = 5,
    OPTION_CURRENT_HEART_RATE = 6,
    OPTION_CURRENT_PACE = 7,
    OPTION_CURRENT_SPEED = 8,
    OPTION_AVERAGE_HEART_RATE = 9,
    OPTION_AVERAGE_PACE = 10,
    OPTION_AVERAGE_PACE_MANUAL_CALC = 11,
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
    OPTION_TRAINING_EFFECT = 28
    */
    /* Options below this line can be uncommented if someone required the functionnality
    OPTION_AMBIENT_PRESSURE = 29,
    OPTION_AVERAGE_CADENCE = 30,
    OPTION_AVERAGE_DISTANCE = 31,
    OPTION_AVERAGE_POWER = 32,
    OPTION_BEARING = 33,
    OPTION_BEARING_FROM_START = 34,
    OPTION_CURRENT_HEADING = 35,
    OPTION_CURRENT_LOCATION = 36,
    OPTION_CURRENT_POWER = 37,
    OPTION_DISTANCE_TO_DESTINATION = 38,
    OPTION_DISTANCE_TO_NEXT_POINT = 39,
    OPTION_ELAPSED_TIME = 40,
    OPTION_ELEVATION_AT_DESTINATION = 41,
    OPTION_ELEVATION_AT_NEXT_POINT = 42,
    OPTION_ENERGY_EXPENDITURE = 43,
    OPTION_FRONT_DERAILLEUR_INDEX = 44,
    OPTION_FRONT_DERAILLEUR_MAX = 45,
    OPTION_FRONT_DERAILLEUR_SIZE = 46,
    OPTION_MAX_CADENCE = 47,
    OPTION_MAX_HEART_RATE = 48,
    OPTION_MAX_POWER = 49,
    OPTION_MAX_SPEED = 50,
    OPTION_MEAN_SEA_LEVEL_PRESSURE = 51,
    OPTION_NAME_OF_DESTINATION = 52,
    OPTION_NAME_OF_NEXT_POINT = 53,
    OPTION_OFF_COURSE_DISTANCE = 54,
    OPTION_RAW_AMBIENT_PRESSURE = 55,
    OPTION_REAR_DERAILLEUR_INDEX = 56,
    OPTION_REAR_DERAILLEUR_MAX = 57,
    OPTION_REAR_DERAILLEUR_SIZE = 58,
    OPTION_START_LOCATION = 59,
    OPTION_START_TIME = 60,
    OPTION_SWIM_STROKE_TYPE = 61,
    OPTION_SWIM_SWOLF = 62,
    OPTION_TIMER_STATE = 63,
    OPTION_TRACK = 64
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
  

  function initializeUserData()
  {
    var deviceSettings = System.getDeviceSettings();
    isPaceUnitsImperial = (deviceSettings.paceUnits == System.UNIT_STATUTE);
    isDistanceUnitsImperial = (deviceSettings.distanceUnits == System.UNIT_STATUTE);
    isElevationUnitsImperial = (deviceSettings.elevationUnits == System.UNIT_STATUTE);
  
    headerPosition = getParameter("HeaderPosition", 1);
    headerHeight = getParameter("HeaderHeight", 22);
    middleColumnPercentageSize = getParameter("MiddleColumnPercentageSize", 75);
    
    dynamicHeaderColor = getParameter("HeaderBackgroundColor", true);
    dynamicForegroundColor = getParameter("DataForegroundColor", false);
    
    lapDistance = getParameter("LapDistance", 1000).toNumber();

    minPace = getParameter("MinPace", isPaceUnitsImperial ? 510 : 315).toNumber();
    maxPace = getParameter("MaxPace", isPaceUnitsImperial ? 555 : 345).toNumber();
        
    // Select which values are displayed in each area
    // Value must be selected according to the enum
    // The following options are currently supported:
    //  - OPTION_EMPTY = 0
    //  - OPTION_CURRENT_TIME = 1
    //  - OPTION_TIMER_TIME = 2
    //  - OPTION_TIMER_TIME_ON_CURRENT_KM_OR_MILE = 3
    //  - OPTION_TIMER_TIME_ON_PREVIOUS_KM_OR_MILE = 4
    //  - OPTION_ELAPSED_DISTANCE = 5
    //  - OPTION_CURRENT_HEART_RATE = 6
    //  - OPTION_CURRENT_PACE = 7
    //  - OPTION_CURRENT_SPEED = 8
    //  - OPTION_AVERAGE_HEART_RATE = 9
    //  - OPTION_AVERAGE_PACE = 10
    //  - OPTION_AVERAGE_PACE_MANUAL_CALC = 11
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
    v1 = getParameter("Area1", 6 /* OPTION_CURRENT_HEART_RATE */);
    v2 = getParameter("Area2", 4 /* OPTION_TIMER_TIME_ON_PREVIOUS_KM_OR_MILE */);
    v3 = getParameter("Area3", 14 /* OPTION_CURRENT_CADENCE */);
    v4 = getParameter("Area4", 7 /* OPTION_CURRENT_PACE */);
    v5 = getParameter("Area5", 5 /* OPTION_ELAPSED_DISTANCE */);
    v6 = getParameter("Area6", 15 /* OPTION_ALTITUDE */);
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
    
    var columnWidth = deviceWidth / 3;
    var shrinkValue = (1 - (middleColumnPercentageSize.toFloat() / 100)) * columnWidth / 2;
    
    var x1 = 0;
    var x2 = columnWidth + shrinkValue;
    var x3 = (columnWidth * 2) - shrinkValue;
    
    var deviceHeaderHeight = deviceHeight * headerHeight/240;
    var deviceValueHeight = deviceHeight * (70 - headerHeight)/240;
    
    var y1 = deviceHeight / 6;      // 40 px
    var y2 = deviceHeight * 11/24;  // 110 px
    var y3 = deviceHeight * 3/4;    // 180 px
    var y4 = deviceHeight * 7/8;    // 210 px
    
    var columnWidth2 = columnWidth + shrinkValue;
    var columnWidth3 = columnWidth - (2 * shrinkValue);
    var y1h = y1 + deviceHeaderHeight;
    var y2h = y2 + deviceHeaderHeight;
    
    v1area = [ x1, 0, deviceWidth, y1 ];
    
    h2area = [ x1, y1, columnWidth2, deviceHeaderHeight ];
    v2area = [ x1, y1h, columnWidth2, deviceValueHeight ];
    
    h3area = [ x2, y1, columnWidth3, deviceHeaderHeight ];
    v3area = [ x2, y1h, columnWidth3, deviceValueHeight ];
    
    h4area = [ x3, y1, columnWidth2, deviceHeaderHeight ];
    v4area = [ x3, y1h, columnWidth2, deviceValueHeight ];
    
    h5area = [ x1, y2, columnWidth2, deviceHeaderHeight ];
    v5area = [ x1, y2h, columnWidth2, deviceValueHeight ];
    
    h6area = [ x2, y2, columnWidth3, deviceHeaderHeight ];
    v6area = [ x2, y2h, columnWidth3, deviceValueHeight ];
    
    h7area = [ x3, y2, columnWidth2, deviceHeaderHeight ];
    v7area = [ x3, y2h, columnWidth2, deviceValueHeight ];
    
    v8area = [ x1, y3, deviceWidth / 2, y4 - y3 ];
    v9area = [ x1 + (deviceWidth / 2), y3, deviceWidth / 2, y4 - y3 ];
    
    v10area = [ x1, y4, deviceWidth, deviceHeight - y4 ];

    if (headerPosition == 2)
    {
      y2h = y2 + deviceValueHeight;
      h5area[1] = y2h;
      v5area[1] = y2;
      
      h6area[1] = y2h;
      v6area[1] = y2;
      
      h7area[1] = y2h;
      v7area[1] = y2;
    }

    else if (headerPosition == 3)
    {
      y1h = y1 + deviceValueHeight;
      h2area[1] = y1h;
      v2area[1] = y1;
      
      h3area[1] = y1h;
      v3area[1] = y1;
      
      h4area[1] = y1h;
      v4area[1] = y1;
    }

    // Move empty area to the top
    if ( (v8 == 0 /* OPTION_EMPTY */) && (v9 == 0 /* OPTION_EMPTY */) ) {
      v8 = v10;
      v10 = 0 /* OPTION_EMPTY */;
    }
    
    if (v10 == 0 /* OPTION_EMPTY */) {
      v8area[3] = deviceHeight - y3 - 10; // Remove last 10 pixels from the bottom of the screen (Not enough width)
      v9area[3] = deviceHeight - y3 - 10; // Remove last 10 pixels from the bottom of the screen (Not enough width)
    }
        
    // Merge area if not defined
    var mergeArray = mergeArea(v2, v3, v4, h2area, v2area, h3area, v3area, h4area, v4area);
    v2 = mergeArray[0];
    v3 = mergeArray[1];
    v4 = mergeArray[2];
    
    mergeArray = mergeArea(v5, v6, v7, h5area, v5area, h6area, v6area, h7area, v7area);
    v5 = mergeArray[0];
    v6 = mergeArray[1];
    v7 = mergeArray[2];
    
    mergeArray = mergeArea(v8, v9, null, null, v8area, null, v9area, null, null);
    v8 = mergeArray[0];
    v9 = mergeArray[1];
    
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
  
 
  function initialize(yOffset)
  {
    DataField.initialize();
    initializeUserData();
  }
  
  
  function mergeArea(v1, v2, v3, h1area, v1area, h2area, v2area, h3area, v3area)
  {
    if ( (v1 == 0 /* OPTION_EMPTY */) && (v2 == 0 /* OPTION_EMPTY */) && (v3 == 0 /* OPTION_EMPTY */) )
    {
      return [ 0 /* OPTION_EMPTY */, 0 /* OPTION_EMPTY */, 0 /* OPTION_EMPTY */ ];
    }
    
    // Move empty area  to the right
    if (v1 == 0 /* OPTION_EMPTY */)
    {
      if (v2 != 0 /* OPTION_EMPTY */)
      {
        v1 = v2;
        v2 = 0 /* OPTION_EMPTY */;
      }
      
      else if (v3 != 0 /* OPTION_EMPTY */ && v3 != null) // v3 can be null for field v8,v9
      {
        v1 = v3;
        v3 = 0 /* OPTION_EMPTY */;
      }
    }
    
    if ( (v2 == 0 /* OPTION_EMPTY */) && (v3 != 0 /* OPTION_EMPTY */) && (v3 != null) ) // v3 can be null for field v8,v9
    {
      v2 = v3;
      v3 = 0 /* OPTION_EMPTY */;
    }
    
    if ( (v2 == 0 /* OPTION_EMPTY */) && ((v3 == 0 /* OPTION_EMPTY */) || (v3 == null)) )
    {
      if (h1area != null) { h1area[2] = deviceWidth; } // if mergeArea() is called for Area 8 and 9 (only 2 fields without Headers)
      v1area[2] = deviceWidth;
    }
    
    else if (v3 == 0 /* OPTION_EMPTY */)
    {
      if (h1area != null) { // if mergeArea() is called for Area 8 and 9 (only 2 fields without Headers)
        h2area[0] = deviceWidth / 2;
        v2area[0] = deviceWidth / 2;
        
        h1area[2] = deviceWidth / 2;
        v1area[2] = deviceWidth / 2;
        h2area[2] = deviceWidth / 2;
        v2area[2] = deviceWidth / 2;
      }
    }
    
    return [v1, v2, v3];
  }
  
  
  // A lap event has occurred.
  // This method is called when a lap is added to the current activity. A notification is triggered after the lap record has been written to the FIT file.
  function onTimerLap()
  {
    var distanceMetric = convertUnitIfRequired(distance * 1000, 1.609344 /* CONVERSION_MILE_TO_KM */, isDistanceUnitsImperial);
    var uncorrectedDistanceMetric = distanceMetric - distanceOffset;
    
    if (lapDistance > 0)
    {
      var diff = distanceMetric.toNumber() % lapDistance;
      diff += distanceMetric - Math.floor(distanceMetric); // Add decimal parts
      
      if (diff < (lapDistance / 2)) { distanceOffset -= diff; } // Distance higher than expected
      else { distanceOffset += (lapDistance - diff); }          // Distance lower than expected
    }
    
    startTimerCurrentLap = timer;
    startDistanceCurrentLap = convertUnitIfRequired((uncorrectedDistanceMetric + distanceOffset) / 1000, 0.62137119 /* CONVERSION_KM_TO_MILE */, isDistanceUnitsImperial); 
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
    
    // Calculate fields used by other options
    if ( (value == 3 /* OPTION_TIMER_TIME_ON_CURRENT_KM_OR_MILE */) || (value == 4 /* OPTION_TIMER_TIME_ON_PREVIOUS_KM_OR_MILE */) ) 
    {
      if (currentKM != Math.floor(distance))
      {
        timerLastKM = timer - startTimerCurrentKM;  // Time taken on last km or mile
        currentKM = Math.floor(distance);
        startTimerCurrentKM = timer;
      }
      
      distanceOnCurrentKM = distance - Math.floor(distance);
    }
    
    // Elapsed time for the current km or mile
    if (value == 3 /* OPTION_TIMER_TIME_ON_CURRENT_KM_OR_MILE */)
    {
      return (timer - startTimerCurrentKM);
    }
    
    // Time taken on previous km or mile
    if (value == 4 /* OPTION_TIMER_TIME_ON_PREVIOUS_KM_OR_MILE */) 
    {
      return timerLastKM;
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
    
    // Average pace in second per kilometer (Calculated mnually using timer/distance)
    if (value == 11 /* OPTION_AVERAGE_PACE_MANUAL_CALC */)
    {
      return (distance <= 0) ? 0 : timer / distance;
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
    
    //if (value == 21 /* OPTION_ETA_5K */ || value == 22 /* OPTION_ETA_10K */ || value == 23 /* OPTION_ETA_HALF_MARATHON */ || value == 24 /* OPTION_ETA_MARATHON */)
    if (value >= 21 /* OPTION_ETA_5K */ && value <= 24 /* OPTION_ETA_MARATHON */)
    {
      var etaGoalTable = [5000, 10000, 21097.5, 42195];
      //var distanceMetric = distance * 1000 / (isDistanceUnitsImperial ? 0.62137119 /* CONVERSION_KM_TO_MILE */ : 1);
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
      var lapTimer = timer - startTimerCurrentLap;
      var localLapDistance = distance - startDistanceCurrentLap;
      
      if (localLapDistance <= 0) { return 0; }
      return lapTimer / localLapDistance;
    }
    
    // The Training Effect score of the current activity
    if ( (value == 28 /* OPTION_TRAINING_EFFECT */) && (info.trainingEffect != null) )
    {
      return info.trainingEffect;
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
      if (DataField.getBackgroundColor() == Graphics.COLOR_BLACK)
      {
        color1 = Graphics.COLOR_WHITE;
        color2 = Graphics.COLOR_BLACK;
        colorBorder = Graphics.COLOR_LT_GRAY;
        colorHeader = Graphics.COLOR_DK_GRAY;
      }
    
      else {
        color1 = Graphics.COLOR_BLACK;
        color2 = Graphics.COLOR_WHITE;
        colorBorder = Graphics.COLOR_DK_GRAY;
        colorHeader = Graphics.COLOR_LT_GRAY;
      }
    }
    
    // Display Area
    displayArea(dc, 1, v1, v1data, null, v1area);
    displayArea(dc, 2, v2, v2data, h2area, v2area);
    displayArea(dc, 3, v3, v3data, h3area, v3area);
    displayArea(dc, 4, v4, v4data, h4area, v4area);
    displayArea(dc, 5, v5, v5data, h5area, v5area);
    displayArea(dc, 6, v6, v6data, h6area, v6area);
    displayArea(dc, 7, v7, v7data, h7area, v7area);
    displayArea(dc, 8, v8, v8data, null, v8area);
    displayArea(dc, 9, v9, v9data, null, v9area);
    displayArea(dc, 10, v10, v10data, null, v10area);
    
    if ( (v8 != 0 /* OPTION_EMPTY */) && (v9 != 0 /* OPTION_EMPTY */) )
    {
      dc.setPenWidth(3);
      dc.setColor(color2, Graphics.COLOR_TRANSPARENT);
      dc.drawLine(v8area[2], v8area[1] + 5, v8area[2], v8area[1] + v8area[3] - 5);
      dc.setPenWidth(1);
    }
    
    // Display horizontal lines
    dc.setColor(colorBorder, Graphics.COLOR_TRANSPARENT);
    dc.drawLine(0, h2area[1], deviceWidth, h2area[1]);
    dc.drawLine(0, h5area[1], deviceWidth, h5area[1]);
    dc.drawLine(0, v8area[1], deviceWidth, v8area[1]);
    dc.drawLine(0, v2area[1], deviceWidth, v2area[1]);
    dc.drawLine(0, v5area[1], deviceWidth, v5area[1]);
  }
  
  
  function displayArea(dc, id, type, value, headerArea, valueArea)
  {
    if (type == 0 /* OPTION_EMPTY */) { return; }
    var leftOffsetX = 0;
    var rightOffsetX = 0;
    var color = getColor(type, value);
  
    // Set Header values, except for Area 1, 8 and 9
    if ( (id >= 2) && (id <= 7) )
    {
      // Get coordinate of Header elements
      var headerX = headerArea[0] + (headerArea[2] / 2);
      var headerY = headerArea[1] + (headerArea[3] / 2);
      
      // Set Header background color
      if (dynamicHeaderColor && (color != null)) { dc.setColor(color, Graphics.COLOR_TRANSPARENT); }
      else { dc.setColor(colorHeader, Graphics.COLOR_TRANSPARENT); }
      dc.fillRectangle(headerArea[0], headerArea[1], headerArea[2], headerArea[3]);
      if (headerArea[0] > 0)
      {
        dc.setColor(colorBorder, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(headerArea[0], headerArea[1], headerArea[0], headerArea[1] + headerArea[3]);
      }
      
      // Set Header foreground color + text
      if (headerArea[0] == 0) { leftOffsetX = (deviceWidth - getWidth(headerY)) / 2; }
      if (headerArea[0] + headerArea[2] == deviceWidth) { rightOffsetX = (deviceWidth - getWidth(headerY)) / 2; }
      if ( (id == 2) || (id == 3) || (id == 5) || (id == 6) ) { rightOffsetX += 1; }
      if ( (id == 3) || (id == 4) || (id == 6) || (id == 7) ) { leftOffsetX += 2; }
      dc.setClip(headerArea[0] + leftOffsetX, headerArea[1], headerArea[2] - leftOffsetX - rightOffsetX, headerArea[3]);
      
      if (dynamicHeaderColor && (color != null)) { dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT); }
      else { dc.setColor(color1, Graphics.COLOR_TRANSPARENT); }
      dc.drawText(headerX + (leftOffsetX / 2) - (rightOffsetX / 2), headerY, Graphics.FONT_XTINY, getHeaderName(type), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      dc.clearClip();
    }
    
    // Get coordinate of Data elements
    var valueX = valueArea[0] + (valueArea[2] / 2);
    var valueY = valueArea[1] + (valueArea[3] / 2) ;
    if ( (id >= 2) && (id <= 7) ) { valueY -= 2; }
    if (id > 7) { valueY += yOffset; }
    //else if (id > 1) { valueY += yOffset; }
    
    // Set Data background color
    if (id < 8) { dc.setColor(color2, Graphics.COLOR_TRANSPARENT); } 
    else { dc.setColor(color1, Graphics.COLOR_TRANSPARENT); }
    if (v10 == 0 /* OPTION_EMPTY */) { dc.fillRectangle(valueArea[0], valueArea[1], valueArea[2], 240); } 
    else { dc.fillRectangle(valueArea[0], valueArea[1], valueArea[2], valueArea[3]); }
    
    if ( (valueArea[0] > 0) && (id >= 2) && (id <= 7) )
    {
      dc.setColor(colorBorder, Graphics.COLOR_TRANSPARENT);
      dc.drawLine(valueArea[0], valueArea[1], valueArea[0], valueArea[1] + valueArea[3]);
    }
    
    if (type == 3 /* OPTION_TIMER_TIME_ON_CURRENT_KM_OR_MILE */)
    {
      var y = valueY > (deviceHeight / 2) ? valueArea[1] : valueArea[1] + valueArea[3];
      if (valueArea[0] == 0) { leftOffsetX = (deviceWidth - getWidth(y)) / 2; }
      if (valueArea[0] + valueArea[2] == deviceWidth) { rightOffsetX = (deviceWidth - getWidth(y)) / 2; }
      
      dc.setColor(0x00AA00, Graphics.COLOR_TRANSPARENT);
      dc.fillRectangle(valueArea[0] + leftOffsetX, valueArea[1], (valueArea[2] - leftOffsetX - rightOffsetX) * distanceOnCurrentKM, valueArea[3]);
    }
    
    // Set Data values
    if (valueArea[0] == 0) { leftOffsetX = (deviceWidth - getWidth(valueY)) / 2; }
    if (valueArea[0] + valueArea[2] == deviceWidth) { rightOffsetX = (deviceWidth - getWidth(valueY)) / 2; }
    dc.setClip(valueArea[0] + leftOffsetX, valueArea[1], valueArea[2] - leftOffsetX - rightOffsetX, valueArea[3]);
    
    if (dynamicForegroundColor && (color != null)) { dc.setColor(color, Graphics.COLOR_TRANSPARENT); }
    else if (id < 8) { dc.setColor(color1, Graphics.COLOR_TRANSPARENT); }
    else { dc.setColor(color2, Graphics.COLOR_TRANSPARENT); }
    
    valueX += (leftOffsetX / 2) - (rightOffsetX / 2);
    
    if (type == 20 /* OPTION_CURRENT_LOCATION_ACCURACY_AND_BATTERY */)
    {
      valueY -= 2;
      //var gpsLength = 28 /* LENGTH_GPS_ICON */ + 6;
      dc.drawBitmap(valueX - 43, valueY - 11, imgGPS);
      drawBattery(dc, id, valueX + 17 /*(gpsLength / 2)*/, valueY);
    }
    
    else if (type == 19 /* OPTION_CURRENT_LOCATION_ACCURACY */)
    {
      valueY -= 2;
      dc.drawBitmap(valueX - 14, valueY - 11, imgGPS);
    }
    
    else if (type == 18 /* OPTION_CURRENT_BATTERY */)
    {
      valueY -= 2;
      drawBattery(dc, id, valueX, valueY);
    }
      
    else
    {
      var formattedValue = getFormattedValue(id, type, value);
      // Display HR icon if in Area 1, 8 or 9
      if ( (type == 6 /* OPTION_CURRENT_HEART_RATE */) && ((id == 1) || (id == 8) || (id == 9) || (id == 10)) )
      {
        var iconWidth = 24; //dc.getTextWidthInPixels("0", fontIcons);
        var font = getFont(dc, type, formattedValue, valueArea[2] - leftOffsetX - rightOffsetX - (iconWidth * 1.5), valueArea[3]);
        var textWidth = (iconWidth / 2) + dc.getTextWidthInPixels(formattedValue, font);
        
        // Always display HR icon in color
        if (color != null) { dc.setColor(color, Graphics.COLOR_TRANSPARENT); }
        dc.drawText(valueX - (textWidth / 2), valueY, fontIcons, 0, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        if (dynamicForegroundColor && (color != null)) { dc.setColor(color, Graphics.COLOR_TRANSPARENT); }
        else if (id < 8) { dc.setColor(color1, Graphics.COLOR_TRANSPARENT); }
        else { dc.setColor(color2, Graphics.COLOR_TRANSPARENT); }
        dc.drawText(valueX + (iconWidth / 2), valueY, font, formattedValue, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      }
      
      // Display regular field
      else
      {
        dc.drawText(valueX, valueY, getFont(dc, type, formattedValue, valueArea[2] - leftOffsetX - rightOffsetX, valueArea[3]), formattedValue, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      }
    }
    
    dc.clearClip();
  }
  
  
  function getHeaderName(type)
  {
    if (type == 1 /* OPTION_CURRENT_TIME */) { return "TIME"; }
    if (type == 2 /* OPTION_TIMER_TIME */) { return "TIMER"; }
    if (type == 3 /* OPTION_TIMER_TIME_ON_CURRENT_KM_OR_MILE */) { return (isDistanceUnitsImperial == true) ? "CUR MI" : "CUR KM"; }
    if (type == 4 /* OPTION_TIMER_TIME_ON_PREVIOUS_KM_OR_MILE */) { return (isDistanceUnitsImperial == true) ? "LAST MI" : "LAST KM"; }
    if (type == 5 /* OPTION_ELAPSED_DISTANCE */) { return "DIST"; }
    if (type == 6 /* OPTION_CURRENT_HEART_RATE */) { return "HR"; }
    if (type == 7 /* OPTION_CURRENT_PACE */) { return "PACE"; }
    if (type == 8 /* OPTION_CURRENT_SPEED */) { return "SPD"; }
    if (type == 9 /* OPTION_AVERAGE_HEART_RATE */) { return "A HR"; }
    if (type == 10 /* OPTION_AVERAGE_PACE */ || type == 11 /* OPTION_AVERAGE_PACE_MANUAL_CALC */) { return "A PACE"; }
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
    
    if (type == 3 /* OPTION_TIMER_TIME_ON_CURRENT_KM_OR_MILE */ ||
        type ==  4 /* OPTION_TIMER_TIME_ON_PREVIOUS_KM_OR_MILE */ ||
        type == 7 /* OPTION_CURRENT_PACE */ ||
        type == 10 /* OPTION_AVERAGE_PACE */ ||
        type == 11 /* OPTION_AVERAGE_PACE_MANUAL_CALC */ ||
        type == 27 /* OPTION_CURRENT_LAP_PACE */)
    {
      return formatDuration(value, false);
    }
    
    if (type == 2 /* OPTION_TIMER_TIME */ ||
        type == 21 /* OPTION_ETA_5K */ ||
        type == 22 /* OPTION_ETA_10K */ ||
        type == 23 /* OPTION_ETA_HALF_MARATHON */ ||
        type == 24 /* OPTION_ETA_MARATHON */ ||
        type == 25 /* OPTION_CURRENT_LAP_TIME */)
    {
      return formatDuration(value, true);
    }

    if (value instanceof Float) { return formatFloat(value); }
    return value.toString();
  }
  
  
  function getFont(dc, type, value, maxWidth, maxHeight)
  {
    var fontID = Graphics.FONT_NUMBER_THAI_HOT;
    var textDimension;
    if (type == 1 /* OPTION_CURRENT_TIME */ || type == 35 /* OPTION_CURRENT_LOCATION */) { fontID = Graphics.FONT_MEDIUM; }
    
    while (fontID > 0)
    {
      textDimension = dc.getTextDimensions(value, fontID);
      
      // No padding
      textDimension[1] = textDimension[1] - (2 * dc.getFontDescent(fontID));
      
      // Add 5% padding top + 5% padding bottom
      //textDimension[1] = textDimension[1] - 0.90 * (2 * dc.getFontDescent(fontID));
      
      if (textDimension[0] <= maxWidth && textDimension[1] <= maxHeight) { return fontID; }
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
        type == 11 /* OPTION_AVERAGE_PACE_MANUAL_CALC */ ||
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
    var grayColor = (id >= 8) ? colorHeader : colorBorder;
    
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
    //else if (type == 3 /* OPTION_TIMER_TIME_ON_CURRENT_KM_OR_MILE */) { return "OPTION_TIMER_TIME_ON_CURRENT_KM_OR_MILE"; }
    //else if (type == 4 /* OPTION_TIMER_TIME_ON_PREVIOUS_KM_OR_MILE */) { return "OPTION_TIMER_TIME_ON_PREVIOUS_KM_OR_MILE"; }
    //else if (type == 5 /* OPTION_ELAPSED_DISTANCE */) { return "OPTION_ELAPSED_DISTANCE"; }
    //else if (type == 6 /* OPTION_CURRENT_HEART_RATE */) { return "OPTION_CURRENT_HEART_RATE"; }
    //else if (type == 7 /* OPTION_CURRENT_PACE */) { return "OPTION_CURRENT_PACE"; }
    //else if (type == 8 /* OPTION_CURRENT_SPEED */) { return "OPTION_CURRENT_SPEED"; }
    //else if (type == 9 /* OPTION_AVERAGE_HEART_RATE */) { return "OPTION_AVERAGE_HEART_RATE"; }
    //else if (type == 10 /* OPTION_AVERAGE_PACE */) { return "OPTION_AVERAGE_PACE"; }
    //else if (type == 11 /* OPTION_AVERAGE_PACE_MANUAL_CALC */) { return "OPTION_AVERAGE_PACE_MANUAL_CALC"; }
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
    //
    //return type;
  //}
}