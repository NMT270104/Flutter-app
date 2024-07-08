import 'package:TEST/l10n/l10n.dart';
import 'package:TEST/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:TEST/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class settingScreen extends StatefulWidget {
  settingScreen({super.key});

  @override
  State<settingScreen> createState() => _settingScreenState();
}

class _settingScreenState extends State<settingScreen> {
  int _currentStep = 0;
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _keys = List.generate(4, (index) => GlobalKey());

  void _scrollToCurrentStep() {
    // Calculate the position of the current step's content and scroll to it
    final context = _keys[_currentStep].currentContext;
    if (context != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Scrollable.ensureVisible(
          context,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.5, // 0.0 means top of the screen
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale ?? Locale('en');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          children: [
            SwitchListTile(
              title: Text(
                themeNotifier.isDarkMode
                    ? AppLocalizations.of(context)!.darkMode
                    : AppLocalizations.of(context)!.lightMode,
              ),
              value: themeNotifier.isDarkMode,
              onChanged: (bool value) {
                themeNotifier.toggleTheme();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Change Language",
                    style: TextStyle(fontSize: 16),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: locale,
                      icon: Container(width: 12),
                      items: L10n.all.map(
                        (locale) {
                          final flag = L10n.getflag(locale.languageCode);

                          return DropdownMenuItem(
                            child: Center(
                              child: Text(
                                flag,
                                style: TextStyle(fontSize: 32),
                              ),
                            ),
                            value: locale,
                            onTap: () {
                              final provider = Provider.of<LocaleProvider>(
                                  context,
                                  listen: false);

                              provider.setLocale(locale);
                            },
                          );
                        },
                      ).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
