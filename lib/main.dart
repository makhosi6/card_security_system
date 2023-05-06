import 'dart:async';

import 'package:card_security_system/models/banned_countries.dart';
import 'package:card_security_system/models/boxes.dart';
import 'package:card_security_system/models/card.dart';
import 'package:card_security_system/models/theme.dart';
import 'package:card_security_system/pages/cards_list_page.dart';
import 'package:card_security_system/pages/country_config_page.dart';
import 'package:card_security_system/pages/create_edit_card_page.dart';
import 'package:card_security_system/provider/card_details.dart';
import 'package:card_security_system/utils/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///
  await Hive.initFlutter();
  Hive.registerAdapter(AppThemeAdapter());
  Hive.registerAdapter(BannedCountryAdapter());
  Hive.registerAdapter(BankCardAdapter());

  ///
  await Hive.openBox<AppTheme>("app_theme",
      compactionStrategy: (_, deleted) => deleted > 0);
  await Hive.openBox<BannedCountry>('banned_countries',
      compactionStrategy: (_, deleted) => deleted > 0);
  await Hive.openBox<BankCard>('bank_cards',
      compactionStrategy: (_, deleted) => deleted > 0);

  /// Error zone of the App body
  runZonedGuarded<void>(
    () {
      /// Pass all uncaught errors from the framework to Crashlytics.
      FlutterError.onError = (details) {
        if (kDebugMode) {
          debugPrint("$details");
        }
      };

      //// Fallback page on fatal error
      // ErrorWidget.builder = (details) => Scaffold(
      //       body: Center(child: Text("Error: $details")),
      //     );

      runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => InferCardType()),
        ],
        child: const App(),
      ));
    },
    (error, _) {
      if (kDebugMode) {
        // In development mode simply print to console.
        debugPrint('Caught Dart Error!');
        debugPrint('$error');
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
  ///user selected theme
  ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    /// system theme and brightness
    Brightness brightness =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    ///
    return ValueListenableBuilder(
      valueListenable: Boxes.getThemeData().listenable(),
      builder: (context, box, child) {
        //stored theme
        var stored = box.get("theme");

        ///get selected theme
        ThemeData theme = stored != null
            ? stored.theme == "dark"
                ? darkTheme
                : lightTheme
            : ((isDarkMode) ? darkTheme : lightTheme);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          title: "Card Security System",
          home: const CardListPage(),
          routes: {
            ConfigCountriesPage.routeName: (context) =>
                const ConfigCountriesPage(),
            CreateEditCard.routeName: (context) => const CreateEditCard()
          },
        );
      },
    );
  }
}
