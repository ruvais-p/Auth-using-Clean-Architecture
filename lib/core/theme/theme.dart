import 'package:blogapp/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: color,
          width: 3,
        ));
  }

  static final darkThemeMode = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppPallete.backgroundColor,
      chipTheme: const ChipThemeData(
        color: MaterialStatePropertyAll(AppPallete.backgroundColor),
        side: BorderSide.none,
      ),
      inputDecorationTheme: InputDecorationTheme(
          enabledBorder: _border(),
          errorBorder: _border(AppPallete.errorColor),
          focusedBorder: _border(AppPallete.gradient2),
          border: _border()));
}
