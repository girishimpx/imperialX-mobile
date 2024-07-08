import 'dart:io';

//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imperial/common/localization/localizations.dart';
import 'package:imperial/common/theme/custom_theme.dart';
import 'package:imperial/common/theme/themes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:imperial/screens/basic/splash.dart';


void main() async {

  HttpOverrides.global = MyHttpOverrides();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    // navigation bar color
    statusBarColor: Color(0xFF242B48),
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark, // status bar icon color
    systemNavigationBarIconBrightness:
        Brightness.dark, // color of navigation controls
  ));

  WidgetsFlutterBinding.ensureInitialized();
   // await Firebase.initializeApp();

  runApp(
    const CustomTheme(
      initialThemeKey: MyThemeKeys.DARK,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Switch Exchange",
        theme: CustomTheme.of(context),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        localizationsDelegates: const [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('tr', ''),
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        });
  }
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}