using Toybox.Application;
using Toybox.Graphics;


class GRunApp extends Application.AppBase
{
  protected var gRunView;
  
  function initialize()
  {
    //System.println("Garmin Edge 520 Plus / 820 (High Memory)");
    AppBase.initialize();
    gRunView = new GRunViewHighMem();
  }
  
  
  public static function getTextDimensions(dc, value, font)
  {
    var textDimensions = dc.getTextDimensions(value, font);
    
    if (font < 7) { textDimensions[0] += 2; }
    textDimensions[1] = 0.8 * textDimensions[1];
    
    return textDimensions;
  }
  
    
  public static function getYOffset(font)
  {
    var yOffset = 1;
    if (font == 4) { yOffset = -2; }
    else if (font == 1) { yOffset = -3; }
    else if (font <= 3) { yOffset = -2; }
    else if (font >= 7) { yOffset = 2; }
    
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