import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:uvindex/localization/app_localizations.dart';
import 'package:uvindex/screen/home_page.dart';

void main() => runApp(UVIndexApp());

class UVIndexApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        Locale('en', ''),
        Locale('vi', ''),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        return locale == null ||
                supportedLocales
                    .map((l) => l.languageCode)
                    .contains(locale.languageCode)
            ? locale
            : supportedLocales.first;
      },
      home: HomePage(),
    );
  }
}
