using Toybox.WatchUi;


class GRunViewHighMemEdge520Plus extends GRunViewHighMem
{
  function initialize()
  {
    GRunViewHighMem.initialize();
  }
  
  function getFont(dc, type, value, maxWidth, maxHeight)
  {
    var fontID = Graphics.FONT_NUMBER_THAI_HOT;
    var textDimension;
    if (type == 1 /* OPTION_CURRENT_TIME */ || type == 108 /* OPTION_CURRENT_LOCATION */) { fontID = Graphics.FONT_LARGE; }
    
    while (fontID > 0)
    {
      textDimension = dc.getTextDimensions(value, fontID);
      
      // Edge 520 Plus
      var unusedHeight = dc.getFontDescent(fontID);
      if (unusedHeight > 8) { unusedHeight = unusedHeight / 3; }
      textDimension[1] = textDimension[1] - unusedHeight;
      
      if (textDimension[0] <= maxWidth && textDimension[1] <= maxHeight) { return fontID; }
      fontID--;
    }
    
    return Graphics.FONT_XTINY;
  }
}