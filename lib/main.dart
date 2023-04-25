import 'dart:async';

import 'package:card_security_system/models/country.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

      /// Fallback page on fatal error
      ErrorWidget.builder = (details) => Scaffold(
            body: Center(child: Text("Error: $details")),
          );

      runApp(const App());
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
  var country = const Country(code: "GB", name: "SATAFRIKA");
  var _count = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                _count++;
              });
            }),
        body: SafeArea(
          child: Center(
            child: SizedBox(
              child: Column(
                children: [Text('${country.flag()} Counter'), Text("$_count")],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
