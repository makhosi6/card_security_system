import 'package:card_security_system/models/banned_countries.dart';
import 'package:card_security_system/models/card.dart';
import 'package:card_security_system/models/theme.dart';
import 'package:hive/hive.dart';

class Boxes {
  static Box<Card> getCards() => Hive.box<Card>('bank_cards');
  static Box<BannedCountry> getBannedCountries() =>
      Hive.box<BannedCountry>('banned_countries');
  static Box<AppTheme> getThemeData() => Hive.box<AppTheme>('theme');
}
