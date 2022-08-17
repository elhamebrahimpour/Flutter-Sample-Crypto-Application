import 'package:crypto_v1/data/constants/color_constants.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  //declare a variable of a selectedTheme
  ThemeData? _selectedTheme;

  ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: whiteColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        maximumSize: Size(240, 70),
        primary: darkTeal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        textStyle: TextStyle(
          color: whiteColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    textTheme: TextTheme(
      subtitle1: TextStyle(color: blackColor, fontSize: 16),
      subtitle2: TextStyle(color: darkGreyColor, fontSize: 14),
      headline1: TextStyle(
          color: blackColor, fontSize: 20.0, fontWeight: FontWeight.w700),
    ),
  );

  ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: blackColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        maximumSize: Size(240, 70),
        primary: darkTeal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        textStyle: TextStyle(
          color: whiteColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    textTheme: TextTheme(
      subtitle1: TextStyle(color: whiteColor, fontSize: 16),
      subtitle2: TextStyle(color: lightGreyColor, fontSize: 14),
      headline1: TextStyle(
          color: lightTeal, fontSize: 20.0, fontWeight: FontWeight.w700),
    ),
  );

  ThemeProvider({required bool isDarkMode}) {
    _selectedTheme = isDarkMode ? darkTheme : lightTheme;
  }

  void swapTheme() {
    _selectedTheme = _selectedTheme == darkTheme ? lightTheme : darkTheme;
    notifyListeners();
  }

  ThemeData get getTheme => _selectedTheme!;
}
