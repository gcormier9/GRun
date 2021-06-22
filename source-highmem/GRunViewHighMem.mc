using Toybox.WatchUi;


class GRunViewHighMem extends GRunView
{
  // Used to determine if Activity has been paused
  protected var previousTimer;

  // Current distance
  var currentDistance;
  // Boolean to make sure value is added once per second in distanceArray
  protected var distanceArrayRequired = false;
  // Index for distanceArray
  protected var arrayDistPointer = 0;
  // Precision in seconds for distanceArray
  protected var arrayDistPrecision;
  // Circular Array to calculate custom average speed
  protected var distanceArray;
  
  // Current altitude
  var currentAltitude;
  // Boolean to make sure value is added once per second in distanceArray
  protected var altitudeArrayRequired = false;
  // Index for altitudeArray
  protected var arrayAltPointer = 0;
  // Precision in seconds for altitudeArray
  protected var arrayAltPrecision;
  // Circular Array to calculate custom average vertical speed
  protected var altitudeArray;
  
  // Used to determine if current cadence is too slow/fast
  protected var targetCadence;
  protected var cadenceRange;
  
  enum {
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
    OPTION_PREVIOUS_LAP_DISTANCE = 23,
    OPTION_PREVIOUS_LAP_PACE = 24,
    OPTION_CURRENT_LAP_TIME = 25,
    OPTION_CURRENT_LAP_DISTANCE = 26,
    OPTION_CURRENT_LAP_PACE = 27,
    OPTION_TRAINING_EFFECT = 28,
    OPTION_PREVIOUS_LAP_TIME = 30,
    OPTION_ETA_LAP = 31.
    OPTION_LAP_COUNT = 32,
    OPTION_AVERAGE_CADENCE = 33,
    OPTION_TIME_OFFSET = 34,
    OPTION_ETA_5K = 50,
    OPTION_ETA_10K = 51,
    OPTION_ETA_HALF_MARATHON = 52,
    OPTION_ETA_MARATHON = 53,
    OPTION_ETA_50K = 54,
    OPTION_ETA_100K = 55,
    OPTION_REQUIRED_PACE_5K = 56,
    OPTION_REQUIRED_PACE_10K = 57,
    OPTION_REQUIRED_PACE_HALF_MARATHON = 58,
    OPTION_REQUIRED_PACE_MARATHON = 59,
    OPTION_REQUIRED_PACE_50K = 60
    OPTION_REQUIRED_PACE_100K = 61
*/
/*
    OPTION_AMBIENT_PRESSURE = 101,
    OPTION_AVERAGE_DISTANCE = 103,
    OPTION_BEARING = 105,
    OPTION_BEARING_FROM_START = 106,
    OPTION_CURRENT_HEADING = 107,
    OPTION_CURRENT_LOCATION = 108,
    OPTION_DISTANCE_TO_DESTINATION = 110,
    OPTION_DISTANCE_TO_NEXT_POINT = 111,
    OPTION_ELAPSED_TIME = 112,
    OPTION_ELEVATION_AT_DESTINATION = 113,
    OPTION_ELEVATION_AT_NEXT_POINT = 114,
    OPTION_ENERGY_EXPENDITURE = 115,
    OPTION_FRONT_DERAILLEUR_INDEX = 116,
    OPTION_FRONT_DERAILLEUR_MAX = 117,
    OPTION_FRONT_DERAILLEUR_SIZE = 118,
    OPTION_MAX_CADENCE = 119,
    OPTION_MAX_HEART_RATE = 120,
*/
    OPTION_MAX_POWER = 121,
/*
    OPTION_MAX_SPEED = 122,
    OPTION_MEAN_SEA_LEVEL_PRESSURE = 123,
    OPTION_NAME_OF_DESTINATION = 124,
    OPTION_NAME_OF_NEXT_POINT = 125,
    OPTION_OFF_COURSE_DISTANCE = 126,
    OPTION_RAW_AMBIENT_PRESSURE = 127,
    OPTION_REAR_DERAILLEUR_INDEX = 128,
    OPTION_REAR_DERAILLEUR_MAX = 129,
    OPTION_REAR_DERAILLEUR_SIZE = 130,
    OPTION_START_LOCATION = 131,
    OPTION_START_TIME = 132,
    OPTION_SWIM_STROKE_TYPE = 133,
    OPTION_SWIM_SWOLF = 134,
    OPTION_TIMER_STATE = 135,
    OPTION_TRACK = 136,
*/
    OPTION_AVERAGE_PACE_CUSTOM = 137,
    OPTION_AVERAGE_SPEED_CUSTOM = 138,
    OPTION_AVERAGE_VERTICAL_SPEED_MIN = 139,
    OPTION_AVERAGE_VERTICAL_SPEED_HOUR = 140,
    
    OPTION_REQUIRED_SPEED_5K = 147,
    OPTION_REQUIRED_SPEED_10K = 148,
    OPTION_REQUIRED_SPEED_HALF_MARATHON = 149,
    OPTION_REQUIRED_SPEED_MARATHON = 150,
    OPTION_REQUIRED_SPEED_100K = 151,
    
    OPTION_REQUIRED_PACE_LAP = 152,
    OPTION_REQUIRED_SPEED_LAP = 153
  }
  
  
  function getParameter(paramName, defaultValue)
  {
    var paramValue = GRunView.getParameter(paramName, defaultValue);
    if ( (paramName.length() > 4) && (paramName.substring(0, 4).equals("Area")) )
    {
      if ( (paramValue == OPTION_AVERAGE_PACE_CUSTOM) || (paramValue == OPTION_AVERAGE_SPEED_CUSTOM) )
      {
        distanceArrayRequired = true;
      }
      
      if ( (paramValue == OPTION_AVERAGE_VERTICAL_SPEED_MIN) || (paramValue == OPTION_AVERAGE_VERTICAL_SPEED_HOUR) )
      {
        altitudeArrayRequired = true;
      }
    }
    
    return paramValue;
  }
  
  function initializeUserData()
  {
    distanceArrayRequired = false;
    altitudeArrayRequired = false;
    GRunView.initializeUserData();
    var info = Activity.getActivityInfo();
    
    if (distanceArrayRequired == false)
    {
      distanceArray = null;
    }
    
    else
    {
      var oldParam = arrayDistPrecision;
      arrayDistPrecision = getParameter("AvgSpeedTime", 15).toNumber();
      if (oldParam != arrayDistPrecision)
      {
        distanceArray = new [arrayDistPrecision];
        currentDistance = info.elapsedDistance == null ? 0 : info.elapsedDistance;
        
        for (var i = 0; i < arrayDistPrecision; i++)
        {
          distanceArray[i] = currentDistance;
        }
      }
    }
    
    if (altitudeArrayRequired == false)
    {
      altitudeArray = null;
    }
    
    else
    {
      var oldParam = arrayAltPrecision;
      arrayAltPrecision = getParameter("AvgVerticalSpeedTime", 60).toNumber();
      if (oldParam != arrayAltPrecision)
      {
        altitudeArray = new [arrayAltPrecision];
        currentAltitude = info.altitude == null ? 0 : info.altitude;
        
        for (var i = 0; i < arrayAltPrecision; i++)
        {
          altitudeArray[i] = currentAltitude;
        }
      }
    }
    
    targetCadence = getParameter("TargetCadence", 180);
    cadenceRange = getParameter("CadenceRange", 5);
    
    // DEBUG
    //System.println("elapsedDistance,OPTION_TIMER_TIME,OPTION_TIMER_TIME,OPTION_ELAPSED_DISTANCE,OPTION_ELAPSED_DISTANCE,OPTION_CURRENT_HEART_RATE,OPTION_CURRENT_HEART_RATE,OPTION_CURRENT_PACE,OPTION_CURRENT_PACE,OPTION_CURRENT_SPEED,OPTION_CURRENT_SPEED,OPTION_AVERAGE_HEART_RATE,OPTION_AVERAGE_HEART_RATE,OPTION_AVERAGE_PACE,OPTION_AVERAGE_PACE,OPTION_AVERAGE_SPEED,OPTION_AVERAGE_SPEED,OPTION_CALORIES,OPTION_CALORIES,OPTION_CURRENT_CADENCE,OPTION_CURRENT_CADENCE,OPTION_ALTITUDE,OPTION_ALTITUDE,OPTION_TOTAL_ASCENT,OPTION_TOTAL_ASCENT,OPTION_TOTAL_DESCENT,OPTION_TOTAL_DESCENT,OPTION_CURRENT_BATTERY,OPTION_CURRENT_BATTERY,OPTION_CURRENT_LOCATION_ACCURACY,OPTION_CURRENT_LOCATION_ACCURACY,OPTION_CURRENT_LOCATION_ACCURACY_AND_BATTERY,OPTION_CURRENT_LOCATION_ACCURACY_AND_BATTERY,OPTION_PREVIOUS_LAP_DISTANCE,OPTION_PREVIOUS_LAP_DISTANCE,OPTION_PREVIOUS_LAP_PACE,OPTION_PREVIOUS_LAP_PACE,OPTION_CURRENT_LAP_TIME,OPTION_CURRENT_LAP_TIME,OPTION_CURRENT_LAP_DISTANCE,OPTION_CURRENT_LAP_DISTANCE,OPTION_CURRENT_LAP_PACE,OPTION_CURRENT_LAP_PACE,OPTION_TRAINING_EFFECT,OPTION_TRAINING_EFFECT,OPTION_PREVIOUS_LAP_TIME,OPTION_PREVIOUS_LAP_TIME,OPTION_ETA_LAP,OPTION_ETA_LAP,OPTION_LAP_COUNT,OPTION_LAP_COUNT,OPTION_AVERAGE_CADENCE,OPTION_AVERAGE_CADENCE,OPTION_TIME_OFFSET,OPTION_TIME_OFFSET,OPTION_ETA_5K,OPTION_ETA_5K,OPTION_ETA_10K,OPTION_ETA_10K,OPTION_ETA_HALF_MARATHON,OPTION_ETA_HALF_MARATHON,OPTION_ETA_MARATHON,OPTION_ETA_MARATHON,OPTION_ETA_50K,,OPTION_ETA_50K,OPTION_ETA_100K,OPTION_ETA_100K,OPTION_REQUIRED_PACE_5K,OPTION_REQUIRED_PACE_5K,OPTION_REQUIRED_PACE_10K,OPTION_REQUIRED_PACE_10K,OPTION_REQUIRED_PACE_HALF_MARATHON,OPTION_REQUIRED_PACE_HALF_MARATHON,OPTION_REQUIRED_PACE_MARATHON,OPTION_REQUIRED_PACE_MARATHON,OPTION_REQUIRED_PACE_50K,OPTION_REQUIRED_PACE_50K,OPTION_REQUIRED_PACE_100K,OPTION_REQUIRED_PACE_100K,OPTION_MAX_POWER,OPTION_MAX_POWER,OPTION_AVERAGE_PACE_CUSTOM,OPTION_AVERAGE_PACE_CUSTOM,OPTION_AVERAGE_SPEED_CUSTOM,OPTION_AVERAGE_SPEED_CUSTOM,OPTION_AVERAGE_VERTICAL_SPEED_MIN,OPTION_AVERAGE_VERTICAL_SPEED_MIN,OPTION_AVERAGE_VERTICAL_SPEED_HOUR,OPTION_AVERAGE_VERTICAL_SPEED_HOUR,OPTION_REQUIRED_SPEED_5K,OPTION_REQUIRED_SPEED_5K,OPTION_REQUIRED_SPEED_10K,OPTION_REQUIRED_SPEED_10K,OPTION_REQUIRED_SPEED_HALF_MARATHON,OPTION_REQUIRED_SPEED_HALF_MARATHON,OPTION_REQUIRED_SPEED_MARATHON,OPTION_REQUIRED_SPEED_MARATHON,OPTION_REQUIRED_SPEED_100K,OPTION_REQUIRED_SPEED_100K,OPTION_REQUIRED_PACE_LAP,OPTION_REQUIRED_PACE_LAP,OPTION_REQUIRED_SPEED_LAP,OPTION_REQUIRED_SPEED_LAP");
  }
  
  
  function initialize()
  {
    GRunView.initialize();
  }

  
  function computeValue(info, id, value, valueData)
  {
    if (value <= 100) { return GRunView.computeValue(info, id, value, valueData); }
    
    /*
    // Ambient pressure in Pascals (Pa).
    if ( (value == OPTION_AMBIENT_PRESSURE) && (info.ambientPressure  != null) )
    {
      return info.ambientPressure;
    }
    
    // Average swim stroke distance from the previous interval in meters (m)
    if ( (value == OPTION_AVERAGE_DISTANCE) && (info.averageDistance != null) )
    {
      if (System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE) {
        // Convert in miles (mi)
        return (info.averageDistance / 1000 * CONVERSION_KM_TO_MILE).toNumber(); 
      }
      
      // Convert to kilometers (km)
      return (info.averageDistance / 1000).toNumber();
    }
    
    // Current bearing in radians
    if ( (value == OPTION_BEARING) && (info.bearing != null) ) 
    {
      return info.bearing;
    }
    
    // Bearing from the starting location to the destination in radians
    if ( (value == OPTION_BEARING_FROM_START) && (info.bearingFromStart != null) ) 
    {
      return info.bearingFromStart;
    }
    
    // True north referenced heading in radians
    if ( (value == OPTION_CURRENT_HEADING) && (info.currentHeading != null) )
    {
      return info.currentHeading;
    }
    
    // Current location
    if ( (value == OPTION_CURRENT_LOCATION) && (info.currentLocation != null) ) 
    {
      // return [ latitude, longitude ]
      return info.currentLocation.toDegrees();
    }
    
    // Distance to the destination in meters (m)
    if ( (value == OPTION_DISTANCE_TO_DESTINATION) && (info.distanceToDestination != null) )   
    {
      if (System.getDeviceSettings().distanceUnits == System.UNIT_STATUTE) {
        // Convert in miles (mi)
        return (info.distanceToDestination / 1000 * CONVERSION_KM_TO_MILE).toNumber(); 
      }
      
      // Convert to kilometers (km)
      return (info.distanceToDestination / 1000).toNumber();
    }
    
    // Distance to the next point in meters (m)
    if ( (value == OPTION_DISTANCE_TO_NEXT_POINT) && (info.distanceToNextPoint != null) )
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
    if ( (value == OPTION_ELAPSED_TIME) (info.elapsedTime != null) )
    {
      // Convert to second
      return info.elapsedTime / 1000;
    }
    
    // Elevation at the destination in meters (m)
    if ( (value == OPTION_ELEVATION_AT_DESTINATION) && (info.elevationAtDestination != null) )
    {
      if (System.getDeviceSettings().heightUnits == System.UNIT_STATUTE) {
        // Convert in miles (mi)
        return (info.elevationAtDestination / 1000 * CONVERSION_KM_TO_MILE).toNumber(); 
      }
      
      return (info.elevationAtDestination / 1000).toNumber();
    }
    
    // Elevation at the next point in meters (m)
    if ( (value == OPTION_ELEVATION_AT_NEXT_POINT) && (info.elevationAtNextPoint != null) )
    {
      if (System.getDeviceSettings().heightUnits == System.UNIT_STATUTE) {
        // Convert in miles (mi)
        return (info.elevationAtNextPoint / 1000 * CONVERSION_KM_TO_MILE).toNumber(); 
      }
      
      return (info.elevationAtNextPoint / 1000).toNumber();
    }
    
    // Current energy expenditure in kilocalories per minute (kcals/min)
    if ( (value == OPTION_ENERGY_EXPENDITURE) && (info.energyExpenditure != null) )
    {
      return info.energyExpenditure;
    }
    
    // Current front bicycle derailleur index
    if ( (value == OPTION_FRONT_DERAILLEUR_INDEX) && (info.frontDerailleurIndex != null) )
    {
      return info.frontDerailleurIndex;
    }
    
    // Front bicycle derailleur maximum index
    if ( (value == OPTION_FRONT_DERAILLEUR_MAX) && (info.frontDerailleurMax != null) )
    {
      return info.frontDerailleurMax;
    }
    
    // Front bicycle derailleur gear size in number of teeth
    if ( (value == OPTION_FRONT_DERAILLEUR_SIZE) && (info.frontDerailleurSize != null) )
    {
      return info.frontDerailleurSize;
    }
    
    // Maximum cadence recorded during the current activity in revolutions per minute (rpm)
    if ( (value == OPTION_MAX_CADENCE) && (info.maxCadence != null) )
    {
      return info.maxCadence;
    }

    // Maximum heart rate recorded during the current activity in beats per minute (bpm)
    if ( (value == OPTION_MAX_HEART_RATE) && (info.maxHeartRate != null) ) 
    {
      return info.maxHeartRate;
    }
    */
    
    // Maximum power recorded during the current activity in Watts (W)
    if ( (value == OPTION_MAX_POWER) && (info.maxPower != null) )
    {
      return info.maxPower;
    }
    
    /*
    // Maximum speed recorded during the current activity in meters per second (mps)
    if ( (value == OPTION_MAX_SPEED) && (info.maxSpeed != null) )
    {
      if (System.getDeviceSettings().paceUnits == System.UNIT_STATUTE) {
        // Convert in miles/h
        return info.maxSpeed * 3.6 * CONVERSION_KM_TO_MILE;
      }
      
      // Convert in km/h
      return info.maxSpeed * 3.6;
    }
    
    // The mean sea level barometric pressure in Pascals (Pa)
    if ( (value == OPTION_MEAN_SEA_LEVEL_PRESSURE) && (info.meanSeaLevelPressure != null) )
    {
      return info.meanSeaLevelPressure;
    }

    // Name of the destination
    if ( (value == OPTION_NAME_OF_DESTINATION) && (info.nameOfDestination != null) )
    {
      return info.nameOfDestination;
    }

    // Name of the next point
    if ( (value == OPTION_NAME_OF_NEXT_POINT) && (info.nameOfNextPoint != null) )
    {
      return info.nameOfNextPoint;
    }

    // Distance to the nearest point on the current course in meters (m)
    if ( (value == OPTION_OFF_COURSE_DISTANCE) && (info.offCourseDistance != null) )
    {
      if (System.getDeviceSettings().paceUnits == System.UNIT_STATUTE) {
        // Convert in miles (mi)
        return (info.offCourseDistance / 1000 * CONVERSION_KM_TO_MILE).toNumber(); 
      }
      
      return (info.offCourseDistance / 1000).toNumber();
    }
    
    // The raw ambient pressure in Pascals (Pa)
    if ( (value == OPTION_RAW_AMBIENT_PRESSURE) && (info.rawAmbientPressure != null) )
    {
      return info.rawAmbientPressure;
    }

    // The current front bicycle derailleur index
    if ( (value == OPTION_REAR_DERAILLEUR_INDEX) && (info.rearDerailleurIndex != null) )
    {
      return info.rearDerailleurIndex;
    }

    // The rear bicycle derailleur maximum index
    if ( (value == OPTION_REAR_DERAILLEUR_MAX) && (info.rearDerailleurMax != null) )
    {
      return info.rearDerailleurMax;
    }

    // The rear bicycle derailleur gear size in number of teeth
    if ( (value == OPTION_REAR_DERAILLEUR_SIZE) && (info.rearDerailleurSize != null) )
    {
      return info.rearDerailleurSize;
    }

    // The starting location of the current activity
    if ( (value == OPTION_START_LOCATION) && (info.startLocation != null) )
    {
      // return [ latitude, longitude ]
      return info.startLocation.toDegrees();
    }

    // The starting time of the current activity
    if ( (value == OPTION_START_TIME) && (info.startTime != null) )
    {
      return info.startTime;
    }

    // The swim stroke type from the previous length
    if ( (value == OPTION_SWIM_STROKE_TYPE) && (info.swimStrokeType != null) )
    {
      return info.swimStrokeType;
    }

    // The SWOLF score from the previous length
    if ( (value == OPTION_SWIM_SWOLF) && (info.swimSwolf != null) )
    {
      return info.swimSwolf;
    }

    // The recording timer state. One off:
    //  - Activity.TIMER_STATE_OFF
    //  - Activity.TIMER_STATE_ON
    //  - Activity.TIMER_STATE_PAUSED
    //  - Activity.TIMER_STATE_STOPPED
    if ( (value == OPTION_TIMER_STATE) && (info.timerState != null) )
    {
      return info.timerState;
    }
    
    // The current track in radians
    if ( (value == OPTION_TRACK) && (info.track != null) )
    {
      return info.track;
    }
    */
    
    // Current Speed calculated using the last arrayDistPrecision seconds
    if ( (value == OPTION_AVERAGE_SPEED_CUSTOM) && (currentDistance != null) )
    {
      var calculatedDistance = currentDistance - distanceArray[arrayDistPointer % arrayDistPrecision];
      var indexLastArrayElement = (arrayDistPointer + 1) < arrayDistPrecision ? arrayDistPointer + 1 : arrayDistPrecision;
      return convertUnitIfRequired(calculatedDistance / indexLastArrayElement * 3.6, 0.62137119 /* CONVERSION_KM_TO_MILE */, isPaceUnitsImperial);
    }
    
    // Current Pace calculated using the last arrayDistPrecision seconds
    if ( (value == OPTION_AVERAGE_PACE_CUSTOM) && (currentDistance != null) )
    {
      var calculatedDistance = currentDistance - distanceArray[arrayDistPointer % arrayDistPrecision];
      if (calculatedDistance <= 0) { return 0; }
      
      var indexLastArrayElement = (arrayDistPointer + 1) < arrayDistPrecision ? arrayDistPointer + 1 : arrayDistPrecision;
      return convertUnitIfRequired(indexLastArrayElement / (calculatedDistance / 1000.0), 1.609344 /* CONVERSION_MILE_TO_KM */, isPaceUnitsImperial);
    }
    
    // Vertical Speed in meter or feet per min calculated using the last arrayAltPrecision seconds
    if ( (value == OPTION_AVERAGE_VERTICAL_SPEED_MIN) && (currentAltitude  != null) )
    {
      var calculatedAltitude = currentAltitude - altitudeArray[arrayAltPointer % arrayAltPrecision];
      var indexLastArrayElement = (arrayAltPointer + 1) < arrayAltPrecision ? arrayAltPointer + 1 : arrayAltPrecision;
      return convertUnitIfRequired((calculatedAltitude / indexLastArrayElement) * 60, 3.28084 /* CONVERSION_METER_TO_FEET */, isElevationUnitsImperial);
    }
    
    // Vertical Speed in meter or feet per hour calculated using the last arrayAltPrecision seconds
    if ( (value == OPTION_AVERAGE_VERTICAL_SPEED_HOUR) && (currentAltitude  != null) )
    {
      var calculatedAltitude = currentAltitude - altitudeArray[arrayAltPointer % arrayAltPrecision];
      var indexLastArrayElement = (arrayAltPointer + 1) < arrayAltPrecision ? arrayAltPointer + 1 : arrayAltPrecision;
      return convertUnitIfRequired((calculatedAltitude / indexLastArrayElement) * 3600, 3.28084 /* CONVERSION_METER_TO_FEET */, isElevationUnitsImperial);
    }
    
    if (value >= OPTION_REQUIRED_SPEED_5K && value <= OPTION_REQUIRED_SPEED_100K)
    {
      var requiredPace = GRunView.computeValue(info, id, value - OPTION_REQUIRED_SPEED_5K + 56 /* OPTION_REQUIRED_PACE_5K */, valueData);
      
      // Convert to km/h or mph
      return 60 / requiredPace;
    }
    
    if ( (value == OPTION_REQUIRED_PACE_LAP) || (value == OPTION_REQUIRED_SPEED_LAP) )
    {
      var distanceMetric = convertUnitIfRequired(distance * 1000, 1.609344 /* CONVERSION_MILE_TO_KM */, isDistanceUnitsImperial);
      var startDistanceCurrentLapMetric = convertUnitIfRequired(startDistanceCurrentLap * 1000, 1.609344 /* CONVERSION_MILE_TO_KM */, isDistanceUnitsImperial);
      
      var distanceCurrentLap = distanceMetric - startDistanceCurrentLapMetric;
      var remainingLapDistance = (lapDistance - distanceCurrentLap) / 1000.0;
      if (remainingLapDistance <= 0) { return 0; }
      
      // Elapsed time for the current lap
      var timerCurrentLap = timer - startTimerCurrentLap;
      if (timerCurrentLap <= 0) { return valueData; }
      
      var targetPaceMetric = convertUnitIfRequired(targetPace,  0.62137119 /* CONVERSION_KM_TO_MILE */, isPaceUnitsImperial);
      var targetTime = targetPaceMetric * (lapDistance / 1000.0);
      var remainingTime = targetTime - timerCurrentLap;
      
      if (value <= OPTION_REQUIRED_PACE_LAP)
      {
        return convertUnitIfRequired(remainingTime / remainingLapDistance, 1.609344 /* CONVERSION_MILE_TO_KM */, isPaceUnitsImperial);
      }
      
      if (remainingTime == 0) { return 0; }
      return convertUnitIfRequired(remainingLapDistance / remainingTime * 3600, 0.62137119 /* CONVERSION_KM_TO_MILE */, isPaceUnitsImperial);
    }
    
    return valueData;
  }
  
  /*
  function debugMetric(name, type, defaultValue, info)
  {
    var value = computeValue(info, 1, type, defaultValue);
    System.print(value + "," + getFormattedValue(1, type, value) + ",");
  }
  
  function printAllMetrics(info)
  {
    System.print(info.elapsedDistance + ",");
    debugMetric("OPTION_TIMER_TIME", 2, "", info);
    debugMetric("OPTION_ELAPSED_DISTANCE", 5, "", info);
    debugMetric("OPTION_CURRENT_HEART_RATE", 6, "", info);
    debugMetric("OPTION_CURRENT_PACE", 7, "", info);
    debugMetric("OPTION_CURRENT_SPEED", 8, 0, info);
    debugMetric("OPTION_AVERAGE_HEART_RATE", 9, "", info);
    debugMetric("OPTION_AVERAGE_PACE", 10, "", info);
    debugMetric("OPTION_AVERAGE_SPEED", 12, 0, info);
    debugMetric("OPTION_CALORIES", 13, "", info);
    debugMetric("OPTION_CURRENT_CADENCE", 14, "", info);
    debugMetric("OPTION_ALTITUDE", 15, "", info);
    debugMetric("OPTION_TOTAL_ASCENT", 16, 0, info);
    debugMetric("OPTION_TOTAL_DESCENT", 17, 0, info);
    debugMetric("OPTION_CURRENT_BATTERY", 18, "", info);
    debugMetric("OPTION_CURRENT_LOCATION_ACCURACY", 19, "", info);
    debugMetric("OPTION_CURRENT_LOCATION_ACCURACY_AND_BATTERY", 20, "", info);
    debugMetric("OPTION_PREVIOUS_LAP_DISTANCE", 23, "", info);
    debugMetric("OPTION_PREVIOUS_LAP_DISTANCE", 24, "", info);
    debugMetric("OPTION_CURRENT_LAP_TIME", 25, "", info);
    debugMetric("OPTION_CURRENT_LAP_DISTANCE", 26, "", info);
    debugMetric("OPTION_CURRENT_LAP_PACE", 27, "", info);
    debugMetric("OPTION_TRAINING_EFFECT", 28, 0, info);
    debugMetric("OPTION_PREVIOUS_LAP_TIME", 30, "", info);
    debugMetric("OPTION_ETA_LAP", 31, "", info);
    debugMetric("OPTION_LAP_COUNT", 32, "", info);
    debugMetric("OPTION_AVERAGE_CADENCE", 33, "", info);
    debugMetric("OPTION_TIME_OFFSET", 34, "", info);
    debugMetric("OPTION_ETA_5K", 50, "", info);
    debugMetric("OPTION_ETA_10K", 51, "", info);
    debugMetric("OPTION_ETA_HALF_MARATHON", 52, "", info);
    debugMetric("OPTION_ETA_MARATHON", 53, "", info);
    debugMetric("OPTION_ETA_50K", 54, "", info);
    debugMetric("OPTION_ETA_100K", 55, "", info);
    debugMetric("OPTION_REQUIRED_PACE_5K", 56, "", info);
    debugMetric("OPTION_REQUIRED_PACE_10K", 57, "", info);
    debugMetric("OPTION_REQUIRED_PACE_HALF_MARATHON", 58, "", info);
    debugMetric("OPTION_REQUIRED_PACE_MARATHON", 59, "", info);
    debugMetric("OPTION_REQUIRED_PACE_50K", 60, "", info);
    debugMetric("OPTION_REQUIRED_PACE_100K", 61, "", info);

    debugMetric("OPTION_MAX_POWER", OPTION_MAX_POWER, "", info);
    debugMetric("OPTION_AVERAGE_PACE_CUSTOM", OPTION_AVERAGE_PACE_CUSTOM, "", info);
    debugMetric("OPTION_AVERAGE_SPEED_CUSTOM", OPTION_AVERAGE_SPEED_CUSTOM, 0, info);
    debugMetric("OPTION_AVERAGE_VERTICAL_SPEED_MIN", OPTION_AVERAGE_VERTICAL_SPEED_MIN, 0, info);
    debugMetric("OPTION_AVERAGE_VERTICAL_SPEED_HOUR", OPTION_AVERAGE_VERTICAL_SPEED_HOUR, 0, info);
    debugMetric("OPTION_REQUIRED_SPEED_5K", OPTION_REQUIRED_SPEED_5K, 0, info);
    debugMetric("OPTION_REQUIRED_SPEED_10K", OPTION_REQUIRED_SPEED_10K, 0, info);
    debugMetric("OPTION_REQUIRED_SPEED_HALF_MARATHON", OPTION_REQUIRED_SPEED_HALF_MARATHON, 0, info);
    debugMetric("OPTION_REQUIRED_SPEED_MARATHON", OPTION_REQUIRED_SPEED_MARATHON, 0, info);
    debugMetric("OPTION_REQUIRED_SPEED_100K", OPTION_REQUIRED_SPEED_100K, 0, info);
    debugMetric("OPTION_REQUIRED_PACE_LAP", OPTION_REQUIRED_PACE_LAP, "", info);
    debugMetric("OPTION_REQUIRED_SPEED_LAP", OPTION_REQUIRED_SPEED_LAP, 0, info);
    System.print(altitudeArray);
    System.println("");
  }
  */
  
  function compute(info)
  {
    previousTimer = timer;
    currentDistance = info.elapsedDistance;
    currentAltitude = info.altitude;
    GRunView.compute(info);
    
    // DEBUG
    //printAllMetrics(info);
    
    if (previousTimer == timer) { return; }
    
    if (distanceArray != null && currentDistance != null && currentDistance > 0)
    {
      distanceArray[arrayDistPointer % arrayDistPrecision] = currentDistance;
      arrayDistPointer++;
    }
    
    if (altitudeArray != null && currentAltitude != null)
    {
      altitudeArray[arrayAltPointer % arrayAltPrecision] = currentAltitude;
      arrayAltPointer++;
    }
  }
  
  
  function getHeaderName(type)
  {
    if (type <= 100) { return GRunView.getHeaderName(type); }
    
    //if (type == OPTION_AMBIENT_PRESSURE) { return "PRES"; }
    //if (type == OPTION_AVERAGE_DISTANCE) { return "A DIST"; }
    //if (type == OPTION_BEARING) { return "BEAR"; }
    //if (type == OPTION_BEARING_FROM_START) { return "BEARS"; }
    //if (type == OPTION_CURRENT_HEADING) { return "HEAD"; }
    //if (type == OPTION_CURRENT_LOCATION) { return "LOC"; }
    //if (type == OPTION_DISTANCE_TO_DESTINATION) { return "DISTD"; }
    //if (type == OPTION_DISTANCE_TO_NEXT_POINT) { return "DISTN"; }
    //if (type == OPTION_ELAPSED_TIME) { return "TIME"; }
    //if (type == OPTION_ELEVATION_AT_DESTINATION) { return "ELVD"; }
    //if (type == OPTION_ELEVATION_AT_NEXT_POINT) { return "DELNP"; }
    //if (type == OPTION_ENERGY_EXPENDITURE) { return "NRG"; }
    //if (type == OPTION_FRONT_DERAILLEUR_INDEX) { return "DERI"; }
    //if (type == OPTION_FRONT_DERAILLEUR_MAX) { return "DERM"; }
    //if (type == OPTION_FRONT_DERAILLEUR_SIZE) { return "DERS"; }
    //if (type == OPTION_MAX_CADENCE) { return "MAX CAD"; }
    //if (type == OPTION_MAX_HEART_RATE) { return "MAX HR"; }
    if (type == OPTION_MAX_POWER) { return "MAX POW"; }
    //if (type == OPTION_MAX_SPEED) { return "MAX SPD"; }
    //if (type == OPTION_MEAN_SEA_LEVEL_PRESSURE) { return "SEA PRES"; }
    //if (type == OPTION_NAME_OF_DESTINATION) { return "DEST"; }
    //if (type == OPTION_NAME_OF_NEXT_POINT) { return "NEXT P"; }
    //if (type == OPTION_OFF_COURSE_DISTANCE) { return "DIST NP"; }
    //if (type == OPTION_RAW_AMBIENT_PRESSURE) { return "PRESS"; }
    //if (type == OPTION_REAR_DERAILLEUR_INDEX) { return "RDERI"; }
    //if (type == OPTION_REAR_DERAILLEUR_MAX) { return "RDERM"; }
    //if (type == OPTION_REAR_DERAILLEUR_SIZE) { return "RDERS"; }
    //if (type == OPTION_START_LOCATION) { return "S LOC"; }
    //if (type == OPTION_START_TIME) { return "S TIME"; }
    //if (type == OPTION_SWIM_STROKE_TYPE) { return "STK TYPE"; }
    //if (type == OPTION_SWIM_SWOLF) { return "SWOLF"; }
    //if (type == OPTION_TIMER_STATE) { return "TMR ST"; }
    //if (type == OPTION_TRACK) { return "TRACK"; }
    if (type == OPTION_AVERAGE_PACE_CUSTOM) { return "PACE(" + arrayDistPrecision + ")"; }
    if (type == OPTION_AVERAGE_SPEED_CUSTOM) { return "SPD(" + arrayDistPrecision + ")"; }
    if ( (type == OPTION_AVERAGE_VERTICAL_SPEED_MIN) || (type == OPTION_AVERAGE_VERTICAL_SPEED_HOUR) ) { return "V SPD(" + arrayAltPrecision + ")"; }
    if (type == OPTION_REQUIRED_SPEED_5K) { return "SPD 5K"; }
    if (type == OPTION_REQUIRED_SPEED_10K) { return "SPD 10K"; }
    if (type == OPTION_REQUIRED_SPEED_HALF_MARATHON) { return "SPD 21K"; }
    if (type == OPTION_REQUIRED_SPEED_MARATHON) { return "SPD 42K"; }
    if (type == OPTION_REQUIRED_SPEED_100K) { return "SPD 100K"; }
    if (type == OPTION_REQUIRED_PACE_LAP) { return "PACE LAP"; }
    if (type == OPTION_REQUIRED_SPEED_LAP) { return "SPD LAP"; }
    
    return "";
  }
  
  
  function getFormattedValue(id, type, value)
  {
    if (type <= 100) { return GRunView.getFormattedValue(id, type, value); }
    
    //if ( (type == OPTION_CURRENT_LOCATION) && (value instanceof Array) )
    //{
    //  return "[" + value[0].format("%.2f") + "," + value[1].format("%.2f") + "]";
    //}
    
    if (type == OPTION_AVERAGE_SPEED_CUSTOM ||
        type == OPTION_REQUIRED_SPEED_5K ||
        type == OPTION_REQUIRED_SPEED_10K ||
        type == OPTION_REQUIRED_SPEED_HALF_MARATHON ||
        type == OPTION_REQUIRED_SPEED_MARATHON ||
        type == OPTION_REQUIRED_SPEED_100K ||
        type == OPTION_REQUIRED_SPEED_LAP)
    {
      if (value < 10) { return value.format("%.2f"); }
      return value.format("%.1f");
    }
      
    if (type == OPTION_AVERAGE_PACE_CUSTOM ||
        type == OPTION_REQUIRED_PACE_LAP)
    {
      return formatDuration(value, false);
    }
    
    if (type == OPTION_AVERAGE_VERTICAL_SPEED_MIN ||
        type == OPTION_AVERAGE_VERTICAL_SPEED_HOUR)
    {
      return Math.round(value).format("%.0f");
    }
    
    return GRunView.getFormattedValue(id, type, value);
  }
  
  
  function getColor(type, value)
  {
    if (type == 14 /* OPTION_CURRENT_CADENCE */ ||
        type == 33 /* OPTION_AVERAGE_CADENCE */)
    {
      if (value <= 0) { return null; }
      if (value < (targetCadence - cadenceRange)) { return Graphics.COLOR_RED; } // 0x00AAFF
      if (value > (targetCadence + cadenceRange)) { return Graphics.COLOR_BLUE; } // 0xFF0000
      return Graphics.COLOR_DK_GREEN; // 0x00AA00
    }
    
    if (type <= 100) { return GRunView.getColor(type, value); }
    
    if (type == OPTION_AVERAGE_SPEED_CUSTOM)
    {
      if (value > 0) {
        type = OPTION_AVERAGE_PACE_CUSTOM;
        value = 1000 / (value / 3.6);
      }
    }
    
    if (type == OPTION_AVERAGE_PACE_CUSTOM)
    {
      if (value <= 0) { return null; }
      if (value < (targetPace - paceRange)) { return Graphics.COLOR_BLUE; }
      if (value > (targetPace + paceRange)) { return Graphics.COLOR_RED; }
      return Graphics.COLOR_DK_GREEN;
    }
    
    return null;
  }
}