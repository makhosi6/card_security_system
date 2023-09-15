// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:card_security_system/main.dart';
import 'package:card_security_system/models/banned_countries.dart';
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
  testWidgets('App start up process', (WidgetTester tester) async {
    // // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // fins a placeholder component
    expect(find.text("0000000000000000"), findsOneWidget);

    tester.pumpAndSettle();
  });
}
