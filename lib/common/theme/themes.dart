import 'package:flutter/material.dart';

enum MyThemeKeys {
  LIGHT,
  DARK,
}

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
      primaryColor:Color(0xFF010712),
      primaryColorLight: Color(0xffFAC579),
      brightness: Brightness.light,
      disabledColor: Color(0xFFedcfa3),
      dialogBackgroundColor: Color(0xFFB3B3B3),
      primaryColorDark: Color(0xFFFFFFFF),
      canvasColor: Color(0xFFFB4160),
      cardColor: Color(0xFF136E82),
      dividerColor: Color(0xFF233446),
      shadowColor: Color(0xFF136E82),
      // cursorColor: Color(0xFFFFFFFF),
      splashColor: Color(0xFF032621),
      focusColor: Color(0xFFFFFFFF),
      highlightColor: Color(0xFFD9D9D9),
      // errorColor: Color(0xFFDD2942),
      hintColor: Color(0xFF1B232A),
      hoverColor: Color(0xFF8B9CAE),
      secondaryHeaderColor:Color(0xFFFFFFFF),
      indicatorColor: Color(0xFF1B9368),
      unselectedWidgetColor: Color(0xFFFAAD34),
      scaffoldBackgroundColor: Color(0xFF262932)
  );


  static final ThemeData darkTheme = ThemeData(
      primaryColor: Color(0xFF010712),
      primaryColorLight: Color(0xff16171D),
      brightness: Brightness.dark,
      disabledColor: Color(0xFF25DEB0),
      focusColor: Color(0xFFFFFFFF),
      dialogBackgroundColor: Color(0xFF242B48),
      primaryColorDark: Color(0xFF787A8D),
      canvasColor: Color(0xFF21242D),
      cardColor: Color(0xFF000000),
      dividerColor: Color(0xFF494D58),
      // cursorColor: Color(0xFF0e1839),
      shadowColor: Color(0xFFA7AFB7),
      secondaryHeaderColor: Color(0xFF00C566),
      splashColor: Color(0xFF131A26),
      highlightColor: Color(0xFFD9D9D9),
      // errorColor: Color(0xFFffffff),
      hintColor: Color(0xFF1B232A),
      hoverColor:  Color(0xFFDD2942),
      indicatorColor: Color(0xFF1B9368),
      unselectedWidgetColor: Color(0xFFFFD403),
      scaffoldBackgroundColor: Color(0xFF262932)
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHT:
        return lightTheme;
      case MyThemeKeys.DARK:
        return darkTheme;
      default:
        return lightTheme;
    }
  }
}
