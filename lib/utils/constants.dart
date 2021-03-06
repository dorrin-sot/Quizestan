import 'package:flutter/material.dart';

const COLOR_BLACK = Color.fromRGBO(48, 47, 48, 1.0);
const COLOR_GREY = Color.fromRGBO(141, 141, 141, 1.0);
const COLOR_YELLOW = Colors.yellowAccent;
const COLOR_WHITE = Colors.white;
const COLOR_DARK_BLUE = Color.fromRGBO(20, 25, 45, 1.0);
ThemeData THEME_DATA = ThemeData(
  backgroundColor: COLOR_DARK_BLUE,
  elevatedButtonTheme: _elevatedButtonThemeData,
  primaryColor: COLOR_DARK_BLUE,
  primaryColorBrightness: Brightness.light,
  splashColor: COLOR_GREY,
  textTheme: TEXT_THEME_DEFAULT,
  // elevatedButtonTheme: _elevatedButtonThemeData,
);

ElevatedButtonThemeData _elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ButtonStyle(
    backgroundColor:
        MaterialStateColor.resolveWith((states) => getButtonColor(states)),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: COLOR_GREY),
      ),
    ),
  ),
);

Color getButtonColor(Set<MaterialState> states) {
  const Set<MaterialState> interactiveStates = <MaterialState>{
    MaterialState.pressed,
    MaterialState.hovered,
    MaterialState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return COLOR_DARK_BLUE;
  }
  return COLOR_BLACK;
}

const TextTheme TEXT_THEME_DEFAULT = TextTheme(
  headline1: TextStyle(
      color: COLOR_WHITE,
      fontWeight: FontWeight.w700,
      fontSize: 26,
      fontFamily: 'Traffic'),
  headline2: TextStyle(
      color: COLOR_WHITE,
      fontWeight: FontWeight.w700,
      fontSize: 22,
      fontFamily: 'Traffic'),
  headline3: TextStyle(
      color: COLOR_WHITE,
      fontWeight: FontWeight.w700,
      fontSize: 20,
      fontFamily: 'Traffic'),
  headline4: TextStyle(
      color: COLOR_WHITE,
      fontWeight: FontWeight.w700,
      fontSize: 16,
      fontFamily: 'Traffic'),
  headline5: TextStyle(
      color: COLOR_WHITE,
      fontWeight: FontWeight.w700,
      fontSize: 14,
      fontFamily: 'Traffic'),
  headline6: TextStyle(
      color: COLOR_WHITE,
      fontWeight: FontWeight.w700,
      fontSize: 12,
      fontFamily: 'Traffic'),
  bodyText1: TextStyle(
      color: COLOR_WHITE,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.5,
      fontFamily: 'Traffic'),
  bodyText2: TextStyle(
      color: COLOR_WHITE,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.5,
      fontFamily: 'Traffic'),
  subtitle1: TextStyle(
      color: COLOR_WHITE,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: 'Traffic'),
  subtitle2: TextStyle(
      color: COLOR_YELLOW,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: 'Traffic'),
);

const TextTheme TEXT_THEME_SMALL = TextTheme(
    headline1: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 22),
    headline2: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 20),
    headline3: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 18),
    headline4: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 14),
    headline5: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 12),
    headline6: TextStyle(
        color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 10),
    bodyText1: TextStyle(
        color: COLOR_BLACK,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5),
    bodyText2: TextStyle(
        color: COLOR_GREY,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.5),
    subtitle1: TextStyle(
        color: COLOR_BLACK, fontSize: 10, fontWeight: FontWeight.w400),
    subtitle2: TextStyle(
        color: COLOR_GREY, fontSize: 10, fontWeight: FontWeight.w400));
