import 'dart:async';

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

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
