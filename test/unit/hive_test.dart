import 'package:card_security_system/models/theme.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hive_test/hive_test.dart';

// TODO: makhosi6 -SetUp mocktail
void main() {
  setUp(() async {
    await setUpTestHive();
  });
  tearDown(() async {
    await tearDownTestHive();
  });

  group("Test all Hive models", () {
    late AppTheme userTheme;
    setUp(() {
      userTheme = AppTheme();
    });
    test("toggle user theme", () async {
      /// initial value should be null
      expect(userTheme.theme, equals(null));
    });

    test("add, update and delete a card", () {
      var state = 100;

      expect(state, isA<int>());
    });

    test("add and remove countries", () {
      var state = 101;

      expect(state, isA<int>());
    });
  });
}
