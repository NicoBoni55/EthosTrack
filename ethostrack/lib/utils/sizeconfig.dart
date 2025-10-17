import 'package:flutter/material.dart';

class Sizeconfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late double textScaleFactor;
  static late Orientation orientation;

  // Tamaño base de diseño (Medidas estandar)
  static const double DESIGN_WIDTH = 375;
  static const double DESIGN_HEIGHT = 812;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    textScaleFactor = _mediaQueryData.textScaleFactor;

    // default size (2.4% del ancho de pantalla)
    defaultSize = screenWidth * 0.024;
  }

  // Obtener ancho adaptativo
  static double width(double width) {
    double screenWidth = Sizeconfig.screenWidth;
    // Convertimos el ancho a un porcentaje de la pantalla
    return(width / DESIGN_WIDTH) * screenWidth;
  }

  // Obtener alto adaptativo
  static double height(double height) {
    double screenHeight = Sizeconfig.screenHeight;
    // Convertimos el alto a un porcentaje de la pantalla
    return(height / DESIGN_HEIGHT) * screenHeight;
  }

  // Obtener tamaño de fuente adaptativo
  static double textScale(double size) {
    return width(size) * textScaleFactor;
  }

  // Obtenemos padding/margin adaptativo
  static EdgeInsets padding({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
    double? all,
  }) {
    if (all != null) {
      return EdgeInsets.all(width(all));
    }
    return EdgeInsets.only(
      left: width(left),
      top: height(top),
      right: width(right),
      bottom: height(bottom),
    );
  }

  // Obtenemos padding/margin simetrico adaptativo
  static EdgeInsets symmetric({
    double horizontal = 0,
    double vertical = 0,
  }) {
    return EdgeInsets.symmetric(
      horizontal: width(horizontal),
      vertical: height(vertical),     
    );
  }

  // Verificar tipo de dispositivo
  static bool isTablet() => screenWidth >= 600;
  static bool isPhone() => screenWidth < 600;
  static bool isSmallPhone() => screenWidth < 360;
}