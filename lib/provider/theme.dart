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

/// is it a iOS device
var isApple = TargetPlatform.iOS == defaultTargetPlatform;

/// default theme
var defaultTheme = ThemeData(
    colorScheme:
        isApple ? ColorScheme.fromSwatch(primarySwatch: Colors.indigo) : null,
    primarySwatch: !isApple ? Colors.indigo : null,
    primaryColor: !isApple ? Colors.indigo : null,
    useMaterial3: isApple);

/// default light theme
var lightTheme = ThemeData.light(useMaterial3: isApple).copyWith(
    colorScheme:
        !isApple ? ColorScheme.fromSwatch(primarySwatch: Colors.indigo) : null,
    // primarySwatch: isApple ? Colors.indigo : null,
    primaryColor: !isApple ? Colors.indigo : null,
    useMaterial3: isApple);

/// default dark theme
var darkTheme = ThemeData.dark(useMaterial3: isApple);
