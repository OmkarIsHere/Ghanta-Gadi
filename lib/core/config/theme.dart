import 'package:flutter/material.dart';

import '../constant/asset_constant.dart';

class MyTheme {

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    dividerColor: const Color(0xFFDCDCDC),
    fontFamily: AssetConstant.poppinsRegular,
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFFFF),
      foregroundColor: Color(0xFF000000),
      titleTextStyle: TextStyle(
          fontSize: 16,
          fontFamily: AssetConstant.poppinsSemiBold,
          color: Colors.black,
          letterSpacing: 1.3,
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, color: Colors.black, fontFamily: AssetConstant.poppinsSemiBold),
      displayMedium: TextStyle(fontSize: 28, color: Colors.black, fontFamily: AssetConstant.poppinsSemiBold),
      displaySmall: TextStyle(fontSize: 26, color: Colors.black, fontFamily: AssetConstant.poppinsSemiBold),
      headlineLarge: TextStyle(fontSize: 28, color: Colors.black, fontFamily: AssetConstant.poppinsMedium),
      headlineMedium: TextStyle(fontSize: 24, color: Colors.black, fontFamily: AssetConstant.poppinsSemiBold),
      headlineSmall: TextStyle(fontSize: 18, color: Colors.black, fontFamily: AssetConstant.poppinsSemiBold),
      titleLarge: TextStyle(fontSize: 20, color: Colors.black, fontFamily: AssetConstant.poppinsMedium),
      titleMedium: TextStyle(fontSize: 18, color: Colors.black, fontFamily: AssetConstant.poppinsMedium),
      titleSmall: TextStyle(fontSize: 16, color: Colors.black, fontFamily: AssetConstant.poppinsMedium),
      labelLarge: TextStyle(fontSize: 16, color: Colors.black, fontFamily: AssetConstant.poppinsRegular),
      labelMedium: TextStyle(fontSize: 14, color: Colors.black, fontFamily: AssetConstant.poppinsRegular),
      labelSmall: TextStyle(fontSize: 12, color: Colors.black, fontFamily: AssetConstant.poppinsRegular),
      bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFA4A4A4)),
      bodySmall: TextStyle(fontSize: 12, color: Color(0xFFA4A4A4)),
    ),
    colorScheme: const ColorScheme.light(
        brightness: Brightness.light,
        primary: Color(0xff2ee400),
        secondary: Color(0xff696a68),
        tertiary: Color(0xFF908D9A),
        primaryContainer: Color(0xFFD6E8F1),
        secondaryContainer: Color(0xFFE3E3E3),
        tertiaryContainer: Color(0xFFF7F7FC),
        onTertiary: Color(0xFF919191),
        scrim: Color(0xFF54e4e2),
        shadow: Color(0xFFDEDEDE),
        outline: Color(0xFFD5D5D5),
        error: Color(0xFFC90202)
    ),
    useMaterial3: true,
  );

}
