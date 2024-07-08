import 'package:TEST/l10n/l10n.dart';
import 'package:TEST/provider/provider.dart';
import 'package:TEST/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const Kulbot(),
    ),
  );
}

class Kulbot extends StatelessWidget {
  const Kulbot({super.key});

  @override
   Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          final provider = Provider.of<LocaleProvider>(context);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'KulBot',
            theme: ThemeData(
              useMaterial3: true,
              brightness: Provider.of<ThemeNotifier>(context).isDarkMode
            ? Brightness.dark
            : Brightness.light,
            ),
            locale: provider.locale,
            supportedLocales: L10n.all,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: HomeScreen(),
          );
        },
      );
}


class ThemeNotifier extends ChangeNotifier {
  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
