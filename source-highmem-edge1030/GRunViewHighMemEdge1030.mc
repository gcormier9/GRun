using Toybox.WatchUi;


class GRunViewHighMemEdge1030 extends GRunViewHighMem
{
  function initialize()
  {
    GRunViewHighMem.initialize();
  }
  
  function getFont(dc, type, value, maxWidth, maxHeight)
  {
    var fontID = Graphics.FONT_NUMBER_THAI_HOT;
    var textDimension;
    if (type == 1 /* OPTION_CURRENT_TIME */ || type == 37 /* OPTION_CURRENT_LOCATION */) { fontID = Graphics.FONT_LARGE; }
    
    while (fontID > 0)
    {
      textDimension = dc.getTextDimensions(value, fontID);
      
      // Edge 1030
      if (textDimension[0] <= maxWidth && textDimension[1] <= maxHeight) { return fontID; }
      fontID--;
    }
    
    return Graphics.FONT_XTINY;
  }
}