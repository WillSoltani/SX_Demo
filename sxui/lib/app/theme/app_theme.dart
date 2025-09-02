// lib/app/theme/app_theme.dart
import 'package:flutter/material.dart';

/// Extra role colors & tokens we want handy in widgets/charts.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  // Semantic accents
  final Color success;      // Emerald/Lime
  final Color warning;      // Amber
  final Color error;        // Red/Rose
  final Color info;         // Indigo/Cyan

  // Surfaces & borders
  final Color canvas;       // Main canvas bg
  final Color nav;          // Top nav surface
  final Color navBorder;    // Nav bottom border
  final Color panel;        // Widget/Card background
  final Color panelAlt;     // Secondary panels
  final Color border;       // Dividers/Borders

  // Text roles
  final Color textHeader;   // H headings
  final Color textBody;     // Body
  final Color textMuted;    // Secondary/Muted
  final Color textDisabled; // Disabled

  // Links / interactive text
  final Color link;

  // Charts palette (at least 5 distinct)
  final List<Color> chartSeries; // [primary, secondary, highlight, purple, teal]

  const AppPalette({
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.canvas,
    required this.nav,
    required this.navBorder,
    required this.panel,
    required this.panelAlt,
    required this.border,
    required this.textHeader,
    required this.textBody,
    required this.textMuted,
    required this.textDisabled,
    required this.link,
    required this.chartSeries,
  });

  @override
  AppPalette copyWith({
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Color? canvas,
    Color? nav,
    Color? navBorder,
    Color? panel,
    Color? panelAlt,
    Color? border,
    Color? textHeader,
    Color? textBody,
    Color? textMuted,
    Color? textDisabled,
    Color? link,
    List<Color>? chartSeries,
  }) {
    return AppPalette(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      canvas: canvas ?? this.canvas,
      nav: nav ?? this.nav,
      navBorder: navBorder ?? this.navBorder,
      panel: panel ?? this.panel,
      panelAlt: panelAlt ?? this.panelAlt,
      border: border ?? this.border,
      textHeader: textHeader ?? this.textHeader,
      textBody: textBody ?? this.textBody,
      textMuted: textMuted ?? this.textMuted,
      textDisabled: textDisabled ?? this.textDisabled,
      link: link ?? this.link,
      chartSeries: chartSeries ?? this.chartSeries,
    );
  }

  @override
  ThemeExtension<AppPalette> lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    Color lerp(Color a, Color b) => Color.lerp(a, b, t)!;
    List<Color> lerpList(List<Color> a, List<Color> b) =>
        List<Color>.generate(a.length, (i) => lerp(a[i], b[i]));
    return AppPalette(
      success: lerp(success, other.success),
      warning: lerp(warning, other.warning),
      error: lerp(error, other.error),
      info: lerp(info, other.info),
      canvas: lerp(canvas, other.canvas),
      nav: lerp(nav, other.nav),
      navBorder: lerp(navBorder, other.navBorder),
      panel: lerp(panel, other.panel),
      panelAlt: lerp(panelAlt, other.panelAlt),
      border: lerp(border, other.border),
      textHeader: lerp(textHeader, other.textHeader),
      textBody: lerp(textBody, other.textBody),
      textMuted: lerp(textMuted, other.textMuted),
      textDisabled: lerp(textDisabled, other.textDisabled),
      link: lerp(link, other.link),
      chartSeries: lerpList(chartSeries, other.chartSeries),
    );
  }
}

class AppTheme {
  // -------------------------
  // Light Mode (exact spec)
  // -------------------------
  // Base colors
  static const _primaryLight   = Color(0xFF2563EB); // Royal Blue
  static const _secondaryLight = Color(0xFF10B981); // Emerald
  static const _warningLight   = Color(0xFFF59E0B); // Amber
  static const _errorLight     = Color(0xFFDC2626); // Red
  static const _infoLight      = Color(0xFF4F46E5); // Indigo

  // Backgrounds
  static const _canvasLight    = Color(0xFFF9FAFB); // Off-white
  static const _navLight       = Color(0xFFFFFFFF); // White
  static const _navBorderLight = Color(0xFFE5E7EB);
  static const _panelLight     = Color(0xFFFFFFFF); // Widget/Card
  static const _panelAltLight  = Color(0xFFF3F4F6); // Light Gray panel
  static const _borderLight    = Color(0xFFE5E7EB); // Dividers/Borders

  // Text
  static const _textHeaderLight   = Color(0xFF111827); // Almost Black
  static const _textBodyLight     = Color(0xFF374151); // Dark Gray
  static const _textMutedLight    = Color(0xFF6B7280); // Medium Gray
  static const _textDisabledLight = Color(0xFF9CA3AF); // Light Gray
  static const _linkLight         = _primaryLight;     // Links = primary blue

  // Chart accents
  static const _chartPrimaryLight   = _primaryLight;         // Blue
  static const _chartSecondaryLight = _secondaryLight;       // Green
  static const _chartHighlightLight = Color(0xFFF97316);     // Orange highlight
  static const _chartPurpleLight    = Color(0xFF8B5CF6);     // Purple
  static const _chartTealLight      = Color(0xFF14B8A6);     // Teal

  // -------------------------
  // Dark Mode (exact spec)
  // -------------------------
  static const _primaryDark   = Color(0xFF3B82F6); // Electric Blue
  static const _secondaryDark = Color(0xFF84CC16); // Lime Green
  static const _warningDark   = Color(0xFFFACC15); // Bright Amber
  static const _errorDark     = Color(0xFFF43F5E); // Rose/Red
  static const _infoDark      = Color(0xFF06B6D4); // Cyan

  // Backgrounds
  static const _canvasDark    = Color(0xFF0F172A); // Deep Charcoal
  static const _navDark       = Color(0xFF1E293B); // Dark Navy
  static const _navBorderDark = Color(0xFF334155);
  static const _panelDark     = Color(0xFF1E293B); // Charcoal widgets
  static const _panelAltDark  = Color(0xFF334155); // Slate
  static const _borderDark    = Color(0xFF475569); // Dim gray

  // Text
  static const _textHeaderDark   = Color(0xFFF9FAFB); // Off-White
  static const _textBodyDark     = Color(0xFFE2E8F0); // Light Gray
  static const _textMutedDark    = Color(0xFF94A3B8); // Cool Gray
  static const _textDisabledDark = Color(0xFF64748B); // Dim gray
  static const _linkDark         = _primaryDark;      // Primary blue for links

  // Chart accents
  static const _chartPrimaryDark   = _primaryDark;          // Blue
  static const _chartSecondaryDark = _secondaryDark;        // Green
  static const _chartHighlightDark = Color(0xFFF97316);     // Orange
  static const _chartPurpleDark    = Color(0xFFA78BFA);     // Softer purple
  static const _chartTealDark      = Color(0xFF2DD4BF);     // Teal

  // ================= ThemeData builders =================

  static ThemeData light() {
    final cs = ColorScheme(
      brightness: Brightness.light,
      primary: _primaryLight,
      onPrimary: Colors.white,
      secondary: _secondaryLight,
      onSecondary: Colors.white,
      error: _errorLight,
      onError: Colors.white,
      background: _canvasLight,
      onBackground: _textBodyLight,
      surface: _panelLight,       // cards/widgets default surface
      onSurface: _textBodyLight,
      tertiary: _infoLight,
      onTertiary: Colors.white,
      // Material 3 extras:
      primaryContainer: const Color(0xFF1D4ED8),
      onPrimaryContainer: Colors.white,
      secondaryContainer: const Color(0xFFD1FAE5),
      onSecondaryContainer: _textBodyLight,
      surfaceContainerLow: _panelAltLight,
      surfaceContainerHighest: _panelLight,
      outline: _borderLight,
      outlineVariant: _borderLight,
      shadow: Colors.black.withOpacity(0.1),
      scrim: Colors.black.withOpacity(0.2),
      inverseSurface: Colors.white,
      inversePrimary: _primaryLight,
    );

    return ThemeData(
      brightness: Brightness.light,
      colorScheme: cs,
      scaffoldBackgroundColor: _canvasLight,
      cardColor: _panelLight,
      dividerColor: _borderLight,
      useMaterial3: true,

      // Typography
      textTheme: const TextTheme(
        headlineMedium: TextStyle(color: _textHeaderLight, fontWeight: FontWeight.w700),
        bodyMedium: TextStyle(color: _textBodyLight),
        labelSmall: TextStyle(color: _textMutedLight),
      ),

      // AppBar/Navigation (GlassBar uses palette.nav + palette.navBorder)
      appBarTheme: const AppBarTheme(
        backgroundColor: _navLight,
        foregroundColor: _textHeaderLight,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryLight,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _panelAltLight,
          disabledForegroundColor: _textDisabledLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _linkLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _textBodyLight,
          backgroundColor: _panelAltLight,
          side: const BorderSide(color: _borderLight),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _panelLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)), // Input Border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primaryLight), // Focus: blue
        ),
        hintStyle: const TextStyle(color: _textMutedLight),
      ),

      // Menus
      popupMenuTheme: const PopupMenuThemeData(
        color: _panelLight,
        textStyle: TextStyle(color: _textBodyLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      ),

      // Extensions
      extensions: [
        const AppPalette(
          success: _secondaryLight,
          warning: _warningLight,
          error: _errorLight,
          info: _infoLight,
          canvas: _canvasLight,
          nav: _navLight,
          navBorder: _navBorderLight,
          panel: _panelLight,
          panelAlt: _panelAltLight,
          border: _borderLight,
          textHeader: _textHeaderLight,
          textBody: _textBodyLight,
          textMuted: _textMutedLight,
          textDisabled: _textDisabledLight,
          link: _linkLight,
          chartSeries: [
            _chartPrimaryLight,
            _chartSecondaryLight,
            _chartHighlightLight,
            _chartPurpleLight,
            _chartTealLight,
          ],
        ),
      ],
    );
  }

  static ThemeData dark() {
    final cs = ColorScheme(
      brightness: Brightness.dark,
      primary: _primaryDark,
      onPrimary: Colors.white,
      secondary: _secondaryDark,
      onSecondary: Colors.black,
      error: _errorDark,
      onError: Colors.white,
      background: _canvasDark,
      onBackground: _textBodyDark,
      surface: _panelDark,
      onSurface: _textBodyDark,
      tertiary: _infoDark,
      onTertiary: Colors.black,
      primaryContainer: const Color(0xFF2563EB),
      onPrimaryContainer: Colors.white,
      secondaryContainer: const Color(0xFF1E293B),
      onSecondaryContainer: _textBodyDark,
      surfaceContainerLow: _panelAltDark,
      surfaceContainerHighest: _panelDark,
      outline: _borderDark,
      outlineVariant: _borderDark,
      shadow: Colors.black.withOpacity(0.45),
      scrim: Colors.black.withOpacity(0.55),
      inverseSurface: Colors.black,
      inversePrimary: _primaryDark,
    );

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: cs,
      scaffoldBackgroundColor: _canvasDark,
      cardColor: _panelDark,
      dividerColor: _borderDark,
      useMaterial3: true,

      // Typography
      textTheme: const TextTheme(
        headlineMedium: TextStyle(color: _textHeaderDark, fontWeight: FontWeight.w700),
        bodyMedium: TextStyle(color: _textBodyDark),
        labelSmall: TextStyle(color: _textMutedDark),
      ),

      // AppBar/Navigation
      appBarTheme: const AppBarTheme(
        backgroundColor: _navDark,
        foregroundColor: _textHeaderDark,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryDark,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _panelAltDark,
          disabledForegroundColor: _textDisabledDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _linkDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _textBodyDark,
          backgroundColor: _panelAltDark,
          side: const BorderSide(color: _borderDark),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _panelDark, // Charcoal input
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primaryDark), // Focus: blue
        ),
        hintStyle: const TextStyle(color: _textMutedDark),
      ),

      // Menus
      popupMenuTheme: const PopupMenuThemeData(
        color: _panelDark,
        textStyle: TextStyle(color: _textBodyDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      ),

      // Extensions
      extensions: [
        const AppPalette(
          success: _secondaryDark,
          warning: _warningDark,
          error: _errorDark,
          info: _infoDark,
          canvas: _canvasDark,
          nav: _navDark,
          navBorder: _navBorderDark,
          panel: _panelDark,
          panelAlt: _panelAltDark,
          border: _borderDark,
          textHeader: _textHeaderDark,
          textBody: _textBodyDark,
          textMuted: _textMutedDark,
          textDisabled: _textDisabledDark,
          link: _linkDark,
          chartSeries: [
            _chartPrimaryDark,
            _chartSecondaryDark,
            _chartHighlightDark,
            _chartPurpleDark,
            _chartTealDark,
          ],
        ),
      ],
    );
  }

  static ThemeData forMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light: return light();
      case ThemeMode.dark:  return dark();
      case ThemeMode.system:
      default:              return dark(); // app default look if system unknown
    }
  }
}
