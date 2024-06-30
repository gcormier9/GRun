using Toybox.Application;
using Toybox.Graphics;
import Toybox.Lang;


class GRunApp extends Application.AppBase
{
  protected var gRunView;
  
  function initialize()
  {
    //System.println("Garmin Fr165 (High Memory)");
    AppBase.initialize();
    gRunView = new GRunView();
  }
  
  
  public static function getTextDimensions(dc, value, font) as [Number, Number]
  {
    var textDimensions = dc.getTextDimensions(value, font) as [Number, Number];
    
    var yFactor = 1.65;
    if (font > 5) { 
      textDimensions[0] *= 0.98;
      yFactor = 1.7;
    }

    if (font < 2) { yFactor = 1.4; }
    textDimensions[1] = textDimensions[1] - (yFactor * dc.getFontDescent(font)).toNumber() + 2;
    
    return textDimensions;
  }
    

  public static function getYOffset(font)
  {
    var yOffset = 0;
    if (font >= 7) { yOffset = 1; }
    else if (font == 0) { yOffset = 0; }    
    else if (font <= 3) { yOffset = -1; }
    
    
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