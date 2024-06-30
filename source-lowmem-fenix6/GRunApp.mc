using Toybox.Application;
using Toybox.Graphics;
import Toybox.Lang;


class GRunApp extends Application.AppBase
{
  protected var gRunView;
  
  function initialize()
  {
    //System.println("Garmin Fenix 6 (Low Memory)");
    AppBase.initialize();
    gRunView = new GRunView();
  }
  
  
  public static function getTextDimensions(dc, value, font) as [Number, Number]
  {
    var textDimensions = dc.getTextDimensions(value, font) as [Number, Number];
    
    if (font < 7) { textDimensions[0] += 2; }
    
    var yFactor = 1.65;
    if (font < 5) { yFactor = 1.45; }
    textDimensions[1] = textDimensions[1] - (yFactor * dc.getFontDescent(font)).toNumber();
    
    return textDimensions;
  }
  
  
  public static function getYOffset(font)
  {
    // Fenix6
    var yOffset = -2;
    if (font >= 8) { yOffset = 1; }
    else if (font >= 6) { yOffset = 0; }
    else if (font >= 5) { yOffset = -1; }
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