import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_over_app/const/app_colors.dart';

abstract class AppTheme {
  static const String _fontName = 'Outfit';

  static const TextStyle _baseStyle = TextStyle(fontFamily: _fontName);

  static ThemeData get lightTheme {
    final foregroundColor = Colors.black;
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: _fontName,
    );

    return base.copyWith(
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
        style: ElevatedButton.styleFrom(
          foregroundColor: foregroundColor,
          textStyle: _baseStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor,
          textStyle: _baseStyle.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
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
    final background = AppColors.backgroundColor;
    final primary = AppColors.primary;
    final secondaryText = AppColors.slateGrey;
    final foregroundColor = Colors.white;

    final base = ThemeData(brightness: Brightness.dark, fontFamily: _fontName);

    return base.copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: primary,
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: primary),
        titleTextStyle: _baseStyle.copyWith(
          color: foregroundColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: base.textTheme
          .apply(
            fontFamily: _fontName,
            bodyColor: foregroundColor,
            displayColor: foregroundColor,
          )
          .copyWith(
            headlineLarge: _baseStyle.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
            bodyMedium: _baseStyle.copyWith(color: secondaryText, fontSize: 16),
          ),
      iconTheme: IconThemeData(color: primary),
      primaryIconTheme: IconThemeData(color: primary),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: background,
        selectedItemColor: primary,
        unselectedItemColor: secondaryText,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: foregroundColor,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: _baseStyle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: _baseStyle.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: _baseStyle.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        splashColor: Color(0x22FFFFFF),
        backgroundColor: primary,
        foregroundColor: foregroundColor,
        elevation: 3,
      ),
    );
  }

  static TextStyle get searchHintTextTheme {
    return _baseStyle.copyWith(
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
    return _baseStyle.copyWith(
      fontSize: 14,
      color: AppColors.black,
      fontWeight: FontWeight.w800,
    );
  }

  static TextStyle get subtitleTextStyle {
    return _baseStyle.copyWith(
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
      hintStyle: _baseStyle.copyWith(
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
