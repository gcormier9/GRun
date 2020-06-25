using Toybox.Application;
using Toybox.Graphics;


class GRunApp extends Application.AppBase
{
  protected var gRunView;
  
  function initialize()
  {
    //System.println("Garmin Oregon/Rino 7xx (High Memory)");
    AppBase.initialize();
    gRunView = new GRunViewHighMem();
  }
  
  
  public static function getTextDimensions(dc, value, font)
  {
    var textDimensions = dc.getTextDimensions(value, font);
    
    if (font < 7) { textDimensions[0] += 2; }
    
    var yPixel = 2;
    if (font < 5) { yPixel = 0; }
    textDimensions[1] = textDimensions[1] - dc.getFontDescent(font) + yPixel;
    
    return textDimensions;
  }
  
  
  public static function getYOffset(font)
  {
    var yOffset = -2;
    if (font >= 8) { yOffset = 4; }
    else if (font >= 7) { yOffset = 2; }
    else if (font >= 5) { yOffset = 2; }
    else if (font >= 4) { yOffset = -1; }    
        
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