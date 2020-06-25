using Toybox.Application;
using Toybox.Graphics;


class GRunApp extends Application.AppBase
{
  protected var gRunView;
  
  function initialize()
  {
    //System.println("Garmin Edge130 (Low Memory)");
    AppBase.initialize();
    gRunView = new GRunView();
  }
  
  
  public static function getTextDimensions(dc, value, font)
  {
    var textDimensions = dc.getTextDimensions(value, font);
    
    if (font < 7) { textDimensions[0] += 2; }
    textDimensions[1] = textDimensions[1] - (1.35 * dc.getFontDescent(font));
    
    return textDimensions;
  }
  
  
  public static function getYOffset(font)
  {
    var yOffset = -1;
    if (font >= 7) { yOffset = 2; }
    else if (font >= 5) { yOffset = 0; }
    else if (font >= 4) { yOffset = -2; }
        
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