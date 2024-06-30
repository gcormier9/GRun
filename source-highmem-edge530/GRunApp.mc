using Toybox.Application;
using Toybox.Graphics;
import Toybox.Lang;


class GRunApp extends Application.AppBase
{
  protected var gRunView;
  
  function initialize()
  {
    //System.println("Garmin Edge 530 (High Memory)");
    AppBase.initialize();
    gRunView = new GRunViewHighMem();
  }
  
  
  public static function getTextDimensions(dc, value, font) as [Number, Number]
  {
    var textDimensions = dc.getTextDimensions(value, font) as [Number, Number];
    
    if (font < 7) { textDimensions[0] += 2; }
    textDimensions[1] = (0.8 * textDimensions[1]).toNumber();
    if (font == 4) { textDimensions[1] -= 4; }
    
    return textDimensions;
  }
  
  
  public static function getYOffset(font)
  {
    var yOffset = -1;
    if (font >= 8) { yOffset = 5; }
    else if (font >= 7) { yOffset = 4; }
    else if (font >= 6) { yOffset = 2; }
    else if (font >= 5) { yOffset = 1; }
    else if (font >= 4) { yOffset = -1; }
    else if (font >= 3) { yOffset = -2; }
    else if (font == 0) { yOffset = -2; }
    
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