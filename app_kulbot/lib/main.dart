import 'package:TEST/l10n/l10n.dart';
import 'package:TEST/provider/provider.dart';
import 'package:TEST/screens/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wakelock/wakelock.dart';

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
            home: SplashState(),
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
class SplashState extends StatefulWidget {
  const SplashState({super.key});

  @override
  State<SplashState> createState() => _SplashStateState();
}


class _SplashStateState extends State<SplashState> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
    });
    Wakelock.enable();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/images/kulbot.png', height: 150,),
              const SizedBox(height: 30,),
              if(defaultTargetPlatform == TargetPlatform.android)
              const CupertinoActivityIndicator(
                color: Colors.white,
                radius: 20,
              )
              else
              const CircularProgressIndicator(
                color: Colors.white,)
              

          ],
        ),
      ),
    );
  }
}
