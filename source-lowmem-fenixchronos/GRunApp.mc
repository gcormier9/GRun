using Toybox.Application;
using Toybox.Graphics;


class GRunApp extends Application.AppBase
{
  protected var gRunView;
  
  function initialize()
  {
    //System.println("Garmin Fenix Chronos (Low Memory)");
    AppBase.initialize();
    gRunView = new GRunView();
  }
  
  
  public static function getTextDimensions(dc, value, font)
  {
    var textDimensions = dc.getTextDimensions(value, font);
    
    var yPixel = 5;
    if (font < 7) {
      textDimensions[0] += 2;
      
      if (font < 5) { yPixel = 4; }
      else { yPixel = 3; }
    }
    textDimensions[1] = textDimensions[1] - (2 * dc.getFontDescent(font)) + yPixel;
    
    return textDimensions;
  }
  
  
  function getYOffset(font)
  {
    var yOffset = -1;
    if (font <= 3) { yOffset = -2; }
    
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