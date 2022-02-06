using Toybox.Application;
using Toybox.Graphics;


class GRunApp extends Application.AppBase
{
  protected var gRunView;
  
  function initialize()
  {
    //System.println("Garmin Venu2 (High Memory)");
    AppBase.initialize();
    gRunView = new GRunViewHighMem();
  }
  
  
  public static function getTextDimensions(dc, value, font)
  {
    var textDimensions = dc.getTextDimensions(value, font);
    
    if (font <= 4) { textDimensions[0] += 1; }
    
    var yFactor = 1.7;
    if (font == 6) { yFactor = 1.6; }
    else if (font == 5) { yFactor = 1.6; }
    else if (font < 5) { yFactor = 1.55; }
    textDimensions[1] = textDimensions[1] - (yFactor * dc.getFontDescent(font));
    
    return textDimensions;
  }
  
  
  public static function getYOffset(font)
  {
    var yOffset = -2;
    if (font >= 7) { yOffset = 1; }
    if (font == 6) { yOffset = -1; }
    if (font == 5) { yOffset = 0; }
    
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