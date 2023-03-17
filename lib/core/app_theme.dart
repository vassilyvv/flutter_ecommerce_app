import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const themeColor = Color(0xFFf16b26);

class AppTheme {
  const AppTheme._();

  static ThemeData lightAppTheme = ThemeData(
    primaryColor: themeColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        backgroundColor: themeColor,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: themeColor),
      focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: themeColor))),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          foregroundColor: themeColor, textStyle: GoogleFonts.nunitoSans()),
    ),
    iconTheme: const IconThemeData(color: themeColor),
    textTheme: GoogleFonts.nunitoSansTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
  );
}
