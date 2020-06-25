using Toybox.Application;
using Toybox.Graphics;


class GRunApp extends Application.AppBase
{
  protected var gRunView;
  
  function initialize()
  {
    //System.println("Garmin (High Memory)");
    AppBase.initialize();
    gRunView = new GRunViewHighMem();
  }
    
  
  public static function getTextDimensions(dc, value, font)
  {
    var textDimensions = dc.getTextDimensions(value, font);
    
    // D2 Charlie
    // D2 Delta
    // D2 Delta PX
    // D2 Delta S
    // Descent Mk1
    // Fenix 5 Plus
    // Fenix 5S Plus
    // Fenix 5X
    // Fenix 5X Plus
    var yPixel = 5;
    if (font < 7)
    {
      textDimensions[0] += 2;
      
      if (font < 5) { yPixel = 4; }
      else { yPixel = 3; }
    }
    
    textDimensions[1] = textDimensions[1] - (2 * dc.getFontDescent(font)) + yPixel;
    return textDimensions;
  }
  
  
  public static function getYOffset(font)
  {
    // D2 Charlie
    // D2 Delta
    // D2 Delta PX
    // D2 Delta S
    // Descent Mk1
    // Fenix 5 Plus
    // Fenix 5S Plus
    // Fenix 5X
    // Fenix 5X Plus
    var yOffset = -1;
    if (font == 2) { yOffset = -2; }
    
    return yOffset;
  }

  
  function onSettingsChanged()
  {
    AppBase.onSettingsChanged();
    gRunView.initializeUserData();
  }
  

  function getInitialView()
  {
    return [ gRunView ];
  }
}