using Toybox.Application;
using Toybox.Graphics;


class GRunApp extends Application.AppBase
{
  protected var gRunView;
  
  function initialize()
  {
    //System.println("Garmin Fr265s (High Memory)");
    AppBase.initialize();
    gRunView = new GRunView();
  }
  
  
  public static function getTextDimensions(dc, value, font)
  {
    var textDimensions = dc.getTextDimensions(value, font);
    
    var yFactor = 1.65;
    if (font > 5) { yFactor = 1.75; }
    if (font < 2) { yFactor = 1.4; }
    textDimensions[1] = textDimensions[1] - (yFactor * dc.getFontDescent(font)) + 2;
    
    return textDimensions;
  }
    
  
  public static function getYOffset(font)
  {
    var yOffset = 1;
    if (font == 0) { yOffset = -1; }
    
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