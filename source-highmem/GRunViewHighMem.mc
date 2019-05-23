using Toybox.WatchUi;

const CONVERSION_KM_TO_MILE = 0.62137119;
const CONVERSION_MILE_TO_KM = 1.609344;
const CONVERSION_METER_TO_FEET = 3.28084;

class GRunViewHighMem extends GRunView
{
  enum {
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
  }


  function initialize()
  {
    GRunView.initialize(0);
  }

  
  function computeValue(info, id, value, valueData)
  {
    if (value <= 28 /* OPTION_TRAINING_EFFECT */) { return GRunView.computeValue(info, id, value, valueData); }
    
    /*
    // Ambient pressure in Pascals (Pa).
    if ( (value == OPTION_AMBIENT_PRESSURE) && (info.ambientPressure  != null) )
    {
      return info.ambientPressure;
    }
    
    // Average cadence during the current activity in revolutions per minute (rpm)
    if ( (value == OPTION_AVERAGE_CADENCE) && (info.averageCadence != null) )
    {
      return info.averageCadence;
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

    // Average power during the current activity in Watts (W)
    if ( (value == OPTION_AVERAGE_POWER) && (info.averagePower != null) ) 
    {
      return info.averagePower;
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
    
    // Current power in Watts (W)
    if ( (value == OPTION_CURRENT_POWER) && (info.currentPower != null) )
    {
      return info.currentPower;
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

    // Maximum power recorded during the current activity in Watts (W)
    if ( (value == OPTION_MAX_POWER) && (info.maxPower != null) )
    {
      return info.maxPower;
    }
    
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
    
    return valueData;
  }
  
  
  function getHeaderName(type)
  {
    if (type <= 28 /* OPTION_TRAINING_EFFECT */) { return GRunView.getHeaderName(type); }
    /*
    switch (type)
    {
      case OPTION_AMBIENT_PRESSURE:
        return "PRES";

      case OPTION_AVERAGE_CADENCE:
        return "A CAD";

      case OPTION_AVERAGE_DISTANCE:
        return "A DIST";

      case OPTION_AVERAGE_POWER:
        return "A POW";

      case OPTION_BEARING:
        return "BEAR";

      case OPTION_BEARING_FROM_START:
        return "BEARS";

      case OPTION_CURRENT_HEADING:
        return "HEAD";

      case OPTION_CURRENT_LOCATION:
        return "LOC";

      case OPTION_CURRENT_POWER:
        return "POW";

      case OPTION_DISTANCE_TO_DESTINATION:
        return "DISTD";

      case OPTION_DISTANCE_TO_NEXT_POINT:
        return "DISTN";

      case OPTION_ELAPSED_TIME:
        return "TIME";

      case OPTION_ELEVATION_AT_DESTINATION:
        return "ELVD";

      case OPTION_ELEVATION_AT_NEXT_POINT:
        return "DELNP";

      case OPTION_ENERGY_EXPENDITURE:
        return "NRG";

      case OPTION_FRONT_DERAILLEUR_INDEX:
        return "DERI";

      case OPTION_FRONT_DERAILLEUR_MAX:
        return "DERM";

      case OPTION_FRONT_DERAILLEUR_SIZE:
        return "DERS";

      case OPTION_MAX_CADENCE:
        return "MAX CAD";

      case OPTION_MAX_HEART_RATE:
        return "MAX HR";

      case OPTION_MAX_POWER:
        return "MAX POW";

      case OPTION_MAX_SPEED:
        return "MAX SPD";

      case OPTION_MEAN_SEA_LEVEL_PRESSURE:
        return "SEA PRES";

      case OPTION_NAME_OF_DESTINATION:
        return "DEST";

      case OPTION_NAME_OF_NEXT_POINT:
        return "NEXT P";

      case OPTION_OFF_COURSE_DISTANCE:
        return "DIST NP";

      case OPTION_RAW_AMBIENT_PRESSURE:
        return "PRESS";

      case OPTION_REAR_DERAILLEUR_INDEX:
        return "RDERI";

      case OPTION_REAR_DERAILLEUR_MAX:
        return "RDERM";

      case OPTION_REAR_DERAILLEUR_SIZE:
        return "RDERS";

      case OPTION_START_LOCATION:
        return "S LOC";

      case OPTION_START_TIME:
        return "S TIME";

      case OPTION_SWIM_STROKE_TYPE:
        return "STK TYPE";

      case OPTION_SWIM_SWOLF:
        return "SWOLF";

      case OPTION_TIMER_STATE:
        return "TMR ST";

      case OPTION_TRACK:
        return "TRACK";
    }
    */
    return "";
  }
  
  function getFormattedValue(id, type, value)
  {
    /*
    switch (type)
    {
      case OPTION_CURRENT_LOCATION:
        if (value instanceof Array) {
          return "[" + value[0].format("%.2f") + "," + value[1].format("%.2f") + "]";
        }
    }
    */
    
    return GRunView.getFormattedValue(id, type, value);
  }
}