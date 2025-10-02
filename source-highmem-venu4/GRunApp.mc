using Toybox.Application;
using Toybox.Graphics;
import Toybox.Lang;


class GRunApp extends Application.AppBase
{
  protected var gRunView;
  
  function initialize()
  {
    //System.println("Garmin Venu4 (High Memory)");
    AppBase.initialize();
    gRunView = new GRunViewHighMem();
  }
  
  
  public static function getTextDimensions(dc, value, font) as [Number, Number]
  {
    var textDimensions = dc.getTextDimensions(value, font) as [Number, Number];
    
    if (font >= 7)
    {
        textDimensions[0] -= 5;
        textDimensions[1] = textDimensions[1] - (0.1 * dc.getFontDescent(font)).toNumber();
    }
    
    else if (font <= 1) { textDimensions[0] += 2; }
    textDimensions[1] = textDimensions[1] - (1.6 * dc.getFontDescent(font)).toNumber();
    
    return textDimensions;
  }
  
  
  public static function getYOffset(font)
  {
    var yOffset = 0;
    if (font >= 7) { yOffset = 2; }
    else if (font >= 5) { yOffset = 1; }
    else if (font == 4) { yOffset = -1; }
    
    else if (font == 2) { yOffset = -1; }
    
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