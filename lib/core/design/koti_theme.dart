import 'package:flutter/material.dart';
import 'koti_colors.dart';
import 'koti_typography.dart';
import 'koti_radii.dart';
import 'koti_spacing.dart';

class KotiTheme {
  static ThemeData get darkTheme {
    final textTheme = KotiTypography.textTheme.apply(
      bodyColor: KotiColors.darkTextPrimary,
      displayColor: KotiColors.darkTextPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: KotiColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: KotiColors.primaryAccent,
        surface: KotiColors.darkSurface,
        onSurface: KotiColors.darkTextPrimary,
        error: KotiColors.expense,
      ),
      textTheme: textTheme,
      cardTheme: const CardThemeData(
        color: KotiColors.darkSurfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: KotiRadii.roundedXLarge),
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: KotiColors.darkSurfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: KotiRadii.bottomSheet),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: KotiColors.darkBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: const IconThemeData(color: KotiColors.darkTextPrimary),
      ),
      dividerTheme: const DividerThemeData(
        color: KotiColors.darkDivider,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: KotiColors.primaryAccent,
          foregroundColor: KotiColors.darkBackground,
          shape: const RoundedRectangleBorder(borderRadius: KotiRadii.roundedMedium),
          padding: const EdgeInsets.symmetric(vertical: KotiSpacing.m, horizontal: KotiSpacing.l),
          textStyle: textTheme.titleMedium,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    final textTheme = KotiTypography.textTheme.apply(
      bodyColor: KotiColors.lightTextPrimary,
      displayColor: KotiColors.lightTextPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: KotiColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: KotiColors.primaryAccentDarker,
        surface: KotiColors.lightSurface,
        onSurface: KotiColors.lightTextPrimary,
        error: KotiColors.expense,
      ),
      textTheme: textTheme,
      cardTheme: CardThemeData(
        color: KotiColors.lightSurfaceElevated,
        shape: const RoundedRectangleBorder(borderRadius: KotiRadii.roundedXLarge),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.06), // Not changing withOpacity for now to ensure compile
        margin: EdgeInsets.zero,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: KotiColors.lightSurface,
        shape: RoundedRectangleBorder(borderRadius: KotiRadii.bottomSheet),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: KotiColors.lightBackground,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: const IconThemeData(color: KotiColors.lightTextPrimary),
      ),
      dividerTheme: const DividerThemeData(
        color: KotiColors.lightDivider,
        thickness: 1,
        space: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: KotiColors.primaryAccentDarker,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(borderRadius: KotiRadii.roundedMedium),
          padding: const EdgeInsets.symmetric(vertical: KotiSpacing.m, horizontal: KotiSpacing.l),
          textStyle: textTheme.titleMedium,
        ),
      ),
    );
  }
}
