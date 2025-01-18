import 'package:flutter/material.dart';
import 'package:shop_app/styles/colors.dart';

ThemeData theme = ThemeData(
primarySwatch: MaterialColor(
defaultColor.value,
<int, Color>{
  50: defaultColor.withOpacity(0.1),
  100: defaultColor.withOpacity(0.2),
  200: defaultColor.withOpacity(0.3),
  300: defaultColor.withOpacity(0.4),
  400: defaultColor.withOpacity(0.5),
  500: defaultColor.withOpacity(0.6),
  600: defaultColor.withOpacity(0.7),
  700: defaultColor.withOpacity(0.8),
  800: defaultColor.withOpacity(0.9),
  900: defaultColor.withOpacity(1.0),
}),
 scaffoldBackgroundColor: Colors.white,

  appBarTheme: AppBarTheme(

    titleSpacing: 20.0,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    elevation: 0.0,
    titleTextStyle: TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
  ),

) ;
