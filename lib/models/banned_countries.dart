import 'package:card_security_system/models/boxes.dart';
import 'package:hive/hive.dart';

part 'banned_countries.g.dart';

@HiveType(typeId: 2)
class BannedCountry extends HiveObject {
  ///
  @HiveField(10)
  String? code;

  /// key is a 2 letter Country Code
  Future<void> saveData(String code) async {
    ///
    var box = Boxes.getBannedCountries();

    var toStore = BannedCountry()..code = code;

    ///
    await box.put(code, toStore);
  }

  /// key is a 2 letter Country Code
  Future<void> deleteData() => Boxes.getBannedCountries().delete(code);

  @override
  String toString() {
    return "";
  }
}
