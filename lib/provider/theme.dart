import 'package:card_security_system/models/boxes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserTheme with ChangeNotifier {
  UserTheme() {
    /// get stored values
    var themeBox = Boxes.getThemeData();
    if (themeBox.values.isNotEmpty) {
      if (themeBox.values.first.theme == "dark") {
        value = darkTheme;
      } else {
        value = lightTheme;
      }
    }
  }

  ThemeData? _value;

  set value(ThemeData? theme) {
    _value = theme;
    notifyListeners();
  }

  ThemeData? get value {
    return _value;
  }
}

var defaultTheme =
    ThemeData(useMaterial3: TargetPlatform.iOS == defaultTargetPlatform);

var lightTheme =
    ThemeData.light(useMaterial3: TargetPlatform.iOS == defaultTargetPlatform);

var darkTheme =
    ThemeData.dark(useMaterial3: TargetPlatform.iOS == defaultTargetPlatform);
