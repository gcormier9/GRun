using Toybox.Application;
using Toybox.Graphics;
import Toybox.Lang;


class GRunApp extends Application.AppBase
{
  protected var gRunView;
  
  function initialize()
  {
    //System.println("Garmin Approach S70 & Descent Mk3 (High Memory)");
    AppBase.initialize();
    gRunView = new GRunViewHighMem();
  }
  
  
  public static function getTextDimensions(dc, value, font) as [Number, Number]
  {
    var textDimensions = dc.getTextDimensions(value, font) as [Number, Number];
    
    if (font <= 4) { textDimensions[0] += 1; }
    else { textDimensions[0] -= 5; }
    
    var yFactor = 1.65;
    textDimensions[1] = textDimensions[1] - (yFactor * dc.getFontDescent(font)).toNumber();
    
    return textDimensions;
  }
  
  
  public static function getYOffset(font)
  {
    var yOffset = -2;
    if (font >= 7) { yOffset = 1; }
    else if (font >= 5) { yOffset = 0; }
    else if (font >= 4) { yOffset = -2; }
    else if (font >= 3) { yOffset = -3; }
    else if (font >= 2) { yOffset = -2; }
    else if (font >= 1) { yOffset = -3; }
    
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