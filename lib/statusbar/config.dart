import 'package:flutter/material.dart';

const MaterialColor primary = MaterialColor(primaryPrimaryValue, <int, Color>{
  50: Color(0xFFFFFDE4),
  100: Color(0xFFFFFABC),
  200: Color(0xFFFFF78F),
  300: Color(0xFFFFF362),
  400: Color(0xFFFFF141),
  500: Color(primaryPrimaryValue),
  600: Color(0xFFFFEC1B),
  700: Color(0xFFFFE917),
  800: Color(0xFFFFE712),
  900: Color(0xFFFFE20A),
});
const int primaryPrimaryValue = 0xFFFFEE1F;

const primaryAccentValue = MaterialColor(primaryPrimaryValue, <int, Color>{
  100: Color(0xFFFFFFFF),
  200: Color(primaryPrimaryValue),
  400: Color(0xFFFFF7C2),
  700: Color(0xFFFFF4A8),
});

class TBThemeVars {
  static const primaryColor = primary;
  static const accentColor = Colors.black;
}

final lightTheme = ThemeData.light().copyWith(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: TBThemeVars.primaryColor,
    accentColor: TBThemeVars.accentColor,
  ),
  primaryColor: TBThemeVars.primaryColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStateProperty.all(0),
    ),
  ),
);
final darkTheme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: TBThemeVars.primaryColor,
    accentColor: TBThemeVars.accentColor,
  ),
  primaryColor: TBThemeVars.primaryColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStateProperty.all(0),
    ),
  ),
);
