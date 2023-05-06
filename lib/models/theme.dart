import 'package:card_security_system/models/boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'theme.g.dart';

@HiveType(typeId: 3)
class AppTheme extends HiveObject {
  ///
  @HiveField(20)
  String? theme;

  /// to save or to update the Theme
  /// - theme, i.e "dark" | "light"
  saveData(String theme) {
    ///theme value should be "dark" | "light"
    if (theme != 'dark' && theme != 'light') {
      throw 'THE theme value should be "dark" | "light", but it received "$theme"';
    }

    /// get the box
    var box = Boxes.getThemeData();

//update fields
    var toStore = AppTheme()..theme = theme;

    /// save
    box.put('theme', toStore);
  }

  @override
  String toString() {
    return "";
  }
}
