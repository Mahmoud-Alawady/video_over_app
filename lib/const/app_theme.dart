import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_over_app/const/app_colors.dart';

abstract class AppTheme {
  static ThemeData get lightTheme {
    final foregroundColor = Colors.black;
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: AppColors.backgroundColor,
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.backgroundColor,
        scrimColor: Colors.black.withAlpha(126),
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.backgroundColor,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.backgroundColor,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: AppColors.backgroundColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.backgroundColor,
        selectedItemColor: foregroundColor,
        elevation: 0,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: foregroundColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(foregroundColor: foregroundColor),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(foregroundColor: foregroundColor),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        splashColor: Color(0x22000000),
        backgroundColor: AppColors.white,
        foregroundColor: Colors.black,
        elevation: 3,
      ),
    );
  }

  static ThemeData get darkTheme {
    final foregroundColor = Colors.white;
    final background = Colors.black;
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: background,
      drawerTheme: DrawerThemeData(
        backgroundColor: background,
        scrimColor: Colors.white.withAlpha(30),
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: background,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: background,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        backgroundColor: background,
        surfaceTintColor: background,
        iconTheme: IconThemeData(color: foregroundColor),
        titleTextStyle: TextStyle(
          color: foregroundColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: background,
        selectedItemColor: foregroundColor,
        unselectedItemColor: AppColors.grey3,
        elevation: 0,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: foregroundColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(foregroundColor: foregroundColor),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(foregroundColor: foregroundColor),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        splashColor: Color(0x22FFFFFF),
        backgroundColor: AppColors.primary,
        foregroundColor: foregroundColor,
        elevation: 3,
      ),
    );
  }

  static TextStyle get searchHintTextTheme {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.grey3,
    );
  }

  static BoxShadow get lightShadow {
    return BoxShadow(
      color: Color(0x0A000000),
      offset: const Offset(2, 2),
      spreadRadius: 2,
      blurRadius: 10,
    );
  }

  static BoxShadow get extraLightShadow {
    return BoxShadow(
      color: Color(0x03000000),
      offset: const Offset(2, 2),
      spreadRadius: 2,
      blurRadius: 10,
    );
  }

  static BoxShadow get heavyShadow {
    return BoxShadow(
      color: Color(0x0F000000),
      offset: const Offset(0, 18),
      spreadRadius: 4,
      blurRadius: 16,
    );
  }

  static TextStyle get titleTextStyle {
    return TextStyle(
      fontSize: 14,
      color: AppColors.black,
      fontWeight: FontWeight.w800,
    );
  }

  static TextStyle get subtitleTextStyle {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.primary,
    );
  }

  static InputDecoration textfieldTheme({
    Widget? suffixIcon,
    Widget? prefixIcon,
    String? hint,
    Color? focusedColor = AppColors.logo2,
    Color? unFocusedColor,
    Color? backgroundColor = AppColors.white,
    TextDirection? hintTextDirection,
  }) {
    final radius = BorderRadius.circular(12);
    final borderSide = BorderSide(
      color: unFocusedColor ?? AppColors.backgroundColor,
      width: 2,
    );

    return InputDecoration(
      isDense: true,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      hintText: hint,
      hintTextDirection: hintTextDirection,

      fillColor: backgroundColor,
      filled: backgroundColor != null,
      hintStyle: TextStyle(
        fontWeight: FontWeight.normal,
        color: Color(0x88888888),
      ),

      // border
      border: OutlineInputBorder(borderRadius: radius, borderSide: borderSide),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: borderSide,
      ),

      // focused
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: borderSide.copyWith(color: focusedColor),
      ),

      // error
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: borderSide.copyWith(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: borderSide.copyWith(color: Colors.red),
      ),
    );
  }
}
