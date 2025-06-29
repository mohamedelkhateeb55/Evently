import 'package:evently_app/utilis/app_colors.dart';
import 'package:evently_app/utilis/app_styles.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.whiteBgColor,
          onPrimary: AppColors.grayColor,
          secondary: AppColors.blackColor,
          onSecondary: AppColors.primaryLight,
          error: AppColors.primaryDark,
          onError: AppColors.primaryLight,
          surface: AppColors.whiteColor,
          onSurface: AppColors.primaryLight),
      focusColor: AppColors.whiteColor,
      dividerColor: AppColors.whiteColor,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          showUnselectedLabels: true,
          selectedLabelStyle: AppStyles.bold12White,
          unselectedLabelStyle: AppStyles.bold16Black,
          elevation: 0),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryLight,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(354),
              side: BorderSide(color: AppColors.whiteColor, width: 4))),
      primaryColor: AppColors.primaryLight,
      appBarTheme:
          AppBarTheme(iconTheme: IconThemeData(color: AppColors.primaryLight)),
      scaffoldBackgroundColor: AppColors.whiteBgColor,
      textTheme: TextTheme(
          headlineLarge: AppStyles.bold20Black,
          headlineMedium: AppStyles.bold20Black,
          headlineSmall: AppStyles.medium16Primary,
          bodyLarge: AppStyles.bold14black,
          labelLarge: AppStyles.medium16Black));
  static final ThemeData darkTheme = ThemeData(
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.primaryDark,
          onPrimary: AppColors.whiteColor,
          secondary: AppColors.whiteColor,
          onSecondary: AppColors.primaryLight,
          error: AppColors.whiteColor,
          onError: AppColors.redColor,
          surface: AppColors.whiteColor,
          onSurface: AppColors.whiteColor),
      focusColor: AppColors.primaryLight,
      dividerColor: AppColors.transparentColor,
      appBarTheme:
          AppBarTheme(iconTheme: IconThemeData(color: AppColors.primaryLight)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          showUnselectedLabels: true,
          selectedLabelStyle: AppStyles.bold12White,
          unselectedLabelStyle: AppStyles.bold12White,
          elevation: 0),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryDark,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(354),
              side: BorderSide(color: AppColors.whiteColor, width: 4))),
      primaryColor: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.primaryDark,
      textTheme: TextTheme(
          headlineLarge: AppStyles.bold20White,
          headlineMedium: AppStyles.bold20Black,
          headlineSmall: AppStyles.medium16White,
          bodyLarge: AppStyles.bold16White,
          labelLarge: AppStyles.medium16White));
}
