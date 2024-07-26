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
import 'package:shared_preferences/shared_preferences.dart';

class settingScreen extends StatefulWidget {
  final Function(String) onSendMessage;

  settingScreen({super.key, required this.onSendMessage});

  @override
  State<settingScreen> createState() => _settingScreenState();
}

class _settingScreenState extends State<settingScreen> {
  // int _currentStep = 0;
  // final ScrollController _scrollController = ScrollController();
  // final List<GlobalKey> _keys = List.generate(4, (index) => GlobalKey());

  // void _scrollToCurrentStep() {
  //   // Calculate the position of the current step's content and scroll to it
  //   final context = _keys[_currentStep].currentContext;
  //   if (context != null) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       Scrollable.ensureVisible(
  //         context,
  //         duration: Duration(milliseconds: 500),
  //         curve: Curves.easeInOut,
  //         alignment: 0.5, // 0.0 means top of the screen
  //       );
  //     });
  //   }
  // }

  final TextEditingController _moveForwardController = TextEditingController();
  final TextEditingController _moveBackwardController = TextEditingController();
    final TextEditingController _moveTurnLeftController = TextEditingController();
  final TextEditingController _moveTurnRightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _moveForwardController.text = prefs.getString('moveForward') ?? 'FF';
      _moveBackwardController.text = prefs.getString('moveBackward') ?? 'BB';
      _moveTurnLeftController.text = prefs.getString('moveTurnLeft') ?? 'LL';
      _moveTurnRightController.text = prefs.getString('moveTurnRight') ?? 'RR';
    });
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('moveForward', _moveForwardController.text);
    prefs.setString('moveBackward', _moveBackwardController.text);
    prefs.setString('moveTurnLeft', _moveTurnLeftController.text);
    prefs.setString('moveTurnRight', _moveTurnRightController.text);
  }

  void _sendMessage() {
    String message;
    message = _moveForwardController.text;
    message = _moveBackwardController.text;
    message = _moveTurnLeftController.text;
    message = _moveTurnRightController.text;
    if (message.isNotEmpty) {
      widget.onSendMessage(message);
      _saveSettings();
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
        title: Text(AppLocalizations.of(context)!.setting),
      ),
      body: SingleChildScrollView(
        child: 
          Padding(
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
                        AppLocalizations.of(context)!.changelanguage,
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
                ),
                Text("Control detail"),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _moveForwardController,
                        decoration: InputDecoration(
                          //label: Text("Di tien"),
                          labelText: "dien gia tri nut di tien ",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _moveBackwardController,
                        decoration: InputDecoration(
                          //label: Text("Di lui"),
                          labelText: "dien gia tri nut di lui ",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _moveTurnLeftController,
                        decoration: InputDecoration(
                          labelText: "dien gia tri nut re trai ",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _moveTurnRightController,
                        decoration: InputDecoration(
                          labelText: "dien gia tri nut re phai ",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text("Luu"),
                ),
              ],
            ),
          ),
        
      ),
    );
  }
}
