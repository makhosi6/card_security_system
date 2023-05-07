import 'package:card_security_system/models/banned_countries.dart';
import 'package:card_security_system/models/boxes.dart';
import 'package:card_security_system/models/card.dart';
import 'package:card_security_system/models/theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:hive_test/hive_test.dart';

void main() {
  setUp(() async {
    await setUpTestHive();
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
  });
  tearDown(() async {
    await tearDownTestHive();
  });

  group("Test all Hive models", () {
    test("toggle user theme", () {
      var userTheme = AppTheme();

      /// initial value should be null
      expect(userTheme.theme, null);

      // /// set theme to light

      userTheme.saveData("light");

      expect(userTheme.theme, "light");

      // reset theme to dark mode
      userTheme.saveData("dark");

      expect(userTheme.theme, "dark");

      /// the app should have one instace of user theme
      var themeBox = Boxes.getThemeData();
      expect(themeBox.values.length, 1);

      ///theme value should be "dark" | "light" ONLY
      expect(() => userTheme.saveData("invalidThemeValue"), throwsException);
    });

    test("add, update and delete a card", () => {});

    test("add and remove countries", () => {});
  });
}
