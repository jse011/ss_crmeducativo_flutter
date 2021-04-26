import 'dart:ui';

class HexColor extends Color {
  HexColor(final String? hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String? hexColor) {
    if(hexColor!=null){
      hexColor = hexColor.toUpperCase().replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF' + hexColor;
      }
      int i  = int.parse(hexColor, radix: 16);
      print("_getColorFromHex: "+i.toString());
      return i;
    }
    return 0xFF000000;//negro

  }
}