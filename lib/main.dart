import 'dart:async';

import 'package:card_security_system/models/country.dart';
import 'package:card_security_system/pages/cards_list_page.dart';
import 'package:card_security_system/pages/country_config_page.dart';
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
      ErrorWidget.builder = (details) => Scaffold(
            body: Center(child: Text("Error: $details")),
          );

      runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserTheme()),
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
    return MaterialApp(
      theme: Provider.of<UserTheme>(context).value,
      home: const CardListPage(),
      routes: {
        '/': (context) => const CardListPage(),
        ConfigCountriesPage.routeName: (context) => const ConfigCountriesPage()
      },
    );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }
}
