using Toybox.Application;
using Toybox.Graphics;
import Toybox.Lang;


class GRunApp extends Application.AppBase
{
  protected var gRunView;
  
  function initialize()
  {
    //System.println("Garmin Marvel/Rey (Low Memory)");
    AppBase.initialize();
    gRunView = new GRunView();
  }
  
  public static function getTextDimensions(dc, value, font) as [Number, Number]
  {
    var textDimensions = dc.getTextDimensions(value, font) as [Number, Number];
    
    var yFactor = 1.9;
    if (font < 7)
    {
      textDimensions[0] += 2;
      
      if (font < 5) { yFactor = 1.4; }
      else { yFactor = 1.6; }
    }
    
    textDimensions[1] = textDimensions[1] - (yFactor * dc.getFontDescent(font)).toNumber();
    return textDimensions;
  }
  
  
  public static function getYOffset(font)
  {
    var yOffset = -2;
    if (font >= 7) { yOffset = -4; }
    else if (font < 3 && font > 0) { yOffset = -1; }
    
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