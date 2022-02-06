using Toybox.Application;
using Toybox.Graphics;


class GRunApp extends Application.AppBase
{
  protected var gRunView;
  
  function initialize()
  {
    //System.println("Garmin Fenix 7/7x (High Memory)");
    AppBase.initialize();
    gRunView = new GRunViewHighMem();
  }
  
  
  public static function getTextDimensions(dc, value, font)
  {
    var textDimensions = dc.getTextDimensions(value, font);
    
    if (font <= 4) { textDimensions[0] += 1; }
    
    var yFactor = 1.65;
    if (font < 5) { yFactor = 1.4; }
    textDimensions[1] = textDimensions[1] - (yFactor * dc.getFontDescent(font));
    
    return textDimensions;
  }
  
  
  public static function getYOffset(font)
  {
    var yOffset = -1;
    if (font >= 8) { yOffset = 1; }
    else if (font >= 6) { yOffset = 0; }
    else if (font >= 4) { yOffset = -1; }
    else if (font >= 3) { yOffset = -2; }
    else if (font <= 1) { yOffset = -2; }
    
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