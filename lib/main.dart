import 'dart:async';

import 'package:card_security_system/models/country.dart';
import 'package:card_security_system/pages/cards_list_page.dart';
import 'package:card_security_system/pages/country_config_page.dart';
import 'package:card_security_system/pages/create_edit_card_page.dart';
import 'package:card_security_system/provider/card_details.dart';
import 'package:card_security_system/provider/theme.dart';
import 'package:card_security_system/utils/state_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();

  /// Error zone of the App body
  runZonedGuarded<void>(
    () {
      /// Pass all uncaught errors from the framework to Crashlytics.
      FlutterError.onError = (details) {
        if (kDebugMode) {
          print(details);
        }
      };

      // / Fallback page on fatal error
      // ErrorWidget.builder = (details) => Scaffold(
      //       body: Center(child: Text("Error: $details")),
      //     );

      runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserTheme()),
          ChangeNotifierProvider(create: (_) => InferCardType()),
        ],
        child: StateManager(child: const App()),
      ));
    },
    (error, _) {
      if (kDebugMode) {
        // In development mode simply print to console.
        print('Caught Dart Error!');
        print('$error');
      } else {
        // In production
        // Report errors to a reporting service such as Sentry or Crashlytics
      }
    },
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ///
  var country = const Country(code: "ZA", name: "SATAFRIKA");

  ///
  final _count = 0;

  ///user selected theme
  ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    /// system theme and brightness
    Brightness brightness =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    ///get selected theme
    ThemeData theme = (Provider.of<UserTheme>(context).value) ??
        ((isDarkMode) ? darkTheme : lightTheme);

    ///
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const CardListPage(),
      routes: {
        ConfigCountriesPage.routeName: (context) => const ConfigCountriesPage(),
        CreateEditCard.routeName: (context) => const CreateEditCard()
      },
    );
  }
}
