using Toybox.Application;
using Toybox.Graphics;
import Toybox.Lang;


class GRunApp extends Application.AppBase
{
  protected var gRunView;
  
  function initialize()
  {
    //System.println("Garmin Edge 540 (High Memory)");
    AppBase.initialize();
    gRunView = new GRunViewHighMem();
  }
  
  
  public static function getTextDimensions(dc, value, font) as [Number, Number]
  {
    var textDimensions = dc.getTextDimensions(value, font) as [Number, Number];
    
    if (font < 7) { textDimensions[0] += 2; }

    if (font > 4) { textDimensions[1] = (0.75 * textDimensions[1]).toNumber(); }
    else if (font == 4) { textDimensions[1] = (0.85 * textDimensions[1]).toNumber(); }
    //if (font == 4) { textDimensions[1] -= 4; }
    
    return textDimensions;
  }
  
  
  public static function getYOffset(font)
  {
    var yOffset = 0;

    if (font >= 5) { yOffset = 0; }
    else if (font >= 4) { yOffset = 3; }
    else if (font >= 1) { yOffset = 1; }
    
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