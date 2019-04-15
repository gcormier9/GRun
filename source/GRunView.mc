using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.UserProfile;

// In order to use less memory, numbers have been hardcoded instead of using const..
//const CONVERSION_KM_TO_MILE = 0.62137119;
//const CONVERSION_MILE_TO_KM = 1.609344;
//const CONVERSION_METER_TO_FEET = 3.28084;
//const LENGTH_GPS_ICON = 28;
//const LENGTH_BATTERY_ICON = 50;


class GRunView extends WatchUi.DataField
{
  // Array of the current heart rate zone threshold values in beats per minute (bpm)
  private var hrZones;
  // Elapsed Distance
  private var distance = 0.0;
  // Timer
  private var timer = 0;
  // Integer indicating the current km or mile. For example, if the distance currently traveled is 3.25 km, the variable will be equal to 3.
  private var currentKM = 0;
  // Time taken on previous km or mile
  private var timerLastKM = 0;
  // Exact time when "currentKM" was last changed
  private var startTimerCurrentKM = 0;
  // Distance reset every km or mile
  private var distanceOnCurrentKM = 0;
  
  // Exact time when lap has changed
  private var startTimerCurrentLap = 0;
  // Exact distance when lap has changed
  private var startDistanceCurrentLap = 0;
  
  // Display data in Metric or Imperial
  private var isPaceUnitsImperial;
  private var isDistanceUnitsImperial;
  private var isElevationUnitsImperial;
  
  private var color1 = Graphics.COLOR_BLACK;
  private var color2 = Graphics.COLOR_WHITE;
  private var colorBorder = Graphics.COLOR_DK_GRAY;
  private var colorHeader = Graphics.COLOR_LT_GRAY;
  
  // Display Header background in red/green/blue based on values (exemple current pace)
  private var dynamicHeaderColor;
  // Display Data foreground in red/green/blue based on values (exemple current pace)
  private var dynamicForegroundColor;
  
  // Header Position change the layout. Possible values are 1, 2 and 3
  private var headerPosition;
  // By default, the layout has 3 columns with the same width. middleColumnPercentageSize is used to reduce or enlarge the middle column.
  // middleColumnPercentageSize value must be between 0 and 100. It's a percentage value. If the value = 150, the width will be 150% larger.
  // If the value = 50, the width wil be 50% smaller. This can be useful to set value with format like 00:00 and the left/right and
  // keep decimal values (Example: Cadence) in the middle
  private var middleColumnPercentageSize;
  // If pace is lower than minPace, it will be displayed in blue
  // If pace is between minPace and maxPace, it will be displayed in green
  // If pace is greater than maxPace, it will be displayed in red
  private var minPace;
  private var maxPace;
  
  // vX variables are used to stored the type of data each area will display (Exemple: Current Pace, Distance, etc.)
  private var v1, v2, v3, v4, v5, v6, v7, v8, v9, v10;
  // vXdata variables contains the actuel value to display. For example, if v1 is configure to display current pace, v1data will display MM:SS
  private var v1data, v2data, v3data, v4data, v5data, v6data, v7data, v8data, v9data, v10data;
  // hXarea indicates the x/y coordonate of the Header area while vXarea indicates the x/y coordonate of the Value area
  private var v1area, h2area, v2area, h3area, v3area, h4area, v4area, h5area, v5area, h6area, v6area, h7area, v7area, v8area, v9area, v10area;
  
  // Device Model
  private var deviceModel;
  // Width of the device screen in pixels
  private var deviceWidth;
  // Height of the device screen in pixels
  private var deviceHeight;
  
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
  private var fontIcons = WatchUi.loadResource(Rez.Fonts.Icons);
  private var fontTiny = WatchUi.loadResource(Rez.Fonts.Roboto_20_Bold);
  
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
    OPTION_CURRENT_LAP_PACE = 27
    */
    /* Options below this line can be uncommented if someone required the functionnality
    OPTION_AMBIENT_PRESSURE = 25,
    OPTION_AVERAGE_CADENCE = 26,
    OPTION_AVERAGE_DISTANCE = 27,
    OPTION_AVERAGE_POWER = 28,
    OPTION_BEARING = 29,
    OPTION_BEARING_FROM_START = 30,
    OPTION_CURRENT_HEADING = 31,
    OPTION_CURRENT_LOCATION = 32,
    OPTION_CURRENT_POWER = 33,
    OPTION_DISTANCE_TO_DESTINATION = 34,
    OPTION_DISTANCE_TO_NEXT_POINT = 35,
    OPTION_ELAPSED_TIME = 36,
    OPTION_ELEVATION_AT_DESTINATION = 37,
    OPTION_ELEVATION_AT_NEXT_POINT = 38,
    OPTION_ENERGY_EXPENDITURE = 39,
    OPTION_FRONT_DERAILLEUR_INDEX = 40,
    OPTION_FRONT_DERAILLEUR_MAX = 41,
    OPTION_FRONT_DERAILLEUR_SIZE = 42,
    OPTION_MAX_CADENCE = 43,
    OPTION_MAX_HEART_RATE = 44,
    OPTION_MAX_POWER = 45,
    OPTION_MAX_SPEED = 46,
    OPTION_MEAN_SEA_LEVEL_PRESSURE = 47,
    OPTION_NAME_OF_DESTINATION = 48,
    OPTION_NAME_OF_NEXT_POINT = 49,
    OPTION_OFF_COURSE_DISTANCE = 50,
    OPTION_RAW_AMBIENT_PRESSURE = 51,
    OPTION_REAR_DERAILLEUR_INDEX = 52,
    OPTION_REAR_DERAILLEUR_MAX = 53,
    OPTION_REAR_DERAILLEUR_SIZE = 54,
    OPTION_START_LOCATION = 55,
    OPTION_START_TIME = 56,
    OPTION_SWIM_STROKE_TYPE = 57,
    OPTION_SWIM_SWOLF = 58,
    OPTION_TIMER_STATE = 59,
    OPTION_TRACK = 60,
    OPTION_TRAINING_EFFECT = 61
    */
  //}
  
  function getParameter(paramName, defaultValue)
  {
    var paramValue = Application.Properties.getValue(paramName);
    if (paramValue == null) { 
      paramValue = defaultValue;
      Application.Properties.setValue(paramName, defaultValue);
    }
    
    if (paramValue == null) { return 0 /* OPTION_EMPTY */; }
    return paramValue;
  }
  

  function initializeUserData()
  {
    var deviceSettings = System.getDeviceSettings();
    isPaceUnitsImperial = (deviceSettings.paceUnits == System.UNIT_STATUTE);
    isDistanceUnitsImperial = (deviceSettings.distanceUnits == System.UNIT_STATUTE);
    isElevationUnitsImperial = (deviceSettings.elevationUnits == System.UNIT_STATUTE);
  
    headerPosition = getParameter("HeaderPosition", 1);
    middleColumnPercentageSize = getParameter("MiddleColumnPercentageSize", 75);
    
    dynamicHeaderColor = getParameter("HeaderBackgroundColor", true);
    dynamicForegroundColor = getParameter("DataForegroundColor", false);
    
    if (isPaceUnitsImperial == true) {
      minPace = getParameter("MinPace", 510);
      maxPace = getParameter("MaxPace", 555);
    }
    
    else {
      minPace = getParameter("MinPace", 315);
      maxPace = getParameter("MaxPace", 345);
    }
        
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
    deviceModel = WatchUi.loadResource(Rez.Strings.DeviceModel);
    deviceWidth = deviceSettings.screenWidth;
    deviceHeight = deviceSettings.screenHeight;
    
    /*
    log("HeaderPosition: " + headerPosition);
    log("Area 1: " + getOptionName(v1));
    log("Area 2: " + getOptionName(v2));
    log("Area 3: " + getOptionName(v3));
    log("Area 4: " + getOptionName(v4));
    log("Area 5: " + getOptionName(v5));
    log("Area 6: " + getOptionName(v6));
    log("Area 7: " + getOptionName(v7));
    log("Area 8: " + getOptionName(v8));
    log("Area 9: " + getOptionName(v9));
    log("HR Zones: " + hrZones);
    */
  }
  
  
  //function initDataVariables(v)
  //{
    //if ( (v == 6 /* OPTION_CURRENT_HEART_RATE */) || (v == 9 /* OPTION_AVERAGE_HEART_RATE */) || (v == OPTION_MAX_HEART_RATE) )
    //if ( (v == 6 /* OPTION_CURRENT_HEART_RATE */) || (v == 9 /* OPTION_AVERAGE_HEART_RATE */) )
    //{
    //  return "--";
    //}
    
    //if (v == 19 /* OPTION_CURRENT_LOCATION_ACCURACY */ || v == 20 /* OPTION_CURRENT_LOCATION_ACCURACY_AND_BATTERY */)
    //{
    //  return -1;
    //}
    
    //if (v == 1 /* OPTION_CURRENT_TIME */)
    //{
    //  return System.getClockTime();
    //}
    
    //if ( (v == 12 /* OPTION_AVERAGE_SPEED */) || (v == 8 /* OPTION_CURRENT_SPEED */) || (v == 5 /* OPTION_ELAPSED_DISTANCE */) )
    //{
    //  return 0.0;
    //}
    
    //return 0;
  //}
  
 
  function initialize()
  {
    DataField.initialize();
    initializeUserData();
    
    var columnWidth = deviceWidth / 3;
    var shrinkValue = (1 - (middleColumnPercentageSize.toFloat() / 100)) * columnWidth / 2;
    
    var x1 = 0;
    var x2 = columnWidth + shrinkValue;
    var x3 = (columnWidth * 2) - shrinkValue;
    
    var headerHeight = deviceHeight * 25/240;
    var valueHeight = deviceHeight * 45/240;
    
    var y1 = deviceHeight / 6;      // 40 px
    var y2 = deviceHeight * 11/24;  // 110 px
    var y3 = deviceHeight * 3/4;    // 180 px
    var y4 = deviceHeight * 7/8;    // 210 px
    
    var columnWidth2 = columnWidth + shrinkValue;
    var columnWidth3 = columnWidth - (2 * shrinkValue);
    var y1h = y1 + headerHeight;
    var y2h = y2 + headerHeight;
    
    v1area = [ x1, 0, deviceWidth, y1 ];
    
    h2area = [ x1, y1, columnWidth2, headerHeight ];
    v2area = [ x1, y1h, columnWidth2, valueHeight ];
    
    h3area = [ x2, y1, columnWidth3, headerHeight ];
    v3area = [ x2, y1h, columnWidth3, valueHeight ];
    
    h4area = [ x3, y1, columnWidth2, headerHeight ];
    v4area = [ x3, y1h, columnWidth2, valueHeight ];
    
    h5area = [ x1, y2, columnWidth2, headerHeight ];
    v5area = [ x1, y2h, columnWidth2, valueHeight ];
    
    h6area = [ x2, y2, columnWidth3, headerHeight ];
    v6area = [ x2, y2h, columnWidth3, valueHeight ];
    
    h7area = [ x3, y2, columnWidth2, headerHeight ];
    v7area = [ x3, y2h, columnWidth2, valueHeight ];
    
    v8area = [ x1, y3, deviceWidth / 2, y4 - y3 ];
    v9area = [ x1 + (deviceWidth / 2), y3, deviceWidth / 2, y4 - y3 ];
    
    v10area = [ x1, y4, deviceWidth, deviceHeight - y4 ];

    if (headerPosition == 2)
    {
      y2h = y2 + valueHeight;
      h5area[1] = y2h;
      v5area[1] = y2;
      
      h6area[1] = y2h;
      v6area[1] = y2;
      
      h7area[1] = y2h;
      v7area[1] = y2;
    }

    else if (headerPosition == 3)
    {
      y1h = y1 + valueHeight;
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
    v1data = 0; //initDataVariables(v1);
    v2data = 0; //initDataVariables(v2);
    v3data = 0; //initDataVariables(v3);
    v4data = 0; //initDataVariables(v4);
    v5data = 0; //initDataVariables(v5);
    v6data = 0; //initDataVariables(v6);
    v7data = 0; //initDataVariables(v7);
    v8data = 0; //initDataVariables(v8);
    v9data = 0; //initDataVariables(v9);
    v10data = 0; //initDataVariables(v10);
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
  
  // Set your layout here. Anytime the size of obscurity of
  // the draw context is changed this will be called.
  function onLayout(dc)
  {
  }
  
  // A lap event has occurred.
  // This method is called when a lap is added to the current activity. A notification is triggered after the lap record has been written to the FIT file.
  function onTimerLap()
  {
    startTimerCurrentLap = timer;
    startDistanceCurrentLap = distance;
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
  
  
  function calculateETA(id, avgSpeed, distanceGoal, nextGoalOption, valueData)
  {
    var remainingDistance = distanceGoal - (distance * 1000);
    if (remainingDistance < 0) {
      if (nextGoalOption != null) { configureID(id, nextGoalOption); }
      else { return valueData; }
    }
  
    if (avgSpeed <= 0) { return valueData; }
    return timer + (remainingDistance / avgSpeed);
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
    // The current timer value in milliseconds (ms)
    if (info.timerTime != null)
    {
      // Convert in second
      timer = info.timerTime / 1000.0;
    }
    
    // Elapsed  of the current activity in meters (m)
    if (info.elapsedDistance != null)
    {
      distance = convertUnitIfRequired(info.elapsedDistance / 1000, 0.62137119 /* CONVERSION_KM_TO_MILE */, isDistanceUnitsImperial);
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
    
    // Average pace in second per kilometer
    if ( (value == 10 /* OPTION_AVERAGE_PACE */) && (info.averageSpeed != null) )
    {
      if (info.averageSpeed <= 0) { return 0; }
      return convertUnitIfRequired(1000 / info.averageSpeed, 1.609344 /* CONVERSION_MILE_TO_KM */, isPaceUnitsImperial);
    }
    
    // Current speed in meters per second (mps)
    if ( (value == 8 /* OPTION_CURRENT_SPEED */) && (info.currentSpeed != null) )
    {
      return convertUnitIfRequired(info.currentSpeed * 3.6, 0.62137119 /* CONVERSION_KM_TO_MILE */, isPaceUnitsImperial);
    }
    
    // Current Clock Time
    if (value == 1 /* OPTION_CURRENT_TIME */)
    {
      return System.getClockTime();
    }
    
    // Calculate fields used by other options
    if ( (value == 4 /* OPTION_TIMER_TIME_ON_PREVIOUS_KM_OR_MILE */) || (value == 3 /* OPTION_TIMER_TIME_ON_CURRENT_KM_OR_MILE */) ) 
    {
      if (currentKM != Math.floor(distance))
      {
        timerLastKM = timer - startTimerCurrentKM;  // Time taken on last km or mile
        currentKM = Math.floor(distance);
        startTimerCurrentKM = timer;
      }
      
      distanceOnCurrentKM = distance - Math.floor(distance);
    }
    
    // Time taken on previous km or mile
    if (value == 4 /* OPTION_TIMER_TIME_ON_PREVIOUS_KM_OR_MILE */) 
    {
      return timerLastKM;
    }
    
    // Elapsed time for the current km or mile
    if (value == 3 /* OPTION_TIMER_TIME_ON_CURRENT_KM_OR_MILE */)
    {
      return (timer - startTimerCurrentKM);
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
      var lapDistance = distance - startDistanceCurrentLap;
      
      if (lapDistance <= 0) { return 0; }
      return lapTimer / lapDistance;
    }
    
    // Current altitude in meters (m)
    if ( (value == 15 /* OPTION_ALTITUDE */) && (info.altitude  != null) )
    {
      return convertUnitIfRequired(info.altitude, 3.28084 /* CONVERSION_METER_TO_FEET */, isElevationUnitsImperial).toNumber();
    }
    
    // Current cadence in revolutions per minute (rpm)
    if ( (value == 14 /* OPTION_CURRENT_CADENCE */) && (info.currentCadence != null) )
    {
      return info.currentCadence;
    }
    
    // Current GPS accuracy
    if ( (value == 19 /* OPTION_CURRENT_LOCATION_ACCURACY */) && (info.currentLocationAccuracy != null) )
    {
      return info.currentLocationAccuracy;
    }
    
    // Current GPS accuracy & Battery Usage
    if ( (value == 20 /* OPTION_CURRENT_LOCATION_ACCURACY_AND_BATTERY */) && (info.currentLocationAccuracy != null) )
    {
      return info.currentLocationAccuracy;
    }
    
    // Estimated Time for 5 km
    if (value == 21 /* OPTION_ETA_5K */)
    {
      var avgSpeed = info.averageSpeed == null ? 0 : info.averageSpeed;
      return calculateETA(id, avgSpeed, 5000, 22 /* OPTION_ETA_10K */, valueData);
    }
    
    // Estimated Time for 10 km
    if (value == 22 /* OPTION_ETA_10K */)
    {
      var avgSpeed = info.averageSpeed == null ? 0 : info.averageSpeed;
      return calculateETA(id, avgSpeed, 10000, 23 /* OPTION_ETA_HALF_MARATHON */, valueData);
    }
    
    // Estimated Time for half marathon (21.075.5 km)
    if (value == 23 /* OPTION_ETA_HALF_MARATHON */)
    {
      var avgSpeed = info.averageSpeed == null ? 0 : info.averageSpeed;
      return calculateETA(id, avgSpeed, 21097.5, 24 /* OPTION_ETA_MARATHON */, valueData);
    }
    
    // Estimated Time for marathon (42.195 km)
    if (value == 24 /* OPTION_ETA_MARATHON */)
    {
      var avgSpeed = info.averageSpeed == null ? 0 : info.averageSpeed;
      return calculateETA(id, avgSpeed, 42195, null, valueData);
    }
    
    // Average pace in second per kilometer (Calculated mnually using timer/distance)
    if (value == 11 /* OPTION_AVERAGE_PACE_MANUAL_CALC */)
    {
      if (distance <= 0) { return 0; }
      return timer / distance;
    }
    
    // Average speed during the current activity in meters per second (mps)
    if ( (value == 12 /* OPTION_AVERAGE_SPEED */) && (info.averageSpeed != null) )
    {
      return convertUnitIfRequired(info.averageSpeed * 3.6, 0.62137119 /* CONVERSION_KM_TO_MILE */, isPaceUnitsImperial);
    }
    
    // Average heart rate during the current activity in beats per minute (bpm)
    if ( (value == 9 /* OPTION_AVERAGE_HEART_RATE */) && (info.averageHeartRate != null) ) 
    {
      return info.averageHeartRate;
    }
    
    // Calories burned throughout the current activity in kilocalories (kcal)
    if ( (value == 13 /* OPTION_CALORIES */) && (info.calories != null) ) 
    {
      return info.calories;
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

    //return computeExtraValue(info, id, value, valueData);
    return valueData;
  }
  
  
  // Extra values, which might be used on device with more memory
  // Keep commented to save memory
  /*
  function computeExtraValue(info, id, value, valueData)
  {
    // Ambient pressure in Pascals (Pa).
    if ( (value == OPTION_AMBIENT_PRESSURE) && (info has :ambientPressure ) && (info.ambientPressure  != null) )
    {
      return info.ambientPressure;
    }
    
    // Average cadence during the current activity in revolutions per minute (rpm)
    if ( (value == OPTION_AVERAGE_CADENCE) && (info has :averageCadence) && (info.averageCadence != null) )
    {
      return info.averageCadence;
    }
    
    // Average swim stroke distance from the previous interval in meters (m)
    if ( (value == OPTION_AVERAGE_DISTANCE) && (info has :averageDistance) && (info.averageDistance != null) )
    {
      if (System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE) {
        // Convert in miles (mi)
        return (info.averageDistance / 1000 * CONVERSION_KM_TO_MILE).toNumber(); 
      }
      
      // Convert to kilometers (km)
      return (info.averageDistance / 1000).toNumber();
    }

    // Average power during the current activity in Watts (W)
    if ( (value == OPTION_AVERAGE_POWER) && (info has :averagePower) && (info.averagePower != null) ) 
    {
      return info.averagePower;
    }
    
    // Current bearing in radians
    if ( (value == OPTION_BEARING) && (info has :bearing) && (info.bearing != null) ) 
    {
      return info.bearing;
    }
    
    // Bearing from the starting location to the destination in radians
    if ( (value == OPTION_BEARING_FROM_START) && (info has :bearingFromStart) && (info.bearingFromStart != null) ) 
    {
      return info.bearingFromStart;
    }
    
    // True north referenced heading in radians
    if ( (value == OPTION_CURRENT_HEADING) && (info has :currentHeading) && (info.currentHeading != null) )
    {
      return info.currentHeading;
    }
    
    // Current location
    if ( (value == OPTION_CURRENT_LOCATION) && (info has :currentLocation) && (info.currentLocation != null) ) 
    {
      // return [ latitude, longitude ]
      return info.currentLocation.toDegrees();
    }
    
    // Current power in Watts (W)
    if ( (value == OPTION_CURRENT_POWER) && (info has :currentPower) && (info.currentPower != null) )
    {
      return info.currentPower;
    }
    
    // Distance to the destination in meters (m)
    if ( (value == OPTION_DISTANCE_TO_DESTINATION) && (info has :distanceToDestination) && (info.distanceToDestination != null) )   
    {
      if (System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE) {
        // Convert in miles (mi)
        return (info.distanceToDestination / 1000 * CONVERSION_KM_TO_MILE).toNumber(); 
      }
      
      // Convert to kilometers (km)
      return (info.distanceToDestination / 1000).toNumber();
    }
    
    // Distance to the next point in meters (m)
    if ( (value == OPTION_DISTANCE_TO_NEXT_POINT) && (info has :distanceToNextPoint) && (info.distanceToNextPoint != null) )
    {
      if (System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE) {
        // Convert in miles (mi)
        return (info.distanceToNextPoint / 1000 * CONVERSION_KM_TO_MILE).toNumber(); 
      }
      
      // Convert to kilometers (km)
      return (info.distanceToNextPoint / 1000).toNumber();
    }
    
    // Elapsed time of the current activity in milliseconds (ms)
    // Time since the recording starts. Elapsed Time Continue to increment when activity is paused. 
    if ( (value == OPTION_ELAPSED_TIME) && (info has :elapsedTime) && (info.elapsedTime != null) )
    {
      // Convert to second
      return info.elapsedTime / 1000;
    }
    
    // Elevation at the destination in meters (m)
    if ( (value == OPTION_ELEVATION_AT_DESTINATION) && (info has :elevationAtDestination) && (info.elevationAtDestination != null) )
    {
      if (System.getDeviceSettings().heightUnits == System.UNIT_STATUTE) {
        // Convert in miles (mi)
        return (info.elevationAtDestination / 1000 * CONVERSION_KM_TO_MILE).toNumber(); 
      }
      
      return (info.elevationAtDestination / 1000).toNumber();
    }
    
    // Elevation at the next point in meters (m)
    if ( (value == OPTION_ELEVATION_AT_NEXT_POINT) && (info has :elevationAtNextPoint) && (info.elevationAtNextPoint != null) )
    {
      if (System.getDeviceSettings().heightUnits == System.UNIT_STATUTE) {
        // Convert in miles (mi)
        return (info.elevationAtNextPoint / 1000 * CONVERSION_KM_TO_MILE).toNumber(); 
      }
      
      return (info.elevationAtNextPoint / 1000).toNumber();
    }
    
    // Current energy expenditure in kilocalories per minute (kcals/min)
    if ( (value == OPTION_ENERGY_EXPENDITURE) && (info has :energyExpenditure) && (info.energyExpenditure != null) )
    {
      return info.energyExpenditure;
    }
    
    // Current front bicycle derailleur index
    if ( (value == OPTION_FRONT_DERAILLEUR_INDEX) && (info has :frontDerailleurIndex) && (info.frontDerailleurIndex != null) )
    {
      return info.frontDerailleurIndex;
    }
    
    // Front bicycle derailleur maximum index
    if ( (value == OPTION_FRONT_DERAILLEUR_MAX) && (info has :frontDerailleurMax) && (info.frontDerailleurMax != null) )
    {
      return info.frontDerailleurMax;
    }
    
    // Front bicycle derailleur gear size in number of teeth
    if ( (value == OPTION_FRONT_DERAILLEUR_SIZE) && (info has :frontDerailleurSize) && (info.frontDerailleurSize != null) )
    {
      return info.frontDerailleurSize;
    }
    
    // Maximum cadence recorded during the current activity in revolutions per minute (rpm)
    if ( (value == OPTION_MAX_CADENCE) && (info has :maxCadence) && (info.maxCadence != null) )
    {
      return info.maxCadence;
    }

    // Maximum heart rate recorded during the current activity in beats per minute (bpm)
    if ( (value == OPTION_MAX_HEART_RATE) && (info has :maxHeartRate) && (info.maxHeartRate != null) ) 
    {
      return info.maxHeartRate;
    }

    // Maximum power recorded during the current activity in Watts (W)
    if ( (value == OPTION_MAX_POWER) && (info has :maxPower) && (info.maxPower != null) )
    {
      return info.maxPower;
    }
    
    // Maximum speed recorded during the current activity in meters per second (mps)
    if ( (value == OPTION_MAX_SPEED) && (info has :maxSpeed) && (info.maxSpeed != null) )
    {
      if (System.getDeviceSettings().paceUnits == System.UNIT_STATUTE) {
        // Convert in miles/h
        return info.maxSpeed * 3.6 * CONVERSION_KM_TO_MILE;
      }
      
      // Convert in km/h
      return info.maxSpeed * 3.6;
    }
    
    // The mean sea level barometric pressure in Pascals (Pa)
    if ( (value == OPTION_MEAN_SEA_LEVEL_PRESSURE) && (info has :meanSeaLevelPressure) && (info.meanSeaLevelPressure != null) )
    {
      return info.meanSeaLevelPressure;
    }

    // Name of the destination
    if ( (value == OPTION_NAME_OF_DESTINATION) && (info has :nameOfDestination) && (info.nameOfDestination != null) )
    {
      return info.nameOfDestination;
    }

    // Name of the next point
    if ( (value == OPTION_NAME_OF_NEXT_POINT) && (info has :nameOfNextPoint) && (info.nameOfNextPoint != null) )
    {
      return info.nameOfNextPoint;
    }

    // Distance to the nearest point on the current course in meters (m)
    if ( (value == OPTION_OFF_COURSE_DISTANCE) && (info has :offCourseDistance) && (info.offCourseDistance != null) )
    {
      if (System.getDeviceSettings().paceUnits == System.UNIT_STATUTE) {
        // Convert in miles (mi)
        return (info.offCourseDistance / 1000 * CONVERSION_KM_TO_MILE).toNumber(); 
      }
      
      return (info.offCourseDistance / 1000).toNumber();
    }
    
    // The raw ambient pressure in Pascals (Pa)
    if ( (value == OPTION_RAW_AMBIENT_PRESSURE) && (info has :rawAmbientPressure) && (info.rawAmbientPressure != null) )
    {
      return info.rawAmbientPressure;
    }

    // The current front bicycle derailleur index
    if ( (value == OPTION_REAR_DERAILLEUR_INDEX) && (info has :rearDerailleurIndex) && (info.rearDerailleurIndex != null) )
    {
      return info.rearDerailleurIndex;
    }

    // The rear bicycle derailleur maximum index
    if ( (value == OPTION_REAR_DERAILLEUR_MAX) && (info has :rearDerailleurMax) && (info.rearDerailleurMax != null) )
    {
      return info.rearDerailleurMax;
    }

    // The rear bicycle derailleur gear size in number of teeth
    if ( (value == OPTION_REAR_DERAILLEUR_SIZE) && (info has :rearDerailleurSize) && (info.rearDerailleurSize != null) )
    {
      return info.rearDerailleurSize;
    }

    // The starting location of the current activity
    if ( (value == OPTION_START_LOCATION) && (info has :startLocation) && (info.startLocation != null) )
    {
      // return [ latitude, longitude ]
      return info.startLocation.toDegrees();
    }

    // The starting time of the current activity
    if ( (value == OPTION_START_TIME) && (info has :startTime) && (info.startTime != null) )
    {
      return info.startTime;
    }

    // The swim stroke type from the previous length
    if ( (value == OPTION_SWIM_STROKE_TYPE) && (info has :swimStrokeType) && (info.swimStrokeType != null) )
    {
      return info.swimStrokeType;
    }

    // The SWOLF score from the previous length
    if ( (value == OPTION_SWIM_SWOLF) && (info has :swimSwolf) && (info.swimSwolf != null) )
    {
      return info.swimSwolf;
    }

    // The recording timer state. One off:
    //  - Activity.TIMER_STATE_OFF
    //  - Activity.TIMER_STATE_ON
    //  - Activity.TIMER_STATE_PAUSED
    //  - Activity.TIMER_STATE_STOPPED
    if ( (value == OPTION_TIMER_STATE) && (info has :timerState) && (info.timerState != null) )
    {
      return info.timerState;
    }
    
    // The current track in radians
    if ( (value == OPTION_TRACK) && (info has :track) && (info.track != null) )
    {
      return info.track;
    }

    // The Training Effect score of the current activity
    if ( (value == OPTION_TRAINING_EFFECT) && (info has :trainingEffect) && (info.trainingEffect != null) )
    {
      return info.trainingEffect;
    }
    
    return valueData;
  }
  */
  
  // The given info object contains all the current workout information.
  // Calculate a value and save it locally in this method.
  // Note that compute() and onUpdate() are asynchronous, and there is no
  // guarantee that compute() will be called before onUpdate().
  function compute(info)
  {
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
    if (DataField.getBackgroundColor() == Graphics.COLOR_BLACK) {
      color1 = Graphics.COLOR_WHITE;
      color2 = Graphics.COLOR_BLACK;
      colorBorder = Graphics.COLOR_DK_GRAY;
      colorHeader = Graphics.COLOR_DK_GRAY;
    }
    
    else {
      color1 = Graphics.COLOR_BLACK;
      color2 = Graphics.COLOR_WHITE;
      colorBorder = Graphics.COLOR_LT_GRAY;
      colorHeader = Graphics.COLOR_LT_GRAY;
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
    var color = getColor(id, type, value);
  
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
    if (deviceModel.equals("fenixFixFont")) {
      if (id > 7) { valueY -= 1; }
      //else if (id > 1) { valueY -= 3; }
    }
    
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
      var gpsLength = 28 /* LENGTH_GPS_ICON */ + 6;
      var batteryLength = 50 /* LENGTH_BATTERY_ICON */ + 6;
      drawGPS(dc, valueX - (batteryLength / 2), valueY, 28 /* LENGTH_GPS_ICON */, value);
      drawBattery(dc, valueX + (gpsLength / 2), valueY, 50 /* LENGTH_BATTERY_ICON */, System.getSystemStats().battery);
    }
    
    else if (type == 19 /* OPTION_CURRENT_LOCATION_ACCURACY */)
    {
      valueY -= 2;
      drawGPS(dc, valueX, valueY, 28 /* LENGTH_GPS_ICON */, value);
    }
    
    else if (type == 18 /* OPTION_CURRENT_BATTERY */)
    {
      valueY -= 2;
      drawBattery(dc, valueX, valueY, 50 /* LENGTH_BATTERY_ICON */, System.getSystemStats().battery);
    }
      
    else
    {
      var formattedValue = getFormattedValue(id, type, value);
      // Display HR icon if in Area 1, 8 or 9
      if ( (type == 6 /* OPTION_CURRENT_HEART_RATE */) && ((id == 1) || (id == 8) || (id == 9) || (id == 10)) )
      {
        var iconLength = dc.getTextWidthInPixels("0", fontIcons);
        var font = getFont(dc, id, type, formattedValue, valueArea[2] - leftOffsetX - rightOffsetX - (iconLength * 1.5), valueArea[3]);
        var textLength = (iconLength / 2) + dc.getTextWidthInPixels(formattedValue, font);
        
        // Always display HR icon in color
        if (color != null) { dc.setColor(color, Graphics.COLOR_TRANSPARENT); }
        dc.drawText(valueX - (textLength / 2), valueY, fontIcons, 0, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        if (dynamicForegroundColor && (color != null)) { dc.setColor(color, Graphics.COLOR_TRANSPARENT); }
        else if (id < 8) { dc.setColor(color1, Graphics.COLOR_TRANSPARENT); }
        else { dc.setColor(color2, Graphics.COLOR_TRANSPARENT); }
        dc.drawText(valueX + (iconLength / 2), valueY, font, formattedValue, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      }
      
      // Display regular field
      else
      {
        dc.drawText(valueX, valueY, getFont(dc, id, type, formattedValue, valueArea[2] - leftOffsetX - rightOffsetX, valueArea[3]), formattedValue, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      }
    }
    
    dc.clearClip();
  }
  
  // Uncompute values are keep commented to save memory usage.
  function getHeaderName(type)
  {
    switch (type)
    {
      case 15 /* OPTION_ALTITUDE */:
        return "ALT";

      //case OPTION_AMBIENT_PRESSURE:
      //  return "PRES";

      //case OPTION_AVERAGE_CADENCE:
      //  return "AVG CAD";

      //case OPTION_AVERAGE_DISTANCE:
      //  return "AVG DIST";

      case 9 /* OPTION_AVERAGE_HEART_RATE */:
        return "AVG HR";

      case 10 /* OPTION_AVERAGE_PACE */:
      case 11 /* OPTION_AVERAGE_PACE_MANUAL_CALC */:
        return "AVG PACE";

      //case OPTION_AVERAGE_POWER:
      //  return "AVG POW";

      case 12 /* OPTION_AVERAGE_SPEED */:
        return "AVG SPD";

      //case OPTION_BEARING:
      //  return "BEAR";

      //case OPTION_BEARING_FROM_START:
      //  return "BEARS";

      case 13 /* OPTION_CALORIES */:
        return "CAL";

      case 18 /* OPTION_CURRENT_BATTERY */:
        return "BAT";

      case 14 /* OPTION_CURRENT_CADENCE */:
        return "CAD";

      //case OPTION_CURRENT_HEADING:
      //  return "COMP";

      case 6 /* OPTION_CURRENT_HEART_RATE */:
        return "HR";

      //case OPTION_CURRENT_LOCATION:
      //  return "LOC";

      case 19 /* OPTION_CURRENT_LOCATION_ACCURACY */:
        return "GPS";

      case 20 /* OPTION_CURRENT_LOCATION_ACCURACY_AND_BATTERY */:
        return "GPS/BAT";

      case 7 /* OPTION_CURRENT_PACE */:
        return "PACE";

      //case OPTION_CURRENT_POWER:
      //  return "POW";

      case 8 /* OPTION_CURRENT_SPEED */:
        return "SPD";

      case 1 /* OPTION_CURRENT_TIME */:
        return "TIME";

      //case OPTION_DISTANCE_TO_DESTINATION:
      //  return "DISTD";

      //case OPTION_DISTANCE_TO_NEXT_POINT:
      //  return "DISTN";

      case 5 /* OPTION_ELAPSED_DISTANCE */:
        return "DIST";

      //case OPTION_ELAPSED_TIME:
      //  return "TIME";

      //case OPTION_ELEVATION_AT_DESTINATION:
      //  return "ELVD";

      //case OPTION_ELEVATION_AT_NEXT_POINT:
      //  return "DELNP";

      //case OPTION_ENERGY_EXPENDITURE:
      //  return "NRG";

      //case OPTION_FRONT_DERAILLEUR_INDEX:
      //  return "DERI";

      //case OPTION_FRONT_DERAILLEUR_MAX:
      //  return "DERM";

      //case OPTION_FRONT_DERAILLEUR_SIZE:
      //  return "DERS";

      //case OPTION_MAX_CADENCE:
      //  return "MAX CAD";

      //case OPTION_MAX_HEART_RATE:
      //  return "MAX HR";

      //case OPTION_MAX_POWER:
      //  return "MAX POW";

      //case OPTION_MAX_SPEED:
      //  return "MAX SPD";

      //case OPTION_MEAN_SEA_LEVEL_PRESSURE:
      //  return "SEA PRES";

      //case OPTION_NAME_OF_DESTINATION:
      //  return "DEST";

      //case OPTION_NAME_OF_NEXT_POINT:
      //  return "NEXT P";

      //case OPTION_OFF_COURSE_DISTANCE:
      //  return "DIST NP";

      case 4 /* OPTION_TIMER_TIME_ON_PREVIOUS_KM_OR_MILE */:
        return (isDistanceUnitsImperial == true) ? "LAST MI" : "LAST KM";

      //case OPTION_RAW_AMBIENT_PRESSURE:
      //  return "PRESS";

      //case OPTION_REAR_DERAILLEUR_INDEX:
      //  return "RDERI";

      //case OPTION_REAR_DERAILLEUR_MAX:
      //  return "RDERM";

      //case OPTION_REAR_DERAILLEUR_SIZE:
      //  return "RDERS";

      //case OPTION_START_LOCATION:
      //  return "S LOC";

      //case OPTION_START_TIME:
      //  return "S TIME";

      //case OPTION_SWIM_STROKE_TYPE:
      //  return "STK TYPE";

      //case OPTION_SWIM_SWOLF:
      //  return "SWOLF";

      //case OPTION_TIMER_STATE:
      //  return "TMR ST";

      case 2 /* OPTION_TIMER_TIME */:
        return "TIMER";

      case 3 /* OPTION_TIMER_TIME_ON_CURRENT_KM_OR_MILE */:
        return (isDistanceUnitsImperial == true) ? "CUR MI" : "CUR KM";
      
      case 25 /* OPTION_CURRENT_LAP_TIME */:
        return "LAP TIME";

      case 26 /* OPTION_CURRENT_LAP_DISTANCE */:
        return "LAP DIST";

      case 27 /* OPTION_CURRENT_LAP_PACE */:
        return "LAP PACE";

      case 16 /* OPTION_TOTAL_ASCENT */:
        return "ASCENT";

      case 17 /* OPTION_TOTAL_DESCENT */:
        return "DESCENT";

      //case OPTION_TRACK:
      //  return "TRACK";

      //case OPTION_TRAINING_EFFECT:
      //  return "TRAIN EFF";
      
      case 21 /* OPTION_ETA_5K */:
        return "ETA 5K";
      
      case 22 /* OPTION_ETA_10K */:
        return "ETA 10K";
      
      case 23 /* OPTION_ETA_HALF_MARATHON */:
        return "ETA 21K";
      
      case 24 /* OPTION_ETA_MARATHON */:
        return "ETA 42K";
    }
    
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
    switch (type)
    {
      case 0 /* OPTION_EMPTY */:
        return "";
      
      case 7 /* OPTION_CURRENT_PACE */:
      case 10 /* OPTION_AVERAGE_PACE */:
      case 11 /* OPTION_AVERAGE_PACE_MANUAL_CALC */:
      case 4 /* OPTION_TIMER_TIME_ON_PREVIOUS_KM_OR_MILE */:
      case 3 /* OPTION_TIMER_TIME_ON_CURRENT_KM_OR_MILE */:
      case 27 /* OPTION_CURRENT_LAP_PACE */:
        return formatDuration(value, false);
      
      case 2 /* OPTION_TIMER_TIME */:
      case 21 /* OPTION_ETA_5K */:
      case 22 /* OPTION_ETA_10K */:
      case 23 /* OPTION_ETA_HALF_MARATHON */:
      case 24 /* OPTION_ETA_MARATHON */:
      case 25 /* OPTION_CURRENT_LAP_TIME */:
        return formatDuration(value, true);
      
      case 1 /* OPTION_CURRENT_TIME */:
        //if ( (type == v1) || (type == v8) || (type == v9) || (type == v10) ) { return getHour(value.hour) + "h" + value.min.format("%02d"); }
        //return getHour(value.hour) + ":" + value.min.format("%02d");
        return getHour(value.hour) + "h" + value.min.format("%02d");
    }

    if (value instanceof Float) { return formatFloat(value); }
    return value.toString();
  }
  
  function isEnoughSpace(dc, value, font, maxWidth, maxHeight)
  {
    var textDimension = dc.getTextDimensions(value, font);
    textDimension[1] = textDimension[1] - (2 * dc.getFontDescent(font));
    if (textDimension[0] <= maxWidth && textDimension[1] <= maxHeight) { return true; }
    return false;
  }
  
  
  function getFont(dc, id, type, value, maxWidth, maxHeight)
  {
    var fontID = 6;
    var textDimension = [0, 0];
    if (type == 1 /* OPTION_CURRENT_TIME */) { fontID = 3; }
        
    if (fontID >= 6) 
    {
      if (isEnoughSpace(dc, value, Graphics.FONT_NUMBER_HOT, maxWidth, maxHeight)) { return Graphics.FONT_NUMBER_HOT; }
      fontID -= 1;
    }
    
    if (fontID >= 5) 
    {
      if (isEnoughSpace(dc, value, Graphics.FONT_NUMBER_MEDIUM, maxWidth, maxHeight)) { return Graphics.FONT_NUMBER_MEDIUM; }
      fontID -= 1;
    }
    
    if (fontID >= 4) 
    {
      if (isEnoughSpace(dc, value, Graphics.FONT_NUMBER_MILD, maxWidth, maxHeight)) { return Graphics.FONT_NUMBER_MILD; }
      fontID -= 1;
    }
    
    if (fontID >= 3) 
    {
      if (isEnoughSpace(dc, value, Graphics.FONT_MEDIUM, maxWidth, maxHeight)) { return Graphics.FONT_MEDIUM; }
      fontID -= 1;
    }
    
    if (fontID >= 2) 
    {
      if (isEnoughSpace(dc, value, Graphics.FONT_SMALL, maxWidth, maxHeight)) { return Graphics.FONT_SMALL; }
      fontID -= 1;
    }
    
    return Graphics.FONT_XTINY;
  }
  
  
  function getColor(id, type, value)
  {
    switch (type)
    {
      case 6 /* OPTION_CURRENT_HEART_RATE */:
      case 9 /* OPTION_AVERAGE_HEART_RATE */:
        if (value < hrZones[1]) { if (id < 8) { return color1; } else { return color2; } } // Black
        else if (value < hrZones[2]) { return 0x00AAFF; } // Blue
        else if (value < hrZones[3]) { return 0x00AA00; } // Green
        else if (value < hrZones[4]) { return 0xFF5500; } // Orange
        return 0xFF0000;                                  // Red
        
      case 7 /* OPTION_CURRENT_PACE */:
      case 10 /* OPTION_AVERAGE_PACE */:
      case 11 /* OPTION_AVERAGE_PACE_MANUAL_CALC */:
      case 27 /* OPTION_CURRENT_LAP_PACE */:
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
      if (mm > 99) { return "--:--"; }
    }
    
    var ss = seconds % 60;
    return hh > 0 ? hh + ":" + mm.format("%02d") + ":" + ss.format("%02d") : mm.format("%d") + ":" + ss.format("%02d");
  }
  
  function drawGPS(dc, x, y, width, gpsAccuracy)
  {
    var height = width * 5/7;
    var x1 = x - (width / 2);
    var y1 = y - (height / 2);
    var space = 2;
    var barWidth = (width / 4) - space;
    
    if (gpsAccuracy <= 0) { dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT); }
    else { dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT); }
    
    dc.fillRectangle(x1 + 0 * (barWidth + space), y1 + (0.6 * height), barWidth, 0.4 * height);
    dc.fillRectangle(x1 + 1 * (barWidth + space), y1 + (0.4 * height), barWidth, 0.6 * height);
    dc.fillRectangle(x1 + 2 * (barWidth + space), y1 + (0.2 * height), barWidth, 0.8 * height);
    dc.fillRectangle(x1 + 3 * (barWidth + space), y1 + (0.0 * height), barWidth, 1.0 * height);
    
    if (gpsAccuracy == 2) { dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT); }
    else if (gpsAccuracy == 3) { dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT); }
    else if (gpsAccuracy == 4) { dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT); }
    else { dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT); }
    
    switch (gpsAccuracy)
    {
      case 4:
        // Good
        dc.fillRectangle(x1 + 3 * (barWidth + space), y1 + (0.0 * height), barWidth, 1.0 * height);
      case 3:
        // Usable
        dc.fillRectangle(x1 + 2 * (barWidth + space), y1 + (0.2 * height), barWidth, 0.8 * height);
      case 2:
        // Poor
        dc.fillRectangle(x1 + 1 * (barWidth + space), y1 + (0.4 * height), barWidth, 0.6 * height);
      case 1:
        // Last Known
        dc.fillRectangle(x1 + 0 * (barWidth + space), y1 + (0.6 * height), barWidth, 0.4 * height);
    }
  }
  
  function drawBattery(dc, x, y, width, batteryPercentage/*, fixedBackground*/)
  {
    var height = (width * 2/5).toNumber();
    var radius = 0.15 * height;
    var x1 = x - (width / 2).toNumber();
    var y1 = y - (height / 2).toNumber();
    
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.fillCircle(x1 + width, y, radius);
    
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    dc.fillRoundedRectangle(x1 + 1, y1, width, height, 3);
    
    dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    dc.drawRoundedRectangle(x1, y1, width, height, 3);
    
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.fillRoundedRectangle(x1 + 2, y1 + 2, width - 4, height - 4, 2);
    
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
}