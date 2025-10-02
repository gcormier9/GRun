using Toybox.Application;
using Toybox.Graphics;
import Toybox.Lang;


class GRunApp extends Application.AppBase
{
  protected var gRunView;
  
  function initialize()
  {
    //System.println("Garmin Instinct 3 (High Memory)");
    AppBase.initialize();
    gRunView = new GRunViewHighMem();
  }
    
  
  public static function getTextDimensions(dc, value, font) as [Number, Number]
  {
    var textDimensions = dc.getTextDimensions(value, font) as [Number, Number];
    
    if (font > 4) { 
      textDimensions[1] = textDimensions[1] - (2.1 * dc.getFontDescent(font)).toNumber();
    } else {
      textDimensions[1] = textDimensions[1] - (1.5 * dc.getFontDescent(font)).toNumber();
    }

    return textDimensions;
  }
  
  
  public static function getYOffset(font)
  {
    var yOffset = -7;

    if (font == 6) { yOffset = -6; }
    else if (font == 5) { yOffset = -6; }
    else if (font == 4) { yOffset = -3; }
    else if (font < 4) { yOffset = -2; }
    
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