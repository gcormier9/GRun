using Toybox.Application;
using Toybox.Graphics;
import Toybox.Lang;


class GRunApp extends Application.AppBase
{
  protected var gRunView;
  
  function initialize()
  {
    //System.println("Garmin Edge 1050 (High Memory)");
    AppBase.initialize();
    gRunView = new GRunViewHighMem();
  }
  
  
  public static function getTextDimensions(dc, value, font) as [Number, Number]
  {
    var textDimensions = dc.getTextDimensions(value, font) as [Number, Number];
    
    if (font < 7) { textDimensions[0] += 2; }

    if (font > 4) { textDimensions[1] = (0.7 * textDimensions[1]).toNumber(); }
    else if (font == 4) { textDimensions[1] = (0.85 * textDimensions[1]).toNumber(); }
    else { textDimensions[1] = (0.9 * textDimensions[1]).toNumber(); }
    
    return textDimensions;
  }
  
  
  public static function getYOffset(font)
  {
    var yOffset = -1;
    if (font >= 8) { yOffset = 3; }
    else if (font >= 7) { yOffset = 2; }
    else if (font >= 6) { yOffset = 1; }
    else if (font >= 5) { yOffset = 1; }
    else if (font >= 4) { yOffset = 7; }
    else if (font >= 1) { yOffset = 4; }
    else if (font == 0) { yOffset = 2; }
    
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