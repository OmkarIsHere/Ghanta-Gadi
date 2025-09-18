import 'package:flutter/material.dart' show BuildContext, MediaQuery,ColorScheme, ThemeData, Theme, TextTheme;

extension Values on BuildContext {
  double get mqWidth => MediaQuery.sizeOf(this).width;
  double get mqHeight => MediaQuery.sizeOf(this).height;
  ColorScheme get color => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
  ThemeData get themeData => Theme.of(this);
}