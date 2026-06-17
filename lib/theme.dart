import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color deliveryPurple = Color(0xFFd5baff);

const dividerTheme = DividerThemeData(indent: 16.0, endIndent: 16.0);

const Color ordersBlue = Color(0xFF38d1cf);
const Color preparationCoral = Color(0xFFffadaf);
const Color primary = Color(0xFFd95030);
const Color secondary = Color(0xFF2869d9);

const Color takeawayBeige = Color(0xFFedc9a9);

/* const Color deliveryBlue = Color(0xFF62d1ee);
const Color takeawayPurple = Color(0xFF988aee); */

final cardTheme = CardTheme(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
);

final darkTheme = FlexThemeData.dark(
  textTheme: textTheme,
  appBarElevation: 8.0,
  primary: primary,
  secondary: secondary,
  useMaterial3: true,
).copyWith(
  inputDecorationTheme: inputDecorationTheme,
  dividerTheme: dividerTheme.copyWith(color: Colors.white10),
  appBarTheme: AppBarTheme(
    titleTextStyle: textTheme.headlineSmall!.copyWith(fontSize: 20.0),
    centerTitle: false,
    toolbarHeight: 56.0,
  ),
  elevatedButtonTheme: elevatedButtonTheme,
  cardTheme: cardTheme,
  dialogTheme: dialogTheme,
  popupMenuTheme: popupMenuTheme,
);

final dialogTheme = DialogTheme(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
);
final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ButtonStyle(
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    ),
    textStyle: MaterialStateProperty.all(
        textTheme.titleSmall!.copyWith(fontSize: 16.0)),
  ),
);

final font = GoogleFonts.nunito();

final headlineFont = GoogleFonts.nunito(fontWeight: FontWeight.bold);

final inputDecorationTheme = InputDecorationTheme(
  fillColor: Colors.white,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(16.0),
  ),
);

final lightTheme = FlexThemeData.light(
  textTheme: textTheme,
  appBarElevation: 8.0,
  primary: primary,
  secondary: secondary,
  background: Colors.white,
  useMaterial3: true,
).copyWith(
  inputDecorationTheme: inputDecorationTheme,
  dividerTheme: dividerTheme.copyWith(color: Colors.black12),
  elevatedButtonTheme: elevatedButtonTheme,
  appBarTheme: AppBarTheme(
    backgroundColor: primary,
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle: textTheme.headlineSmall!.copyWith(fontSize: 20.0),
    actionsIconTheme: const IconThemeData(color: Colors.white),
    centerTitle: false,
    toolbarHeight: 56.0,
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  cardTheme: cardTheme,
  dialogTheme: dialogTheme,
  popupMenuTheme: popupMenuTheme,
);

final popupMenuTheme = PopupMenuThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)));

final textTheme = Typography.material2021(platform: TargetPlatform.android)
    .black
    .copyWith(
      headlineLarge: headlineFont.copyWith(fontSize: 48.0, letterSpacing: -1.5),
      headlineMedium:
          headlineFont.copyWith(fontSize: 36.0, letterSpacing: -0.5),
      headlineSmall: headlineFont.copyWith(fontSize: 16.0),
      titleLarge: font.copyWith(fontSize: 20.0, letterSpacing: 0.25),
      titleMedium: font.copyWith(fontSize: 16.0),
      titleSmall: font.copyWith(fontSize: 14.0, letterSpacing: 0.15),
      displayLarge: font.copyWith(fontSize: 16.0, letterSpacing: 0.15),
      displayMedium: font.copyWith(fontSize: 14.0, letterSpacing: 0.1),
      displaySmall: font.copyWith(fontSize: 12.0, letterSpacing: 0.05),
      bodyLarge: font.copyWith(fontSize: 16.0, letterSpacing: 0.5),
      bodyMedium: font.copyWith(fontSize: 14.0, letterSpacing: 0.25),
      bodySmall: font.copyWith(fontSize: 12.0, letterSpacing: 0.25),
      labelLarge: font.copyWith(fontSize: 16.0, letterSpacing: 1.25),
      labelMedium: font.copyWith(fontSize: 14.0, letterSpacing: 0.4),
      labelSmall: font.copyWith(fontSize: 12.0, letterSpacing: 1.5),
    );
